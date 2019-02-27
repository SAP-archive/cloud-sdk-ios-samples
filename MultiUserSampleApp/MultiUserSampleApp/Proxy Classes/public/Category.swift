// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

open class Category: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var id_: Property = DemoServiceMetadata.EntityTypes.category.property(withName: "ID")

    private static var name_: Property = DemoServiceMetadata.EntityTypes.category.property(withName: "Name")

    private static var products_: Property = DemoServiceMetadata.EntityTypes.category.property(withName: "Products")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: DemoServiceMetadata.EntityTypes.category)
    }

    open class func array(from: EntityValueList) -> Array<Category> {
        return ArrayConverter.convert(from.toArray(), Array<Category>())
    }

    open func copy() -> Category {
        return CastRequired<Category>.from(self.copyEntity())
    }

    open class var id: Property {
        get {
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                return Category.id_
            }
        }
        set(value) {
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                Category.id_ = value
            }
        }
    }

    open var id: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: Category.id))
        }
        set(value) {
            self.setOptionalValue(for: Category.id, to: IntValue.of(optional: value))
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
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                return Category.name_
            }
        }
        set(value) {
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                Category.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Category.name))
        }
        set(value) {
            self.setOptionalValue(for: Category.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Category {
        return CastRequired<Category>.from(self.oldEntity)
    }

    open class var products: Property {
        get {
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                return Category.products_
            }
        }
        set(value) {
            objc_sync_enter(Category.self)
            defer { objc_sync_exit(Category.self) }
            do {
                Category.products_ = value
            }
        }
    }

    open var products: Array<Product> {
        get {
            return ArrayConverter.convert(EntityValueList.castRequired(self.requiredValue(for: Category.products)).toArray(), Array<Product>())
        }
        set(value) {
            Category.products.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, Array<EntityValue>())))
        }
    }
}
