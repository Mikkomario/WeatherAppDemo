//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by Mikko Hilpinen on 26.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell
{
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var weatherLabel: UILabel!
	@IBOutlet weak var maxTempLabel: UILabel!
	@IBOutlet weak var minTempLabel: UILabel!
	
	
	private static var _dayOfTheWeekFormatter: DateFormatter!
	
	private static var dayOfTheWeekFormatter: DateFormatter
	{
		if _dayOfTheWeekFormatter == nil
		{
			_dayOfTheWeekFormatter = DateFormatter()
			//_dayOfTheWeekFormatter.dateStyle = .full
			_dayOfTheWeekFormatter.dateFormat = "EEEE"
			//_dayOfTheWeekFormatter.timeStyle = .none
		}
		
		return _dayOfTheWeekFormatter!
	}
	
	
	func configureCell(_ forecast: Weather)
	{
		dayLabel.text = WeatherCell.dayOfTheWeekFormatter.string(from: forecast.date)
		weatherLabel.text = forecast.description
		maxTempLabel.text = "\(forecast.maxTemp) °C"
		minTempLabel.text = "\(forecast.mintemp) °C"
		weatherImageView.image = UIImage(named: forecast.weatherType + " Mini")
	}
}
