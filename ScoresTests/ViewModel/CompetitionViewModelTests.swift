//
//  CompetitionViewModelTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import XCTest
@testable import Scores

class CompetitionViewModelTests: XCTestCase {
    let defaults = UserDefaults.standard
    
    let competition: Competition = ["id": 1, "name": "PL"].resource()
    
    override func setUp() {
        UserDefaults.standard.remove(from: .main)
    }
    
    func testToggleFavorite() {
        let viewModel = CompetitionViewModel(competition: competition)
        XCTAssertFalse(viewModel.isFavorite)
        viewModel.toggleFavorite()
        XCTAssertTrue(viewModel.isFavorite)
    }
}
