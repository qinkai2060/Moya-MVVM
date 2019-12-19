//
//  HFViewController.m


#import "HFViewController.h"

@interface HFViewController ()

@end

@implementation HFViewController

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//
//    HFViewController *viewController = [super allocWithZone:zone];
//
//    @weakify(viewController)
//
//    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
//
//        @strongify(viewController)
//        [viewController hh_addSubviews];
//        [viewController hh_bindViewModel];
//    }];
////
//    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
//
//        @strongify(viewController)
//        [viewController hh_layoutNavigation];
//        [viewController hh_getNewData];
//    }];
//
//    return viewController;
//}
- (instancetype)init {
    if (self = [super init]) {
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            
            @strongify(self)
            [self hh_addSubviews];
            [self hh_bindViewModel];
        }];
        //
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
            
            @strongify(self)
            [self hh_layoutNavigation];
            [self hh_getNewData];
        }];
    }
    return self;
}
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    if (self = [super init]) {
        @weakify(self)
        
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            
            @strongify(self)
            [self hh_addSubviews];
            [self hh_bindViewModel];
        }];
        //
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
            
            @strongify(self)
            [self hh_layoutNavigation];
            [self hh_getNewData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)hh_addSubviews {}

/**
 *  绑定
 */
- (void)hh_bindViewModel {}

/**
 *  设置navation
 */
- (void)hh_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)hh_getNewData {}

@end
