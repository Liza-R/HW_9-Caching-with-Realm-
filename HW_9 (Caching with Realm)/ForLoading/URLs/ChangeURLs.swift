//
//  ChangeURLs.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation

class ChangingURLs{
    func changeCurrentURLAlam(cityName: String){
        URLs().url_current_uploadAlam = "https://api.openweathermap.org/data/2.5/weather?q=\(cityNameAlam)&appid=f786f3131537f8ee067b397b6f7753be".encodeUrl
    }
    func changeForecastURLAlam(cityName: String){
        URLs().url_forecast_uploadAlam = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityNameAlam)&appid=f786f3131537f8ee067b397b6f7753be".encodeUrl
    }
}
