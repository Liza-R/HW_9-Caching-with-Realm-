//
//  AllStructs.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import UIKit

class DaysInfo{
    struct All_Day_Info: Decodable{
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
    
    struct forBaseTableAlam{
        var temper_Alam: String,
            icon_Alam: UIImage,
            descript_Alam: String,
            data_Alam: String,
            time_Alam: String
    }
}

