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
    }

    func savingForecastInfo(uniqDates: [String], allDates: [String],cod: String, descripts: [String], icons: [NSData], temps: [String], times: [String]){
        let infoFD = ForecastWeather(),
            icon = IconForTableClass(),
            un_day = UnDayForTableClass(),
            day = DayForTableClass(),
            descript = DescriptForTableClass(),
            temp = TempForTableClass(),
            time = TimeForTableClass()

        infoFD.cod = cod

        for i in icons{
            icon.icon = i
            infoFD.icons.append(icon)
        }

        for i in uniqDates{
            un_day.un_date = i
            infoFD.un_dates.append(un_day)
        }
        for i in allDates{
            day.date = i
            infoFD.all_dates.append(day)
        }
        for i in descripts{
            descript.descript = i
            infoFD.descripts.append(descript)
        }
        for i in temps{
            temp.temp = i
            infoFD.temps.append(temp)
        }
        for i in times{
            time.time = i
            infoFD.times.append(time)
        }

        try! realm.write{
            realm.add(infoFD)
        }
        savingForecastInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldForecastInfo()
    }
    
    func savingNewCity(city: String){
        let newCity = SearchCityName()
        newCity.cityName = city
        try! realm.write{
            realm.add(newCity)
        }
    }
}
