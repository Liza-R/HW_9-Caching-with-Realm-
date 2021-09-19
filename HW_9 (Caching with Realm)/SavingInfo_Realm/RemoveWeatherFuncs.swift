//
//  SavingCurrentWeatherFunc.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation

class RemoveOldWeatherInfo{

    func removeOldCurrentInfo(){
        print("Начало удаления старой информации о текущей погоде Realm")
        let modelCurrent = RealmWeather().realm.objects(CurrentWeather.self)
        if modelCurrent.first != nil && modelCurrent.count > 2{
            let oldInfo = modelCurrent.first!
            try! RealmWeather().realm.write {
                RealmWeather().realm.delete(oldInfo)
            }
        }
        print("Конец удаления старой информации о текущей погоде Realm")
    }
    
    func removeOldForecastInfo(){
        print("Начало удаления старой информации о прогнозе погоды Realm")
        let modelForecast = RealmWeather().realm.objects(ForecastWeather.self)
        if modelForecast.first != nil && modelForecast.count > 2{
            let oldInfo = modelForecast.first!
            try! RealmWeather().realm.write {
                RealmWeather().realm.delete(oldInfo)
            }
        }
        print("Конец удаления старой информации о прогнозе погоды Realm")
    }
}
