//
//  RealmVarForMainVC.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation

class RealmVars{
    let currentInfoRealm = ReturnInfoModels().returnCurrentInfo(realm: RealmWeather().realm),
        currentImageRealm = ReturnInfoModels().returnCurrentImage(realm: RealmWeather().realm),
        forecastInfoRealm = ReturnInfoModels().returnForecastInfo(realm: RealmWeather().realm),
        forecastImagesRealm = ReturnInfoModels().returnForecastImages(realm: RealmWeather().realm),
        saveNewCity = ReturnInfoModels().returnNewCityName(realm: RealmWeather().realm)
}
