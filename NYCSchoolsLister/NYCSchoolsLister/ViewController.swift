//
//  ViewController.swift
//  NYCSchoolsLister
//
//  Created by Rafael Colon on 10/11/18.
//  Copyright © 2018 rafcolm_. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var schoolTableView: UITableView!
    static let JSON_ENDPOINT = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    static let JSON_SATS_ENDPOINT = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    var schoolNames = [String]();
    var mainSchoolArray = [Any]();
    var sats_array = [Any]();
    var main_json:JSON?;
    var sats_json:JSON?;
    
    
    
    /**
     ** NOTE: Requesting data only once here for the life of the app, but if we were dealing with contantly changing data, then some other procedure from viewWillAppear would have been better.
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolTableView.delegate = self;
        self.schoolTableView.dataSource = self;
        self.loadingIcon.isHidden = false;
        self.loadingIcon.startAnimating();
        self.schoolTableView.isHidden = true;
        self.downloadSchoolsData();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*
     * For the purpose of the exercise, this method shows an alert view and hides the app.  For real case scenarios, we would have had some sort of data backup to use instead of requesting for new data, and alert the user about it.
     */
    func showNoSchoolsFoundsMsg(){
        self.loadingIcon.stopAnimating();
        self.loadingIcon.isHidden = true;
        AppDelegate.showAlertWithOkToHideApp(controller: self, tittle:"No schools found", msg:"No schools returned from server.  Try again later.");
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    func downloadSchoolsData(){   //alamofire request for school lists
        let networkReachabilityManager = Alamofire.NetworkReachabilityManager(host: ViewController.JSON_ENDPOINT);
        if(networkReachabilityManager?.isReachable ?? false){
            Alamofire.request(ViewController.JSON_ENDPOINT).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    self.main_json = JSON(responseData.result.value!)  //making it global just in case for later use
                    print(self.main_json!);
                    if(self.main_json != nil && !self.main_json!.isEmpty){
                        self.schoolNames.removeAll();
                        self.mainSchoolArray.removeAll();
                        self.mainSchoolArray = self.main_json!.array!;
                        if(self.mainSchoolArray.count > 0){
                            self.downloadSATs();
                        } else {  //json returned empty
                            self.showNoSchoolsFoundsMsg();
                        }
                    } else {  //json returned nil
                        self.showNoSchoolsFoundsMsg();
                    }
                }
            }
        } else {  //no internet, hide the app
            self.loadingIcon.stopAnimating();
            self.loadingIcon.isHidden = true;
            AppDelegate.showAlertWithOkToHideApp(controller: self, tittle:"No internet connection.", msg:"Please make sure your internet connection is stable and try again.");
        }
    }
    
    //alamofire request for SAT scores; don't hide app if no data available as we still have schoo,data at this point
    func downloadSATs(){
        let networkReachabilityManager = Alamofire.NetworkReachabilityManager(host: ViewController.JSON_SATS_ENDPOINT);
        if(networkReachabilityManager?.isReachable ?? false){
            Alamofire.request(ViewController.JSON_SATS_ENDPOINT).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    self.sats_json = JSON(responseData.result.value!)  //making it global just in case for later use
                    print(self.sats_json!);
                    if(self.sats_json != nil && !self.sats_json!.isEmpty){
                        self.sats_array.removeAll();
                        self.sats_array = self.sats_json!.array!;
                        if(self.sats_array.count > 0){
                            DispatchQueue.main.async{
                                self.loadingIcon.stopAnimating();
                                self.loadingIcon.isHidden = true;
                                self.schoolTableView.isHidden = false;
                                self.schoolTableView.reloadData();
                            }
                        } else { //no sats found, show message but that feature wont be available
                            self.view.makeToast("SAT scores feature disabled for now.", duration: 3.0, position: .center);
                        }
                    } else { //no sats found, show message but that feature wont be available
                        self.view.makeToast("SAT scores feature disabled for now.", duration: 3.0, position: .center);
                    }
                }
            }
        } else {  //no sats found, show message but that feature wont be available
            self.view.makeToast("SAT scores feature disabled for now.", duration: 3.0, position: .center);
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainSchoolArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell");
        }
        let name =  (self.mainSchoolArray[indexPath.row] as! JSON)["school_name"].string;
        cell!.textLabel?.text = name != nil ? name : "Unknown Name";
        cell!.accessoryType = .disclosureIndicator;
        return cell!;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < self.mainSchoolArray.count){  //for safety
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "SchoolDetailView") as! SchoolDetailView
            let schoolNode = self.mainSchoolArray[indexPath.row] as? JSON;
            let dbn = schoolNode!["dbn"].string;
            controller.schoolDetails = schoolNode;
            for node in self.sats_array as! [JSON]{
                if(node["dbn"].string == dbn){
                    controller.satScores = node;
                    break;
                }
            }
            self.present(controller, animated: true, completion: nil);
        }
    }
}

