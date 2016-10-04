//
//  Weather.swift
//  RainyShinyCloudy
//
//  Created by Mikko Hilpinen on 26.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class Weather
{
	private var _cityName = ""
	private var _date = Date()
	private var _weatherType = ""
	private var _description = ""
	private var _temp = 0.0
	private var _minTemp = 0.0
	private var _maxTemp = 0.0
	
	var cityName: String {return _cityName}
	var date: Date {return _date}
	var weatherType: String {return _weatherType}
	var temp: Double {return _temp}
	var mintemp: Double {return _minTemp}
	var maxTemp: Double {return _maxTemp}
	var description: String {return _description}
	
	init()
	{
		// Empty initialiser
	}
	
	init(_ element: [String : AnyObject])
	{
		if let temperatureBody = element["temp"] as? [String : Double]
		{
			_temp = Weather.celcius(kelvin: temperatureBody["day"]!)
			_minTemp = Weather.celcius(kelvin: temperatureBody["min"]!)
			_maxTemp = Weather.celcius(kelvin: temperatureBody["max"]!)
		}
		if let weathers = element["weather"] as? [[String : AnyObject]]
		{
			parseWeathers(weathers)
		}
		if let unixDate = element["dt"] as? TimeInterval
		{
			_date = Date(timeIntervalSince1970: unixDate)
		}
	}
	
	func downloadWeatherDetails(at location: CLLocation, completed: @escaping (Weather) -> ())
	{
		let currentWeatherURL = URL(string: CURRENT_WEATHER_URL(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
		
		//var request = URLRequest(url: currentWeatherURL!)
		Alamofire.request(currentWeatherURL!).responseJSON
		{
			response in
			let result = response.result
			
			print()
			print()
			if let body = result.value as? [String : AnyObject]
			{
				print(body)
				
				if let code = body["cod"] as? Int
				{
					if code == 200
					{
						if let name = body["name"] as? String
						{
							self._cityName = name.capitalized
						}
						
						if let weathers = body["weather"] as? [[String : AnyObject]]
						{
							self.parseWeathers(weathers)
						}
						
						if let temperatureBody = body["main"] as? [String: AnyObject], let temperatureKelvin = temperatureBody["temp"] as? Double
						{
							self._temp = Weather.celcius(kelvin: temperatureKelvin)
						}
					}
					else
					{
						self._cityName = "Unknown"
						self._temp = 0
						self._weatherType = "Cloudy"
					}
				}
				else
				{
					print("NO CODE IN RESPONSE")
				}
			}
			else
			{
				print("FAILED")
				print(response)
				self._cityName = "Unknown"
				self._temp = 0
				self._weatherType = "Cloudy"

			}
			
			print()
			print()
			
			completed(self)
		}
	}
	
	private func parseWeathers(_ weathers: [[String : AnyObject]])
	{
		if let weather = weathers[0]["main"] as? String
		{
			self._weatherType = weather.capitalized
		}
		if let description = weathers[0]["description"] as? String
		{
			self._description = description
		}
	}
	
	private static func celcius(kelvin: Double) -> Double
	{
		return round(kelvin - 273.15)
	}
}
