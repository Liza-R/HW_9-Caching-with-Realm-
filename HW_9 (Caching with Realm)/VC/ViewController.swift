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
        refreshControl = UIRefreshControl()
    
    let todayInfoRealm = ReturnInfoModels().returnCurrentInfo(realm: RealmWeather().realm),
        forecastInfoRealm = ReturnInfoModels().returnForecastInfo(realm: RealmWeather().realm),
        saveNewCity = ReturnInfoModels().returnNewCityName(realm: RealmWeather().realm),
        disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        weather_Table_Alamofire.addSubview(refreshControl)
        
        switch todayInfoRealm.isEmpty {
        case true:
            cityNameAlam = "Dubai"
            RealmWeather().savingNewCity(city: cityNameAlam)
        case false:
            uploadNOEmptyCurrentInfo()
        }
        ViewModel().uploadCurrentInfo()

        switch forecastInfoRealm.isEmpty {
        case true:
            allWeatherInfo_Alam.append([])
            uniqDatesForTable.append("Loading weather forecast for \(cityNameAlam)")
        case false:
            uploadNOEmptyForecastInfo()
        }
        ViewModel().uploadForecastInfo()
        
        savingCurrentInfoVar.asObservable().subscribe{ status in
            if status.element == true{
                self.uploadNOEmptyCurrentInfo()
            }else{}
        }.disposed(by: disposeBag)
        
        savingForecastInfoVar.asObservable().subscribe { status in
            if status.element == true{
                self.uploadNOEmptyForecastInfo()
            }else{}
        }.disposed(by: disposeBag)
        
        self.weather_Table_Alamofire.dataSource = self
        self.weather_Table_Alamofire.reloadData()
    }

    @objc func refresh(_ sender: AnyObject) {
        uploadNOEmptyCurrentInfo()
        ViewModel().uploadCurrentInfo()
        uploadNOEmptyForecastInfo()
        ViewModel().uploadForecastInfo()
        self.weather_Table_Alamofire.reloadData()
        self.refreshControl.endRefreshing()
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
        let inForecast = self.forecastInfoRealm.last!
        self.uniqDatesForTable.removeAll()
        allDates.removeAll()
        allWeatherInfo_Alam.removeAll()
        self.codFiveDays = inForecast.cod
        for j in inForecast.un_dates{
            self.uniqDatesForTable.append("\(j.un_date)")
        }
        for _ in 0...self.uniqDatesForTable.count - 1{
            allWeatherInfo_Alam.append([])
        }
        for j in inForecast.all_dates{
            for h in inForecast.un_dates{
                if j.date == h.un_date{
                    allDates.append("\(j.date)")
                }
            }
        }
        for (k, u) in inForecast.temps.enumerated(){
            tempS.append(u.temp)
            descrS.append(inForecast.descripts[k].descript)
            timeS.append(inForecast.times[k].time)
            iconS.append(inForecast.icons[k].icon)
        }
        for s in 0...uniqDatesForTable.count - 1{
            for v in 0...allDates.count - 1{
                if uniqDatesForTable[s] == allDates[v]{
                    allWeatherInfo_Alam[s].append(LoadingStruct.InfoTableAlam(temper_Alam: tempS[v], icon_Alam: UIImage(data: iconS[v] as Data) ?? .strokedCheckmark, descript_Alam: descrS[v], time_Alam: timeS[v]))
                }
            }
        }
        self.weather_Table_Alamofire.reloadData()
    }

    @IBAction func searchButton(_ sender: Any) {
        if searchTF.text?.isEmpty == true{
            Alerts().alertNilTF(vc: self)
        }
        else{
            cityNameAlam = searchTF.text!
            let changeURL = ChangingURLs()
            changeURL.changeCurrentURLAlam(cityName: cityNameAlam)
            changeURL.changeForecastURLAlam(cityName: cityNameAlam)
            if codFiveDays == ""{
                Alerts().alertCityNotFound(vc: self, cityName: cityNameAlam)
            }else{
                print(codFiveDays)
                RealmWeather().savingNewCity(city: cityNameAlam)
                codFiveDays = ""
                ViewModel().uploadCurrentInfo()
                ViewModel().uploadForecastInfo()
                uploadNOEmptyForecastInfo()
                self.weather_Table_Alamofire.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView_Alam: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWeatherInfo_Alam.count
    }

    func tableView(_ tableView_Alam: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell_Alam = tableView_Alam.dequeueReusableCell(withIdentifier: "weather_Alamofire", for: indexPath) as! WeatherAlamofireTableViewCell

        var city = self.todayInfoRealm.last?.cityNameTemp
        city = city?.components(separatedBy: "C ").last?.components(separatedBy: "").first ?? "City Not Found"

        cell_Alam.day_Label_Alam.text = "\(uniqDatesForTable[indexPath.row]) \(String(describing: city!))"
        
        cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        cell_Alam.collectionTableAlam.reloadData()
        
        return cell_Alam
    }
}
