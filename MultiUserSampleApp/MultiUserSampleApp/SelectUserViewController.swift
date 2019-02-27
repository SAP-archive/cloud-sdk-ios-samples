//
//  SelectUserViewController.swift
//  MultiUserSampleApp
//
//  Created by Palfi, Andras on 2019. 02. 21..
//  Copyright © 2019. SAP. All rights reserved.
//

import UIKit
import SAPFioriFlows

class UserTableViewCell: UITableViewCell {
    static let cellID = "UserSelectorCell"
    
    @IBOutlet weak var userName: UILabel!
}

class SelectUserViewController: UITableViewController {
    
    static let storyboardID = "SelectUserViewController"
    
    // called when the user selected the action
    var flowSelectionCompletion: ((_ username: String, _ flowType: OnboardingFlow.FlowType)->Void)?
    
    // helper array used by the Tableview
    var users = [MultiUserOnboardingIDManager.User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Event handling
    
    
    /// Called when the user select to start a new onboarding
    @IBAction func addUser(_ sender: Any) {
        guard let completion = flowSelectionCompletion else {
            return
        }
        completion("username", .onboard)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellID) as! UserTableViewCell
        cell.userName.text = "\(users[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let completion = flowSelectionCompletion else {
            return
        }
        let selectedUser = users[indexPath.row]
        completion(selectedUser.name, .restore(onboardingID: selectedUser.onboardingID))
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
