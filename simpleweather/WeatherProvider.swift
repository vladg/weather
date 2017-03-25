//
//  WeatherProvider.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import Foundation

class WeatherProvider {
	static let instance = WeatherProvider()
	static let API_KEY = "00d6a04371eea33bc61269fbd760ee1e"
	static let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
	
	// HTTP or JSON deserialization error will not be meaningfull to the end user
	// therefore this method will discard all errors and simply call handler with nil
	// also, for this sample project we will not model out weather as a class nor
    // will we do any validation on the received weather info
	// simply return weather information as NSDictionary
	
	func fetchWeatherForLocation(_ location: String, handler: @escaping (NSDictionary?) -> Void) {
		let urlString = WeatherProvider.BASE_URL + "APPID=\(WeatherProvider.API_KEY)" + "&" + "q=\(location)"
		let url = URL(string: urlString)
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			guard error == nil else {
				debugPrint(error!);
				DispatchQueue.main.async { handler(nil) }
				return;
			}
			
			if let jsonData = data {
				let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
				debugPrint("===>" + jsonString!)
				do {
					let json = try JSONSerialization.jsonObject(with: jsonData)
					if(json is NSDictionary) {
						debugPrint(json)
						let code = (json as! NSDictionary)["cod"] as? Int
						if (code != nil && code == 200) {
							DispatchQueue.main.async { handler(json as? NSDictionary) }
						} else {
							DispatchQueue.main.async { handler(nil) }
						}
					} else {
						// in theory this we probably should also check for JSON array
						// but for this sample project we don't care about that
						DispatchQueue.main.async { handler(nil) }
					}
				} catch {
					DispatchQueue.main.async { handler(nil) }
				}
			}
		}
		task.resume()
	}
	
	class func extractIcon(_ json: NSDictionary) -> String? {
		let weatherList = json["weather"] as? NSArray
		let weather = weatherList?[0] as? NSDictionary
		let icon = weather?["icon"] as? String
		return icon
	}

	class func extractDescription(_ json: NSDictionary) -> String? {
		let weatherList = json["weather"] as? NSArray
		let weather = weatherList?[0] as? NSDictionary
		let description = weather?["description"] as? String
		return description
	}

	class func extractTemp(_ json: NSDictionary) -> String? {
		let main = json["main"] as? NSDictionary
		let temp = main?["temp"] as? Double
		guard temp != nil else { return nil }
		let tempC = temp! - 273 // Kelvin to Celsius
		let tempF = ((9 * tempC) / 5) + 32 // Celsius to Fahrenheit
		let roundedTemp = Double(round(tempF * 10) / 10) // round to one digit after decimal
		return "\(roundedTemp)°F"
	}

	class func extractHumidity(_ json: NSDictionary) -> String? {
		let main = json["main"] as? NSDictionary
		let humidity = main?["humidity"] as? Int
		guard humidity != nil else { return nil }
		return "\(humidity!)%"
	}
}
