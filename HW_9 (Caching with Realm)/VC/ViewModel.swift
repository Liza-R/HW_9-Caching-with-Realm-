//
//  ViewModel.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import Foundation
import UIKit
import Alamofire

class ViewModel{
    private var current_Info: [CurrentWeatherStruct.Current_Info] = [],
                forecast_Info: [ForecastWeatherStruct.Forecast_Info] = []

    func uploadCurrentInfo(){
        CurrentLoader().loadCurrentInfo { current in
            self.current_Info = current
            let nf = "Not Found"
            DispatchQueue.main.async {
                for i in current{
                     for j in i.weather{
                         RealmWeather().savingCurrentInfo(descr: j?.description ?? nf, icon_url: j?.icon ?? nf, cityName: "\(String(describing: Int(i.main!.temp - 273.15)))°C \(i.name)", tempFL: "Feels like: \(String(describing: Int(i.main!.feels_like - 273.15)))°C", tempTMax: "Max: \(String(describing: Int(i.main!.temp_max - 273.15)))°C", tempTMin: "Min: \(String(describing: Int(i.main!.temp_min - 273.15)))°C")
                        }
                    }
                }
            }
        }
    
    func uploadForecastInfo(){
        var temp_: [String] = [],
            descript: [String] = [],
            iconLinkAlam: [String] = [],
            data: [String] = [],
            time: [String] = [],
            cod: String = ""
  
        let date = Date(),
        formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let result_Al = formatter.string(from: date)

        ForecastDaysLoader().loadForecastInfo { forecast in
            self.forecast_Info = forecast
            DispatchQueue.main.async {
                for i in forecast{
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
                ImageLoader().uploadForecastImages(image_urls: iconLinkAlam, all_temps: temp_)
                RealmWeather().savingForecastInfo(uniqDates: Array(Set(data)).sorted(), allDates: data, cod: cod, descripts: descript, icons: iconLinkAlam, temps: temp_, times: time)
            }
        }
    }
}
