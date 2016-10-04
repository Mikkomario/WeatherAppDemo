//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by Mikko Hilpinen on 26.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import Foundation

// Btw, this doesn't seem to be a good idea in the long run
let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let CURRENT = "weather"
let FORECAST = "forecast/daily"
let LATITUDE_PARAM = "lat"
let LONGITUDE_PARAM = "lon"
let APP_ID_PARAM = "appid"
let APP_ID = "45dd981d2adec8c979f79bf7d3dc1ee8"
let FORECAST_LENGTH_PARAM = "cnt"

typealias DownloadComplete = () -> ()

func CURRENT_WEATHER_URL(latitude: Double, longitude: Double) -> String
{
	return "\(BASE_URL)\(CURRENT)?\(LATITUDE_PARAM)=\(latitude)&\(LONGITUDE_PARAM)=\(longitude)&\(APP_ID_PARAM)=\(APP_ID)"
}

func FORECAST_URL(latitude: Double, longitude: Double, days: Int) -> String
{
	return "\(BASE_URL)\(FORECAST)?\(LATITUDE_PARAM)=\(latitude)&\(LONGITUDE_PARAM)=\(longitude)&\(FORECAST_LENGTH_PARAM)=\(days)&\(APP_ID_PARAM)=\(APP_ID)"
}
