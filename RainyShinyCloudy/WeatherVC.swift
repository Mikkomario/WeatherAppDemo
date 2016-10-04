//
//  ViewController.swift
//  RainyShinyCloudy
//
//  Created by Mikko Hilpinen on 15.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate
{
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var weatherTableView: UITableView!
	@IBOutlet weak var weatherLabel: UILabel!
	
	private var forecast = [Weather]()
	private let locationManager = CLLocationManager()
	
	private static var _currentDateformatter: DateFormatter!
	
	private static var currentDateFormatter: DateFormatter
	{
		if _currentDateformatter == nil
		{
			_currentDateformatter = DateFormatter()
			_currentDateformatter.dateStyle = .short
			_currentDateformatter.timeStyle = .none
		}
		
		return _currentDateformatter!
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		weatherTableView.delegate = self
		weatherTableView.dataSource = self
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startMonitoringSignificantLocationChanges()
		locationManager.startUpdatingLocation()
		
		//updateWeatherOnLocation(locationManager.location)
		//locationManager.requestLocation()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return forecast.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		// Finds a reusable cell to use as the base
		if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell
		{
			cell.configureCell(forecast[indexPath.row])
			return cell
		}
		// No more editing required
		else
		{
			// TODO: failing here could be preferable
			return WeatherCell()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		print("LOCATIONS")
		for location in locations
		{
			print("lat: \(location.coordinate.latitude), lon: \(location.coordinate.longitude)")
		}
		
		updateWeatherOnLocation(locations.last)
		locationManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		print("LOCATION REQUEST FAILED")
		print(error)
	}
	
	/*
	private func locationAuthStatus()
	{
		if CLLocationManager.authorizationStatus() != .authorizedWhenInUse
		{
			locationManager.requestWhenInUseAuthorization()
		}
		
		// TODO: Remove from here
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
		{
			currentLocation = locationManager.location
		}
	}
*/
	
	private func updateWeatherOnLocation(_ location: CLLocation?)
	{
		// Updates local data with new location data
		if let location = location
		{
			Weather().downloadWeatherDetails(at: location, completed: updateMainUI)
			WeatherVC.downloadforecastData(at: location)
			{
				weathers in
				
				print("DONWLOADED \(weathers.count) DAYS OF FORECAST")
				self.forecast = weathers
				
				// removes the first result (this day)
				if !self.forecast.isEmpty
				{
					self.forecast.remove(at: 0)
				}
				
				// Updates the table as well
				self.weatherTableView.reloadData()
			}
		}
	}
	
	private static func downloadforecastData(at location: CLLocation, completed: @escaping ([Weather]) -> ())
	{
		print("FORECAST DOWNLOAD STARTING")
		
		let urlString = FORECAST_URL(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, days: 7)
		let url = URL(string: urlString)
		print(urlString)
		Alamofire.request(url!).responseJSON
		{
			response in
			
			print(response)
			var forecasts = [Weather]()
			let result = response.result
			if let body = result.value as? [String : AnyObject]
			{
				// TODO: Code retrieving simply doesn't work
				/*if let code = body["cod"] as? Int
				{
					if code == 200
					{*/
				if let forecastList = body["list"] as? [[String : AnyObject]]
				{
					for forecastData in forecastList
					{
						forecasts.append(Weather(forecastData))
					}
				}
					/*}
					else
					{
						print(response)
					}
				}
				else
				{
					print("NO CODE IN RESPONSE")
				}
*/
			}
			
			completed(forecasts)
		}
	}
	
	private func updateMainUI(currentWeather: Weather)
	{
		print(currentWeather.cityName)
		print(currentWeather.weatherType)
		print(currentWeather.date)
		
		dateLabel.text = "Today, " + WeatherVC.currentDateFormatter.string(from: currentWeather.date)
		temperatureLabel.text = "\(Int(currentWeather.temp)) °C"
		weatherLabel.text = currentWeather.description
		locationLabel.text = currentWeather.cityName
		weatherImageView.image = UIImage(named: currentWeather.weatherType)
	}
}

