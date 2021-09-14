//
//  ViewController.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import UIKit

var cityNameAlam: String = ""

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
        print("Загрузка приложения")
        cityNameAlam = searchTF.text!
        
       // if todayInfoRealm.isEmpty{
            print("Инфы о тек погоде нет")
            uploadEmptyTodayInfo()
            updateInfo()
       /* }else{
            print("Таблица не пуста")
            uploadLastInfo()
        }*/
        
       /* self.weather_Table_Alamofire.reloadData()
        self.weather_Table_Alamofire.dataSource = self*/
        print("Конец загрузки приложения")
    }

    func uploadEmptyTodayInfo(){
        print("Старт функ для первой загрузки")
       // today_Label_Alam.text = "Loading..."
        temp_Label_Alam.text = "Loading..."
        min_temp_Label_alam.text = "Loading..."
        max_Label_Alam.text = "Loading..."
        feels_like_Label_Alam.text = "Loading..."
        descript_Label_Alam.text = "Loading..."
        icon_Image_Alam.image = .none
        print("Информация помещена в UI")
        print("Конец функ для первой загрузки")
    }
    
    func uploadLastInfo(){
        print("Начало вставки последней инфо let")
        if todayInfoRealm.isEmpty{
            print("Data NF")
        }else{
            print("OK")
            for i in todayInfoRealm{
   
            }
        }
        /*for i in todayInfoRealm{
            today_Label_Alam.text = "TODAY: \(i.dateToday)"
            temp_Label_Alam.text = "\(i.cityNameTemp)"
            min_temp_Label_alam.text = "\(i.tempTMin)"
            max_Label_Alam.text = "\(i.tempTMax)"
            feels_like_Label_Alam.text = "\(i.tempFL)"
            descript_Label_Alam.text = "\(i.descr)"
            icon_Image_Alam.image = UIImage(data: i.icon as Data)
        }
        print("Информация из таблицы помещена в UI")*/
        print("Конец вставки последней инфо в let")
    }
    
    func updateInfo(){
        print("Начало обновления инфо о тек погоде")
        ViewModelAlamofire().uploadToday()
        print("Конец обновления инфо о тек погоде")
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


