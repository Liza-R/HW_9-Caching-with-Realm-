//
//  CurrentImageObj.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 12/10/2021.
//

import Foundation
import RealmSwift

class CurrentImage: Object{
    @objc dynamic var icon = NSData()
}
