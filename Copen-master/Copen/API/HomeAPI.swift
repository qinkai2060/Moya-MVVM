//
//  HomeAPI.swift
//  Copen
//
//  Created by YinTokey on 2018/5/12.
//  Copyright © 2018年 YinTokey. All rights reserved.
//

import Foundation
import Moya
//首页

enum HomeAPI{
    case homeMoudle
    
}

extension HomeAPI{
    var path:String{
        switch self {
        case .homeMoudle:
            return "/module/home.do"
        }
    }
    
    var method:Moya.Method{
        switch self{
        case .homeMoudle:
            return .post
        }
    }
    
    var task:Task{
        switch self {
        case .home:
            return .requestPlain
        }
        
    }

}
