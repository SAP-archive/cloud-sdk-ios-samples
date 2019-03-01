// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

open class Supplier: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var id_: Property = DemoServiceMetadata.EntityTypes.supplier.property(withName: "ID")

    private static var name_: Property = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Name")

    private static var address_: Property = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Address")

    private static var concurrency_: Property = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Concurrency")

    private static var products_: Property = DemoServiceMetadata.EntityTypes.supplier.property(withName: "Products")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: DemoServiceMetadata.EntityTypes.supplier)
    }

    open class var address: Property {
        get {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                return Supplier.address_
            }
        }
        set(value) {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                Supplier.address_ = value
            }
        }
    }

    open var address: Address? {
        get {
            return CastOptional<Address>.from(self.optionalValue(for: Supplier.address))
        }
        set(value) {
            self.setOptionalValue(for: Supplier.address, to: value)
        }
    }

    open class func array(from: EntityValueList) -> Array<Supplier> {
        return ArrayConverter.convert(from.toArray(), Array<Supplier>())
    }

    open class var concurrency: Property {
        get {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                return Supplier.concurrency_
            }
        }
        set(value) {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                Supplier.concurrency_ = value
            }
        }
    }

    open var concurrency: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: Supplier.concurrency))
        }
        set(value) {
            self.setOptionalValue(for: Supplier.concurrency, to: IntValue.of(optional: value))
        }
    }

    open func copy() -> Supplier {
        return CastRequired<Supplier>.from(self.copyEntity())
    }

    open class var id: Property {
        get {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                return Supplier.id_
            }
        }
        set(value) {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                Supplier.id_ = value
            }
        }
    }

    open var id: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: Supplier.id))
        }
        set(value) {
            self.setOptionalValue(for: Supplier.id, to: IntValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(id: Int?) -> EntityKey {
        return EntityKey().with(name: "ID", value: IntValue.of(optional: id))
    }

    open class var name: Property {
        get {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                return Supplier.name_
            }
        }
        set(value) {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                Supplier.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Supplier.name))
        }
        set(value) {
            self.setOptionalValue(for: Supplier.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Supplier {
        return CastRequired<Supplier>.from(self.oldEntity)
    }

    open class var products: Property {
        get {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                return Supplier.products_
            }
        }
        set(value) {
            objc_sync_enter(Supplier.self)
            defer { objc_sync_exit(Supplier.self) }
            do {
                Supplier.products_ = value
            }
        }
    }

    open var products: Array<Product> {
        get {
            return ArrayConverter.convert(EntityValueList.castRequired(self.requiredValue(for: Supplier.products)).toArray(), Array<Product>())
        }
        set(value) {
            Supplier.products.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, Array<EntityValue>())))
        }
    }
}
