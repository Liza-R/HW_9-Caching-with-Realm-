//
//  DisplayInfoLoadApp.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation
import RealmSwift
import UIKit

class CheckDataBase{
    func diaplayLoadApp(curInfoRealm: Results<CurrentWeather>, fcInfoRealm: Results<ForecastWeather>, uploadNOCurInfo: () -> Void, uploadNOFcInfo: () -> Void, table: UITableView, lastUPDLabel: UILabel){
        switch curInfoRealm.isEmpty {
        case true:
            cityNameAlam = "Moscow"
            RealmWeather().savingNewCity(city: cityNameAlam)
        case false:
            uploadNOCurInfo()
        }
        ViewModel().uploadCurrentInfo()

        switch fcInfoRealm.isEmpty {
        case true:
            ViewController().allWeatherInfo_Alam.append([])
            ViewController().uniqDatesForTable.append("Loading weather forecast for \(cityNameAlam)")
        case false:
            uploadNOFcInfo()
        }
        ViewModel().uploadForecastInfo()
        table.reloadData()
        
        LastUpdate().lastDate(lastUPDLabel: lastUPDLabel)
    }
}
