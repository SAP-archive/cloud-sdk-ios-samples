// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

open class Product: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var id_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "ID")

    private static var name_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Name")

    private static var description_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Description")

    private static var releaseDate_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "ReleaseDate")

    private static var discontinuedDate_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "DiscontinuedDate")

    private static var rating_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Rating")

    private static var price_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Price")

    private static var category_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Category")

    private static var supplier_: Property = DemoServiceMetadata.EntityTypes.product.property(withName: "Supplier")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: DemoServiceMetadata.EntityTypes.product)
    }

    open class func array(from: EntityValueList) -> Array<Product> {
        return ArrayConverter.convert(from.toArray(), Array<Product>())
    }

    open class var category: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.category_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.category_ = value
            }
        }
    }

    open var category: Category? {
        get {
            return CastOptional<Category>.from(self.optionalValue(for: Product.category))
        }
        set(value) {
            self.setOptionalValue(for: Product.category, to: value)
        }
    }

    open func copy() -> Product {
        return CastRequired<Product>.from(self.copyEntity())
    }

    open class var description: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.description_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.description_ = value
            }
        }
    }

    open var description: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.description))
        }
        set(value) {
            self.setOptionalValue(for: Product.description, to: StringValue.of(optional: value))
        }
    }

    open class var discontinuedDate: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.discontinuedDate_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.discontinuedDate_ = value
            }
        }
    }

    open var discontinuedDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Product.discontinuedDate))
        }
        set(value) {
            self.setOptionalValue(for: Product.discontinuedDate, to: value)
        }
    }

    open class var id: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.id_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.id_ = value
            }
        }
    }

    open var id: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: Product.id))
        }
        set(value) {
            self.setOptionalValue(for: Product.id, to: IntValue.of(optional: value))
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
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.name_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.name))
        }
        set(value) {
            self.setOptionalValue(for: Product.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Product {
        return CastRequired<Product>.from(self.oldEntity)
    }

    open class var price: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.price_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.price_ = value
            }
        }
    }

    open var price: BigInteger? {
        get {
            return IntegerValue.optional(self.optionalValue(for: Product.price))
        }
        set(value) {
            self.setOptionalValue(for: Product.price, to: IntegerValue.of(optional: value))
        }
    }

    open class var rating: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.rating_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.rating_ = value
            }
        }
    }

    open var rating: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: Product.rating))
        }
        set(value) {
            self.setOptionalValue(for: Product.rating, to: IntValue.of(optional: value))
        }
    }

    open class var releaseDate: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.releaseDate_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.releaseDate_ = value
            }
        }
    }

    open var releaseDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Product.releaseDate))
        }
        set(value) {
            self.setOptionalValue(for: Product.releaseDate, to: value)
        }
    }

    open class var supplier: Property {
        get {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                return Product.supplier_
            }
        }
        set(value) {
            objc_sync_enter(Product.self)
            defer { objc_sync_exit(Product.self) }
            do {
                Product.supplier_ = value
            }
        }
    }

    open var supplier: Supplier? {
        get {
            return CastOptional<Supplier>.from(self.optionalValue(for: Product.supplier))
        }
        set(value) {
            self.setOptionalValue(for: Product.supplier, to: value)
        }
    }
}
