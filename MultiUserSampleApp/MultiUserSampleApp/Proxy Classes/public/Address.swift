// # Proxy Compiler 19.1.0-995ae6-20190123

import Foundation
import SAPOData

open class Address: ComplexValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var street_: Property = DemoServiceMetadata.ComplexTypes.address.property(withName: "Street")

    private static var city_: Property = DemoServiceMetadata.ComplexTypes.address.property(withName: "City")

    private static var state_: Property = DemoServiceMetadata.ComplexTypes.address.property(withName: "State")

    private static var zipCode_: Property = DemoServiceMetadata.ComplexTypes.address.property(withName: "ZipCode")

    private static var country_: Property = DemoServiceMetadata.ComplexTypes.address.property(withName: "Country")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: DemoServiceMetadata.ComplexTypes.address)
    }

    open class var city: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.city_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.city_ = value
            }
        }
    }

    open var city: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.city))
        }
        set(value) {
            self.setOptionalValue(for: Address.city, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> Address {
        return CastRequired<Address>.from(self.copyComplex())
    }

    open class var country: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.country_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.country_ = value
            }
        }
    }

    open var country: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.country))
        }
        set(value) {
            self.setOptionalValue(for: Address.country, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open var old: Address {
        return CastRequired<Address>.from(self.oldComplex)
    }

    open class var state: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.state_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.state_ = value
            }
        }
    }

    open var state: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.state))
        }
        set(value) {
            self.setOptionalValue(for: Address.state, to: StringValue.of(optional: value))
        }
    }

    open class var street: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.street_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.street_ = value
            }
        }
    }

    open var street: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.street))
        }
        set(value) {
            self.setOptionalValue(for: Address.street, to: StringValue.of(optional: value))
        }
    }

    open class var zipCode: Property {
        get {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                return Address.zipCode_
            }
        }
        set(value) {
            objc_sync_enter(Address.self)
            defer { objc_sync_exit(Address.self) }
            do {
                Address.zipCode_ = value
            }
        }
    }

    open var zipCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Address.zipCode))
        }
        set(value) {
            self.setOptionalValue(for: Address.zipCode, to: StringValue.of(optional: value))
        }
    }
}
