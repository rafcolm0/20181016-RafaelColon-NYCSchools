# NYCSchoolsLister
* Developer: Rafael J. Colon
* Email: rafael.colon5@gmail.com
* Phone: 614-218-0648
* Ressume attached to repo.

## NOTES:
 * Tech used: Swift, Alamofire, SwiftyJSON, Toast_Swift
 * Non-OOP & MVC version: NO objects used to serialize the JSON with; instead, algorithm handles the data straight from the JSON.  Done this way for experiment purposes.
 * UI TEST: Provided only one all-around comprehenssive test cases that basically goes through the entire app UI flow: starts up the app, waits (maximum of 20 secods) for all data to download and then tap on each school entry from the main screen to check for any crashes.  In a real case scenario, I would have checked table view entries against real expected values and behaviours. 
 * Unit test: As most of the application is based on UI flows, I wasn't sure on how to approach singular test cases on the code itself.  Possible real case testing scenarios however are: check for JSON data validity, check json parsers to handle when nodes are not available, create objects that would carry the JSON data and validate them against the JSON nodes, etc.
