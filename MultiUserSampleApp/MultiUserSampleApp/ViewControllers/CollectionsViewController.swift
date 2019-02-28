//
// MultiUserSampleApp
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 28/02/19
//

import Foundation
import SAPFiori
import SAPFioriFlows
import SAPOData

protocol EntityUpdaterDelegate {
    func entityHasChanged(_ entity: EntityValue?)
}

protocol EntitySetUpdaterDelegate {
    func entitySetHasChanged()
}

class CollectionsViewController: FUIFormTableViewController {
    private var collections = CollectionType.all

    // Variable to store the selected index path
    private var selectedIndex: IndexPath?

    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")

    var isPresentedInSplitView: Bool {
        return !(self.splitViewController?.isCollapsed ?? true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 480)

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.makeSelection()
    }

    override func viewWillTransition(to _: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            let isNotInSplitView = !self.isPresentedInSplitView
            self.tableView.visibleCells.forEach { cell in
                // To refresh the disclosure indicator of each cell
                cell.accessoryType = isNotInSplitView ? .disclosureIndicator : .none
            }
            self.makeSelection()
        })
    }

    // MARK: - UITableViewDelegate

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.collections.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        cell.headlineLabel.text = self.collections[indexPath.row].rawValue
        cell.accessoryType = !self.isPresentedInSplitView ? .disclosureIndicator : .none
        cell.isMomentarySelection = false
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.collectionSelected(at: indexPath)
    }

    // CollectionType selection helper
    private func collectionSelected(at indexPath: IndexPath) {
        // Load the EntityType specific ViewController from the specific storyboard"
        var masterViewController: UIViewController!
        guard let demoService = OnboardingSessionManager.shared.onboardingSession?.odataController.demoService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.selectedIndex = indexPath

        switch self.collections[indexPath.row] {
        case .suppliers:
            let supplierStoryBoard = UIStoryboard(name: "Supplier", bundle: nil)
            let supplierMasterViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "SupplierMaster") as! SupplierMasterViewController
            supplierMasterViewController.demoService = demoService
            supplierMasterViewController.entitySetName = "Suppliers"
            func fetchSuppliers(_ completionHandler: @escaping ([Supplier]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    demoService.fetchSuppliers(matching: query, completionHandler: completionHandler)
                }
            }
            supplierMasterViewController.loadEntitiesBlock = fetchSuppliers
            supplierMasterViewController.navigationItem.title = "Supplier"
            masterViewController = supplierMasterViewController
        case .products:
            let productStoryBoard = UIStoryboard(name: "Product", bundle: nil)
            let productMasterViewController = productStoryBoard.instantiateViewController(withIdentifier: "ProductMaster") as! ProductMasterViewController
            productMasterViewController.demoService = demoService
            productMasterViewController.entitySetName = "Products"
            func fetchProducts(_ completionHandler: @escaping ([Product]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    demoService.fetchProducts(matching: query, completionHandler: completionHandler)
                }
            }
            productMasterViewController.loadEntitiesBlock = fetchProducts
            productMasterViewController.navigationItem.title = "Product"
            masterViewController = productMasterViewController
        case .categories:
            let categoryStoryBoard = UIStoryboard(name: "Category", bundle: nil)
            let categoryMasterViewController = categoryStoryBoard.instantiateViewController(withIdentifier: "CategoryMaster") as! CategoryMasterViewController
            categoryMasterViewController.demoService = demoService
            categoryMasterViewController.entitySetName = "Categories"
            func fetchCategories(_ completionHandler: @escaping ([Category]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    demoService.fetchCategories(matching: query, completionHandler: completionHandler)
                }
            }
            categoryMasterViewController.loadEntitiesBlock = fetchCategories
            categoryMasterViewController.navigationItem.title = "Category"
            masterViewController = categoryMasterViewController
        case .none:
            masterViewController = UIViewController()
        }

        // Load the NavigationController and present with the EntityType specific ViewController
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "RightNavigationController") as! UINavigationController
        rightNavigationController.viewControllers = [masterViewController]
        self.splitViewController?.showDetailViewController(rightNavigationController, sender: nil)
    }

    // MARK: - Handle highlighting of selected cell

    private func makeSelection() {
        if let selectedIndex = selectedIndex {
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            self.tableView.scrollToRow(at: selectedIndex, at: .none, animated: true)
        } else {
            self.selectDefault()
        }
    }

    private func selectDefault() {
        // Automatically select first element if we have two panels (iPhone plus and iPad only)
        if self.splitViewController!.isCollapsed || OnboardingSessionManager.shared.onboardingSession?.odataController.demoService == nil {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        self.collectionSelected(at: indexPath)
    }
}
