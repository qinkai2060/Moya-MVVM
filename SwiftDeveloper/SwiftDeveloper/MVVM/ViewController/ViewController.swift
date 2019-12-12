//
//  ViewController.swift
//  SwiftDeveloper
//
//  Created by usermac on 2019/11/25.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import Then
import SnapKit
import Moya
import Kingfisher
import MJRefresh
import Reusable
class ViewController: UIViewController {
//    var b:BaseView?
    var emptyStr2:[String:String]?
    let viewModel = BaseViewModel()
    lazy  var tableView = { () -> UITableView in
     let b = UITableView()
     b.register(cellType: LXFViewCell.self)
    return b
   }()
    lazy var base:BaseView =  { 
        let b = BaseView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), viewModel: nil)
        
        return b
    }()
    let dataSource = RxTableViewSectionedReloadDataSource<ModelSection>(configureCell: { datasource, tableview, IndexPath, item in
        let cell = tableview.dequeueReusableCell(for: IndexPath) as LXFViewCell

    
//        cell.picView.kf.setImage(with: URL(string: item.url))
//        cell.descLabel.text = "描述: \(item.desc)"
//        cell.sourceLabel.text = "来源: \(item.source)"
      
        return cell
    })
    
    init() {
//        self.emptyStr2 = ["":""]
        super.init(nibName: nil, bundle: nil)
    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyStr2 = nil
        empty(string: emptyStr2 ?? ["":""])
        ViewController()
        let vmOutput = viewModel.transform(input: .Home(.homeMoudle(map: ["":""])))
        vmOutput.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource))
    }
    
       override func awakeFromNib() {
       super.awakeFromNib()
        }

        required init?(coder aDecoder: NSCoder) {
//            self.emptyStr2 = ["":""]
            super.init(coder: aDecoder)
//            fatalError("init(coder:) has not been implemented")
        }
  
    func empty(string:[String:String]) {
        
    }

}


class LXFViewCell: UITableViewCell, Reusable {
    
}
