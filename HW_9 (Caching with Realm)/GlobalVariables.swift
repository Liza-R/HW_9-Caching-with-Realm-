//
//  GlobalVariables.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation
import RxCocoa

var cityNameAlam: String = "",
        savingCurrentInfoVar = BehaviorRelay<Bool>(value: false),
        savingForecastInfoVar = BehaviorRelay<Bool>(value: false)
