//
//  ViewController.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet var busyView: UIView!
	@IBOutlet var errorView: UIView!
	@IBOutlet var contentView: UIView!
	
	@IBOutlet var weatherImage: UIImageView!
	@IBOutlet var weatherDescription: UILabel!
	@IBOutlet var weatherTemp: UILabel!
	@IBOutlet var weatherHumidity: UILabel!
	

	override func viewDidLoad() {
		super.viewDidLoad()

		self.busyView.isHidden = false;
		self.errorView.isHidden = true;
		self.contentView.isHidden = true;
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);
		reload();
	}
	
	@IBAction func reload() {
		// show busy indicator
		self.busyView.isHidden = false;
		self.errorView.isHidden = true;
		self.contentView.isHidden = true;
		
		WeatherProvider.instance.fetchWeatherForLocation("Dallas") {
			(json: NSDictionary?) in
			
			self.busyView.isHidden = true;
			if let json = json {
				let icon = WeatherProvider.extractIcon(json)
				let description = WeatherProvider.extractDescription(json)
				let temp = WeatherProvider.extractTemp(json)
				let humidity = WeatherProvider.extractHumidity(json)
				
				self.weatherDescription.text = description
				self.weatherTemp.text = temp
				self.weatherHumidity.text = humidity
				
				if let icon = icon {
					self.weatherImage.image = nil;
					IconLoader.instance.loadIcon(icon) {
						(image: UIImage?) in
						self.weatherImage.image = image;
					}
				}

				self.contentView.isHidden = false;
			} else {
				self.errorView.isHidden = false;
			}
		}
	}


}

