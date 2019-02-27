//
//  MultiUserOnboardingIDManager.swift
//  MultiUserSampleApp
//
//  Created by Palfi, Andras on 2019. 02. 19..
//  Copyright © 2019. SAP. All rights reserved.
//

import Foundation
import UIKit
import SAPFoundation
import SAPFioriFlows


/// Saves `onboardingIDs` to the `UserDefaults`; Decides whether a new Onboard should happen or a previous one shuold be returned. For the decision it presents a ViewController
public class MultiUserOnboardingIDManager: OnboardingIDManaging {
    
    public enum UserError: Error {
        case cannotLoad
        case internalError
    }
    
    // Auto-implement `Codable` so it is quite simple to persist and restore
    public struct User: Codable {
        let name: String
        let onboardingID: UUID
    }
    
    // prefix of the keys used to store the onboardingID in the UserDefaults
    let OnboardedUserKeyPrefix = "Onboarded_"
    // PlistCoder to ease the code/decode of User types
    let coder = SAPFoundation.PlistCoder()
    
    // username selected when the onboard starts however it should be persisted if it is successful: store it temporarily
    var selectedUserName: String?
    
    
    /// Returns all the onobarded users
    ///
    /// - Returns: array of users currently stored in the UserDefaults
    public func allUsers() -> [User] {
        var users = [User]()
        
        for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix(OnboardedUserKeyPrefix) {
            let onboardingIDString = key.dropFirst(OnboardedUserKeyPrefix.count)
            do {
                guard let onboardingID = UUID(uuidString: String(onboardingIDString)) else {
                    // TODO: error handling, currently just skip
                    continue
                }
                let user = try self.user(for: onboardingID)
                users.append(user)
            }
            catch {
                // TODO: error handling
            }
        }
        
        return users
    }
    
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

}

// MARK: - `OnboardingIDManaging` protocol implementation
extension MultiUserOnboardingIDManager {
    
    public func flowToStart(completionHandler: @escaping (OnboardingFlow.FlowType) -> Void) {
        self.selectedUserName = "test"
        completionHandler(.onboard)
    }
    
    public func store(onboardingID: UUID, completionHandler: @escaping (Error?) -> Void) {
        guard let username = selectedUserName else {
            completionHandler(UserError.internalError)
            return
        }
        let user = User(name: username, onboardingID: onboardingID)
        self.selectedUserName = nil
        do {
            try self.saveOnboardedUser(user)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
    public func remove(onboardingID: UUID, completionHandler: () -> Void) {
        self.selectedUserName = nil
        self.removeOnboardedUser(onboardingID)
    }
}