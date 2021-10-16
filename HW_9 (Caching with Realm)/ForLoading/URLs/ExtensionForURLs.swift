//
//  ExtensionForURLs.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 16/10/2021.
//

import Foundation

extension String{
    var encodeUrl: String{
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String{
        return self.removingPercentEncoding!
    }
}
