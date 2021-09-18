//
//  TodayLoader.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import Alamofire

class CorrentLoader{
    func loadCurrentInfo(completion: @escaping ([CurrentWeatherStruct.All_Day_Info]) -> Void){
        AF.request(URL(string: url_today_uploadAlam)!)
        .validate()
            .responseDecodable(of: CurrentWeatherStruct.All_Day_Info.self) { (response) in
          guard let currentInfo = response.value else { return }
                completion([currentInfo])
        }
    }
}

