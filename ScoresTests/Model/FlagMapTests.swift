//
//  FlagMapTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import XCTest
@testable import Scores

class FlagMapTests: XCTestCase {
    func testFlags() {
        XCTAssertEqual("🇨🇿", FlagMap.shared.map["Czechia"]?.emoji)
    }
}
