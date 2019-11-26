//
//  BreakAPI.swift
//  Copen
//
//  Created by YinTokey on 2018/5/12.
//  Copyright © 2018年 YinTokey. All rights reserved.
//

import Foundation
import Moya

// 课间
enum BreaksAPI {
    case list //课间列表
    case detail(id:String) //详情
}

extension BreaksAPI{
    var path:String{
        switch self {
        case .list:
            return "classbreak/list.do"
        case .detail:
            return "classbreak/h5Detail.do"
        }
    }
    
    var method:Moya.Method{
        switch self{
        case .list,.detail:
            return .get
        }
    }
    
    var task:Task{
        switch self {
        case .list:
            return .requestPlain
        case .detail(let id):
            return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
        }
        
    }
    
}
