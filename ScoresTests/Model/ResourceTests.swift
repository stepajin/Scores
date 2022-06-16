//
//  ResourceTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import XCTest
@testable import Scores

class ResourceTests: XCTestCase {
    func testParseArea() {
        let json = """
        {"id":2000,"name":"Afghanistan","countryCode":"AFG","flag":null,"parentAreaId":2014,"parentArea":"Asia"}
        """
        let data = json.data(using: .utf8)!
        let area = try? JSONDecoder().decode(Area.self, from: data)
        XCTAssertNotNil(area)
    }
    
    func testParseAreas() {
        let json =
        """
        {"count":272,"filters":{},"areas":[{"id":2000,"name":"Afghanistan","countryCode":"AFG","flag":null,"parentAreaId":2014,"parentArea":"Asia"},{"id":2001,"name":"Africa","countryCode":"AFR","flag":null,"parentAreaId":2267,"parentArea":"World"}]}
        """
        let data = json.data(using: .utf8)!
        let areas = try? JSONDecoder().decode(Areas.self, from: data)
        XCTAssertNotNil(areas)
    }
}
