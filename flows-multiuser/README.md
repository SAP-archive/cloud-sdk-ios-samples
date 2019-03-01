#  Supporting multiple users in an app

## What is multi-user scenario
We talk about multi-user scenario when an application has multiple persisted user data at the same time and so anyone can be restored to be used in the app. However only one of them can be active or opened.  When an application is used more people but the application gets reset before the next user onboards then it is a single user scenario - the default how applications are generated. 

## Quick overview
To support multi-user scenarios you should  replace the default `SingleUserOnboardingIDManager` to your custom implementation in the `OnboardingController`. This class must implement the OnboardingIDManaging protocol and is responsible to store the `onboardingIDs` as well to decide to create a new onboarding session or restore an existing one using the `onboardingID`. It is up to your application design how you support these options.
In this sample a view controller will be presented to the users where the user can select one from the existing sessions or create a new one.

# Requirements
* Xcode 10.1+
* SAP Cloud Platform SDK for iOS 3.0 SP01+
* Existing *SAP Cloud Platform Mobile Services* account  

# Configuration
1. The `Cloud Platform mobile services` configuration for this application must be created on the server. Create one or import the [com.sap.multiuser.sample_1.0.zip](com.sap.multiuser.sample_1.0.zip) at the `Mobile Services Cockpit` under the `Mobile Applications` / `Native/Hybrid`. This is a simple configuration which points to the publicly available read/write OData service at https://services.odata.org 
1. After downloading this iOS application the server parameters must be updated as well so it will connect to your server. To copy the proper URL go to the `Cloud Platform mobile services` cockpit, select the `Multi User Sample` under the `Mobile Applications` / `Native/Hybrid`. Go to the `APIs` tab. Under the `APIs` section there is a `Server` item with a URL. This is your applications base server URL. Open the `ConfigurationProvider.plist` in the `Onboarding` folder. Update the value of the `host` key to the host part of the `Server` URL (something like https://hcpms-xyztrial.hanatrial.ondemand.com) without the `https://` prefix and without the '/' suffix.
1. Add the `SAPCommon.framework`, `SAPFoundation.framework`, `SAPOData.framework`, `SAPOfflineOData.framework`, `SAPFiori.framework`, and `SAPFioriFlows.framework` to the Embedded Binaries and Linked Frameworks and Libraries.

# Steps required to support multiple users

This app already shows the working end-state of a multi-user enabled app.
Here we describe the required changes and enhancements for that in more detail.

## Create a new onboardingID manager

Create a new Swift class named `MultiUserOnboardingIDManager` and implement the `OnboardingIDManaging` protocol with a simple implementation first: stores the id, returns with `.onboard` when it is asked in `flowToStart`... To make it more realistic we introduce a `User` type which contains a `name` and the `onboardingID`. This will be managed by the `MultiUserOnboardingIDManager`. Auto-implement the Codable protocol to ease the persistatition and restoration. Declare a variable `coder` and assign the `PlistCoder` from `SAPFoundation`. This will be used to run the Codable protocol. Also declare an error type used to signal any problem.
    
    ```swift
    public enum UserError: Error {
        case cannotLoad
        case internalError
    }
    
    public struct User: Codable {
        let name: String
        let onboardingID: UUID
    }
    // PlistCoder to ease the code/decode of User types
    let coder = SAPFoundation.PlistCoder()
    ```
It is worth to create some private helper methods to store/retrieve the `Users`. This way the users can see user names instead of `onboardingIDs` and the type can be extended later on demand.
Let's differentiate the keys in the user defaults with a custom prefix. Also use the
    ```swift
    let OnboardedUserKeyPrefix = "Onboarded_"
    ```
Implement the base functionality: create and read items

    ```swift
    // MARK: - Private methods
    private func userdefaultsKey(for onboardingID: UUID) -> String {
        return "\(OnboardedUserKeyPrefix)\(onboardingID)"
    }

    private func user(for onboardingID: UUID) throws -> User {
        let key = userdefaultsKey(for: onboardingID)
        guard let userData = UserDefaults.standard.object(forKey: key) as? Data else {
            throw UserError.cannotLoad
        }
        let user = try coder.decode(User.self, from: userData)
        return user
    }

    private func saveOnboardedUser(_ user: User) throws {
        let key = userdefaultsKey(for: user.onboardingID)
        let userData = try coder.encode(user)
        UserDefaults.standard.set(userData, forKey: key)
    }

    private func removeOnboardedUser(_ onboardingID: UUID) {
        let key = userdefaultsKey(for: onboardingID)
        UserDefaults.standard.removeObject(forKey: key)
    }
    ```
    
Implement a public function which will be used to list all the items

    ```swift
    /// Returns all the onobarded users
    ///
    /// - Returns: array of users currently stored in the UserDefaults
    public func allUsers() -> [User] {
        var users = [User]()
        
        for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix(OnboardedUserKeyPrefix) {
            let onboardingIDString = key.dropFirst(OnboardedUserKeyPrefix.count)
            do {
                guard let onboardingID = UUID(uuidString: String(onboardingIDString)) else {
                    Logger.root.error("Failed to create UUID for key: \(onboardingIDString)")
                    continue
                }
                let user = try self.user(for: onboardingID)
                users.append(user)
            }
            catch {
                Logger.root.error("Failed to load User for key: \(onboardingIDString)", error: error)
            }
        }
        
        return users
    }
    ```

## Create the UI to interact with the user

### Create a `UITableViewController`

Create a new `UITableViewController` descendant Swift class and name it `SelectUserViewController`. This will present the list of existing onboarding sessions.

1. Create a small new class for the presented UITableViewCells used by SelectUserViewController. Name it `UserTableViewCell`.
1. The cell should have a UILabel as an IBOutlet.
1. create a const cellID: will be used to get the cell, must be set in the storyboard as well
    ```swift
    static let cellID = "UserSelectorCell"
    ```
1. Declare two properties:
    1. `flowSelectionCompletion`: the completion handler to call when the user selected the action
    1. users: array of `User`s; set by the `MultiUserOnboardingIDManager` with the available users and used by the tableview to present the items
1. Create new IBAction for the add user option: `addUser`
1. Remove the `numberOfSections` method as we only have one section
1. In the `tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)` just return with the users.count
1. uncomment the `cellForRowAt: indexPath` method and dequeue the cell with the id. Fill the cell with the user name blonging to that line/indexPath
    ```swift
    cell.userName.text = "\(users[indexPath.row].name)"
    ```
1. implement the `didSelectRowAt indexPath` method to handle the user selection of items. Just call back on the flowCompletionHandler with the username and onboardingID  
1. remove any other unnecessary commented code snippet from the file

### Create the UI in storyboard for the SelectUserViewController

Open the `Main.storyboard`
1. Drop in a new UITablewViewController scene
1. Set the class of the view controller to `SelectUserViewController`
1. Set the `Storyboard ID` to `SelectUserViewController`
1. Select the prototype cell and set its class to `UserTableViewCell`
1. Add a UILabel to the cell and bind it to the userName outlet. Don't forget to set up the autolayout constraints properly
1. Set the `identifier` of the prototype cell to `UserSelectorCell`
1. drop a `NavigationItem` to the view controller
1. drop a `UIBarButtonItem` to the right-top, set its `System Item` to `Add` in the *Attributes Inspector*
1. Bind the action of this button to the `addUser` IBAction

## Bind together the pieces to make it work

Finalize `MultiUserOnboardingIDManager`. When `flowToStart` called we present the UI where the user can select to start a new onboarding session or restore and existing one. So in `flowToStart`

1. get a reference to the main storyboard and load the `SelectUserViewController` from it
1. set the `flowSelectionCompletion`; in the closure save the selected user name and dismiss the view controller, then call the `completionHandler` of the `flowToSelect`.
1. Create a new property where we can save the user name. When onboarding finished and the onboardingID mus tbe persisted we can attach the name to the ID creating a `User` and save it to the UseDefaults
```swift
var selectedUserName: String?
```
When the other delegate methods are called make sure to nil out the property!
1. set the available users on `SelectUserViewController`
```swift
selectUserViewController.users = self.allUsers()
```
2. present the view controller in a NavigationController to be able to present the buttons in the Navigation Bar. Make sure you call it on the main queue
```swift
DispatchQueue.main.async {
topViewController.present(navCtrl, animated: true)
}
```
3. Bind the `OnboardingController` to the `MultiUserOnboardingIDManager`. By default the `OnboardingController` is created inside a convenience init of `OnboardingSessionManager` so we will modify that call
In your `AppDelegate` find the `initializeOnboarding` method  (it is implemented as an extension on AppDelegate) and modify the line initialization of `OnboardingSessionManager` by adding the parameter to the initializer (after the `flowProvider` parameter) `, onboardingIDManager: MultiUserOnboardingIDManager()`

Before:
```swift
self.sessionManager = OnboardingSessionManager(presentationDelegate: presentationDelegate, flowProvider: self.flowProvider, delegate: self.onboardingErrorHandler)
```
After:
```swift
self.sessionManager = OnboardingSessionManager(presentationDelegate: presentationDelegate, flowProvider: self.flowProvider, onboardingIDManager: MultiUserOnboardingIDManager(), delegate: self.onboardingErrorHandler)
```

Try out what we have! When the app starts instead of starting with the standard 'Welcome screen' it presents an empty list - this will contain the onboarding sessions. Press the '+' button on the top left corner to initiate a new onboard.

# License
Copyright (c) 2019 SAP SE or an SAP affiliate company. 
All rights reserved.

This project is licensed under the SAP Sample Code License except as noted otherwise in the [LICENSE](../LICENSE) file.
