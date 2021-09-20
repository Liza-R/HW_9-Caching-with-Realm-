//
//  SavingCurrentWeatherFunc.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation

class RemoveOldWeatherInfo{
    func removeOldCurrentInfo(){
        let modelCurrent = RealmWeather().realm.objects(CurrentWeather.self)
        if modelCurrent.first != nil && modelCurrent.count > 2{
            try! RealmWeather().realm.write {
                RealmWeather().realm.delete(modelCurrent.first!)
            }
        }
    }
    
    func removeOldForecastInfo(){
        let modelForecast = RealmWeather().realm.objects(ForecastWeather.self)
        if modelForecast.first != nil && modelForecast.count > 2{
            try! RealmWeather().realm.write {
                RealmWeather().realm.delete(modelForecast.first!)
            }
        }
    }
}
