//
//  UserDefaultsTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import XCTest
@testable import Scores

class UserDefaultsTests: XCTestCase {
    let defaults = UserDefaults.standard
    
    override func setUp() {
        defaults.remove(from: .main)
    }
    
    func testFavorites() {
        XCTAssertFalse(defaults.isFavorite(id: 1))
        defaults.addFavoriteCompetition(id: 1)
        XCTAssertTrue(defaults.isFavorite(id: 1))
        defaults.removeFavoriteCompetition(id: 1)
        XCTAssertFalse(defaults.isFavorite(id: 1))
    }
}
