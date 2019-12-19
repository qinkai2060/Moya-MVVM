//
//  SpCartViewController.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpCartViewController.h"
#import "HFCarMainView.h"
#import "HFCarViewModel.h"
#import "HFShopingModel.h"
#import "FeatureViewController.h"
#import "UIBarButtonItem+Exetention.h"
@interface SpCartViewController ()<FeatureViewDelegate>
@property (nonatomic,strong) HFCarMainView *carMainView;
//@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) HFCarViewModel *viewModel;
@property (nonatomic,assign) SpCartViewControllerEnterType contentMode;
@property (nonatomic,strong) HFStoreModel *model;
@property (nonatomic, strong)UIView *blackView;
@end

@implementation SpCartViewController

- (instancetype)initWithType:(SpCartViewControllerEnterType)contentMode {
    if (self = [super init]) {
        self.contentMode = contentMode;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.carMainView];
    [self setNav];
    [self bindModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShopCar) name:@"refreshShopCar" object:nil];
    if(self.contentMode == SpCartViewControllerEnterTypeOther){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"HMH_back_light" target:self action:@selector(back)];
    }
    NSLog(@"👌%@",self.navigationController.navigationBar.subviews.firstObject);
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.getCardDetialCommand execute:nil];
}
- (void)refreshShopCar {
    [self.viewModel.getCardDetialCommand execute:nil];
}
- (void)bindModel {
    @weakify(self);
    HMHBasePrimaryViewController *loginVC = [[HMHBasePrimaryViewController alloc] init];
    if ([loginVC isLogin]){
        [self.viewModel.getCardDetialCommand execute:nil];
    }
       [self.viewModel.getCarInfo subscribeNext:^(id  _Nullable x) {
           @strongify(self);
           self.messageBtn.hidden = !((NSArray*)x).count;
           
       }];
    [self.viewModel.deleteFavEndingSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.messageBtn.hidden = !((NSArray*)x).count;
        
    }];
    [self.viewModel.resetEditingButtonStateSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.messageBtn.selected = NO;
    }];
    [self.viewModel.enterCommitPayMent subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        HFPayMentViewController *vc = [[HFPayMentViewController alloc] initWithType:HFPayMentViewControllerEnterTypeNone];
        vc.viewModel.contentType = 1;
        [vc requestPram:(NSArray*)x];
        vc.viewModel.orderWriteParams = @{};
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.enterStoreSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        HFShopingModel *shopModel = (HFShopingModel*)x;
        ShopListViewController *vc = [[ShopListViewController alloc] init];
        GoodsDetailModel*detailModel = [[GoodsDetailModel alloc] init];
       
        ProductDetail              * data = [[ProductDetail   alloc] init];
        Product *p = [[Product alloc] init];
        p.shopId= [shopModel.shopsId integerValue];
         detailModel.data = data;
         data.product = p;
        
        vc.detailModel =  detailModel;//[shopModel.shopsId integerValue]
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.viewModel.enterDetailSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFStoreModel *storeModel = (HFStoreModel *)x;
        GetProductListByConditionModel *list = [[GetProductListByConditionModel alloc] init];
        list.productId = storeModel.productId;
        SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] initWithModel:list];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goodsType=OrdinaryGoodsDetailStyle;
//        vc.listModel = list;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.resetSpecialsSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x != nil) {
            HFStoreModel *model = (HFStoreModel*)x;
            self.model = model;
            _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            _blackView.alpha=0.6;
            _blackView.backgroundColor=HEXCOLOR(0X000000);
            _blackView.tag = 440;
            [self.view addSubview:_blackView];
            _blackView.alpha=0;
            [UIView animateWithDuration:0.5f animations:^{
                _blackView.alpha = 0.6;
                
            } completion:^(BOOL finished) {
                
            }];
            FeatureViewController *vc = [[FeatureViewController alloc] init];
            vc.Delegate = self;
            vc.productId = model.productId;
            vc.type=@"购物车重置";
            ProductFeatureModel *featureModel = [[ProductFeatureModel alloc]init];
            featureModel.data=[[FeatureModelDetail alloc]init];
//            featureModel.data.rsMap=[[RsMap alloc]initWithDictionary:model.productspMap error:nil];
            featureModel.data.rsMap= [RsMap modelWithJSON:model.productspMap];
            vc.featureModel=featureModel;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    [self.viewModel.goCategorySubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tabBarController setSelectedIndex:1];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShoppingSuccess) name:@"addShoppingCarSuccess" object:nil];
}
#pragma featureView delegate
- (void)featureViewdismissVC
{
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.35f animations:^{
        _blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [_blackView removeFromSuperview];
    }];
    
    
}
- (void)selectedItemType:(NSString*)type dic:(NSDictionary*)dic {
    HFStoreModel *storModel = [[HFStoreModel alloc] init];
    [storModel getData:dic];
    self.viewModel.resetSpecialPrams = @{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"id":@(self.model.storeId.integerValue),@"productID":@(storModel.commodityId.integerValue),@"productTypeID":@(storModel.specifications.integerValue),@"shoppingCount":@(storModel.countStr.integerValue),@"shopsId":@(self.model.shopsId.integerValue),@"shopsType":@(1),@"stealAge":@(0),@"price":@(storModel.resetprice.floatValue)};
    
    [self.viewModel.resetSpecialCommand execute:nil];
}
- (void)addShoppingSuccess {
     [self.viewModel.getCardDetialCommand execute:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.contentMode == SpCartViewControllerEnterTypeNone) {
        self.tabBarController.tabBar.hidden = NO;
        self.hidesBottomBarWhenPushed = NO;
    }
    
//
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setNav {
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 40)];
   // [rightV addSubview:self.editBtn];
    [rightV addSubview:self.messageBtn];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightV];
    self.navigationItem.rightBarButtonItem = item;

}
#pragma mark - Event
- (void)editingClickEvent:(UIButton*)btn {
   
   
         btn.selected = !btn.selected;
        [self.viewModel.editingSelectSubjc sendNext:btn];
        [self.carMainView isEditingPriceView:btn.selected];
    

}
#pragma mark - Lazy
- (HFCarMainView *)carMainView {
    if (!_carMainView) {
        CGFloat height = 0;
        if (self.contentMode == SpCartViewControllerEnterTypeNone) {
            height = (IS_iPhoneX?64+24:64)+(IS_iPhoneX?49+34:49);
        }else {
            height = (IS_iPhoneX?64+24+34:64);
        }
        _carMainView = [[HFCarMainView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH- height) WithViewModel:self.viewModel];
    }
    return _carMainView;
}
//- (UIButton *)editBtn {
//    if (!_editBtn) {
//        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (20-15)*0.5, 27, 15)];
//        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//        [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
//        _editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_editBtn addTarget:self action:@selector(editingClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//        _editBtn.hidden = YES;
//    }
//    return _editBtn;
//}
- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(57-40, 0, 40, 40)];
      //  [_messageBtn setImage:[UIImage imageNamed:@"message_light"] forState:UIControlStateNormal];
        [_messageBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_messageBtn setTitle:@"完成" forState:UIControlStateSelected];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(editingClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}
- (HFCarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFCarViewModel alloc] init];
    }
    return _viewModel;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
