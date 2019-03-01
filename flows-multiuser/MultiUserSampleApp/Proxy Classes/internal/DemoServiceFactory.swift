// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

internal class DemoServiceFactory {
    static func registerAll() throws {
        DemoServiceMetadata.ComplexTypes.address.registerFactory(ObjectFactory.with(create: { Address(withDefaults: false) }, createWithDecoder: { d in try Address(from: d) }))
        DemoServiceMetadata.EntityTypes.category.registerFactory(ObjectFactory.with(create: { Category(withDefaults: false) }, createWithDecoder: { d in try Category(from: d) }))
        DemoServiceMetadata.EntityTypes.product.registerFactory(ObjectFactory.with(create: { Product(withDefaults: false) }, createWithDecoder: { d in try Product(from: d) }))
        DemoServiceMetadata.EntityTypes.supplier.registerFactory(ObjectFactory.with(create: { Supplier(withDefaults: false) }, createWithDecoder: { d in try Supplier(from: d) }))
        DemoServiceStaticResolver.resolve()
    }
}
