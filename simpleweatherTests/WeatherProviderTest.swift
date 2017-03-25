//
//  WeatherProviderTest.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import XCTest
@testable import simpleweather


class WeatherProviderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test() {
		let responseReceived = expectation(description: "Response received")
		let haveJson = expectation(description: "Got json data")
		let haveWeatherInfo = expectation(description: "Got weather information")
		WeatherProvider.instance.fetchWeatherForLocation("Dallas") {
			(json: NSDictionary?)  in
			responseReceived.fulfill()
			if(json != nil) {
				haveJson.fulfill()
				let icon = WeatherProvider.extractIcon(json!)
				let description = WeatherProvider.extractDescription(json!)
				let temp = WeatherProvider.extractTemp(json!)
				let humidity = WeatherProvider.extractHumidity(json!)
				if (icon != nil && description != nil && temp != nil && humidity != nil) {
					haveWeatherInfo.fulfill()
				}
			}
		}
		waitForExpectations(timeout: 2, handler: nil)
	}

	func testNotFound() {
		let noWeatherData = expectation(description: "No weather data for this location")
		WeatherProvider.instance.fetchWeatherForLocation("askldjfanildjfgqkv") {
			(json: NSDictionary?)  in
			if(json == nil) {
				noWeatherData.fulfill()
			}
		}
		waitForExpectations(timeout: 2, handler: nil)
	}
}
