//
//  CurrentWeatherStrust.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation

class CurrentWeatherStruct{
    struct Current_Info: Decodable{
        var weather: [Weather?],
        main: Main?,
        dt: Int64,
        name: String,
        cod: Int
    }
    struct Weather: Decodable{
        var main: String,
        description: String,
        icon: String
    }
    struct Main: Decodable{
        var temp: Double,
        feels_like: Double,
        temp_max: Double,
        temp_min: Double
    }
}
