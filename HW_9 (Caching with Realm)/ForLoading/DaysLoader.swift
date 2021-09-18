//
//  DaysLoader.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import Alamofire

class TodayFiveDaysLoader{
     func loadFiveDaysAlamofire(completion: @escaping ([ForecastWeatherStruct.All_Five_Days_Info]) -> Void){
        
        AF.request(URL(string: url_fiveDays_uploadAlam)!)
        .validate()
            .responseDecodable(of: ForecastWeatherStruct.All_Five_Days_Info.self) { (response) in
                    guard let five_days = response.value else { return }
                    completion([five_days])
        }
    }
}
