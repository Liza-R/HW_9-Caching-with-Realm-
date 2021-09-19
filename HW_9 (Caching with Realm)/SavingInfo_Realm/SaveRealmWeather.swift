//
//  RealmWeather.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import RealmSwift
import UIKit

class RealmWeather{
    let realm = try! Realm()
    
    func savingCurrentInfo(descr: String, icon: NSData, cityName: String, tempFL: String, tempTMax: String, tempTMin: String, dt: String){
        print("-------Начало сохранения в Realm инфо о текущей погоде")
        let infoT = CurrentWeather()
        
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
        savingCurrentInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldCurrentInfo()
        print("-------Конец сохранения инфо в Realm о текущей погоде")
    }

    func savingForecastInfo(uniqDates: [String], allDates: [String],cod: String, descripts: [String], icons: [NSData], temps: [String], times: [String]){
        print("-------Начало сохранения в Realm инфо прогноза погоды")
        let infoFD = ForecastWeather()

        infoFD.cod = cod

        for i in icons{
            infoFD.icons.append(i as Data)
        }
        for i in uniqDates{
            let un_day = UnDayForTableClass()
            un_day.un_date = i
            infoFD.un_dates.append(un_day)
        }
        for i in allDates{
            let day = DayForTableClass()
            day.date = i
            infoFD.all_dates.append(day)
        }
        for i in descripts{
            let descript = DescriptForTableClass()
            descript.descript = i
            infoFD.descripts.append(descript)
        }
        for i in temps{
            let temp = TempForTableClass()
            temp.temp = i
            infoFD.temps.append(temp)
        }
        for i in times{
            let time = TimeForTableClass()
            time.time = i
            infoFD.times.append(time)
        }

        try! realm.write{
            realm.add(infoFD)
        }
        savingForecastInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldForecastInfo()

        print("-------Конец сохранения инфо прогноза погоды в Realm")
    }
}
