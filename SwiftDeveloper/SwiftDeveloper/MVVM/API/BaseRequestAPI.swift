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
    case GET(map:[String:Any],urlPath:String?)
    case POST(map:[String:Any],urlPath:String?)
}
extension BaseRequestAPI :TargetType {

    var path: String {
        switch self {
            case .GET(_, let urlPath):
            
            return urlPath ?? ""
            case .POST(_,let url):
                return url ?? ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .GET(_,_):
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .GET(let map,_),.POST(let map,_):
            return .requestParameters(parameters: map, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["":""]
    }
    
    var baseURL: URL {
        return URL(string: "")!
    }
    
}

