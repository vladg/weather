//
//  LocationProvider.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import Foundation

protocol LocationProviderDelegate: class {
	func locationDidChange()
}

class LocationProvider {
	static let instance = LocationProvider()
	static let LOCATION_KEY = "Location"
	
	weak var delegate: LocationProviderDelegate?
	
	init() {
		self.delegate = nil
	}
	
	var currentLocation: String {
		get {
			let loc = UserDefaults.standard.value(forKey: LocationProvider.LOCATION_KEY) as? String
			return (loc ?? "Dallas")
		}
		
		set(value) {
			UserDefaults.standard.set(value, forKey: LocationProvider.LOCATION_KEY)
		self.delegate?.locationDidChange()
		}
	}
	
	func reset() {
		UserDefaults.standard.removeObject(forKey: LocationProvider.LOCATION_KEY)
	}
}
