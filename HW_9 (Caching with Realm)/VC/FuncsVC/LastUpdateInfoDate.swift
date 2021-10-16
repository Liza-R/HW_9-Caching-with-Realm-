//
//  LastUpdateInfoDate.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 16/10/2021.
//

import Foundation
import UIKit

class LastUpdate{
    func lastDate(lastUPDLabel: UILabel){
        switch errorLoad {
        case 0:
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "dd.MM.yy HH:mm:ss"
            let dateString = formatter.string(from: Date())
            lastUPDLabel.text = "Last update: \(dateString)"
            RealmWeather().savingLastUPDDate(date: dateString)
        default:
            let lastDate = RealmVars().lastUPD.last
            lastUPDLabel.text = "Last update: \(String(describing: lastDate))"
        }
    }
}
