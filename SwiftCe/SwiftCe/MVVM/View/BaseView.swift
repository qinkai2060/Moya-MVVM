//
//  BaseView.swift
//  SwiftCe
//
//  Created by usermac on 2019/11/22.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit

class BaseView: UIView ,baseViewModelDelegate{
    var BaseViewModel:BaseViewModel?
    init(frame:CGRect ,viewModel:BaseViewModel?) {
        BaseViewModel = viewModel
        super.init(frame: frame)
        hh_setupView()
        hh_bindView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func hh_setupView() {
        
    }
    func hh_bindView() {
        
    }

}
