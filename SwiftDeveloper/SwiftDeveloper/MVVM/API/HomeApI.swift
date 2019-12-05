//
//  HomeApI.swift
//  SwiftDeveloper
//
//  Created by usermac on 2019/12/5.
//  Copyright © 2019 usermac. All rights reserved.
//

import Foundation
import Moya
enum HomeApi {
    case homeMoudle(map:[String:Any])
}
extension HomeApi {
    var path:String{
        switch self {
        case .homeMoudle:
            return "/module/home.do"
        }
    }
    var method:Moya.Method{
        switch self{
        case .homeMoudle:
            return .get
        }
    }
    var task:Task{
        switch self {
        case .homeMoudle(let map):
            return .requestParameters(parameters:map , encoding: JSONEncoding.default)
        }
        
    }
}
