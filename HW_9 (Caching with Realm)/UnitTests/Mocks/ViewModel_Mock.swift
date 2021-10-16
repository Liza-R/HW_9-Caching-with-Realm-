//
//  ViewModel_Mock.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation
import Alamofire

class ViewModel_Mock: CurrentLoader{
    var curInfoLoad = false,
        forecastInfoLoad = false
    
    override func loadCurrentInfo(completion: @escaping ([CurrentWeatherStruct.Current_Info]) -> Void) {
        AF.request(URL(string: URLs().url_current_uploadAlam)!)
        .validate()
            .responseDecodable(of: CurrentWeatherStruct.Current_Info.self) { (response) in
                let error = response.error?.errorDescription
                if error == nil{
                    self.curInfoLoad = true
                }else{
                    self.curInfoLoad = false
                }
          guard let currentInfo = response.value else { return }
                completion([currentInfo])
        }
    }
}
