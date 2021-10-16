//
//  ImageLoader.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation
import UIKit
import Alamofire

class ImageLoader{
    func uploadCurrentImage(image_url: String){
        let url_icon_Al = URLs().url_icon_upload.replacingOccurrences(of: "PICTURENAME", with: "\(image_url)")
        AF.request(url_icon_Al ,method: .get).response{ response in
        switch response.result {
             case .success(let responseData):
                let icon = UIImage(data: responseData!, scale:1) ?? .checkmark
                RealmWeather().savingCurrentImage(icon: NSData(data: icon.pngData()!))
            
             case .failure(let error):
                print("error---> avatar loading", error, response.response?.statusCode as Any)
             }
        }
    }
    func uploadForecastImages(image_urls: [String], all_temps: [String]){
        var icons: [NSData] = []
        for (_, j) in image_urls.enumerated(){
            let url_icon_Al = URLs().url_icon_upload.replacingOccurrences(of: "PICTURENAME", with: "\(j)")
            AF.request(url_icon_Al ,method: .get).response{ response in
            switch response.result {
                 case .success(let responseData):
                    let ic = UIImage(data: responseData!, scale:1) ?? .checkmark
                    icons.append(NSData(data: ic.pngData()!))
                    if icons.count == all_temps.count{
                        RealmWeather().savingForecastImages(icons: icons)
                    }

                 case .failure(let error):
                    print("error---> avatar loading", error, response.response?.statusCode as Any)
                 }
            }
        }
    }
}
