//
//  BaseRequestAPI.swift
//  SwiftCe
//
//  Created by usermac on 2019/10/12.
//  Copyright © 2019 usermac. All rights reserved.
//

import Foundation
import Moya
let baseRequestAPI = MoyaProvider<BaseRequestAPI>()
enum BaseRequestAPI {
//    case GET(map:[String:Any],urlPath:String)
//    case POST(map:[String:Any],urlPath:String)
    case Home(HomeApi)
}
extension BaseRequestAPI :TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var sampleData: Data {
         return Data()
    }
    
    var task: Task {
        switch self {
            case .Home(let home):
            return home.task
        }
    }
    
    var headers: [String : String]? {
         return ["":""]
    }
    
    var path: String {
        switch self {
        case .Home(let home):
            return home.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Home(let home):
            return home.method
        }
    }
    

    
}

