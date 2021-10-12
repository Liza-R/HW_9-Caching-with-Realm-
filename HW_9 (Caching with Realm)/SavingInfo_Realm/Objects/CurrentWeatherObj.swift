//
//  CurrentWeatherObj.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 18.09.2021.
//

import Foundation
import RealmSwift

class CurrentWeather: Object{
    @objc dynamic var cityNameTemp = ""
    @objc dynamic var tempFL = ""
    @objc dynamic var tempTMax = ""
    @objc dynamic var tempTMin = ""
    @objc dynamic var descr = ""
    @objc dynamic var icon_url = ""
}
