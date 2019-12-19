//
//  YunDianNewRefundDetailViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailViewController.h"
#import "YunDianNewRefundDetailStateView.h"
#import "YunDianNewRefundDetailResultView.h"
#import "YunDianNewRefundDetailPingTaiResultView.h"
#import "YunDianNewRefundDetailSellerResultView.h"
#import "YunDianNewRefundDetailBugerResultView.h"
#import "YunDianNewRefundProductView.h"
#import "YunDianRefuseRefundViewController.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
#import "CustomPasswordAlter.h"
@interface YunDianNewRefundDetailViewController ()<YunDianNewRefundDetailBugerResultViewDelegate,YunDianNewRefundDetailSellerResultViewDelegate>
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundModel;
@property (nonatomic, strong) YunDianNewRefundDetailStateView *nRefundDetailStateView;//退款状态view
@property (nonatomic, assign) CGFloat nRefundDetailStateViewHeight;//85

@property (nonatomic, strong) YunDianNewRefundDetailResultView *nRefundDetailResultView;
@property (nonatomic, assign) CGFloat nRefundDetailResultViewHeight;// 70 or 45

@property (nonatomic, strong) YunDianNewRefundDetailPingTaiResultView *nRefundDetailPingTaiResultView;//平台仲裁结果
@property (nonatomic, assign) CGFloat nRefundDetailPingTaiResultViewHeight;// 60 + 详情高

@property (nonatomic, strong) YunDianNewRefundDetailSellerResultView * nRefundDetailSellerResultView;//卖家处理结果
@property (nonatomic, assign) CGFloat nRefundDetailSellerResultViewHeight;// 60 + 详情高 + 图片高度  或者  50 或者 60 + 详情高
@property (nonatomic, strong) YunDianNewRefundDetailBugerResultView * nRefundDetailBugerResultView;//卖家处理结果
@property (nonatomic, assign) CGFloat nRefundDetailBugerResultViewHeight;// 60 + 详情高 + 图片高度  或者  50 或者 60 + 详情高
@property (nonatomic, strong) YunDianNewRefundProductView * nRefundProductView;//商品图片
@property (nonatomic, assign) CGFloat nRefundProductViewHeight;// 287

@property (nonatomic, strong) UIScrollView *scrollView;

//@property (nonatomic, assign) NSInteger add;

@end

@implementation YunDianNewRefundDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款详情";
//    self.add = 0;
    
    [self setUI];
    [self.scrollView.mj_header beginRefreshing];
    
    
    
}
- (void)setUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(ScreenW, ScreenH);
    [self.view addSubview:self.scrollView];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestReturnDetails];
    }];
    
    [self.scrollView addSubview:self.nRefundDetailStateView];
    [self.scrollView addSubview:self.nRefundDetailResultView];
    [self.scrollView addSubview:self.nRefundDetailPingTaiResultView];
    [self.scrollView addSubview:self.nRefundDetailSellerResultView];
    [self.scrollView addSubview:self.nRefundDetailBugerResultView];
    [self.scrollView addSubview:self.nRefundProductView];
    
    
}

#pragma mark -退款详情接口

