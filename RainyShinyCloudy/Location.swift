//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by Mikko Hilpinen on 26.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import Foundation
import CoreLocation

// This is how to use a singleton class. But please, don't use it here...
class Location
{
	static var sharedInstance = Location()
	var latitude: Double!
	var longitude: Double!
	
	private init()
	{
		// Empty initialiser
	}
}
