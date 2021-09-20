//
//  TodayLoader.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import Alamofire

class CorrentLoader{
    func loadCurrentInfo(completion: @escaping ([CurrentWeatherStruct.Current_Info]) -> Void){
        AF.request(URL(string: URLs().url_current_uploadAlam)!)
        .validate()
            .responseDecodable(of: CurrentWeatherStruct.Current_Info.self) { (response) in
          guard let currentInfo = response.value else { return }
                completion([currentInfo])
        }
    }
}

