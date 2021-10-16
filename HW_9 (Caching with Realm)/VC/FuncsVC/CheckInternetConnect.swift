//
//  CheckInternetConnect.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 16/10/2021.
//

import Foundation
import UIKit

class CheckInternetConnect{
    func checkIntenet(vc: UIViewController, refreshControl: UIRefreshControl, table: UITableView, uploadNOEmptyCurrentInfo: () -> Void, uploadNOEmptyForecastInfo: () -> Void){
        if Connectivity.isConnectedToInternet {
                print("Yes! internet is available.")
            CheckDataBase().diaplayLoadApp(curInfoRealm: RealmVars().currentInfoRealm, fcInfoRealm: RealmVars().forecastInfoRealm, uploadNOCurInfo: uploadNOEmptyCurrentInfo, uploadNOFcInfo: uploadNOEmptyForecastInfo, table: table)
        }else{
            print("No! internet is not available.")
            vc.present(Alerts().alertNotConnect(), animated: true, completion: nil)
            refreshControl.endRefreshing()
        }
    }
}
