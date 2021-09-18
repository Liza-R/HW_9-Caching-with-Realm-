//
//  ForecastWeatherStruct.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation

class ForecastWeatherStruct{
    struct All_Five_Days_Info: Decodable{
        var cod: String,
        list: [List?]
    }
    struct List: Decodable{
        var main: Main_5?,
        dt_txt: String,
        weather: [Weather_5?]
    }
    struct Main_5: Decodable{
        var temp: Double,
        temp_min: Double,
        temp_max: Double
    }
    struct Weather_5: Decodable{
        var icon: String,
        description: String
    }
}
