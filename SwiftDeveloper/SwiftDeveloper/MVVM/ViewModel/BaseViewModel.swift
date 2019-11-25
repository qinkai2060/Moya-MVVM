//
//  BaseViewModel.swift
//  SwiftCe
//
//  Created by usermac on 2019/11/22.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}
class BaseViewModel: NSObject {
    // 存放着解析完成的模型数组 BehaviorRelay <[数据类型]>
    let dataModel = BehaviorRelay<[Model]>(value: [])
    let dataModel2 = BehaviorRelay<Model>(value: Model())
    
     var index: Int = 1

}

extension BaseViewModel:baseViewModelDelegate {
    typealias Input = BaseInput
    typealias Output = BaseOutput
    struct BaseInput {
        let requestType:BaseRequestAPI
        
        init(requestType:BaseRequestAPI) {
            self.requestType = requestType
        }
    }
    
    struct BaseOutput {
        let sections: Driver<[ModelSection]>
        
        let requestCommond = PublishSubject<Bool>()
        
        let refreshStatus = BehaviorRelay<RefreshStatus>(value:.none)
        
        init(sections:Driver<[ModelSection]>){
            self.sections = sections
        }
    }
    func transform(input: BaseViewModel.BaseInput) -> BaseViewModel.BaseOutput {
        let sections = dataModel.asObservable().map { (d) -> [ModelSection] in
            
            return [ModelSection(items: d)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = BaseOutput(sections: sections)
        
        output.requestCommond.subscribe(onNext: { [unowned self] isReloadData in
            self.index = isReloadData ? 1 : self.index+1
            baseRequestAPI.rx.request(.GET(map: ["":""], urlPath: "")).asObservable()
            
            
        }, onError: { (r) in
            
        }, onCompleted: {
            
        }) {
            
        }
        return output
    }
    func hh_bindView() {
        
    }
    func hh_setupView() {
         
    }
}
