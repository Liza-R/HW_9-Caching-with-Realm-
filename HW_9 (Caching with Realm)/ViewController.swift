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
        tableRowDataAlam: String = "",
        dayForTableAlam: [String] = [],
        allDataAlam: [String] = [],
        allWeatherInfo_Alam: [[DaysInfo.forBaseTableAlam]] = [[], [], [], [], []],
        countInfo = 0
    let todayInfoRealm = RealmWeather().returnTodayInfo(),
        forecastInfoRealm = RealmWeather().returnFiveDaysInfo(),
        disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Загрузка приложения")
        cityNameAlam = searchTF.text!
        if todayInfoRealm.isEmpty && forecastInfoRealm.isEmpty{
            print("--Инфо о текущей погоде нет. БД пуста")
            uploadEmptyTodayInfo()
            uploadEmptyForecastInfo()
            updateTodayInfo()
        }else{
            print("--БД текущей погоды не пуста. Вставка последней загруженной инфо")
            uploadNOEmptyTodayInfo()
            updateFDInfo()
        }
        changingUIs_loadingNewData()
        
        self.weather_Table_Alamofire.reloadData()
        self.weather_Table_Alamofire.dataSource = self
        
        print("-Конец загрузки приложения")
    }

    func changingUIs_loadingNewData(){
        savingTodayInfoVar.asObservable().subscribe { status in
            if status.element == true{
                for i in self.todayInfoRealm{
                    self.today_Label_Alam.text = "TODAY: \(i.dateToday)"
                    self.temp_Label_Alam.text = "\(i.cityNameTemp)"
                    self.min_temp_Label_alam.text = "\(i.tempTMin)"
                    self.max_Label_Alam.text = "\(i.tempTMax)"
                    self.feels_like_Label_Alam.text = "\(i.tempFL)"
                    self.descript_Label_Alam.text = "\(i.descr)"
                    self.icon_Image_Alam.image = UIImage(data: i.icon as Data)
                }
                print("--> Новая инфо о текущей погоде загружена")
                print("--------Новая инфо о текущей погоде из Realm помещена в UIs")
            }else{
                print("--> Новая инфо о текущей погоде не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func uploadEmptyTodayInfo(){
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
        dayForTableAlam.append("Loading weather forecast ...")
        print("---Конец функции для первой загрузки прогноза погоды")
    }
    
    func uploadNOEmptyTodayInfo(){
        print("---Старт функции для повторной загрузки")
        for i in self.todayInfoRealm{
            self.today_Label_Alam.text = "TODAY: \(i.dateToday)"
            self.temp_Label_Alam.text = "\(i.cityNameTemp)"
            self.min_temp_Label_alam.text = "\(i.tempTMin)"
            self.max_Label_Alam.text = "\(i.tempTMax)"
            self.feels_like_Label_Alam.text = "\(i.tempFL)"
            self.descript_Label_Alam.text = "\(i.descr)"
            self.icon_Image_Alam.image = UIImage(data: i.icon as Data)
        }
        print("----Инфо из Realm помещена в UI (не новая, последняя)")
        print("---Конец функции для повторной загрузки")
    }
    
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
            let changeURL = changeURL()
            changeURL.changeTodayURLAlam(cityName: cityNameAlam)
            changeURL.changeFiveDaysURLAlam(cityName: cityNameAlam)
            if codFiveDays == ""{
                alert.alertCityNotFound(vc: self, cityName: cityNameAlam)
            }else{
                codFiveDays = ""
                updateTodayInfo()
                updateFDInfo()
                /*let viewModelAlam = ViewModelAlamofire()
                viewModelAlam.weatherDelegateAlam = self*/
                self.weather_Table_Alamofire.reloadData()
                self.weather_Table_Alamofire.dataSource = self
            }
        }
    }
}

/*extension ViewController: uploadWeatherAlamofire{

    func uploadFiveDays(allData_: [String], cod: String, allWeatherInfo_:  [[DaysInfo.forBaseTableAlam]], daysForTable: [String]) {
        allWeatherInfo_Alam = allWeatherInfo_
        codFiveDays = cod
        allDataAlam = allData_
        dayForTableAlam = daysForTable
        weather_Table_Alamofire.reloadData()
    }
}*/

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView_Alam: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayForTableAlam.count
    }

    func tableView(_ tableView_Alam: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell_Alam = tableView_Alam.dequeueReusableCell(withIdentifier: "weather_Alamofire", for: indexPath) as! WeatherAlamofireTableViewCell

        //cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        cell_Alam.collectionTableAlam.reloadData()
        
        //day cell
        cell_Alam.day_Label_Alam.text = "\(dayForTableAlam[indexPath.row]) \(cityNameAlam)"
        return cell_Alam
    }
}
