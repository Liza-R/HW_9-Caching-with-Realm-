//
//  RealmWeather.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import RealmSwift
import UIKit

class TodayWeather: Object{
    @objc dynamic var cityNameTemp = ""
    @objc dynamic var tempFL = ""
    @objc dynamic var tempTMax = ""
    @objc dynamic var tempTMin = ""
    @objc dynamic var descr = ""
    @objc dynamic var dateToday = ""
    @objc dynamic var icon = NSData()
}

class FiveDaysWeather: Object{
    @objc dynamic var cod = ""
    let icons = List<Data>(),
        descripts = List<String>(),
        dates = List<String>(),
        times = List<String>(),
        temps = List<String>()
}

class RealmWeather{
    let realm = try! Realm()
    
    func savingTodayInfo(descr: String, icon: NSData, cityName: String, tempFL: String, tempTMax: String, tempTMin: String, dt: String){
        print("-------Начало сохранения в Realm инфо о текущей погоде")
        let infoT = TodayWeather()
        
        infoT.cityNameTemp = cityName
        infoT.tempFL = tempFL
        infoT.tempTMax = tempTMax
        infoT.tempTMin = tempTMin
        infoT.descr = descr
        infoT.dateToday = dt
        infoT.icon = icon
        
        try! realm.write{
            realm.add(infoT)
        }
        savingTodayInfoVar.accept(true)
        print("-------Конец сохранения инфо в Realm о текущей погоде")
    }
    
    func returnTodayInfo() -> Results<TodayWeather>{
        print("Начало создания модели текущей погоды Realm")
        let modelToday = realm.objects(TodayWeather.self)
        print("Конец создания модели текущей погоды Realm")
        return modelToday
    }
    
    func savingFiveDaysInfo(dates: [String], cod: String, descripts: [String], icons: [NSData], temps: [String], times: [String]){
        print("-------Начало сохранения в Realm инфо прогноза погоды")
        let infoFD = FiveDaysWeather()

        infoFD.cod = cod

        for i in icons{
            infoFD.icons.append(i as Data)
        }
        for i in dates{
            infoFD.dates.append(i)
        }
        for i in descripts{
            infoFD.descripts.append(i)
        }
        for i in temps{
            infoFD.temps.append(i)
        }
        for i in times{
            infoFD.times.append(i)
        }

        try! realm.write{
            realm.add(infoFD)
        }
        savingFiveDaysInfoVar.accept(true)
        print("-------Конец сохранения инфо прогноза погоды в Realm")
    }
    
    func returnFiveDaysInfo() -> Results<FiveDaysWeather>{
        print("Начало создания модели прогноза погоды Realm")
        let modelFiveDays = realm.objects(FiveDaysWeather.self)
        print("Конец создания модели прогноза погоды Realm")
        return modelFiveDays
    }
}
