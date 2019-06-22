//
//  NetworkingStatus.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/23/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import Foundation
import Alamofire

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
