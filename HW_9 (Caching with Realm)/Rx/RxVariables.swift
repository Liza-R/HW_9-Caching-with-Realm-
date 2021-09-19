//
//  RxVariables.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 19.09.2021.
//

import Foundation
import RxCocoa
import RxSwift

class RxVar{
    var savingCurrentInfoVar = BehaviorRelay<Bool>(value: false),
        savingForecastInfoVar = BehaviorRelay<Bool>(value: false)
}
