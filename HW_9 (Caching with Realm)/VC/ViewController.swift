//
//  ViewController.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

var cityNameAlam: String = "",
    savingTodayInfoVar = BehaviorRelay<Bool>(value: false),
    savingFiveDaysInfoVar = BehaviorRelay<Bool>(value: false)

class ViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var today_Label_Alam: UILabel!
    @IBOutlet weak var icon_Image_Alam: UIImageView!
    @IBOutlet weak var temp_Label_Alam: UILabel!
    @IBOutlet weak var max_Label_Alam: UILabel!
    @IBOutlet weak var min_temp_Label_alam: UILabel!
    @IBOutlet weak var descript_Label_Alam: UILabel!
    @IBOutlet weak var feels_like_Label_Alam: UILabel!
    @IBOutlet weak var weather_Table_Alamofire: UITableView!
    
    var codFiveDays = "",
        uniqDatesForTable: [String] = [],
        allDates: [String] = [],
        allWeatherInfo_Alam: [[LoadingStruct.InfoTableAlam]] = [[], [], [], [], []]
    
    let todayInfoRealm = ReturnInfoModels().returnCurrentInfo(realm: RealmWeather().realm),
        forecastInfoRealm = ReturnInfoModels().returnForecastInfo(realm: RealmWeather().realm),
        disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Загрузка приложения")
        cityNameAlam = "Moscow"
        
        switch todayInfoRealm.isEmpty {
        case true:
            print("--Инфо о текущей погодe в БД нет")
            EmptyInfo().uploadEmptyCurrentInfo(dateLabel: today_Label_Alam, tempLabel: temp_Label_Alam, minTempLabel: min_temp_Label_alam, maxTempLabel: max_Label_Alam, feels_likeTempLabel: feels_like_Label_Alam, descrLabel: descript_Label_Alam, icon: icon_Image_Alam)
            updateTodayInfo()
        case false:
            print("--Инфо о текущей погодe в БД есть")
            uploadNOEmptyTodayInfo()
            updateTodayInfo()
        }
        
        switch forecastInfoRealm.isEmpty {
        case true:
            print("--Инфо о прогнозе погоды в БД нет")
            uploadEmptyForecastInfo()
            updateFDInfo()
        case false:
            print("--Инфо о прогнозе погоды в БД есть")
            updateFDInfo()
            uploadNOEmptyForecastInfo()
        }
        
        changingUIs_loadingNewTodayData()
        changingUIs_loadingNewTForecastData()
        
        self.weather_Table_Alamofire.dataSource = self
        self.weather_Table_Alamofire.reloadData()
        
        print("-Конец загрузки приложения")
    }

    func changingUIs_loadingNewTodayData(){
        savingTodayInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyTodayInfo()
                print("---------> Новая инфо о текущей погоде загружена")
            }else{
                print("---------> Новая инфо о текущей погоде не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func changingUIs_loadingNewTForecastData(){
        savingFiveDaysInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyForecastInfo()
                print("---------> Новая инфо о прогнозе погоды загружена")
                self.weather_Table_Alamofire.reloadData()
            }else{
                print("---------> Новая инфо о прогнозе погоды не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    
    
    func uploadEmptyForecastInfo(){
        print("---Старт функции для первой загрузки прогноза погоды")
        uniqDatesForTable.append("Loading weather forecast for")
        print("---Конец функции для первой загрузки прогноза погоды")
    }
    
    func uploadNOEmptyTodayInfo(){
        print("---Старт функции для повторной загрузки текущей погоды")
        for i in self.todayInfoRealm{
            self.today_Label_Alam.text = "TODAY: \(i.dateToday)"
            self.temp_Label_Alam.text = "\(i.cityNameTemp)"
            self.min_temp_Label_alam.text = "\(i.tempTMin)"
            self.max_Label_Alam.text = "\(i.tempTMax)"
            self.feels_like_Label_Alam.text = "\(i.tempFL)"
            self.descript_Label_Alam.text = "\(i.descr)"
            self.icon_Image_Alam.image = UIImage(data: i.icon as Data)
        }
        print("----Инфо из Realm о текущей погоде помещена в UIs")
        print("---Конец функции для повторной загрузки текущей погоды")
    }
//-----------------------------------------
    func uploadNOEmptyForecastInfo(){
        print("---Старт функции для повторной загрузки прогноза погоды")
        for i in self.forecastInfoRealm{
            self.codFiveDays = i.cod
            self.uniqDatesForTable.removeAll()
            for j in i.un_dates{
                self.uniqDatesForTable.append("\(j.un_date)")
            }
            for j in i.all_dates{
                for h in i.un_dates{
                    if j.date == h.un_date{
                        allDates.append("\(j.date)")
                    }
                }
            }
            var timeS: [String] = [],
                tempS: [String] = [],
                descrS: [String] = []
            
            for u in i.temps{
                tempS.append(u.temp)
            }
            for u in i.descripts{
                descrS.append(u.descript)
            }
            for u in i.times{
                timeS.append(u.time)
            }
            //let uniq_timeS = Array(Set(timeS))
        
            for s in 0...uniqDatesForTable.count - 1{
                for v in 0...allDates.count - 1{
                    if uniqDatesForTable[s] == allDates[v]{
                        //print("if")
                        switch s {
                        case 0:
                            for t in 0...7{
                                allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[t], icon_Alam: .checkmark, descript_Alam: descrS[t], data_Alam: "", time_Alam: timeS[t]))

                            }
                        case 1:
                            for t in 8...15{
                                allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[t], icon_Alam: .checkmark, descript_Alam: descrS[t], data_Alam: "", time_Alam: timeS[t]))
                            }
                        case 2:
                            for t in 16...23{
                                allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[t], icon_Alam: .checkmark, descript_Alam: descrS[t], data_Alam: "", time_Alam: timeS[t]))
                            }
                        case 3:
                            for t in 24...31{
                                allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[t], icon_Alam: .checkmark, descript_Alam: descrS[t], data_Alam: "", time_Alam: timeS[t]))
                            }
                        case 4:
                            for t in 32...tempS.count - 1{
                                allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[t], icon_Alam: .checkmark, descript_Alam: descrS[t], data_Alam: "", time_Alam: timeS[t]))
                            }
                        default:
                            print("---> ")
                        }
                        //print(allWeatherInfo_Alam)
                        //allWeatherInfo_Alam[u][k].icon_Alam = i.icons as List<Data>
                    }
                }
            }
        }
        print("----Инфо из Realm о прогнозе погоды помещена в UIs")
        print("---Конец функции для повторной загрузки прогноза погоды")
    }
