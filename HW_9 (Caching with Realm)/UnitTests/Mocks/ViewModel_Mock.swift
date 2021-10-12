//
//  ViewModel_Mock.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation

class ViewModel_Mock: ViewModel{
    var curInfoLoad = 0,
        forecastInfoLoad = 0

    override func uploadCurrentInfo() {
        curInfoLoad = 1
    }
    override func uploadForecastInfo() {
        forecastInfoLoad = 1
    }
}
