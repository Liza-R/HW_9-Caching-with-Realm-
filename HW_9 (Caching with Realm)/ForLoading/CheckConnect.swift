//
//  CheckConnect.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 16/10/2021.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
