//
//  ForecastImagesObj.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 16/10/2021.
//

import Foundation
import RealmSwift

class IconsForForecastClass: Object {
    @objc dynamic var icon = NSData()
}

class ForecastImages: Object{
    let icons = List<IconsForForecastClass>()
}
