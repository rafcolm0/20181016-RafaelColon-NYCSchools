//
//  SchoolDetailView.swift
//  NYCSchoolsLister
//
//  Created by Rafael Colon on 10/11/18.
//  Copyright © 2018 rafcolm_. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SchoolDetailView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolDetailTable: UITableView!
    var schoolDetails:JSON?;
    var satScores:JSON?;
    static let infoToShow = ["code1", "location", "phone_number"];
    static let scoresToShow = ["sat_writing_avg_score", "sat_math_avg_score", "sat_critical_reading_avg_score"];
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //only these pieces of data for the purpose of the exercise; if sats scores where found, then show 3 score fields
        return SchoolDetailView.infoToShow.count + (self.satScores != nil && !self.satScores!.isEmpty ? 3 : 0);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let name = self.schoolDetails!["school_name"].string;
        self.schoolName.text = (name != nil && !name!.isEmpty) ? name : "Unknown Name";
        self.schoolDetailTable.dataSource = self;
        self.schoolDetailTable.reloadData();
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row;
        var cell = tableView.dequeueReusableCell(withIdentifier: "detail_cell");
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "detail_cell");
        }
        if(row < SchoolDetailView.infoToShow.count){
            let name = self.schoolDetails![SchoolDetailView.infoToShow[row]];
            if(name.exists()){
                cell!.textLabel?.text = String(format: "%@: %@", SchoolDetailView.infoToShow[row], name.string ?? "N/A");
            } else {
                cell!.textLabel?.text = String(format: "%@: %@", SchoolDetailView.infoToShow[row], "N/A");
            }
        } else {
            let row2 = row - SchoolDetailView.infoToShow.count;
            let name = self.satScores![SchoolDetailView.scoresToShow[row2]];
            if(name.exists()){
                cell!.textLabel?.text = String(format: "%@: %@", SchoolDetailView.scoresToShow[row2], name.string ?? "N/A");
            } else {
                cell!.textLabel?.text = String(format: "%@: %@", SchoolDetailView.scoresToShow[row2], "N/A");
            }
        }
        return cell!;
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated:true);
    }
}
