//
//  Response+ObjectMapper.swift
//  SwiftDeveloper
//
//  Created by usermac on 2019/11/25.
//  Copyright © 2019 usermac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension Response{
    public func mapObject<T:BaseMappable>(_ type:T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject:try? mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
     
    public func mapArray<T:BaseMappable>(_ type:T.Type) throws -> [T] {
        guard let json = try? mapJSON() as? [String:Any] else {
            throw MoyaError.jsonMapping(self)
        }
        var arrayM :[Any]?
        for (_,value) in json {
            guard let array = value as? [Any] else {
                throw MoyaError.jsonMapping(self)
            }
            guard let dicts = array as? [[String: Any]] else {
                throw MoyaError.jsonMapping(self)
            }
            arrayM = dicts
            break
        }
        return Mapper<T>().mapArray(JSONArray: arrayM as! [[String : Any]])
    }
}

extension ObservableType where E == Response {
    public func mapObject<T:BaseMappable>(_ type:T.Type) -> Observable<T> {
        return flatMap { (response) -> Observable<T>  in
            return Observable.just(try response.mapObject(T.self))
        }
    }
    
    public func mapArray<T:BaseMappable>(_ type:T.Type) -> Observable<[T]>{
        return flatMap { (response) -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self))
        }
    }
}
