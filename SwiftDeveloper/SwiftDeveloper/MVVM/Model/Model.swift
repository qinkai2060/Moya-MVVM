//
//  Model.swift
//  SwiftCe
//
//  Created by usermac on 2019/10/12.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit
import ObjectMapper
public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
}
class Model: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    

}
struct ModelSection {
    
    var items: [Item]
}

extension ModelSection: SectionModelType {
    
    typealias Item = Model
    
    init(original: ModelSection, items: [ModelSection.Item]) {
        self = original
        self.items = items
    
    }
}
