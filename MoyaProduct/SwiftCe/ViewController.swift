//
//  ViewController.swift
//  SwiftCe
//
//  Created by usermac on 2019/10/9.
//  Copyright © 2019 usermac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
protocol Vehicle
{
    var numberOfWheels: Int {get}
    var color: UIColor {get set}

    mutating func changeColor()
}
struct MyCar: Vehicle {
    let numberOfWheels = 4
    var color = UIColor.blue

    mutating func changeColor() {
        color = UIColor.red
    }
}
func addOne(num: Int) -> Int {
    return num + 1
}
func addTo(adder: Int) -> (_ a:Int) -> Int {
    return {
        return $0+adder
    }
}
func greaterThan(comparer: Int) -> (_ a:Int) -> Bool {
    return { $0 > comparer }
}


class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let control = Control()
    var myClosure: (() -> String)?  // 这是一个不带参数带返回值的闭包
    var myClosure2: ((Int) -> String)? // 带参数带返回值
    var myC: (() ->())?// 无返回值无参数
    var myC2: ((Int , @escaping ()->()) ->())?// 带参数不带返回值
    let tableview = UITableView()
    let i = Observable<[Control]>.just([])
    
    private let provider  = MoyaProvider<APIManager>()
    lazy var  btn : UIButton =
        {
            
        let btn = UIButton(frame: CGRect(x: 0, y:100, width: 200, height: 100))
        btn.backgroundColor = UIColor.red
        return btn
    
        }()
    let query = UILabel()
    var resultCount = UITextField()
    var resultCount2 = UITextView()
    var resultsTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.backgroundColor = UIColor.red

        view.addSubview(btn)
        let btn2 = UIButton()
        btn2.backgroundColor = UIColor.black
        btn2.frame = CGRect(x: 0, y: 300, width: 200, height: 100)
        btn2.setTitle("shab", for: .normal)
        view.addSubview(btn2)
        btn.rx.tap.subscribe(onNext: {[weak self] in
            self?.tapClick(btn:(btn2))
            print("hhaha")
            }).disposed(by: disposeBag)
        
        resultCount2.rx.didBeginEditing
                .subscribe(onNext: {
                    print("开始编辑")
                })
                .disposed(by: disposeBag)
        
        resultCount.rx.text.orEmpty.changed
        .subscribe(onNext: {
            print("您输入的是：\($0)")
        })
        .disposed(by: disposeBag)
        resultCount.rx.text.orEmpty.changed.subscribe(onNext: {
            print("您输入的是：\($0)")
        } ).disposed(by: disposeBag)

        //        btn.addTarget(self, action: Selector(tapClick), for: .touchUpInside)ni
//        let a = Observable.of("1")
//        a.subscribe().disposed(by: disposeBag)
//        let subject1 = BehaviorSubject(value: "A")
//        let subject2 = BehaviorSubject(value: "1")
//        let str1 = "1"
//        let str2 = "3"
//        print(str1+str2)
//        let variable = Variable(subject1)
//
//        variable.asObservable()
//            .flatMap { $0 }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
//
//        subject1.onNext("B")
//        variable.value = subject2
//        subject2.onNext("2")
//        subject1.onNext("C")
//
//        let dou = 1.2
//        let bol = 1
//        print(dou+Double(bol))
 
//
//        o.flatMap {
//             $0
//        }.subscribe(onNext: { element in
//            print(element)
//        })
//        .disposed(by: disposeBag)
        
//        let disposeBag = DisposeBag()
         
        

    }
    func  tapClick (btn:UIButton) {
        
        print("Hello world\(btn.currentTitle ?? "")")
    }

    func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
        for item in list {
            if condition(item) {
                return true
            }
        }
        return false
    }
    func onButtonTap() {
        print("Button was tapped")
    }

}
protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>:TargetAction {
                            
    weak var target: T?
    let action: (T) -> () -> ()
   
    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}
enum ControlEvent {
    case TouchUpInside
    case ValueChanged
    // ...
}


class Control {
    var actions = [ControlEvent: TargetAction]()

    func setTarget<T: AnyObject>(target: T,action: @escaping (T) -> () -> (),controlEvent: ControlEvent)    {
       
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
            
    }

    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }

    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}
enum APIManager {                    //先定义一个枚举，里面规定了这些请求的名称和参数
    case GetSearch(String,Int)          //搜索小说，如果参数多，建议传字典
    case GetSection(String)              //获取小说章节
    case GetNovel(String)                //获取小说内容
}
extension APIManager:TargetType{       // 扩展APIManager，让它实现Moya的TargetType协议
    var baseURL: URL{                         //获取BaseURL，一般来说，同一个项目BaseURL是相同的，但会根据使用CDN或者使用一些第三方服务而有不同
        switch self {
        case .GetSearch(_, _):
            return URL(string: "http://zhannei.baidu.com")!    //搜索小说使用此域名
        case .GetSection(_),.GetNovel(_):
            return URL(string: "http://www.37zw.net")!       //获取小说章节和内容使用此域名
        }
    }
    var path: String{                                      //获取BaseURL后面的路径
        switch self {
        case .GetSearch(_, _):                        //搜索小说使用此路径
            return "/cse/search"
        case .GetSection(let path2),.GetNovel(let path2):  //获取小说章节和内容用自定义路径
            return path2
        }
    }
    var method: Moya.Method {
        switch self {
        case .GetNovel(_):
            return .post
        default:
            return .get
        }//这三个请求都用Get请求
    }
    var parameterEncoding: ParameterEncoding {  //这三个请求都用默认编码
        return URLEncoding.default
    }
    var sampleData: Data {                          //这里是当API还没有开发好时自定义一些模拟数据
        return "".data(using: String.Encoding.utf8)!
    }
    var task: Moya.Task {                      //如果要设置请求参数，可以在这个属性里设置
        switch self {
         case .GetSearch(let key, let index):        //设置搜索的Key和index页码
            let params = ["q":key,
                          "p":index,
                          "isNeedCheckDomain":1,
                          "jump":"1",
                          "s":"2041213923836881982"] as [String : Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .GetSection(_),.GetNovel(_): //这两个不需要其他参数
            return .requestPlain
        }
    }
    var validate: Bool {   //是否需要执行 Alamofire 验证
        return false
    }
    var headers: [String : String]?{        //设置HTTP 的Head内容，这里看后台的需求了
        return nil
    }
}
