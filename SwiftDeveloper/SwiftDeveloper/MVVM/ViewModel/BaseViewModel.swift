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
import SVProgressHUD
import NSObject_Rx
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
    
     var index: Int = 1
     
    let prams:[String:Any]? = ["":""]
    
    let path:String? = ""
    
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
            baseRequestAPI.rx.request(.GET(map: self.prams!, urlPath: self.path!))
                .asObservable()
                .mapArray(Model.self).subscribe ({[weak self] (event) in
                    switch event {
                    case let .next(modelArr):
                        self?.dataModel.accept(isReloadData ? modelArr : (self?.dataModel.value ?? []) + modelArr)
                        SVProgressHUD.showSuccess(withStatus: "加载成功")
                    case let .error(error):
                        SVProgressHUD.showSuccess(withStatus:error.localizedDescription)
                    case .completed:
                        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : .endFooterRefresh)
                    }
                }).disposed(by: self.rx.disposeBag)
        }).disposed(by:rx.disposeBag)
        return output
    }
    
    func hh_bindView() {
        
    }
    func hh_setupView() {
         
    }

}
