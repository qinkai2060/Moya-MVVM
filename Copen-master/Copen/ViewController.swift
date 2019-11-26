//
//  ViewController.swift
//  Copen
//
//  Created by YinTokey on 2018/5/12.
//  Copyright © 2018年 YinTokey. All rights reserved.
//

import UIKit
import Moya


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        API.provider.request(.Subscribe(.hotrank), completion: {result in
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