- (void)requestReturnDetails{
//    self.add += 1;
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@?sid=%@",[[NetWorkManager shareManager] getForKey:@"order./user/m/order-refund/details"], @(2),self.refundNo,sid];
    
    [HFCarRequest requsetUrl:url withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:nil success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.scrollView.mj_header endRefreshing];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if (Is_Kind_Of_NSDictionary_Class([[dic objectForKey:@"data"] objectForKey:@"orderRefundDetails"])) {//Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"orderRefundDetails"]];
//                [dic1 setObject:@(self.add) forKey:@"returnState"];
//                [dic1 setObject:@(0) forKey:@"autoRefund"];
//                //                [dic1 setObject:@"P_BIZ_CLOUD_WAREHOUSE_ORDER" forKey:@"orderBizCategory"];
//                [dic1 setObject:@(1567578284303) forKey:@"applyRemindInvalidTimestamp"];
                
                self.refundModel = [YunDianNewRefundDetailModel modelWithJSON:dic1];
                [self refrenshUI];
            } else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
        } else {
            [self showSVProgressHUDErrorWithStatus:@"网络请求异常!"];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.scrollView.mj_header endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
#pragma mark - 卖家图片点击协议action
- (void)yunDianNewRefundDetailSellerResultViewDelegateClickImgIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (YunDianNewRefundBuyerOrSellerRefundImagesMode *model in self.refundModel.sellerRefundImages) {
        [arr addObject:[model.imagePath get_Image_String]];
    }
    [self yunDianRefundDetailReasonViewDelegateClickImgIndex:index imgArr:arr];
    
}
#pragma mark - 买家图片点击协议action
- (void)yunDianNewRefundDetailBugerResultViewDelegateClickImgIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (YunDianNewRefundBuyerOrSellerRefundImagesMode *model in self.refundModel.buyerRefundImages) {
        [arr addObject:[model.imagePath get_Image_String]];
    }
    [self yunDianRefundDetailReasonViewDelegateClickImgIndex:index imgArr:arr];
    
}
#pragma mark - 同意拒绝退款
- (void)yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:(YunDianNewRefundDetailBugerResultViewTypeClick)type{
    
    switch (type) {
        case YunDianNewRefundDetailBugerResultViewTypeRefund:
        {
            //同意
            
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"同意退款后，平台将退款给买家" suret:@"确定" closet:@"取消" sureblock:^{
                          [self requestRefund];

                      } closeblock:^{
                          
                      }];
            
        }
            break;
        case YunDianNewRefundDetailBugerResultViewTypeRefuse:
        {
            //拒绝
            YunDianRefuseRefundViewController *vc = [[YunDianRefuseRefundViewController alloc] init];
            vc.refundModel = self.refundModel;
            WEAKSELF
            vc.block = ^{
                [weakSelf.scrollView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 同意退款接口
- (void)requestRefund{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    

    
    NSString *url = [NSString stringWithFormat:@"%@?sid=%@",[[NetWorkManager shareManager] getForKey:@"order.user/m/order-refund/seller-confirm-refund"],sid];
    NSDictionary *dic = @{
        @"refundNo":self.refundModel.refundNo,
        
        @"refundState":@(2)//2=同意，3=拒绝
    };
    [HFCarRequest requsetUrl:url withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"退款成功!"];
            [self.scrollView.mj_header beginRefreshing];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.scrollView.mj_header endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
#pragma mark - 图片点击模态
- (void)yunDianRefundDetailReasonViewDelegateClickImgIndex:(NSInteger)index imgArr:(NSArray *)imgArr{
    
    if (imgArr.count > index) {
        NSMutableArray * selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < imgArr.count; i++) {
            [selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
        }
        
        if (selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = selectImageTap;
            pictureVC.picUrlArray = imgArr;
            // 标记点击的是哪一张图片
            pictureVC.touchIndex = index;
            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
            CLPresent *present = [CLPresent sharedCLPresent];
            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
            pictureVC.transitioningDelegate = present;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:pictureVC animated:YES completion:nil];
        }
    }
}
#pragma mark - 刷新ui
- (void)refrenshUI{
    
    self.nRefundDetailStateViewHeight = 85;
    self.nRefundProductViewHeight = 287;
    
    
    self.nRefundDetailStateView.refundDetailModel = self.refundModel;
    self.nRefundDetailResultView.refundDetailModel = self.refundModel;
    self.nRefundDetailPingTaiResultView.refundDetailModel = self.refundModel;
    self.nRefundDetailSellerResultView.refundDetailModel = self.refundModel;
    self.nRefundDetailBugerResultView.refundDetailModel = self.refundModel;
    self.nRefundProductView.refundDetailModel = self.refundModel;
    
    switch ([self.refundModel.returnState integerValue]) {
        case 1://(买家=退款中，卖家=退款待处理）
        {
            self.nRefundDetailResultViewHeight = 70;
            self.nRefundDetailResultView.hidden = NO;
            
            self.nRefundDetailPingTaiResultView.hidden = YES;
            self.nRefundDetailPingTaiResultViewHeight = 0;
            
            self.nRefundDetailSellerResultView.hidden = YES;
            self.nRefundDetailSellerResultViewHeight = 0;
            
            self.nRefundDetailBugerResultView.hidden = NO;
            self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            
            [self refrenshFrame];
        }
            break;
        case 2://撤销退款
        {
            self.nRefundDetailResultViewHeight = 45;
            self.nRefundDetailResultView.hidden = NO;
            
            self.nRefundDetailPingTaiResultView.hidden = YES;
            self.nRefundDetailPingTaiResultViewHeight = 0;
            
            self.nRefundDetailSellerResultView.hidden = YES;
            self.nRefundDetailSellerResultViewHeight = 0;
            
            self.nRefundDetailBugerResultView.hidden = NO;
            self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            [self refrenshFrame];
            
        }
            break;
        case 3://(商家拒绝退款）
        {
            
            self.nRefundDetailResultViewHeight = 45;
            self.nRefundDetailResultView.hidden = NO;
            
            self.nRefundDetailPingTaiResultView.hidden = YES;
            self.nRefundDetailPingTaiResultViewHeight = 0;
            
            self.nRefundDetailSellerResultView.hidden = NO;
            self.nRefundDetailSellerResultViewHeight = [YunDianNewRefundDetailSellerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            
            self.nRefundDetailBugerResultView.hidden = NO;
            self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            [self refrenshFrame];
        }
            break;
        case 4://（商家同意退款)
        {
            if ([self.refundModel.autoRefund integerValue] == 1) {
                //商家未发货 系统自动u退款
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = YES;
                self.nRefundDetailPingTaiResultViewHeight = 0;
                
                self.nRefundDetailSellerResultView.hidden = YES;
                self.nRefundDetailSellerResultViewHeight = 0;
                
                self.nRefundDetailBugerResultView.hidden = YES;
                self.nRefundDetailBugerResultViewHeight = 0;
            } else {
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = YES;
                self.nRefundDetailPingTaiResultViewHeight = 0;
                
                self.nRefundDetailSellerResultView.hidden = YES;
                self.nRefundDetailSellerResultViewHeight = 0;
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            }
            [self refrenshFrame];
        }
            break;
        case 5://(退款待仲裁）
        {
            
            if ([self.refundModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
                //微店
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = YES;
                self.nRefundDetailPingTaiResultViewHeight = 0;
                
                self.nRefundDetailSellerResultView.hidden = YES;
                self.nRefundDetailSellerResultViewHeight = 0;
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            } else {
                
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = YES;
                self.nRefundDetailPingTaiResultViewHeight = 0;
                
                self.nRefundDetailSellerResultView.hidden = NO;
                self.nRefundDetailSellerResultViewHeight = [YunDianNewRefundDetailSellerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            }
            [self refrenshFrame];
            
        }
            break;
        case 6://（仲裁拒绝退款）
        {
            
            if ([self.refundModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
                //微店
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = NO;
                self.nRefundDetailPingTaiResultViewHeight = [YunDianNewRefundDetailPingTaiResultView yunDianNewRefundDetailPingTaiResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailSellerResultView.hidden = YES;
                self.nRefundDetailSellerResultViewHeight = 0;
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            } else {
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = NO;
                self.nRefundDetailPingTaiResultViewHeight = [YunDianNewRefundDetailPingTaiResultView yunDianNewRefundDetailPingTaiResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailSellerResultView.hidden = NO;
                self.nRefundDetailSellerResultViewHeight = [YunDianNewRefundDetailSellerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            }
            [self refrenshFrame];
        }
            break;
        case 7://（仲裁同意退款)
        {
            if ([self.refundModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
                //微店
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = YES;
                self.nRefundDetailPingTaiResultViewHeight = 0;
                
                self.nRefundDetailSellerResultView.hidden = YES;
                self.nRefundDetailSellerResultViewHeight = 0;
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            } else {
                self.nRefundDetailResultViewHeight = 45;
                self.nRefundDetailResultView.hidden = NO;
                
                self.nRefundDetailPingTaiResultView.hidden = NO;
                self.nRefundDetailPingTaiResultViewHeight = [YunDianNewRefundDetailPingTaiResultView yunDianNewRefundDetailPingTaiResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailSellerResultView.hidden = NO;
                self.nRefundDetailSellerResultViewHeight = [YunDianNewRefundDetailSellerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
                
                self.nRefundDetailBugerResultView.hidden = NO;
                self.nRefundDetailBugerResultViewHeight = [YunDianNewRefundDetailBugerResultView yunDianNewRefundDetailSellerResultViewReturnHeight:self.refundModel];
            }
            [self refrenshFrame];
        }
            break;
            
        default:
            break;
    }
    
    
    
}
- (YunDianNewRefundDetailStateView *)nRefundDetailStateView{
    if (!_nRefundDetailStateView) {
        _nRefundDetailStateView = [[YunDianNewRefundDetailStateView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.nRefundDetailStateViewHeight)];
    }
    return _nRefundDetailStateView;
}
- (YunDianNewRefundDetailResultView *)nRefundDetailResultView{
    if (!_nRefundDetailResultView) {
        _nRefundDetailResultView = [[YunDianNewRefundDetailResultView alloc] initWithFrame:CGRectMake(0, MaxY(_nRefundDetailStateView), ScreenW, self.nRefundDetailResultViewHeight)];
    }
    return _nRefundDetailResultView;
}
- (YunDianNewRefundDetailPingTaiResultView *)nRefundDetailPingTaiResultView{
    if (!_nRefundDetailPingTaiResultView) {
        _nRefundDetailPingTaiResultView = [[YunDianNewRefundDetailPingTaiResultView alloc] initWithFrame:CGRectMake(0, MaxY(_nRefundDetailResultView), ScreenW, self.nRefundDetailPingTaiResultViewHeight)];
    }
    return _nRefundDetailPingTaiResultView;
}
- (YunDianNewRefundDetailSellerResultView *)nRefundDetailSellerResultView{
    if (!_nRefundDetailSellerResultView) {
        _nRefundDetailSellerResultView = [[YunDianNewRefundDetailSellerResultView alloc] initWithFrame:CGRectMake(0, MaxY(_nRefundDetailPingTaiResultView), ScreenW, self.nRefundDetailSellerResultViewHeight)];
        _nRefundDetailSellerResultView.delegate = self;
    }
    return _nRefundDetailSellerResultView;
}
- (YunDianNewRefundDetailBugerResultView *)nRefundDetailBugerResultView{
    if (!_nRefundDetailBugerResultView) {
        _nRefundDetailBugerResultView = [[YunDianNewRefundDetailBugerResultView alloc] initWithFrame:CGRectMake(0, MaxY(_nRefundDetailSellerResultView), ScreenW, self.nRefundDetailBugerResultViewHeight)];
        _nRefundDetailBugerResultView.delegate = self;
    }
    return _nRefundDetailBugerResultView;
}
- (YunDianNewRefundProductView *)nRefundProductView{
    if (!_nRefundProductView) {
        _nRefundProductView = [[YunDianNewRefundProductView alloc] initWithFrame:CGRectMake(0, MaxY(_nRefundDetailBugerResultView), ScreenW, self.nRefundProductViewHeight)];
    }
    return _nRefundProductView;
}
#pragma mark - 刷新ui Frame
- (void)refrenshFrame{
  

    self.scrollView.contentSize = CGSizeMake(ScreenW, self.nRefundDetailStateViewHeight + self.nRefundDetailResultViewHeight + self.nRefundDetailPingTaiResultViewHeight + self.nRefundDetailSellerResultViewHeight + self.nRefundDetailBugerResultViewHeight + self.nRefundProductViewHeight);
    
    _nRefundDetailStateView.frame = CGRectMake(0, 0, ScreenW, self.nRefundDetailStateViewHeight);
    _nRefundDetailResultView.frame = CGRectMake(0, MaxY(_nRefundDetailStateView), ScreenW, self.nRefundDetailResultViewHeight);
    _nRefundDetailPingTaiResultView.frame = CGRectMake(0, MaxY(_nRefundDetailResultView), ScreenW, self.nRefundDetailPingTaiResultViewHeight);
    _nRefundDetailSellerResultView.frame = CGRectMake(0, MaxY(_nRefundDetailPingTaiResultView), ScreenW, self.nRefundDetailSellerResultViewHeight);
    _nRefundDetailBugerResultView.frame = CGRectMake(0, MaxY(_nRefundDetailSellerResultView), ScreenW, self.nRefundDetailBugerResultViewHeight);
    _nRefundProductView.frame = CGRectMake(0, MaxY(_nRefundDetailBugerResultView), ScreenW, self.nRefundProductViewHeight);
    
}
@end
