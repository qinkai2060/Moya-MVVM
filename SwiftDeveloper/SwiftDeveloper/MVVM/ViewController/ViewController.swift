//
//  ViewController.swift
//  SwiftDeveloper
//
//  Created by usermac on 2019/11/25.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    var b:BaseView?
    lazy var base:BaseView =  { 
        let b = BaseView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), viewModel: nil)
        
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    



}

