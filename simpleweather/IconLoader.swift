//
//  IconLoader.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import UIKit

class IconLoader {
	static var instance = IconLoader()
	static let BASE_URL = "http://openweathermap.org/img/w/"
	
	let queue: DispatchQueue
	
	init() {
		self.queue = DispatchQueue(label: "IconLoader")
	}
	
	func loadIcon(_ icon: String, handler: @escaping (UIImage?) -> Void) {
		self.queue.async() {
			let urlString = IconLoader.BASE_URL + icon + ".png"
			let url = NSURL(string: urlString)!
			let data = NSData(contentsOf: url as URL)
			let image = UIImage(data: data as! Data)
			DispatchQueue.main.async() {
				handler(image)
			}
		}
	}
}
