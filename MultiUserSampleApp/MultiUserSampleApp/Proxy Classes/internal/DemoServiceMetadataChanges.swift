// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

internal class DemoServiceMetadataChanges {
    static func merge(metadata: CSDLDocument) {
        metadata.hasGeneratedProxies = true
        DemoServiceMetadata.document = metadata
        DemoServiceMetadataChanges.merge1(metadata: metadata)
        try! DemoServiceFactory.registerAll()
    }

    private static func merge1(metadata: CSDLDocument) {
        Ignore.valueOf_any(metadata)
        if !DemoServiceMetadata.ComplexTypes.address.isRemoved {
            DemoServiceMetadata.ComplexTypes.address = metadata.complexType(withName: "ODataDemo.Address")
        }
        if !DemoServiceMetadata.EntityTypes.category.isRemoved {
            DemoServiceMetadata.EntityTypes.category = metadata.entityType(withName: "ODataDemo.Category")
        }
        if !DemoServiceMetadata.EntityTypes.product.isRemoved {
            DemoServiceMetadata.EntityTypes.product = metadata.entityType(withName: "ODataDemo.Product")
        }
        if !DemoServiceMetadata.EntityTypes.supplier.isRemoved {
            DemoServiceMetadata.EntityTypes.supplier = metadata.entityType(withName: "ODataDemo.Supplier")
        }
        if !DemoServiceMetadata.EntitySets.categories.isRemoved {
            DemoServiceMetadata.EntitySets.categories = metadata.entitySet(withName: "Categories")
        }
        if !DemoServiceMetadata.EntitySets.products.isRemoved {
            DemoServiceMetadata.EntitySets.products = metadata.entitySet(withName: "Products")
        }
        if !DemoServiceMetadata.EntitySets.suppliers.isRemoved {
            DemoServiceMetadata.EntitySets.suppliers = metadata.entitySet(withName: "Suppliers")
        }
        if !DemoServiceMetadata.FunctionImports.getProductsByRating.isRemoved {
            DemoServiceMetadata.FunctionImports.getProductsByRating = metadata.dataMethod(withName: "GetProductsByRating")
        }
        if !Address.street.isRemoved {
            Address.street = DemoServiceMetadata.ComplexTypes.address.property(withName: "Street")
        }
        if !Address.city.isRemoved {
            Address.city = DemoServiceMetadata.ComplexTypes.address.property(withName: "City")
        }
        if !Address.state.isRemoved {
            Address.state = DemoServiceMetadata.ComplexTypes.address.property(withName: "State")
        }
        if !Address.zipCode.isRemoved {
            Address.zipCode = DemoServiceMetadata.ComplexTypes.address.property(withName: "ZipCode")
        }
        if !Address.country.isRemoved {
            Address.country = DemoServiceMetadata.ComplexTypes.address.property(withName: "Country")
        }
        if !Category.id.isRemoved {
            Category.id = DemoServiceMetadata.EntityTypes.category.property(withName: "ID")
        }
        if !Category.name.isRemoved {
            Category.name = DemoServiceMetadata.EntityTypes.category.property(withName: "Name")
        }
        if !Category.products.isRemoved {
            Category.products = DemoServiceMetadata.EntityTypes.category.property(withName: "Products")
        }
        if !Product.id.isRemoved {
            Product.id = DemoServiceMetadata.EntityTypes.product.property(withName: "ID")
        }
        if !Product.name.isRemoved {
            Product.name = DemoServiceMetadata.EntityTypes.product.property(withName: "Name")
        }
        if !Product.description.isRemoved {
            Product.description = DemoServiceMetadata.EntityTypes.product.property(withName: "Description")
        }
        if !Product.releaseDate.isRemoved {
            Product.releaseDate = DemoServiceMetadata.EntityTypes.product.property(withName: "ReleaseDate")
        }
        if !Product.discontinuedDate.isRemoved {
            Product.discontinuedDate = DemoServiceMetadata.EntityTypes.product.property(withName: "DiscontinuedDate")
        }
        if !Product.rating.isRemoved {
            Product.rating = DemoServiceMetadata.EntityTypes.product.property(withName: "Rating")
        }
        if !Product.price.isRemoved {
            Product.price = DemoServiceMetadata.EntityTypes.product.property(withName: "Price")
        }
        if !Product.category.isRemoved {
            Product.category = DemoServiceMetadata.EntityTypes.product.property(withName: "Category")
        }
        if !Product.supplier.isRemoved {
            Product.supplier = DemoServiceMetadata.EntityTypes.product.property(withName: "Supplier")
        }
        if !Supplier.id.isRemoved {
            Supplier.id = DemoServiceMetadata.EntityTypes.supplier.property(withName: "ID")
        }
        if !Supplier.name.isRemoved {
            Supplier.name = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Name")
        }
        if !Supplier.address.isRemoved {
            Supplier.address = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Address")
        }
        if !Supplier.concurrency.isRemoved {
            Supplier.concurrency = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Concurrency")
        }
        if !Supplier.products.isRemoved {
            Supplier.products = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Products")
        }
    }
}
