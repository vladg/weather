//
//  LocationProviderTest.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import XCTest
@testable import simpleweather

class LocationProviderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test() {
		LocationProvider.instance.reset();
		let loc = LocationProvider.instance.currentLocation;
		XCTAssert(loc.characters.count > 0)
		LocationProvider.instance.currentLocation = "London"
		let london = LocationProvider.instance.currentLocation
		XCTAssert(london == "London")
		LocationProvider.instance.currentLocation = "Paris";
		let paris = LocationProvider.instance.currentLocation
		XCTAssert(paris == "Paris")
		LocationProvider.instance.reset()
		let defaultLoc = LocationProvider.instance.currentLocation
		XCTAssert(defaultLoc != "Paris")
    }
    
}
