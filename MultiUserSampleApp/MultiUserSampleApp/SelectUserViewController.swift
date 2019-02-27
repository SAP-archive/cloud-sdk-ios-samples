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
        showAlertForUser()
    }

    func showAlertForUser() {
        guard let completion = flowSelectionCompletion else {
            return
        }
        
        let addUserController = UIAlertController(title: "Add user", message: "Create a new onboarding. Specify your name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let textField = addUserController.textFields?.first, let userName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userName.isEmpty else {
                // restart if something went wrong
                DispatchQueue.main.async {
                    self.showAlertForUser()
                }
                return
            }

            // do not allow to create an existing user
            guard !self.users.contains(where: { return $0.name.lowercased() == userName.lowercased() }) else {
                let errorController = UIAlertController(title: "Error", message: "User already exists", preferredStyle: .alert)
                errorController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in self.showAlertForUser() }))
                self.present(errorController, animated: true)
                return
            }
            
            completion(userName, .onboard)
        }
        saveAction.isEnabled = false
        addUserController.addTextField { textField in
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        addUserController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addUserController.addAction(saveAction)
        self.present(addUserController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // find the UIAlertController
        var current: UIResponder? = textField
        while current != nil && !(current is UIAlertController) {
            current = current?.next
        }
        
        // find the action
        guard let alertController = current as? UIAlertController, let saveAction = alertController.actions.first(where: { $0.style != .cancel }) else {
            return
        }
        // enabled or disable the saveButton based on the text provided by the user
        if let userName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userName.isEmpty, !self.users.contains(where: { return $0.name.lowercased() == userName.lowercased() }) {
            saveAction.isEnabled = true
        }
        else {
            saveAction.isEnabled = false
        }
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
        cell.userName.text = "\(users[indexPath.row].name)"
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
