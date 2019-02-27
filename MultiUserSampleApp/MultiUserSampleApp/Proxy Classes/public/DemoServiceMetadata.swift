// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

public class DemoServiceMetadata {
    private static var document_: CSDLDocument = DemoServiceMetadata.resolve()

    public static var document: CSDLDocument {
        get {
            objc_sync_enter(DemoServiceMetadata.self)
            defer { objc_sync_exit(DemoServiceMetadata.self) }
            do {
                return DemoServiceMetadata.document_
            }
        }
        set(value) {
            objc_sync_enter(DemoServiceMetadata.self)
            defer { objc_sync_exit(DemoServiceMetadata.self) }
            do {
                DemoServiceMetadata.document_ = value
            }
        }
    }

    private static func resolve() -> CSDLDocument {
        try! DemoServiceFactory.registerAll()
        DemoServiceMetadataParser.parsed.hasGeneratedProxies = true
        return DemoServiceMetadataParser.parsed
    }

    public class ComplexTypes {
        private static var address_: ComplexType = DemoServiceMetadataParser.parsed.complexType(withName: "ODataDemo.Address")

        public static var address: ComplexType {
            get {
                objc_sync_enter(DemoServiceMetadata.ComplexTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.ComplexTypes.self) }
                do {
                    return DemoServiceMetadata.ComplexTypes.address_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.ComplexTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.ComplexTypes.self) }
                do {
                    DemoServiceMetadata.ComplexTypes.address_ = value
                }
            }
        }
    }

    public class EntityTypes {
        private static var category_: EntityType = DemoServiceMetadataParser.parsed.entityType(withName: "ODataDemo.Category")

        private static var product_: EntityType = DemoServiceMetadataParser.parsed.entityType(withName: "ODataDemo.Product")

        private static var supplier_: EntityType = DemoServiceMetadataParser.parsed.entityType(withName: "ODataDemo.Supplier")

        public static var category: EntityType {
            get {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    return DemoServiceMetadata.EntityTypes.category_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    DemoServiceMetadata.EntityTypes.category_ = value
                }
            }
        }

        public static var product: EntityType {
            get {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    return DemoServiceMetadata.EntityTypes.product_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    DemoServiceMetadata.EntityTypes.product_ = value
                }
            }
        }

        public static var supplier: EntityType {
            get {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    return DemoServiceMetadata.EntityTypes.supplier_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntityTypes.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntityTypes.self) }
                do {
                    DemoServiceMetadata.EntityTypes.supplier_ = value
                }
            }
        }
    }

    public class EntitySets {
        private static var categories_: EntitySet = DemoServiceMetadataParser.parsed.entitySet(withName: "Categories")

        private static var products_: EntitySet = DemoServiceMetadataParser.parsed.entitySet(withName: "Products")

        private static var suppliers_: EntitySet = DemoServiceMetadataParser.parsed.entitySet(withName: "Suppliers")

        public static var categories: EntitySet {
            get {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    return DemoServiceMetadata.EntitySets.categories_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    DemoServiceMetadata.EntitySets.categories_ = value
                }
            }
        }

        public static var products: EntitySet {
            get {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    return DemoServiceMetadata.EntitySets.products_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    DemoServiceMetadata.EntitySets.products_ = value
                }
            }
        }

        public static var suppliers: EntitySet {
            get {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    return DemoServiceMetadata.EntitySets.suppliers_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.EntitySets.self)
                defer { objc_sync_exit(DemoServiceMetadata.EntitySets.self) }
                do {
                    DemoServiceMetadata.EntitySets.suppliers_ = value
                }
            }
        }
    }

    public class FunctionImports {
        private static var getProductsByRating_: DataMethod = DemoServiceMetadataParser.parsed.dataMethod(withName: "GetProductsByRating")

        public static var getProductsByRating: DataMethod {
            get {
                objc_sync_enter(DemoServiceMetadata.FunctionImports.self)
                defer { objc_sync_exit(DemoServiceMetadata.FunctionImports.self) }
                do {
                    return DemoServiceMetadata.FunctionImports.getProductsByRating_
                }
            }
            set(value) {
                objc_sync_enter(DemoServiceMetadata.FunctionImports.self)
                defer { objc_sync_exit(DemoServiceMetadata.FunctionImports.self) }
                do {
                    DemoServiceMetadata.FunctionImports.getProductsByRating_ = value
                }
            }
        }
    }
}