//-----------------------------------------
    func updateTodayInfo(){
        print("---Начало обновления инфо о текущей погоде")
        ViewModelAlamofire().uploadToday()
        print("---Конец обновления инфо о текущей погоде")
    }
    
    func updateFDInfo(){
        print("---Начало обновления инфо о прогнозе погоды")
        ViewModelAlamofire().uploadDays()
        print("---Конец обновления инфо о прогнозе погоды")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let alert = Alerts()
        if searchTF.text?.isEmpty == true{
            alert.alertNilTF(vc: self)
        }
        else{
            cityNameAlam = searchTF.text!
            let changeURL = ChangingURLs()
            changeURL.changeCurrentURLAlam(cityName: cityNameAlam)
            changeURL.changeForecastURLAlam(cityName: cityNameAlam)
            if codFiveDays == ""{
                alert.alertCityNotFound(vc: self, cityName: cityNameAlam)
            }else{
                codFiveDays = ""
                updateTodayInfo()
                updateFDInfo()
                self.weather_Table_Alamofire.reloadData()
                self.weather_Table_Alamofire.dataSource = self
            }
        }
    }
}

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView_Alam: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqDatesForTable.count
    }

    func tableView(_ tableView_Alam: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell_Alam = tableView_Alam.dequeueReusableCell(withIdentifier: "weather_Alamofire", for: indexPath) as! WeatherAlamofireTableViewCell

        cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        print(allWeatherInfo_Alam[indexPath.row].count)
        cell_Alam.collectionTableAlam.reloadData()
        
        //day cell
        cell_Alam.day_Label_Alam.text = "\(uniqDatesForTable[indexPath.row]) \(cityNameAlam)"
        return cell_Alam
    }
}