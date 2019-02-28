//
// MultiUserSampleApp
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 28/02/19
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData
import SAPOfflineOData

public class OfflineODataController {
    enum OfflineODataControllerError: Error {
        case cannotCreateOfflinePath
        case storeClosed
    }

    private let logger = Logger.shared(named: "OfflineODataController")
    var demoService: DemoService<OfflineODataProvider>!
    private(set) var isOfflineStoreOpened = false

    public init() {}

    // MARK: - Public methods

    public static func offlineStorePath(for onboardingID: UUID) throws -> URL {
        guard let documentsFolderURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            throw OfflineODataControllerError.cannotCreateOfflinePath
        }
        let offlineStoreURL = documentsFolderURL.appendingPathComponent(onboardingID.uuidString)
        return offlineStoreURL
    }

    public static func removeStore(for onboardingID: UUID) throws {
        let offlinePath = try offlineStorePath(for: onboardingID)
        try OfflineODataProvider.clear(at: offlinePath, withName: nil)
    }

    // Read more about setting up an application with Offline Store: https://help.sap.com/viewer/fc1a59c210d848babfb3f758a6f55cb1/Latest/en-US/92f0a91d9d3148fd98b86082cf2cb1d5.html
    public func configureOData(sapURLSession: SAPURLSession, serviceRoot: URL, onboardingID: UUID) throws {
        var offlineParameters = OfflineODataParameters()
        offlineParameters.enableRepeatableRequests = true

        // Configure the path of the Offline Store
        let offlinePath = try OfflineODataController.offlineStorePath(for: onboardingID)
        try FileManager.default.createDirectory(at: offlinePath, withIntermediateDirectories: true)
        offlineParameters.storePath = offlinePath

        // Setup an instance of delegate. See sample code below for definition of OfflineODataDelegateSample class.
        let delegate = OfflineODataDelegateSample()
        let offlineODataProvider = try! OfflineODataProvider(serviceRoot: serviceRoot, parameters: offlineParameters, sapURLSession: sapURLSession, delegate: delegate)
        try configureDefiningQueries(on: offlineODataProvider)
        self.demoService = DemoService(provider: offlineODataProvider)
    }

    public func openOfflineStore(synchronize: Bool, completionHandler: @escaping (Error?) -> Void) {
        if !self.isOfflineStoreOpened {
            // The OfflineODataProvider needs to be opened before performing any operations.
            self.demoService.open { error in
                if let error = error {
                    self.logger.error("Could not open offline store.", error: error)
                    completionHandler(error)
                    return
                }
                self.isOfflineStoreOpened = true
                self.logger.info("Offline store opened.")
                if synchronize {
                    // You might want to consider doing the synchronization based on an explicit user interaction instead of automatically synchronizing during startup
                    self.synchronize(completionHandler: completionHandler)
                } else {
                    completionHandler(nil)
                }
            }
        } else if synchronize {
            // You might want to consider doing the synchronization based on an explicit user interaction instead of automatically synchronizing during startup
            self.synchronize(completionHandler: completionHandler)
        } else {
            completionHandler(nil)
        }
    }

    public func closeOfflineStore() {
        if self.isOfflineStoreOpened {
            do {
                // the Offline store should be closed when it is no longer used.
                try self.demoService.close()
                self.isOfflineStoreOpened = false
            } catch {
                self.logger.error("Offline Store closing failed.")
            }
        }
        self.logger.info("Offline Store closed.")
    }

    // You can read more about data synchnonization: https://help.sap.com/viewer/fc1a59c210d848babfb3f758a6f55cb1/Latest/en-US/59ae11dc4df345bc8073f9da45170706.html
    public func synchronize(completionHandler: @escaping (Error?) -> Void) {
        if !self.isOfflineStoreOpened {
            self.logger.error("Offline Store is still closed")
            completionHandler(OfflineODataControllerError.storeClosed)
            return
        }
        self.uploadOfflineStore { error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.downloadOfflineStore { error in
                completionHandler(error)
            }
        }
    }

    // MARK: - Private methods

    // Read more about Defining Queries: https://help.sap.com/viewer/fc1a59c210d848babfb3f758a6f55cb1/Latest/en-US/2235da24931b4be69ad0ada82873044e.html
    private func configureDefiningQueries(on offlineODataProvider: OfflineODataProvider) throws {
        // Although it is not the best practice, we are defining this query limit as top=20.
        // If the service supports paging, then paging should be used instead of top!
        do {
            try offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: DemoServiceMetadata.EntitySets.suppliers.localName, query: DataQuery().from(DemoServiceMetadata.EntitySets.suppliers).selectAll().top(20), automaticallyRetrievesStreams: false))
            try offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: DemoServiceMetadata.EntitySets.products.localName, query: DataQuery().from(DemoServiceMetadata.EntitySets.products).selectAll().top(20), automaticallyRetrievesStreams: false))
            try offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: DemoServiceMetadata.EntitySets.categories.localName, query: DataQuery().from(DemoServiceMetadata.EntitySets.categories).selectAll().top(20), automaticallyRetrievesStreams: false))
        } catch {
            self.logger.error("Failed to add defining query for Offline Store initialization", error: error)
            throw error
        }
    }

    private func downloadOfflineStore(completionHandler: @escaping (Error?) -> Void) {
        // the download function updates the client’s offline store from the backend.
        self.demoService.download { error in
            if let error = error {
                self.logger.error("Offline Store download failed", error: error)
            } else {
                self.logger.info("Offline Store successfully downloaded")
            }
            completionHandler(error)
        }
    }

    private func uploadOfflineStore(completionHandler: @escaping (Error?) -> Void) {
        // the upload function updates the backend from the client’s offline store.
        self.demoService.upload { error in
            if let error = error {
                self.logger.error("Offline Store upload failed.", error: error)
                completionHandler(error)
                return
            }
            self.logger.info("Offline Store successfully uploaded.")
            completionHandler(nil)
        }
    }
}

class OfflineODataDelegateSample: OfflineODataDelegate {
    private let logger = Logger.shared(named: "AppDelegateLogger")

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateDownloadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateFileDownloadProgress progress: OfflineODataFileDownloadProgress) {
        self.logger.info("downloadProgress: \(progress.bytesReceived)  \(progress.fileSize)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateUploadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, requestDidFail request: OfflineODataFailedRequest) {
        self.logger.info("requestFailed: \(request.httpStatusCode)")
    }

    // The OfflineODataStoreState is a Swift OptionSet. Use the set operation to retrieve each setting.
    private func storeState2String(_ state: OfflineODataStoreState) -> String {
        var result = ""
        if state.contains(.opening) {
            result += ":opening"
        }
        if state.contains(.open) {
            result += ":open"
        }
        if state.contains(.closed) {
            result += ":closed"
        }
        if state.contains(.downloading) {
            result += ":downloading"
        }
        if state.contains(.uploading) {
            result += ":uploading"
        }
        if state.contains(.initializing) {
            result += ":initializing"
        }
        if state.contains(.fileDownloading) {
            result += ":fileDownloading"
        }
        if state.contains(.initialCommunication) {
            result += ":initialCommunication"
        }
        return result
    }

    public func offlineODataProvider(_: OfflineODataProvider, stateDidChange newState: OfflineODataStoreState) {
        let stateString = storeState2String(newState)
        self.logger.info("stateChanged: \(stateString)")
    }
}
