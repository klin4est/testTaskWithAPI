//
//  CurrentSession.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 12.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class CurrentSession: NSObject {
    static let shared = CurrentSession()


    var name = ""
    var email = ""
    var password = ""
    var accessToken = ""

    var dictSymbols = Dictionary <Character, Int>()
}
