// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

internal class DemoServiceStaticResolver {
    static func resolve() {
        DemoServiceStaticResolver.resolve1()
    }

    private static func resolve1() {
        Ignore.valueOf_any(DemoServiceMetadata.ComplexTypes.address)
        Ignore.valueOf_any(DemoServiceMetadata.EntityTypes.category)
        Ignore.valueOf_any(DemoServiceMetadata.EntityTypes.product)
        Ignore.valueOf_any(DemoServiceMetadata.EntityTypes.supplier)
        Ignore.valueOf_any(DemoServiceMetadata.EntitySets.categories)
        Ignore.valueOf_any(DemoServiceMetadata.EntitySets.products)
        Ignore.valueOf_any(DemoServiceMetadata.EntitySets.suppliers)
        Ignore.valueOf_any(DemoServiceMetadata.FunctionImports.getProductsByRating)
        Ignore.valueOf_any(Address.street)
        Ignore.valueOf_any(Address.city)
        Ignore.valueOf_any(Address.state)
        Ignore.valueOf_any(Address.zipCode)
        Ignore.valueOf_any(Address.country)
        Ignore.valueOf_any(Category.id)
        Ignore.valueOf_any(Category.name)
        Ignore.valueOf_any(Category.products)
        Ignore.valueOf_any(Product.id)
        Ignore.valueOf_any(Product.name)
        Ignore.valueOf_any(Product.description)
        Ignore.valueOf_any(Product.releaseDate)
        Ignore.valueOf_any(Product.discontinuedDate)
        Ignore.valueOf_any(Product.rating)
        Ignore.valueOf_any(Product.price)
        Ignore.valueOf_any(Product.category)
        Ignore.valueOf_any(Product.supplier)
        Ignore.valueOf_any(Supplier.id)
        Ignore.valueOf_any(Supplier.name)
        Ignore.valueOf_any(Supplier.address)
        Ignore.valueOf_any(Supplier.concurrency)
        Ignore.valueOf_any(Supplier.products)
    }
}
