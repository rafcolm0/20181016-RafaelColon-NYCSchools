//
//  NYCSchoolsListerUITests.swift
//  NYCSchoolsListerUITests
//
//  Created by Rafael Colon on 10/11/18.
//  Copyright © 2018 rafcolm_. All rights reserved.
//

import XCTest

class NYCSchoolsListerUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication();
        app.launch();
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
     ** For the purpose of this exercise, I wrote a comprehensive test that would wait (maximum of 20 secods) for all data to download, and then tap on each school entry to check for crashes.
     ** Real case scenario: I would have check each school name againts the json itself, and then corroborate the school data based on the school's JSON node and SAT scores (if any).
     **/
    func testComprehenssive() {
        let cells = XCUIApplication().tables.cells
        let indicator = XCUIApplication().progressIndicators.element;
        let doesNotExistPredicate = NSPredicate(format: "exists == FALSE")
        self.expectation(for: doesNotExistPredicate, evaluatedWith: indicator, handler: nil)
        self.waitForExpectations(timeout: 20.0, handler: nil)
        for cell in cells.allElementsBoundByIndex {
            cell.tap()
            let backButton = app.buttons.element;
            backButton.tap();
            sleep(1);
        }
    }

}
