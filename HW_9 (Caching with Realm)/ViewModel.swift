//
//  ViewModel.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import UIKit
import Alamofire

protocol uploadWeatherAlamofire{
   // func uploadToday()
    func uploadFiveDays(allData_: [String], cod: String, allWeatherInfo_:  [[DaysInfo.forBaseTableAlam]], daysForTable: [String])
}

class ViewModelAlamofire{
    private var today_Alam: [DaysInfo.All_Day_Info] = [],
                five_days_Alam: [DaysInfo.All_Five_Days_Info] = []
    
    var weatherDelegateAlam: uploadWeatherAlamofire?

    init(){
        //uploadToday()
        uploadDays()
    }
    
    func uploadToday(){
        print("----Начало работы функции viewModel")
        TodayLoader().loadTodayAlamofire { today in
            print("-----Начало загрузки информации о текущей погоде")
            self.today_Alam = today
            DispatchQueue.main.async {
                for i in today{
                     var icon_today_Alam: String? = "",
                         descript: String = ""
                     
                     for j in i.weather{
                        icon_today_Alam = j?.icon
                        descript = j?.description ?? "Not Found"
                     }
                    
                    let url_icon_Al = url_icon_upload.replacingOccurrences(of: "PICTURENAME", with: "\(icon_today_Alam!)")

                    AF.request(URL(string: url_icon_Al)!, method: .get).response{ response in
                        switch response.result {
                            case .success(let responseData):
                                //self.weatherDelegateAlam?.uploadToday(todayAlam: i, description: descript, image: UIImage(data: responseData!, scale:1) ?? .checkmark)
                                let ic = UIImage(data: responseData!, scale:1) ?? .checkmark,
                                date = NSDate(timeIntervalSince1970: TimeInterval(i.dt)),
                                        dayTimePeriodFormatter = DateFormatter()
                                dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd"
                                let dateString = dayTimePeriodFormatter.string(from: date as Date),
                                    todayInfo = "\(String(describing: Int(i.main!.temp - 273.15)))°C \(i.name)",
                                    min_temp = "Min: \(String(describing: Int(i.main!.temp_min - 273.15)))°C",
                                    max_temp = "Max: \(String(describing: Int(i.main!.temp_max - 273.15)))°C",
                                    feelsL_temp = "Feels like: \(String(describing: Int(i.main!.feels_like - 273.15)))°C",
                                    dataIcon = NSData(data: ic.pngData()!)
                                print("------Вызов функции Realm")
                                RealmWeather().savingTodayInfo(descr: descript, icon: dataIcon, cityName: todayInfo, tempFL: feelsL_temp, tempTMax: max_temp, tempTMin: min_temp, dt: dateString)
                                print("------Конец вызова функции Realm")
                                
                            case .failure(let error):
                                print("error--->",error)
                        }
                    }
                }
            }
            print("-----Конец загрузки информации о текущей погоде")
        }
        print("----Конец работы функции viewModel")
    }
    
    func uploadDays(){
        var temp_: [String] = [],
            descript: [String] = [],
            iconLinkAlam: [String] = [],
            iconsAlam: [UIImage] = [],
            data: [String] = [],
            time: [String] = [],
            cod: String = "",
            
            dayForTable_F: [String] = [],
            allData_F: [String] = []
  
        let date = Date(),
        formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let result_Al = formatter.string(from: date)

        TodayFiveDaysLoader().loadFiveDaysAlamofire { five_days in
            self.five_days_Alam = five_days
            DispatchQueue.main.async {
                for i in five_days{
                    cod = i.cod
                    for j in i.list{
                        let denechek = j?.dt_txt.components(separatedBy: " ")
                        if denechek![0] != result_Al{
                            temp_.append("\(String(describing: Int((j!.main!.temp) - 273.15)))°C ")
                            data.append(denechek?[0] ?? "Not Found")
                            time.append(denechek?[1] ?? "Not Found")
                            for (_, w) in (j?.weather.enumerated())!{
                                descript.append("\(w!.description)")
                                iconLinkAlam.append("\(w!.icon)")
                            }
                        }
                    }
                }
                for (_, j) in iconLinkAlam.enumerated(){
                    let url_icon = url_icon_upload.replacingOccurrences(of: "PICTURENAME", with: "\(j)")
                    AF.request(URL(string: url_icon)!, method: .get).response{ response in
                        switch response.result {
                            case .success(let responseData):
                                iconsAlam.append(UIImage(data: responseData!, scale: 1) ?? .checkmark)
                                var moving = false
                                if iconsAlam.count == temp_.count{
                                    moving = true
                                }
                                if moving == true{
                                    allData_F = data
                                    var set = Set<String>()
                                    dayForTable_F = allData_F.filter{ set.insert($0).inserted }
                                    dayForTable_F = dayForTable_F.filter { $0 != "Not Found" }
                                    dayForTable_F = dayForTable_F.filter { $0 != result_Al }
                                    var allWeatherInfo_Alam: [[DaysInfo.forBaseTableAlam]] = [[]]
                                    for _ in 0...dayForTable_F.count - 2{
                                        allWeatherInfo_Alam.append([])
                                    }
                                    for (y, u) in dayForTable_F.enumerated(){
                                        for (i, j) in allData_F.enumerated(){
                                            if u == j{
                                                allWeatherInfo_Alam[y].append(DaysInfo.forBaseTableAlam(temper_Alam: temp_[i], icon_Alam: iconsAlam[i], descript_Alam: descript[i], data_Alam: data[i], time_Alam: time[i]))
                                            }
                                        }
                                    }
                                    self.weatherDelegateAlam?.uploadFiveDays(allData_: allData_F, cod: cod, allWeatherInfo_: allWeatherInfo_Alam, daysForTable: dayForTable_F)
                                }
                            case .failure(let error):
                                print("error--->",error)
                        }
                    }
                }
            }
        }
    }
}
