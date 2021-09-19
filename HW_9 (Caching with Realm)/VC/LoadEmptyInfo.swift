//
//  LoadEmptyInfo.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 19.09.2021.
//

import Foundation
import UIKit

class EmptyInfo{
    func uploadEmptyCurrentInfo(dateLabel: UILabel, tempLabel: UILabel, minTempLabel: UILabel, maxTempLabel: UILabel, feels_likeTempLabel: UILabel, descrLabel: UILabel, icon: UIImageView){
        print("---Старт функции для первой загрузки текущей погоды")
        dateLabel.text = "Loading date..."
        tempLabel.text = "Loading t..."
        minTempLabel.text = "Loading min t..."
        maxTempLabel.text = "Loading max t..."
        feels_likeTempLabel.text = "Loading feels t..."
        descrLabel.text = "Loading descript..."
        icon.image = .none
        print("----Инфо о текущей погоде помещена в UI")
        print("---Конец функции для первой загрузки текущей погоды")
    }
}
