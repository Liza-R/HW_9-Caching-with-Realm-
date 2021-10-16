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
        return realm.objects(CurrentWeather.self)
    }
    func returnCurrentImage(realm: Realm) -> Results<CurrentImage>{
        return realm.objects(CurrentImage.self)
    }
    func returnForecastInfo(realm: Realm) -> Results<ForecastWeather>{
        return realm.objects(ForecastWeather.self)
    }
    func returnForecastImages(realm: Realm) -> Results<ForecastImages>{
        return realm.objects(ForecastImages.self)
    }
    func returnNewCityName(realm: Realm) -> Results<SearchCityName>{
        return realm.objects(SearchCityName.self)
    }
    func returnDateLAstUPD(realm: Realm) -> Results<LastUPDInfoWeather>{
        return realm.objects(LastUPDInfoWeather.self)
    }
}
