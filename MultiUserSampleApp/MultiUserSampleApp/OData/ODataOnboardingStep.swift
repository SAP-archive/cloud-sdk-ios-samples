//
// MultiUserSampleApp
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 27/02/19
//

import Foundation
import SAPCommon
import SAPFioriFlows
import SAPFoundation

open class ODataOnboardingStep: OnboardingStep {
    var controller: OfflineODataController?
    private let logger = Logger.shared(named: "AppDelegateLogger")

    public func onboard(context: OnboardingContext, completionHandler: @escaping (OnboardingResult) -> Void) {
        self.configureOData(using: context, completionHandler: completionHandler)
    }

    public func restore(context: OnboardingContext, completionHandler: @escaping (OnboardingResult) -> Void) {
        self.configureOData(using: context, completionHandler: completionHandler)
    }

    public func reset(context: OnboardingContext, completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        do {
            try OfflineODataController.removeStore(for: context.onboardingID)
        } catch {
            self.logger.error("Remove Offline Store failed", error: error)
        }
    }

    // Read more about consumption of OData services in mobile applications: https://help.sap.com/viewer/fc1a59c210d848babfb3f758a6f55cb1/Latest/en-US/1c7d937d0c8a43f4aca7175e9051d108.html
    private func configureOData(using context: OnboardingContext, completionHandler: @escaping (OnboardingResult) -> Void) {
        context.presentationDelegate.setInfoText("Synchronizing Data")

        // Adjust this path so it can be called after authentication and returns an HTTP 200 code. This is used to validate the authentication was successful.
        let configurationURL = URL(string: "https://hcpms-i074559trial.hanatrial.ondemand.com/odata.readwrite.test.service")!

        do {
            let offlineOdataController = OfflineODataController()
            try offlineOdataController.configureOData(sapURLSession: context.sapURLSession, serviceRoot: configurationURL, onboardingID: context.onboardingID)

            offlineOdataController.openOfflineStore(synchronize: false) { error in
                if let error = error {
                    completionHandler(.failed(error))
                    return
                }

                self.controller = offlineOdataController
                completionHandler(.success(context))
            }
        } catch {
            completionHandler(.failed(error))
        }
    }
}
