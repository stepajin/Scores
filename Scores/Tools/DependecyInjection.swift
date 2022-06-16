//
//  Swinject.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation
import Swinject

@propertyWrapper
public struct Inject<T> {
    private var service: T

    public init() {
        service = DI.container.resolve(T.self)!
    }

    public var wrappedValue: T {
        get { service }
        set { service = newValue }
    }
}

struct DI {
    static let container = Container()
}
