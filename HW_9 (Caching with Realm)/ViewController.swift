//
//  ViewController.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import UIKit

var cityNameAlam: String = "" // needed for search city

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
    
    let todayInfoRealm = RealmWeather().returnTodayInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameAlam = searchTF.text!
        
        for i in todayInfoRealm{
            today_Label_Alam.text = "TODAY: \(i.dateToday)"
            temp_Label_Alam.text = "\(i.cityNameTemp)"
            min_temp_Label_alam.text = "\(i.tempTMin)"
            max_Label_Alam.text = "\(i.tempTMax)"
            feels_like_Label_Alam.text = "\(i.tempFL)"
            descript_Label_Alam.text = "\(i.descr)"
            //icon_Image_Alam.image = i.icon
        }
        
        let viewModelAlam = ViewModelAlamofire()
        viewModelAlam.weatherDelegateAlam = self
        self.weather_Table_Alamofire.reloadData()
        self.weather_Table_Alamofire.dataSource = self
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
                let viewModelAlam = ViewModelAlamofire()
                viewModelAlam.weatherDelegateAlam = self
                self.weather_Table_Alamofire.reloadData()
                self.weather_Table_Alamofire.dataSource = self
            }
        }
    }
}

extension ViewController: uploadWeatherAlamofire{

    func uploadFiveDays(allData_: [String], cod: String, allWeatherInfo_:  [[DaysInfo.forBaseTableAlam]], daysForTable: [String]) {
        allWeatherInfo_Alam = allWeatherInfo_
        codFiveDays = cod
        allDataAlam = allData_
        dayForTableAlam = daysForTable
        weather_Table_Alamofire.reloadData()
    }
    
    func uploadToday(todayAlam: DaysInfo.All_Day_Info, description: String, image: UIImage) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(todayAlam.dt)),
            dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd"

        let dateString = dayTimePeriodFormatter.string(from: date as Date),
            todayInfo = "\(String(describing: Int(todayAlam.main!.temp - 273.15)))°C \(cityNameAlam)",
            min_temp = "Min: \(String(describing: Int(todayAlam.main!.temp_min - 273.15)))°C",
            max_temp = "Max: \(String(describing: Int(todayAlam.main!.temp_max - 273.15)))°C",
            feelsL_temp = "Feels like: \(String(describing: Int(todayAlam.main!.feels_like - 273.15)))°C"
        self.min_temp_Label_alam.text = "\(min_temp)"
        self.max_Label_Alam.text = "\(max_temp)"
        self.feels_like_Label_Alam.text = "\(feelsL_temp)"
        self.descript_Label_Alam.text = description
        self.icon_Image_Alam.image = image
        self.today_Label_Alam.text = "TODAY: \(dateString)"
        self.temp_Label_Alam.text = "\(todayInfo)"
        weather_Table_Alamofire.reloadData()
    }
}

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView_Alam: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayForTableAlam.count
    }

    func tableView(_ tableView_Alam: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell_Alam = tableView_Alam.dequeueReusableCell(withIdentifier: "weather_Alamofire", for: indexPath) as! WeatherAlamofireTableViewCell
        
        tableRowDataAlam = dayForTableAlam[indexPath.row]
        cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        cell_Alam.collectionTableAlam.reloadData()
        
        //day cell
        cell_Alam.day_Label_Alam.text = "\(tableRowDataAlam) \(cityNameAlam)"
        return cell_Alam
    }
}


