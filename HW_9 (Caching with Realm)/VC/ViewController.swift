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
        allWeatherInfo_Alam: [[LoadingStruct.InfoTableAlam]] = [],
        
        refreshControl: UIRefreshControl!
    
    let todayInfoRealm = ReturnInfoModels().returnCurrentInfo(realm: RealmWeather().realm),
        forecastInfoRealm = ReturnInfoModels().returnForecastInfo(realm: RealmWeather().realm),
        saveNewCity = ReturnInfoModels().returnNewCityName(realm: RealmWeather().realm),

        disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        weather_Table_Alamofire.addSubview(refreshControl)
        
        switch todayInfoRealm.isEmpty {
        case true:
            cityNameAlam = "Moscow"
            RealmWeather().savingNewCity(city: cityNameAlam)
        case false:
            uploadNOEmptyCurrentInfo()
        }
        ViewModelAlamofire().uploadToday()

        switch forecastInfoRealm.isEmpty {
        case true:
            allWeatherInfo_Alam.append([])
            uniqDatesForTable.append("Loading weather forecast for \(cityNameAlam)")
        case false:
            uploadNOEmptyForecastInfo()
        }
        ViewModelAlamofire().uploadDays()
        
        changingUIs_loadingNewCurrentData()
        changingUIs_loadingNewForecastData()
        
        self.weather_Table_Alamofire.dataSource = self
        self.weather_Table_Alamofire.reloadData()
    }

    @objc func refresh(_ sender: AnyObject) {
        uploadNOEmptyCurrentInfo()
        ViewModelAlamofire().uploadToday()
        uploadNOEmptyForecastInfo()
        ViewModelAlamofire().uploadDays()
        self.weather_Table_Alamofire.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func changingUIs_loadingNewCurrentData(){
        savingCurrentInfoVar.asObservable().subscribe{ status in
            if status.element == true{
                self.uploadNOEmptyCurrentInfo()
            }else{
                print("---------> Новая инфо о текущей погоде не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func changingUIs_loadingNewForecastData(){
        savingForecastInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyForecastInfo()
                self.weather_Table_Alamofire.reloadData()
            }else{
                print("---------> Новая инфо о прогнозе погоды не загружена")
            }
        }.disposed(by: disposeBag)
    }
    
    func uploadNOEmptyCurrentInfo(){
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
    }

    func uploadNOEmptyForecastInfo(){
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
                print(codFiveDays)
                RealmWeather().savingNewCity(city: cityNameAlam)
                codFiveDays = ""
                ViewModelAlamofire().uploadToday()
                
                print("---Начало обновления инфо о прогнозе погоды")
                ViewModelAlamofire().uploadDays()
                print("---Конец обновления инфо о прогнозе погоды")
                uploadNOEmptyForecastInfo()

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
        var city = ""
        
        cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        cell_Alam.collectionTableAlam.reloadData()
        
        for i in self.todayInfoRealm{
            city = i.cityNameTemp
        }

        cell_Alam.day_Label_Alam.text = "\(uniqDatesForTable[indexPath.row]) \(String(describing: city.components(separatedBy: "C ").last?.components(separatedBy: "").first ?? ""))"
        return cell_Alam
    }
}
