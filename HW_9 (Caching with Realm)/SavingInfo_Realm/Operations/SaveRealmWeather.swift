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
    
    func savingCurrentInfo(descr: String, cityName: String, tempFL: String, tempTMax: String, tempTMin: String){
        let infoT = CurrentWeather()
        infoT.cityNameTemp = cityName
        infoT.tempFL = tempFL
        infoT.tempTMax = tempTMax
        infoT.tempTMin = tempTMin
        infoT.descr = descr
        try! realm.write{
            realm.add(infoT)
        }
        savingCurrentInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldCurrentInfo()
    }
    
    func savingCurrentImage(icon: NSData){
        let image = CurrentImage()
        image.icon = icon
        try! realm.write{
            realm.add(image)
        }
        savingCurrentInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldCurrentImage()
    }

    func savingForecastInfo(uniqDates: [String], allDates: [String],cod: String, descripts: [String], temps: [String], times: [String]){
        let infoFD = ForecastWeather()
        infoFD.cod = cod
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
        RemoveOldWeatherInfo().removeOldForecastInfo()
    }
    
    func savingForecastImages(icons: [NSData]){
        let infoFIs = ForecastImages()
        for i in icons{
            let image = IconsForForecastClass()
            image.icon = i
            infoFIs.icons.append(image)
        }
        try! realm.write{
            realm.add(infoFIs)
        }
        savingForecastInfoVar.accept(true)
        RemoveOldWeatherInfo().removeOldForecastImage()
    }
    
    func savingNewCity(city: String){
        let newCity = SearchCityName()
        newCity.cityName = city
        try! realm.write{
            realm.add(newCity)
        }
    }
}
