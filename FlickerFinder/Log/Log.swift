//
//  Log.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/20/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import os

private let subsystem = "com.FatimahGalhoum.FlickerFinder"

struct Log {
    static let networking = OSLog(subsystem: subsystem, category: "networking")
    static let featchedCoreData = OSLog(subsystem: subsystem, category: "coreData")
    static let updateCoreData = OSLog(subsystem: subsystem, category: "updatecoreData")
    static let catchError = OSLog(subsystem: subsystem, category: "catchError")
    static let alertControllerCalled = OSLog(subsystem: subsystem, category: "alertControllerCalled")


}



