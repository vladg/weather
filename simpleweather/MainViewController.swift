//
//  ViewController.swift
//  simpleweather
//
//  Created by Vladislav Glabai on 3/25/17.
//  Copyright © 2017 Vladislav Glabai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, LocationProviderDelegate {
	
	@IBOutlet var busyView: UIView!
	@IBOutlet var errorView: UIView!
	@IBOutlet var contentView: UIView!
	
	@IBOutlet var weatherImage: UIImageView!
	@IBOutlet var weatherDescription: UILabel!
	@IBOutlet var weatherTemp: UILabel!
	@IBOutlet var weatherHumidity: UILabel!
	
	var location: String! {
		didSet {
			self.title = self.location
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.busyView.isHidden = false;
		self.errorView.isHidden = true;
		self.contentView.isHidden = true;
		
		self.location = LocationProvider.instance.currentLocation
		LocationProvider.instance.delegate = self
		
		self.title = self.location
		let settingsImage = UIImage(named: "settings.png")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(didPressSettings))
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
		
		WeatherProvider.instance.fetchWeatherForLocation(self.location) {
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

	@IBAction func didPressSettings() {
		let alert: UIAlertController = UIAlertController(title: "Enter city", message: "", preferredStyle: .alert)
		
		let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
		let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
			let text = (alert.textFields!.first! as UITextField).text
			if let text = text {
				if(text.characters.count > 0) {
					LocationProvider.instance.currentLocation = text;
				}
				
			}
		}

		alert.addAction(cancelAction)
		alert.addAction(okAction)
		alert.addTextField() { (textField) -> Void in
		}

		self.present(alert, animated: true, completion: nil)
	}
	
	func locationDidChange() {
		self.location = LocationProvider.instance.currentLocation
		self.reload();
	}

}

