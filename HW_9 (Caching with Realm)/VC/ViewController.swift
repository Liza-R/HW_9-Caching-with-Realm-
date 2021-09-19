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
    savingCurrentInfoVar = BehaviorRelay<Bool>(value: false),
    savingForecastInfoVar = BehaviorRelay<Bool>(value: false)

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
        allWeatherInfo_Alam: [[LoadingStruct.InfoTableAlam]] = []
    
    let todayInfoRealm = ReturnInfoModels().returnCurrentInfo(realm: RealmWeather().realm),
        forecastInfoRealm = ReturnInfoModels().returnForecastInfo(realm: RealmWeather().realm),
        saveNewCity = ReturnInfoModels().returnNewCityName(realm: RealmWeather().realm),
        disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Загрузка приложения")
        
        switch todayInfoRealm.isEmpty {
        case true:
            print("--Инфо о текущей погодe в БД нет")
            cityNameAlam = "Moscow"
            RealmWeather().savingNewCity(city: cityNameAlam)
            uploadEmptyCurrentInfo()
            updateCurrentInfo()
        case false:
            print("--Инфо о текущей погодe в БД есть")
            uploadNOEmptyCurrentInfo()
            updateCurrentInfo()
        }
        
        switch forecastInfoRealm.isEmpty {
        case true:
            print("--Инфо о прогнозе погоды в БД нет")
            uploadEmptyForecastInfo()
            updateForecastInfo()
        case false:
            print("--Инфо о прогнозе погоды в БД есть")
            updateForecastInfo()
            uploadNOEmptyForecastInfo()
        }
        
        changingUIs_loadingNewCurrentData()
        changingUIs_loadingNewForecastData()
        
        self.weather_Table_Alamofire.dataSource = self
        self.weather_Table_Alamofire.reloadData()
        
        print("-Конец загрузки приложения")
    }

    func changingUIs_loadingNewCurrentData(){
        savingCurrentInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyCurrentInfo()
                print("---------> Новая инфо о текущей погоде загружена")
            }else{
                print("---------> Новая инфо о текущей погоде не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func changingUIs_loadingNewForecastData(){
        savingForecastInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyForecastInfo()
                print("---------> Новая инфо о прогнозе погоды загружена")
                self.weather_Table_Alamofire.reloadData()
            }else{
                print("---------> Новая инфо о прогнозе погоды не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func uploadEmptyCurrentInfo(){
        print("---Старт функции для первой загрузки текущей погоды")
        today_Label_Alam.text = "Loading date..."
        temp_Label_Alam.text = "Loading t..."
        min_temp_Label_alam.text = "Loading min t..."
        max_Label_Alam.text = "Loading max t..."
        feels_like_Label_Alam.text = "Loading feels t..."
        descript_Label_Alam.text = "Loading descript..."
        icon_Image_Alam.image = .none
        print("----Инфо о текущей погоде помещена в UI")
        print("---Конец функции для первой загрузки текущей погоды")
    }
    
    func uploadEmptyForecastInfo(){
        print("---Старт функции для первой загрузки прогноза погоды")
        allWeatherInfo_Alam.append([])
        uniqDatesForTable.append("Loading weather forecast for")
        print("---Конец функции для первой загрузки прогноза погоды")
    }
    
    func uploadNOEmptyCurrentInfo(){
        print("---Старт функции для повторной загрузки текущей погоды")
        for c in saveNewCity{
            cityNameAlam = c.cityName
        }
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

    func uploadNOEmptyForecastInfo(){
        print("---Старт функции для загрузки прогноза погоды")
        var timeS: [String] = [],
            tempS: [String] = [],
            descrS: [String] = [],
            iconS: [NSData] = []
        for i in self.forecastInfoRealm{
            self.codFiveDays = i.cod
            self.uniqDatesForTable.removeAll()
            allDates.removeAll()
            allWeatherInfo_Alam.removeAll()
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

            for u in i.temps{
                tempS.append(u.temp)
            }
            for u in i.descripts{
                descrS.append(u.descript)
            }
            for u in i.times{
                timeS.append(u.time)
            }
            for u in i.icons{
                iconS.append(u.icon)
            }
        }

        for _ in 0...self.uniqDatesForTable.count - 1{
            allWeatherInfo_Alam.append([])
        }
            for s in 0...uniqDatesForTable.count - 1{
                for v in 0...allDates.count - 1{
                    if uniqDatesForTable[s] == allDates[v]{
                        allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[v], icon_Alam: UIImage(data: iconS[v] as Data) ?? .checkmark, descript_Alam: descrS[v], data_Alam: "", time_Alam: timeS[v]))
                }
            }
        }
        print("----Инфо из Realm о прогнозе погоды помещена в UIs")
        print("---Конец функции для загрузки прогноза погоды")
    }
    func updateCurrentInfo(){
        print("---Начало обновления инфо о текущей погоде")
        ViewModelAlamofire().uploadToday()
        print("---Конец обновления инфо о текущей погоде")
    }
    
    func updateForecastInfo(){
        print("---Начало обновления инфо о прогнозе погоды")
        ViewModelAlamofire().uploadDays()
        print("---Конец обновления инфо о прогнозе погоды")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        print("Start searching city")
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
                print(codFiveDays)
                RealmWeather().savingNewCity(city: cityNameAlam)
                codFiveDays = ""
                uploadEmptyCurrentInfo()
                updateCurrentInfo()
                
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
        cell_Alam.collectionTableAlam.reloadData()
        var city = ""
        for i in self.todayInfoRealm{
            city = i.cityNameTemp
        }
        //day cell
        cell_Alam.day_Label_Alam.text = "\(uniqDatesForTable[indexPath.row]) \(String(describing: city.components(separatedBy: "C ").last?.components(separatedBy: "").first ?? ""))"
        return cell_Alam
    }
}
