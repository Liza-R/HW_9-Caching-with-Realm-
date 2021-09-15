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

/*class FiveDaysWeather: Object{
    @objc dynamic var dates = [""]
    @objc dynamic var tempers = [""]
    @objc dynamic var times = [""]
    @objc dynamic var descripts = [""]
    @objc dynamic var icons = [UIImage()]
}*/


class RealmWeather{
    /*let modelToday = realm.objects(TodayWeather.self),
        modelFiveDays = realm.objects(FiveDaysWeather.self)
    
    var todayInfo: Results<TodayWeather>?,
        fiveDaysInfo: Results<FiveDaysWeather>?
    */
    let realm = try! Realm()
    
    func savingTodayInfo(descr: String, icon: NSData, cityName: String, tempFL: String, tempTMax: String, tempTMin: String, dt: String){
        print("-------Начало сохранения в Realm информации о текущей погоде")
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
        print("-------Конец сохранения информации в Realm о текущей погоде")
    }
    
    func returnTodayInfo() -> Results<TodayWeather>{
        print("Начало создания модели Realm")
        let modelToday = realm.objects(TodayWeather.self)
        print("Конец создания модели Realm")
        return modelToday
    }
    
    func loadingFiveDaysInfo(){
        
    }
}
