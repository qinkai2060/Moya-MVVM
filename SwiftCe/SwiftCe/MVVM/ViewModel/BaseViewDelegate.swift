//
//  BaseViewModel.swift
//  SwiftCe
//
//  Created by usermac on 2019/10/12.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
protocol baseViewModelDelegate {
    func hh_setupView ()
    
    func hh_bindView ()
}
extension baseViewModelDelegate {
    func hh_setupView() {
        
    }
    func hh_bindView() {
        
    }
}
