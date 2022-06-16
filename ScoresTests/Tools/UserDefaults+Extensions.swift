//
//  UserDefaults+Extensions.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 16.06.2022.
//

import Foundation

extension UserDefaults {
    func remove(from bundle: Bundle) {
        guard let bundleId = bundle.bundleIdentifier else { return }
        removePersistentDomain(forName: bundleId)
    }
}
