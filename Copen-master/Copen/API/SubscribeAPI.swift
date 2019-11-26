//
//  Subscribe.swift
//  Copen
//
//  Created by YinTokey on 2018/5/12.
//  Copyright © 2018年 YinTokey. All rights reserved.
//

import Foundation
import Moya
//订阅

enum SubscribeAPI{
    case banner(position:Int,rtypes:String)
    case hotrank
    case new
    
}

extension SubscribeAPI{
    var path:String{
        switch self {
        case .banner:
            return "/subscribe/banner.do"
        case .hotrank:
            return "/subscribe/hotrank/list.do"
        case .new:
            return "/subscribe/new/list.do"
        }
    }
    
    var method:Moya.Method{
        switch self{
        case .banner,.hotrank,.new:
            return .get
        }
    }
    
    var task:Task{
        switch self {
        case .hotrank,.new:
            return .requestPlain
        case .banner(let position, let rtypes):
            return .requestParameters(parameters: ["position":position,"rtypes":rtypes], encoding: URLEncoding.queryString)
        }
        
    }
}
