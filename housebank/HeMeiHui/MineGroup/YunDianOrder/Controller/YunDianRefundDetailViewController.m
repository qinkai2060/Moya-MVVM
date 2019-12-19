
//
//  YunDianRefundDetailViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianRefundDetailViewController.h"
#import "YunDianOrderRefundProductView.h"
#import "WRNavigationBar.h"
#import "YunDianRefundDetailReasonView.h"
#import "ChatUtil.h"
#import "YunDianRefundDetailModel.h"
#import "YunDianDetailBottomView.h"
#import "CustomPasswordAlter.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
@interface YunDianRefundDetailViewController ()<YunDianDetailBottomViewDelegate, YunDianRefundDetailReasonViewDelegate>
@property (nonatomic, strong) YunDianOrderRefundProductView *refundProductView;//商品试图
@property (nonatomic, strong) YunDianRefundDetailReasonView *reasonView;//退款理由 图片试图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YunDianRefundDetailModel *refundModel;
@property (nonatomic, strong) YunDianDetailBottomView *bottomView;//操作按钮view
@property (nonatomic, strong) NSMutableArray *imgArr;//退款图片
@end

@implementation YunDianRefundDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    
}

- (YunDianDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YunDianDetailBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50, ScreenW, 50)];
        _bottomView.delegate = self;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

/**
 操作按钮点击放大

 @param ClickType 类型
 */
- (void)yunDianDetailBottomViewBtnClickType:(YunDianDetailBottomViewClickType)ClickType{
    switch (ClickType) {
        case YunDianDetailBottomViewClickTypeDonotAgreen:
        {
            //拒绝退款
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"您确定拒绝退款吗?" suret:@"是" closet:@"否" sureblock:^{
                [self requestSureOrNoSureRefund:@(3)];
            } closeblock:^{
                
            }];
        }
            break;
        case YunDianDetailBottomViewClickTypeAgreen:
        {
            //退款
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"您确定同意退款吗?" suret:@"是" closet:@"否" sureblock:^{
                [self requestSureOrNoSureRefund:@(2)];

            } closeblock:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}
//退款图片点击
- (void)yunDianRefundDetailReasonViewDelegateClickImgIndex:(NSInteger)index{
 
    if (self.imgArr.count > index) {
       NSMutableArray * selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < self.imgArr.count; i++) {
            [selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:self.imgArr[i]]];
        }
        
        if (selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = selectImageTap;
            pictureVC.picUrlArray = self.imgArr;
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

/**
 同意 或者拒绝退款

 @param state 3=拒绝，2=同意
 */
- (void)requestSureOrNoSureRefund:(NSNumber *)state{
    [SVProgressHUD show];
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSDictionary *dic1 = @{
                        @"orderProductId":self.refundModel.orderProductId ?: @"",
                           @"orderNo":self.refundModel.orderNo ?: @"",
                           @"state":state,
                           @"orderReturnId":self.refundModel.orderReturnId ?: @""
                           };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/retail/order/confirm-refund"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if ([state isEqual:@(3)]) {
                [self showSVProgressHUDSuccessWithStatus:@"已拒绝退款!"];
            } else {
                [self showSVProgressHUDSuccessWithStatus:@"退款成功!"];
            }
            [self.scrollView.mj_header beginRefreshing];
         
            
        } else {
            NSLog(@"%@", [dic objectForKey:@"msg"]);
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];

        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款详情";
    
    [self setUI];
    [self.scrollView.mj_header beginRefreshing];
    
}

/**
 退款详情接口
 */
- (void)requestReturnDetails{
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSDictionary *dic1 = @{
                           @"orderReturnId":self.orderReturnId ?: @"",
                           @"orderNo":self.orderNo ?: @""
                           };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/view-return-details"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl, sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.scrollView.mj_header endRefreshing];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSDictionary_Class([[dic objectForKey:@"data"] objectForKey:@"orderReturnDetails"])) {
                self.refundModel = [YunDianRefundDetailModel modelWithJSON:[[dic objectForKey:@"data"] objectForKey:@"orderReturnDetails"]];
                
                self.imgArr = [NSMutableArray array];
                
                
                if (Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"imgList"])) {
                    NSArray *arr  = [NSArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"imgList"]];
                    
                    for (NSDictionary *dicUrl in arr) {

                        [self.imgArr addObject:[[NSString stringWithFormat:@"%@",[dicUrl objectForKey:@"imgUrl"]] get_Image_String]];
                    }
                }
                
                
                
                [self refrensh];
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
- (void)refrensh{
    [self refreshUI:self.imgArr];
    self.refundProductView.refundDetailModel = self.refundModel;
    self.reasonView.refundDetailModel = self.refundModel;
    self.reasonView.arrImg = self.imgArr;
}
- (void)refreshUI:(NSArray *)arr{
    
    if ([self.refundModel.returnState integerValue] == 1) {
        //退款中
        //微店没有   oto不是快递的没有
        
        if ([self.shopsType isEqual:@(1)]) {
            
            self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50);
            [self.bottomView showRefundBtn];
            
        } else if ([self.shopsType isEqual:@(2)]){
            
            if ([self.distribution isEqual:@(0)]) {
                
                self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
                self.bottomView.hidden = YES;
                
            } else if ([self.distribution isEqual:@(1)]) {
                //查看物流
                self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50);
                [self.bottomView showRefundBtn];
                
            } else if ([self.distribution isEqual:@(2)]) {
                //闪送
                self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
                self.bottomView.hidden = YES;
                
            } else if ([self.distribution isEqual:@(3)]) {
                
                self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
                self.bottomView.hidden = YES;
                
            } else {
                
                self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50);
                [self.bottomView showRefundBtn];
                
            }
        } else {
            
            self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
            self.bottomView.hidden = YES;
        }
        
        
    } else {
        self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
        self.bottomView.hidden = YES;
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenW, [self calHeightArrCount:arr.count text:self.refundModel.remark] + 340);
    self.reasonView.frame = CGRectMake(0, 340, ScreenW, [self calHeightArrCount:arr.count text:self.refundModel.remark]);

}

- (void)setUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestReturnDetails];
    }];
    [self.scrollView addSubview:self.refundProductView];
    [self.scrollView addSubview:self.reasonView];
}
//计算高度 通过 退款理由 及其图片个数
- (CGFloat )calHeightArrCount:(NSInteger)count text:(NSString *)text{
    if (count != 0) {
        CGFloat btnH = (ScreenW - 60) / 3;
        NSInteger row = count / 3;
        CGFloat btnY = 15 + (btnH + 15) * row;
        CGFloat btnViewH = btnY + btnH + 15;
        CGFloat labelH = [ChatUtil getHeightWithFontSize:12 width:ScreenW - 30 text:text];
        CGFloat height = 40 + labelH + btnViewH;
        return height;

    } else {
        CGFloat labelH = [ChatUtil getHeightWithFontSize:12 width:ScreenW - 30 text:text];

        return 40 + labelH + 15;
    }
  
}
- (YunDianOrderRefundProductView *)refundProductView{
    if (!_refundProductView) {
        _refundProductView = [[YunDianOrderRefundProductView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 330)];
    }
    return _refundProductView;
}
- (YunDianRefundDetailReasonView *)reasonView{
    if (!_reasonView) {
        _reasonView  = [[YunDianRefundDetailReasonView alloc] initWithFrame:CGRectMake(0, 340, ScreenW, 50)];
        _reasonView.delegate = self;
    }
    return _reasonView;
}
@end
