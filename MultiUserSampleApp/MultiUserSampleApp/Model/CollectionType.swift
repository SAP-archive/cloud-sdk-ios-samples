//
// MultiUserSampleApp
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 27/02/19
//

import Foundation

enum CollectionType: String {
    case suppliers = "Suppliers"
    case products = "Products"
    case categories = "Categories"
    case none = ""
    static let all = [suppliers, products, categories]
}
