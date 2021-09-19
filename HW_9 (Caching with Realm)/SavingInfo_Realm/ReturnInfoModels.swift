//
//  ReturnInfoModels.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation
import RealmSwift

class ReturnInfoModels{
    func returnCurrentInfo(realm: Realm) -> Results<CurrentWeather>{
        print("Начало создания модели текущей погоды Realm")
        let modelCurrent = realm.objects(CurrentWeather.self)
        print("Конец создания модели текущей погоды Realm")
        return modelCurrent
    }
    func returnForecastInfo(realm: Realm) -> Results<ForecastWeather>{
        print("Начало создания модели прогноза погоды Realm")
        let modelForecast = realm.objects(ForecastWeather.self)
        print("Конец создания модели прогноза погоды Realm")
        return modelForecast
    }
    func returnNewCityName(realm: Realm) -> Results<SearchCityName>{
        print("Начало создания модели сохранённых городов")
        let modelCity = realm.objects(SearchCityName.self)
        print("Конец создания модели сохранённых городов")
        return modelCity
    }
}
