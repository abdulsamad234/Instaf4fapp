//
//  AppConfig.swift
//  Instagram Clone
//
//  Created by Edward Pie on 26/01/2017.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import Foundation
class AppConfig{
    
    static let ACCESS_TOKEN_KEY = "f15fb0dcc41e458ca732f0be705cf51b"
    static let HAS_STORED_FEEDS_OFFLINE_KEY = "HAS_STORED_FEEDS_OFFLINE_KEY"
    
    static let TargetApiEnvironment = InstagramEnvironment.SANDBOX
    
    static func storeAccessToken(token: String){
        UserDefaults.standard.set(token, forKey: AppConfig.ACCESS_TOKEN_KEY)
    }
    
    static func getAccessToken() -> String?{
        return UserDefaults.standard.value(forKey: AppConfig.ACCESS_TOKEN_KEY) as? String
    }
    
    static func setHasStoredFeedsOffline(status: Bool){
        UserDefaults.standard.set(status, forKey: AppConfig.HAS_STORED_FEEDS_OFFLINE_KEY)
    }
    
    static func hasStoredFeedsOffline() -> Bool?{
        return UserDefaults.standard.value(forKey: AppConfig.HAS_STORED_FEEDS_OFFLINE_KEY) as? Bool
    }
    
    enum InstagramEnvironment{
        case SANDBOX
        case PRODUCTION
        
        func getEnvironmentConfiguration() -> (baseUrl: String,clientID: String, clientSecret: String, redirectUrl: String){
            var configuration = ("","","","")
            
            switch self {
            case .SANDBOX:
                configuration = ("https://api.instagram.com/v1","3e81125131f0418ead40b25a655f2ede","f15fb0dcc41e458ca732f0be705cf51b","http://instagram.com")
            case .PRODUCTION:
                configuration = ("","","","")
            }
            
            return configuration
        }
    }
}
