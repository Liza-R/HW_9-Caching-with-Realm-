//
//  DaysLoader.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import Alamofire

class ForecastDaysLoader{
     func loadForecastInfo(completion: @escaping ([ForecastWeatherStruct.Forecast_Info]) -> Void){
        AF.request(URL(string: URLs().url_forecast_uploadAlam)!)
        .validate()
            .responseDecodable(of: ForecastWeatherStruct.Forecast_Info.self) { (response) in
                    guard let forecast = response.value else { return }
                    completion([forecast])
        }
    }
}
