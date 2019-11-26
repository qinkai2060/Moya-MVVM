//
//  API.swift
//  Copen
//
//  Created by YinTokey on 2018/5/12.
//  Copyright © 2018年 YinTokey. All rights reserved.
//

import Foundation
import Moya


enum API {
    //按照大模块划分
    case Home(HomeAPI) //首页模块
    case Subscribe(SubscribeAPI) //订阅模块
    case Breaks(BreaksAPI) //课间模块
}

extension API:TargetType{
    
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        
        return URL.init(string:"https://c.open.163.com/open/mob")!
    }
    
    var path: String {
        switch self {
        //大模块划分
        case .Home(let home): //首页模块
            return home.path
        case .Subscribe(let subscribe):
            return subscribe.path
        case .Breaks(let breaks):
            return breaks.path
        }
        
    }
    
    var method: Moya.Method {
        switch self{
        case .Home(let home):
            return home.method
        case .Subscribe(let subscribe):
            return subscribe.method
        case .Breaks(let breaks):
            return breaks.method
        }
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self{
        case .Home(let home):
            return home.task
        case .Subscribe(let subscribe):
            return subscribe.task
        case .Breaks(let breaks):
            return breaks.task
        }
    }
    
    
    var validate: Bool {
        return false
    }
    
    
}



extension API{
  
    static let provider = MoyaProvider<API>()
    
    
}
