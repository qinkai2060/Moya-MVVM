//
//  SpGoodsDetailViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpGoodsDetailViewController.h"
#import "WRNavigationBar.h"
#import "UIView+addGradientLayer.h"
#import "FeatureViewController.h"
#import "HMHVideoListModel.h"
#import "ConsultationViewController.h"
#import "ParametersViewController.h"
#import "GetCommentListModel.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
#import "JPUSHService.h"
#import "GSKeyChainDataManager.h"
#import "CustomInputMoneyView.h"
#import "CutomVipShareView.h"
#import "SpProductReviewCell.h"
/** 轮播器高度 */
#define CycleSV_HEIGHT YQP(ScreenW-KTopHeight)
@interface SpGoodsDetailViewController ()<UIScrollViewDelegate,ShareToolDelegete,FeatureViewDelegate,SpGoodBaseViewDelegate>
/** 自定义导航条子视图 */
@property (strong, nonatomic) UIView *bgView;
/** 记录界面切换前的偏移量 */
@property (assign, nonatomic) CGFloat particularsOffsetY;
/** 记录上一次选中的Button */
@property (nonatomic , weak) UIButton *selectBtn;
/** 标题按钮地下的指示器 */
@property (weak ,nonatomic) UIView *indicatorView;
/** 分享按钮 */
@property (strong ,nonatomic) UIButton *shareBtn;
/** 底部视图 */
@property (strong ,nonatomic) UIView *footView;
/** 购物车计数 */
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UIView *blackView;
@property (nonatomic, strong)FeatureViewController *featureVC;

@property (nonatomic, strong) ShareTools *shareTool;
@property (nonatomic, strong) HMHVideoListModel *HMH_videoModel;
//直供精品的activeCode = 5  1元拼团的 activeCode = 1   促销和普通商品为activeCode = 0  6秒杀商品
@property (nonatomic, strong) NSString * active;


@end

@implementation SpGoodsDetailViewController
- (instancetype)initWithModel:(GetProductListByConditionModel*)model {
    if (self = [super init]) {
        self.listModel = model;
        self.productId = model.productId;
    }
    return self;
}
#pragma mark - LazyLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.productId = @"37";
    [self setUpInit];
    [self setUpTopButtonView];
    //    self.scrollerView.contentSize = CGSizeMake(self.view.dc_width * 3, 0);
    if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == NO) {
        self.active=@"5";//直供精品
    }else
    {
        self.active=@"0";//促销和普通商品
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self acceptanceNote];
    self.customNavBar.hidden=NO;
    /** 指定边缘要延伸的方向 */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /** 自动滚动调整，默认为YES */
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    //    if (_selectBtn) {
    //        [self topBottonClick:_selectBtn];
    //    }
    if (self.isJudgeLogin) {
        if ( [_countLabel.text isEqualToString:@""]||[_countLabel.text isEqualToString:@"0"]) {
            _countLabel.hidden=YES;
        }else
        {
            _countLabel.hidden=NO;
        }
    }else
    {
        _countLabel.hidden=YES;
    }
    [self  getinitData];
    //  从屏幕边缘计算（默认）
    //  self.edgesForExtendedLayout =UIRectEdgeAll;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.customNavBar.hidden=YES;
    [self setNavBgColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
//倒计时结束重新刷新页面
-(void)reloadViewAndData
{
    [self  getinitData];
}
//自定义导航条始终放在最上层
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.customNavBar];
}
- (void)setUpInit
{
    WEAKSELF
    self.customNavBar.hidden=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.scrollerView.backgroundColor = [UIColor whiteColor];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon2"]];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward3"]];
    //    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.onClickLeftButton=^(void) {
        if (weakSelf.selectBtn.tag!=0) {
            UIButton *firstButton = weakSelf.bgView.subviews[0];
            [weakSelf topBottonClick:firstButton]; //默认选择第一个
        }else
        {
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    self.customNavBar.onClickRightButton=^(void) {
        [weakSelf  topShareBtnClick];
    };
    self.customNavBar.titleLabelColor = [UIColor blackColor];
    
}
//初始化详情数据
-(void)getinitData
{
    [SVProgressHUD show];
    WEAKSELF
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./goods/getProductDetail"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"productId":self.productId,@"sid":[HFCarShoppingRequest sid],@"active":self.active} success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         
         if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
         {
             
             NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
             if ([dict[@"state"] intValue] !=1) {
                 [SVProgressHUD dismiss];
                 [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                 [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                 [SVProgressHUD dismissWithDelay:1.0];
                 return ;
             }
//             self.detailModel=[[GoodsDetailModel alloc]initWithDictionary:dict error:nil];
             self.detailModel = [GoodsDetailModel modelWithJSON:dict];
             self.spacEndDateTime=self.detailModel.data.product.endDate;
             self.spaceStartTime=self.detailModel.data.product.startDate;
             //  设置倒计时时间
             NSString *nowTime=[MyUtil getNowTimeTimestamp3];
             //self.spaceTime=@"500";
             //self.spaceTime=[MyUtil compareTwoTime:@"15000" time2:nowTime];
             self.spaceTime=[MyUtil compareTwoTime:self.spacEndDateTime time2:nowTime];
             self.starSpaceTime=[MyUtil compareTwoTime:self.spaceStartTime time2:nowTime];
             if ( self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
                 self.goodsType=SpikeGoodsDetailStyle;
             }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
             {
                 self.goodsType=SpikeGoodsDetailStyle;
             }else
             {
                 if (self.detailModel.data.product.endDate) {//结束日期有值
                     
                     if ( [self.spaceTime intValue]>0) {
                         self.goodsType=PromotionGoodsDetailStyle;
                     }else
                     {
                         if (self.goodsType==DirectSupplyGoodsDetailStyle) {
                             self.goodsType=DirectSupplyGoodsDetailStyle;
                         }else
                         {
                             if (self.detailModel.data.product.isWholesaleProduct == 1 && self.detailModel.data.product.commodityType == 6) {
                                 self.goodsType=VipWholesaleGoodsDetailStyle;
                             } else {
                                 self.goodsType=OrdinaryGoodsDetailStyle;
                                 
                             }
                         }
                     }
                     
                 }else
                 {
                     if (self.goodsType==DirectSupplyGoodsDetailStyle) {
                         self.goodsType=DirectSupplyGoodsDetailStyle;
                        
                     }else
                     {
                         if (self.detailModel.data.product.isWholesaleProduct == 1 && self.detailModel.data.product.commodityType == 6) {
                             self.goodsType=VipWholesaleGoodsDetailStyle;
                         } else {
                             self.goodsType=OrdinaryGoodsDetailStyle;
                             
                         }
                     }
                     
                 }
             }
             
             if (self.detailModel.data.product.commodityType == 7) {
                 self.goodsType = DirectSupplyGoodsDetailStyle;
                 self.isVipGiftPackage = YES;
             }

             
             //           评论
            NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./comment/getCommentList"];
             [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"productId":self.productId,@"pageNum":@"1",@"pageSize":@"8",@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
              {
                  
                  if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
                  {
                      
                      NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                      if ([dict[@"state"] intValue] !=1) {
                          [SVProgressHUD dismiss];
                          [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                          [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                          [SVProgressHUD dismissWithDelay:1.0];
                          return ;
                      }
//                      self.commentList=[[CommentListModel alloc]initWithDictionary:dict error:nil];
                      self.commentList = [CommentListModel modelWithJSON:dict];
                      //                    规格
                        NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./goods/getProductTypeDetailHM"]; 
                      [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"productId":self.productId,@"agentDetailId":@"0",@"active":self.active,@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
                       {
                           [SVProgressHUD dismiss];
                           if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
                           {
                               NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                               if ([dict[@"state"] intValue] !=1) {
                                   [SVProgressHUD dismiss];
                                   [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                                   [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                                   [SVProgressHUD dismissWithDelay:1.0];
                                   return ;
                               }
//                               self.featureModel=[[ProductFeatureModel alloc]initWithDictionary:dict error:nil];
                               self.featureModel = [ProductFeatureModel modelWithJSON:dict];
                               // self.featureModel.data.rsMap.descartesCombinationMap//规格信息
                               // self.featureModel.data.rsMap.descartesCombinationMap.SKU//规格数list
                               // self.featureModel.data.rsMap.productTtributesMap//规格属性
                               // self.featureModel.data.rsMap.productTtributesMap.seriesAttributes//规格属性list
                               if ( weakSelf.footView) {
                                   [weakSelf.footView removeFromSuperview];
                               }
                               
                               if (weakSelf.goodBaseVc) {
                                   [weakSelf.goodBaseVc.view removeFromSuperview];
                                   [weakSelf.goodBaseVc removeFromParentViewController];
                               }
                               self.code=@"";
                               [self setUpChildViewControllers];
                               [self setUpBottomButton];
                               [weakSelf.goodBaseVc.collectionView reloadData];
                               weakSelf.countLabel.text=[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.countShoppingCart];
                               
                               if ([weakSelf.countLabel.text isEqualToString:@""]||[weakSelf.countLabel.text isEqualToString:@"0"]) {
                                   weakSelf.countLabel.hidden=YES;
                               }else
                               {
                                   weakSelf.countLabel.hidden=NO;
                               }
                               
                               NSLog(@"%@",dict);
                               NSLog(@"%@",dict);
                           }
                       } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                           if (!request.cancelled) {
                               [SVProgressHUD dismiss];
                               [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
                               [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                               [SVProgressHUD dismissWithDelay:1.0];
                           }
                           
                           NSLog(@"❤️1️⃣");
                       }];
                      
                  }
              } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                  if (!request.cancelled) {
                      [SVProgressHUD dismiss];
                      [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
                      [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                      [SVProgressHUD dismissWithDelay:1.0];
                  }
                  
                  NSLog(@"❤️1️⃣");
              }];
             
             NSLog(@"%@",dict);
         }
     } error:^(__kindof YTKBaseRequest * _Nonnull request) {
         if (!request.cancelled) {
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
         }
         
         NSLog(@"❤️1️⃣");
     }];
}

-(void)resetThirdNavBar:(CGFloat)offsetY
{
    self.particularsOffsetY=offsetY;
    /** 更改透明度 */
    if (offsetY > 0)
    {
        CGFloat alpha = offsetY/CycleSV_HEIGHT;
        _bgView.alpha=alpha;
        if (alpha>=0.5) {
            CGFloat alpha2 =(alpha-0.5)/0.5;;
            
            self.customNavBar.leftButton.alpha=alpha2/0.5;
            self.customNavBar.rightButton.alpha=alpha2/0.5;
            [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon"]];
            [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward2"]];
        }else
        {
            
            CGFloat alpha2=-(alpha-0.5)/0.5;
            self.customNavBar.leftButton.alpha=alpha2/0.5;
            self.customNavBar.rightButton.alpha=alpha2/0.5;
            [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon2"]];
            [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward3"]];
        }
        
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        [self.customNavBar wr_setTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon2"]];
        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward3"]];
        _bgView.alpha=0;
        [self.customNavBar wr_setBackgroundAlpha:0];
        [self.customNavBar wr_setTintColor:[UIColor whiteColor]];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
#pragma mark - 头部View
- (void)setUpTopButtonView
{
    //    self.shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    self.shareBtn.frame=CGRectMake(YQP(295), [self navBarBottom], YQP(44), 44);
    //    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"forward2"] forState:UIControlStateNormal];
    //    [self.shareBtn addTarget:self action:@selector(topShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.customNavBar addSubview:self.shareBtn];
    
    NSArray *titles = @[@"商品",@"评价",@"详情"];
    _bgView = [[UIView alloc] init];
    _bgView.frame=CGRectMake(YQP(113) , [self navBarBottom], YQP(150), 44);
    [self.customNavBar addSubview:_bgView];
    _bgView.alpha=0;
    
    CGFloat buttonW = YQP(50);
    CGFloat buttonH = 20;
    CGFloat buttonY = 11;
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = PFR14Font;
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = i * buttonW ;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [_bgView addSubview:button];
        
    }
    
    UIButton *firstButton = _bgView.subviews[0];
    [self topBottonClick:firstButton]; //默认选择第一个
    
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    indicatorView.dc_height = 2;
    indicatorView.dc_y = _bgView.dc_height - indicatorView.dc_height;
    
    [firstButton.titleLabel sizeToFit];
    indicatorView.dc_width = firstButton.titleLabel.dc_width;
    indicatorView.dc_centerX = firstButton.dc_centerX;
    
    [_bgView addSubview:indicatorView];
    
}

#pragma mark - 添加子控制器
-(void)setUpChildViewControllers
{
    WEAKSELF
    _goodBaseVc = [[SpGoodBaseViewController alloc] init];
    
    //滑动什么位置 选中什么按钮
    _goodBaseVc.offSetBlock = ^(OffSetStyle indexStyle) {
        switch (indexStyle) {
            case OffSetStyleGood://商品
            {
                UIButton *firstButton = (UIButton *)weakSelf.bgView.subviews[0];
                [weakSelf changeNavigationBtnSelect:firstButton];
            }
                
                break;
            case OffSetStyleComment://评价
            {
                UIButton *firstButton = (UIButton *)weakSelf.bgView.subviews[1];
                [weakSelf changeNavigationBtnSelect:firstButton];
            }
                break;
            case OffSetStyledDetail://详情
            {
                UIButton *firstButton = (UIButton *)weakSelf.bgView.subviews[2];
                [weakSelf changeNavigationBtnSelect:firstButton];
            }
                break;
                
            default:
                break;
        }
    };
    _goodBaseVc.isVipGiftPackage = self.isVipGiftPackage;
    _goodBaseVc.spaceTime=self.spaceTime;
    _goodBaseVc.starSpaceTime=self.starSpaceTime;
    _goodBaseVc.Delegate=self;
    _goodBaseVc.listModel=self.listModel;
    _goodBaseVc.detailModel=self.detailModel;
    _goodBaseVc.commentList=self.commentList;
    _goodBaseVc.featureModel=self.featureModel;
    //    _goodBaseVc.code=self.detailModel.data.product.code;
    _goodBaseVc.goodTitle = _goodTitle;
    _goodBaseVc.goodPrice = _goodPrice;
    _goodBaseVc.goodSubtitle = _goodSubtitle;
    _goodBaseVc.shufflingArray = _shufflingArray;
    _goodBaseVc.goodImageView = _goodImageView;
    if ( self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
        _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
    }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
    {
        _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
    }else
    {
        if (self.goodsType==PromotionGoodsDetailStyle) {
            _goodBaseVc.goodsBaseStyle=PromotionGoodsBaseDetailStyle;
        } else if (self.goodsType==DirectSupplyGoodsDetailStyle){
            _goodBaseVc.goodsBaseStyle=DirectSupplyGoodsDetailStyle;
        }
    }
    
    _goodBaseVc.spaceTime=self.spaceTime;
    _goodBaseVc.starSpaceTime=self.starSpaceTime;
    _goodBaseVc.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - TabBarHeight);
    [self.view addSubview:_goodBaseVc.view];
    
    
}
#pragma mark - 底部按钮(收藏 购物车 加入购物车 立即购买)
- (void)setUpBottomButton
{
    self.footView=[[UIView alloc]init];
    self.footView.frame=CGRectMake(0, ScreenH-TabBarHeight, ScreenW, TabBarHeight);
    self.footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.footView];
    [self setUpLeftTwoButton];//店铺 收藏 购物车
    [self setUpRightTwoButton];//加入购物车 立即购买
}

#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor=@[];
    NSArray *imagesSel=@[];
    NSArray *nameArray=@[];
    if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == NO) {//直供精品
        imagesNor = @[];
        imagesSel = @[];
        nameArray = @[];
    }else if ((self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == YES) || self.goodsType == VipWholesaleGoodsDetailStyle) {//直供精品
        imagesNor = @[@"shop_light",@"like"];
        imagesSel = @[@"shop_light",@"like_fill"];
        nameArray = @[@"店铺",@"收藏"];
    }else
    {//普通商品
        imagesNor = @[@"shop_light",@"like",@"cart_light"];
        imagesSel = @[@"shop_light",@"like_fill",@"cart_light"];
        nameArray = @[@"店铺",@"收藏",@"购物车"];
    }
    
    CGFloat buttonW = 39;CGFloat buttonH = 39;CGFloat buttonY = 6;CGFloat nameLableY = 31;
    CGFloat edgeSpace =15; CGFloat btnSpace= (11*ScreenW/25-2*edgeSpace-3*buttonW)/2;
    CGFloat lableW = 35;CGFloat lableH = 14;
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i+100;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = edgeSpace+(buttonW+btnSpace)*i;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (button.tag==101) {
            [button setTitle:[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"已收藏"] forState:UIControlStateSelected];
            [button setTitleColor:HEXCOLOR(0x494949) forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0xF3344A) forState:UIControlStateSelected];
            
        }else
        {
            [button setTitle:[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x494949) forState:UIControlStateNormal];
        }
        //        button.backgroundColor=[UIColor grayColor];
        if (button.tag==101) {
            if (self.detailModel.data.product.isAttention==0) {
                button.selected=YES;
            }else
            {
                button.selected=NO;
            }
        }
        CGFloat offset = 5.0f;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height-offset/2, 0);
        // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
        // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -button.titleLabel.intrinsicContentSize.width);
        [self.footView addSubview:button];
        
        //        UILabel *nameLable = [[UILabel alloc] init];
        //        nameLable.center=CGPointMake(button.centerX, nameLableY+lableH/2);
        //        nameLable.bounds=CGRectMake(0, 0, lableW, lableH);
        //        nameLable.textAlignment = NSTextAlignmentCenter;
        //        nameLable.font = [UIFont systemFontOfSize:10];
        //        nameLable.text=[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]];
        //        [self.footView addSubview:nameLable];
        if (i==2) {
            //        添加购物车计数
            _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, 15, 15)];
            _countLabel.backgroundColor = [UIColor redColor];
            _countLabel.textAlignment = NSTextAlignmentCenter;
            _countLabel.textColor = [UIColor whiteColor];
            _countLabel.layer.cornerRadius = 8;
            _countLabel.font = [UIFont systemFontOfSize:10];
            _countLabel.layer.masksToBounds = YES;
            _countLabel.text=@"";
            [button addSubview:_countLabel];
            if (!self.isJudgeLogin) {
                _countLabel.hidden=YES;
            }else
            {
                if ([_countLabel.text isEqualToString:@""]||[_countLabel.text isEqualToString:@"0"]) {
                    _countLabel.hidden=YES;
                }else
                {
                    _countLabel.hidden=NO;
                }
                
            }
            
        }
    }
}
#pragma mark - 加入购物车 立即购买
- (void)setUpRightTwoButton
{
    CGFloat buttonW1 = 39;
    CGFloat edgeSpace =15; CGFloat btnSpace= (11*ScreenW/25-2*edgeSpace-3*buttonW1)/2;
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonW = 7*ScreenW/25;
    if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == NO) {//直供精品
        titles= @[@"立即购买"];
        buttonW=ScreenW;
    }else if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == YES) {//直供精品
        titles= @[@"立即购买"];
        buttonW=7*ScreenW/25*2 +buttonW1+btnSpace;
    } else if (self.goodsType==VipWholesaleGoodsDetailStyle) {//vip批发
        titles= @[@"分享推广",@"立即购买"];
        buttonW=(7*ScreenW/25*2 +buttonW1+btnSpace) / 2;
    }else
    {//普通商品
        if(self.detailModel.data.seckillInfo.isSeckill==1&&self.detailModel.data.seckillInfo.purchasedQuantity>=self.detailModel.data.seckillInfo.stock) {//售罄
            titles= @[@"已售罄"];
            buttonW=7*ScreenW/25*2;
        }else
        {
            titles = @[@"加入购物车",@"立即购买"];
            buttonW = 7*ScreenW/25;
        }
        
    }
    
    CGFloat buttonH = 50;
    CGFloat buttonY = 0;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonX =11*ScreenW/25 + (buttonW * i);
        if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == NO) {//直供精品
            buttonX =0;
        }else if (self.goodsType==DirectSupplyGoodsDetailStyle && self.isVipGiftPackage == YES){
            buttonX =11*ScreenW/25 + (buttonW * i)-buttonW1-btnSpace;
            
        } else if (self.goodsType==VipWholesaleGoodsDetailStyle) {//vip批发
            buttonX =11*ScreenW/25 + (buttonW * i)-buttonW1-btnSpace;
        }else
        {//普通商品
            buttonX =11*ScreenW/25 + (buttonW * i);
        }
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        if (i==0) {
            if (self.goodsType==DirectSupplyGoodsDetailStyle) {//直供精品
                //       设置渐变背景色
                [button addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
            }else
            {//普通商品
                if(self.detailModel.data.seckillInfo.isSeckill==1&&self.detailModel.data.seckillInfo.purchasedQuantity>=self.detailModel.data.seckillInfo.stock) {//售罄
                    button.backgroundColor =HEXCOLOR(0x404040);
                }else
                {
                    button.backgroundColor =HEXCOLOR(0x404040);
                }
                
            }
            
        }else
        {
            //       设置渐变背景色
            [button addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        }
        if (self.goodsType==DirectSupplyGoodsDetailStyle) {//直供精品
            button.tag = i + 201;
        } else if (self.goodsType==VipWholesaleGoodsDetailStyle) {//vip推广
            button.tag = i + 300;
        }else
        {//普通商品
            button.tag = i + 200;
        }
        
        button.titleLabel.font = PFR16Font;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if(self.detailModel.data.seckillInfo.isSeckill==1&&self.detailModel.data.seckillInfo.purchasedQuantity>=self.detailModel.data.seckillInfo.stock) {//售罄
            [button setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5] forState:UIControlStateNormal];
            
        }else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:button];
    }
}
#pragma mark - 点击事件
#pragma mark - 头部按钮点击
- (void)topBottonClick:(UIButton *)button
{
    
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    if (button.tag ==0) {
        //        不做处理，原本什么样就什么样
        [self resetThirdNavBar:self.particularsOffsetY];
    }
    
    button.selected = !button.selected;
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    switch (button.tag) {
        case 0:
        {
            
            [_goodBaseVc.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
            break;
        case 1:
        {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            UICollectionViewCell * item = [_goodBaseVc.collectionView cellForItemAtIndexPath:indexPath];
            CGRect cellInCollection = [_goodBaseVc.collectionView convertRect:item.frame toView:_goodBaseVc.collectionView];
            if (cellInCollection.origin.y == 0) {//获取不到准确的位置
                
                [_goodBaseVc.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionTop) animated:NO];
                if (_goodBaseVc.lastcontentOffset > 0) {
                    [_goodBaseVc.collectionView setContentOffset:CGPointMake(0, _goodBaseVc.lastcontentOffset - IPHONEX_SAFE_AREA_TOP_HEIGHT_88) animated:YES];
                    
                }
            } else {
                [_goodBaseVc.collectionView setContentOffset:CGPointMake(0, cellInCollection.origin.y - IPHONEX_SAFE_AREA_TOP_HEIGHT_88) animated:YES];
            }
        }
            break;
        case 2:
        {
            
            CGFloat y =  [self collectionViewContentSizeHeight] - _goodBaseVc.wkwebviewHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_88;
            [_goodBaseVc.collectionView setContentOffset:CGPointMake(0, y) animated:_goodBaseVc.isFirstRefrenshWeb];
        }
            break;
            
        default:
            break;
    }
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
}

- (void)changeNavigationBtnSelect:(UIButton *)button {
    if (button == _selectBtn) {
        return;
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
    
}
- (CGFloat)collectionViewContentSizeHeight{
    return _goodBaseVc.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
}
#pragma mark ]按钮点击
- (void)topShareBtnClick
{
    if (!self.isLogin) {
        return;
    }
    if (self.goodsType == VipWholesaleGoodsDetailStyle) {
        [CustomInputMoneyView CustomInputMoneyViewIn:[UIApplication sharedApplication].keyWindow sureblock:^(float money) {
            [CutomVipShareView CutomVipShareViewIn:[UIApplication sharedApplication].keyWindow addMoney:money goodsDetailModel:self.detailModel wxblock:^{
                
            } pyqblock:^{
                
            } closeblock:^{
                
            }];
        } closeblock:^{
            
        }];
        return;
    }
    
    
    NSString *url=@"";
    if (self.detailModel.data.product.commodityType == 7) {//vip礼包
        url=[NSString stringWithFormat:@"%@%@&shareId=%@&active=%@", fyMainHomeUrl,self.detailModel.data.productShart,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"11"];
    }else
    {
        url=[NSString stringWithFormat:@"%@%@&shareId=%@&active=%@", fyMainHomeUrl,self.detailModel.data.productShart,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],self.active];
    }
    if (self.detailModel.data.product.productId <= 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请耐心等待详情页加载!"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *dicJson = [@{@"productId":@(self.detailModel.data.product.productId),
                                      @"shareId":[HFUserDataTools getUserUidStr]} mutableCopy];
    switch (self.goodsType) {
            
        case OrdinaryGoodsDetailStyle:            //普通商品
            [dicJson setObject:@(0) forKey:@"active"];
            
            break;
        case DirectSupplyGoodsDetailStyle:            //直供精品 VIP礼包(需判断isVipGiftPackage)
            if (_isVipGiftPackage) {
                [dicJson setObject:@(0) forKey:@"active"];
                
            } else {
                [dicJson setObject:@(5) forKey:@"active"];
                
            }
            
            break;
        case PromotionGoodsDetailStyle:            //促销商品
            
            [dicJson setObject:@(0) forKey:@"active"];
            
            break;
        case SpikeGoodsDetailStyle:            //秒杀商品
            [dicJson setObject:@(6) forKey:@"active"];
            
            
            break;
        case AssembleGoodsDetailStyle:            //拼团商品
            
            [dicJson setObject:@(0) forKey:@"active"];
            
            break;
        case VipWholesaleGoodsDetailStyle:            //Vip批发商品
            
            [dicJson setObject:@(7) forKey:@"active"];
            
            break;
            
        default:
            break;
    }
    NSString *str = [dicJson jsonStringEncoded];
    NSDictionary *body = @{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag": @"fy_mall_goods_detail",@"extras":str.length == 0 ? @"":str};
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:body success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[request.responseObject valueForKey:@"data"]];
            [dic setObject:self.detailModel.data.product.title ?: @"" forKey:@"shareTitle"];
            [dic setObject:self.detailModel.data.product.productSubtitle ?: @"" forKey:@"shareDesc"];
            
            NSString * imgUrl = @"";
            if (self.detailModel.data.product.productPics.count>0) {
                ProductPicsItem *PicsItem= [self.detailModel.data.product.productPics objectAtIndex:0];
                if (PicsItem.address.length > 0) {
                    imgUrl = PicsItem.address;
                }
            }
            [dic setObject:imgUrl forKey:@"shareImageUrl"];
            
            [ShareTools goodDetailShareWithContent:dic detailModel:self.detailModel];
            
        }else {
            
        }
        NSLog(@"");
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
    }];
    

//    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
//    if (getUrlStr) {
//        getUrlStr = getUrlStr;
//    }
//    [HFCarRequest requsetUrl:@"getUrlStr" withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_vip_goods_home"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
//        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
//            [subscriber sendNext:[request.responseObject valueForKey:@"data"]];
//            [subscriber sendCompleted];
//        }else {
//            [subscriber sendNext:@(2)];
//            [subscriber sendCompleted];
//        }
//        NSLog(@"");
//    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [subscriber sendNext:@(2)];
//        [subscriber sendCompleted];
//    }]
    
    //    [HFCarRequest requsetUrl:@"/webview/share" withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"fy_vip_goods_home"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
    //            [subscriber sendNext:[request.responseObject valueForKey:@"data"]];
    //            [subscriber sendCompleted];
    //        }else {
    //            [subscriber sendNext:@(2)];
    //            [subscriber sendCompleted];
    //        }
    //        NSLog(@"");
    //    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        [subscriber sendNext:@(2)];
    //        [subscriber sendCompleted];
    //    }]
    
    
    
    
    //    NSString *url=[NSString stringWithFormat:@"%@%@&shareId=%@&active=%@",fyMainHomeUrl,self.detailModel.data.productShart,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    //    [HFCarShoppingRequest requestURL:@"/url/short" baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"url":url,@"sid":[[NSUserDefaults standardUserDefaults] objectForKey:@"sid"],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
    //     {
    //
    //         if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
    //         {
    //
    //             NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
    //             if ([dict[@"state"] intValue] !=1) {
    //                 [SVProgressHUD dismiss];
    //                 [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
    //                 [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //                 [SVProgressHUD dismissWithDelay:1.0];
    //                 return ;
    //             }
    //             NSString *shortUri=[[dict objectForKey:@"data"] objectForKey:@"shortUri"];
    //             NSString *contents=[NSString stringWithFormat:@"%@/shorturl/%@",CurrentEnvironment,shortUri];
    //             [HFCarShoppingRequest requestURL:@"/user/mall/encodeCode/product/create" baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"contents":contents,@"path":@"/data/www/static/qr/offlineProduct",@"width":@"300",@"height":@"300",@"offlineShopId":[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.shopId],@"productId":self.productId,@"sid":[[NSUserDefaults standardUserDefaults] objectForKey:@"sid"],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
    //              {
    //
    //                  if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
    //
    //                  {
    //
    //                      NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
    //                      if ([dict[@"state"] intValue] !=1) {
    //                          if ([dict[@"state"] intValue] ==3) {//sid超时需登录
    //                              [self gotoLogin];
    //                          }else
    //                          {
    //                              [SVProgressHUD dismiss];
    //                              [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
    //                              [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //                              [SVProgressHUD dismissWithDelay:1.0];
    //                          }
    //                          return ;
    //                      }
    //                      NSString *qrUrl=[[dict objectForKey:@"data"] objectForKey:@"qr"];
    //                      NSMutableArray *picList=[NSMutableArray new];
    //                      if (self.detailModel.data.product.productPics.count>0) {
    //                          for (int i=0; i<self.detailModel.data.product.productPics.count; i++) {
    //                              ProductPicsItem *PicsItem= [self.detailModel.data.product.productPics objectAtIndex:i];
    //                              NSString *str=@"";
    //                              if (PicsItem.address.length > 0) {
    //                                  NSString *str3 = [PicsItem.address substringToIndex:1];
    //                                  if ([str3 isEqualToString:@"/"]) {
    //                                      ManagerTools *manageTools =  [ManagerTools ManagerTools];
    //                                      if (manageTools.appInfoModel) {
    //                                          str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,PicsItem.address,@"!PD750"];
    //                                          //                            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    //                                      }
    //                                  }else
    //                                  {
    //                                      str = [NSString stringWithFormat:@"%@%@",PicsItem.address,@"!PD750"];
    //                                  }
    //                              }
    //                              //                NSString *UrlDddress=[NSString stringWithFormat:@"%@%@",CurrentEnvironment,PicsItem.address];
    //                              [picList addObject:str];
    //                          }
    //                      }
    //                      NSString *productImg=@"";
    //                      if (picList.count>0) {
    //                          productImg =[picList objectAtIndex:0];
    //                      }
    //                      [HFCarShoppingRequest requestURL:@"/details/createProCode" baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"price":[NSString stringWithFormat:@"%.2f",self.detailModel.data.product.price],@"title":self.detailModel.data.product.title,@"Subtitle":self.detailModel.data.product.productSubtitle,@"cityName":[NSString stringWithFormat:@"%@ %@",self.detailModel.data.product.cityName,self.detailModel.data.product.regionName],@"sellCount":[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.initialNumber],@"qrUrl":qrUrl,@"productImg":productImg,@"sid":[[NSUserDefaults standardUserDefaults] objectForKey:@"sid"],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
    //                       {
    //                           [SVProgressHUD dismiss];
    //                           if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
    //
    //                           {
    //
    //                               NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
    //                               if ([dict[@"state"] intValue] !=1) {
    //                                   [SVProgressHUD dismiss];
    //                                   [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
    //                                   [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //                                   [SVProgressHUD dismissWithDelay:1.0];
    //                                   return ;
    //                               }
    //
    ////                               %@?vno=%@&shareId=%@
    //                               NSString *rsPath=[[dict objectForKey:@"data"] objectForKey:@"rsPath"];
    //                               NSString *shareurl=@"";
    //                               if (self.detailModel.data.product.commodityType == 7) {//vip礼包
    //                                   shareurl=[NSString stringWithFormat:@"%@%@&shareId=%@&active=%@", fyMainHomeUrl,self.detailModel.data.productShart,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"11"];
    //                               }else
    //                               {
    //                                   shareurl=[NSString stringWithFormat:@"%@%@&shareId=%@&active=%@", fyMainHomeUrl,self.detailModel.data.productShart,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],self.active];
    //                               }
    //
    //                               NSDictionary *dic = @{
    //                                                     @"shareDesc":self.detailModel.data.product.productSubtitle,
    //                                                     @"shareImageUrl":[NSString stringWithFormat:@"%@/qr/%@",SharePictureUrl,rsPath],
    //                                                     @"shareTitle":self.detailModel.data.product.title,
    //                                                     @"shareUrl":shareurl
    //                                                     };
    //
    //                               [ShareTools shareWithContent:dic];
    //                               NSLog(@"%@",dict);
    //                           }
    //                       } error:^(__kindof YTKBaseRequest * _Nonnull request) {
    //                           [SVProgressHUD dismiss];
    //                           [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
    //                           [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //                           [SVProgressHUD dismissWithDelay:1.0];
    //                           NSLog(@"❤️1️⃣");
    //                       }];
    //
    //                      NSLog(@"%@",dict);
    //
    //                      NSLog(@"%@",dict);
    //                  }
    //              } error:^(__kindof YTKBaseRequest * _Nonnull request) {
    //                  [SVProgressHUD dismiss];
    //                  [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
    //                  [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //                  [SVProgressHUD dismissWithDelay:1.0];
    //                  NSLog(@"❤️1️⃣");
    //              }];
    //
    //             NSLog(@"%@",dict);
    //         }
    //     } error:^(__kindof YTKBaseRequest * _Nonnull request) {
    //         [SVProgressHUD dismiss];
    //         [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
    //         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //         [SVProgressHUD dismissWithDelay:1.0];
    //         NSLog(@"❤️1️⃣");
    //     }];
    //
    //
    
    
}

- (NSString *)coverImageUrlStr{
    if (self.HMH_videoModel.coverImageUrl.length > 0) {
        NSString *str3 = [self.HMH_videoModel.coverImageUrl substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self.HMH_videoModel.coverImageUrl,@"!PD750"];
                return imageUrl;
            }
        }
    }
    return self.HMH_videoModel.coverImageUrl;
}

#pragma mark 返回用户uid
- (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    //        没登录先登录
    //    LocalLoginViewController *LVC = [[LocalLoginViewController alloc]init];
    //    LVC.mainUrlStr =  self.url_login;
    //    LVC.mineUrl = self.main_mine;
    //    LVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:LVC animated:YES];//用选中的
    return @"";
    
}
// 分享状态返回 1 成功    2 失败   -1 失败 为安装客户端
- (void)shareResultState:(NSString *)state{
    //    NSString *sidStr = [self getUserSidStr];
    //    if ([state isEqualToString:@"1"] && [self isJudgeLogin]) {
    //        NSString *urlStr = [NSString stringWithFormat:@"/share/benefit?sid=%@",sidStr];
    //        [self requestData:nil withUrl:urlStr requestType:@"post"];
    //    }
}
#pragma mark 底部自定义按钮点击
-(void)bottomButtonClick:(UIButton *)button
{
    //显示隐藏购物车数量
    if (self.isJudgeLogin) {
        if ( [_countLabel.text isEqualToString:@""]||[_countLabel.text isEqualToString:@"0"]) {
            _countLabel.hidden=YES;
        }else
        {
            _countLabel.hidden=NO;
        }
    }else
    {
        _countLabel.hidden=YES;
    }
    WEAKSELF
    switch (button.tag) {
        case 100://店铺
        {
            if (!self.isLogin) {
                return;
            }
            ShopListViewController *ShopListVC=[[ShopListViewController alloc]init];
            ShopListVC.detailModel=self.detailModel;
            [self.navigationController pushViewController:ShopListVC animated:YES];
        }
            break;
        case 101://收藏
        {
            if (!self.isLogin) {
                return;
            }
            
            [SVProgressHUD show];
            //                projectId为productid为收藏商品。 为shopid为关注店铺
             NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/addMyfollow"];
            [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"projectId":self.productId,@"followType":@"MALL",@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                [SVProgressHUD dismiss];
                if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                    if ([dict[@"state"] intValue] !=1) {
                        if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                            [self gotoLogin];
                        }else
                        {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                            [SVProgressHUD dismissWithDelay:1.0];
                        }
                        return ;
                    }
                    NSDictionary *dataDic=[dict objectForKey:@"data"];
                    NSString * isFollow=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isFollow"]];
                    if ([isFollow isEqualToString:@"1"]) {
                        button.selected=YES;
                    }else
                    {
                        button.selected=NO;
                    }
                    CGFloat offset = 5.0f;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height-offset/2, 0);
                    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
                    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
                    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -button.titleLabel.intrinsicContentSize.width);
                    
                }
            } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                [SVProgressHUD dismiss];
                [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
            }];
            
        }
            break;
        case 102://购物车
        {
            if (!self.isLogin) {
                return;
            }
            SpCartViewController*SpVC=[[SpCartViewController alloc]initWithType:SpCartViewControllerEnterTypeOther];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detial" object:nil];
            SpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:SpVC animated:YES];
        }
            break;
        case 200://加入购物车
        {
            if(self.detailModel.data.seckillInfo.isSeckill==1&&self.detailModel.data.seckillInfo.purchasedQuantity>=self.detailModel.data.seckillInfo.stock) {//售罄
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"商品已售罄，下次早点来哦"  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 确定按钮的点击事件
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }else
            {
                if (!self.isLogin) {
                    return;
                }
                [self requestTheFeatureDataShowFeatureView:@"加入购物车" indexPath:nil];
            }
            
            
        }
            break;
        case 301:
        case 201://立即购买
        {
            if (!self.isLogin) {
                return;
            }
            [self requestTheFeatureDataShowFeatureView:@"立即购买" indexPath:nil];
            
            
        }
            break;
        case 300://分享推广
        {
            if (!self.isLogin) {
                return;
            }
            [CustomInputMoneyView CustomInputMoneyViewIn:[UIApplication sharedApplication].keyWindow sureblock:^(float money) {
                [CutomVipShareView CutomVipShareViewIn:[UIApplication sharedApplication].keyWindow addMoney:money goodsDetailModel:self.detailModel wxblock:^{
                    
                } pyqblock:^{
                    
                } closeblock:^{
                    
                }];
            } closeblock:^{
                
            }];
            
            
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - 加入购物车成功
- (void)setUpWithAddSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addShoppingCarSuccess" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"添加成功,在购物车等你亲～"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
#pragma mark - 接受通知
- (void)acceptanceNote
{
    // 接收推送的文本消息 (当用户下单时 弹XX下单的框)
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //      查看咨询
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chakanzixun:)name:SeaConsultationDetail object:nil];
    //     查看评价
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chakanpingjia:)name:SeaTheReviewList object:nil];
    //     选择规格
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xuanzeguige:)name:SelectionSpecification object:nil];
    
    //    查看参数
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chakancanshu:)name:SeaParameters object:nil];
    //    查看图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chakantupian:)name:SeaTheBigPicList object:nil];
    //联系商家，进店逛逛通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jindianguanguang:)name:ShopAroundAndContact object:nil];
    //    进入店铺
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jinrudianpu:)name:GoToStoreList object:nil];
    //    进入详情
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jinruxiangqing:)name:ShopeProductDetailView object:nil];
    
    
    //分享通知
    WEAKSELF
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    [self goodsInfoPushMessageWithDic:userInfo];
}
//查看咨询
-(void)chakanzixun:(NSNotification*)note
{
    ConsultationViewController *ConsultationVC=[[ConsultationViewController alloc]init];
    ConsultationVC.url=[NSString stringWithFormat:@"%@/html/goods/main/information_new.html?platform=mobile&productId=%ld",fyMainHomeUrl,(long)self.detailModel.data.product.productId];
    [self.navigationController pushViewController:ConsultationVC animated:YES];
}
//    查看评价
-(void)chakanpingjia:(NSNotification*)note
{
    WEAKSELF
    _goodCommentVc = [[SpGoodCommentViewController alloc] init];
    _goodCommentVc.productId = self.productId;
    _goodCommentVc.myBlock = ^(UIViewController * _Nonnull vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    [self.navigationController pushViewController:_goodCommentVc animated:YES];
}
//    选择规格
-(void)xuanzeguige:(NSNotification*)note
{
    NSDictionary *dic = note.userInfo;
    [self requestTheFeatureDataShowFeatureView:@"选择规格" indexPath:dic[@"indexpath"]];
}
//    查看参数
-(void)chakancanshu:(NSNotification*)note
{
    ParametersViewController *vc = [[ParametersViewController alloc] init];
    self.definesPresentationContext = YES;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
//    查看图片
-(void)chakantupian:(NSNotification*)note
{
    [self CommentListMainUserTapImageViewWithCellImageViewsIndex:nil commentListModel:nil];
}
//联系商家，进店逛逛通知
-(void)jindianguanguang:(NSNotification*)note
{
    if ([note.userInfo[@"buttonTag"] isEqualToString:@"101"]) { //联系商家
        //            if (self.detailModel.data.product.telPhone) {
        //               [weakSelf telWithPhoneNum:self.detailModel.data.product.telPhone];
        //            }else
        //            {
        //                [weakSelf telWithPhoneNum:@"13601897864"];
        //            }
        
    }else if ([note.userInfo[@"buttonTag"] isEqualToString:@"102"]){//进店逛逛
        if (!self.isLogin) {
            return;
        }
        ShopListViewController *ShopListVC=[[ShopListViewController alloc]init];
        ShopListVC.detailModel=self.detailModel;
        [self.navigationController pushViewController:ShopListVC animated:YES];
    }
}
//    进入店铺
-(void)jinrudianpu:(NSNotification*)note
{
    if (!self.isLogin) {
        return;
    }
    ShopListViewController *ShopListVC=[[ShopListViewController alloc]init];
    ShopListVC.detailModel=self.detailModel;
    [self.navigationController pushViewController:ShopListVC animated:YES];
}
//    进入详情
-(void)jinruxiangqing:(NSNotification*)note
{
    SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
    SpGoodsDetailVC.productId=[note.userInfo objectForKey:@"productId"];
    //    直供精品商铺跳详情直接跳转普通商品、促销的根绝是否有促销价判断
    //    SpGoodsDetailVC.goodsType=self.goodsType;
    [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
}
#pragma mark 打电话事件
- (void)telWithPhoneNum:(NSString *)phoneNum{
    
    NSString *phone =[NSString string]; ;
    NSArray *arr = [phoneNum componentsSeparatedByString:@" "];
    if (arr.count) {
        for (NSString*str in arr) {
            phone =  [phone stringByAppendingString:str];
        }
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //    });
}
-(void)CommentListMainUserTapImageViewWithCellImageViewsIndex:(NSInteger)imageIndex commentListModel:(GetCommentListModel *)listModel{
    NSArray *imgArr = listModel.commentPictureList;
    
    if (imgArr.count > imageIndex) {
        self.selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < imgArr.count; i++) {
            [_selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
        }
        
        if (_selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = _selectImageTap;
            pictureVC.picUrlArray = imgArr;
            // 标记点击的是哪一张图片
            pictureVC.touchIndex = imageIndex;
            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
            CLPresent *present = [CLPresent sharedCLPresent];
            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
            pictureVC.transitioningDelegate = present;
            [self presentViewController:pictureVC animated:YES completion:nil];
        }
    }
}
//请求规格数据展示规格页面
-(void)requestTheFeatureDataShowFeatureView:(NSString*)type indexPath:(NSIndexPath*)indexpath
{
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
    _featureVC = [[FeatureViewController alloc] init];
    if (![self.code isEqualToString:@""]&&self.code.length>0) {
        self.detailModel.data.product.code=self.code;
    }
    _featureVC.detailModel=self.detailModel;
    _featureVC.productId=self.productId;
    _featureVC.indexpath=indexpath;
    _featureVC.featureModel=self.featureModel;
    _featureVC.Delegate=self;
    _featureVC.type=type;
    _featureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    _featureVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:_featureVC animated:YES completion:nil];
    
    
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

//FeatureViewController  选择规格 代理回调
- (void)selectedItemType:(NSString*)type dic:(NSDictionary*)dic 
{
    if (dic[@"isSeckill"]) {
        self.detailModel.data.seckillInfo.isSeckill=[dic[@"isSeckill"] integerValue];
    }
    if (dic[@"noticeActivityStart"]) {
        self.detailModel.data.seckillInfo.noticeActivityStart=[dic[@"noticeActivityStart"] integerValue];
    }
    if (dic[@"purchaseLimitation"] ) {
        self.detailModel.data.seckillInfo.purchaseLimitation=[dic[@"purchaseLimitation"] integerValue];
    }
    if (dic[@"stockKill"]) {
        self.detailModel.data.seckillInfo.stock=[dic[@"stockKill"] integerValue];
    }
    if (dic[@"purchasedQuantity"]) {
        self.detailModel.data.seckillInfo.purchasedQuantity=[dic[@"purchasedQuantity"] integerValue];
    }
    
    if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
    {
        //        后期可能会改为6
        self.active=@"0";
    }
    if ([type isEqualToString: @"立即购买"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detial" object:nil];
        }];
        if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
        {
            //          后期可能会改为6
            self.active=@"0";
        }
        HFPayMentViewController *vc = [[HFPayMentViewController alloc] initWithType:HFPayMentViewControllerEnterTypeOther];
        if (self.isVipGiftPackage) {
            vc.viewModel.contentType=  HFOrderShopModelTypeVipPackage;
        }else {
            vc.viewModel.contentType= HFOrderShopModelTypeDetial ;
        }
        vc.viewModel.orderWriteParams=@{@"sid":[HFCarShoppingRequest sid] ,
                                        @"terminal": @"P_TERMINAL_MOBILE",
                                        @"commodityId":@(self.productId.integerValue),
                                        @"shoppingcartId":@"",
                                        @"specifications":dic[@"specifications"],
                                        @"count":@([dic[@"count"] integerValue]),
                                        @"active": self.goodsType == VipWholesaleGoodsDetailStyle ? @"7" : self.active};
        //        NSDictionary *dict = @{@"sid":[HFCarShoppingRequest sid] ,
        //                               @"terminal": @"P_TERMINAL_MOBILE",
        //                               @"commodityId":self.productId,
        //                               @"shoppingcartId":[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.sellerId],
        //                               @"specifications":dic[@"specifications"],
        //                               @"count":dic[@"count"],
        //                               @"active": self.active
        //                               };
        
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.hidesBottomBarWhenPushed = YES;
        self.customNavBar.hidden=YES;
        self.navigationController.navigationBar.hidden=NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([type isEqualToString: @"加入购物车"]) {
        //        保存购物车接口
        [SVProgressHUD show];
        NSDictionary *params=@{@"productID":self.productId,@"productTypeID":dic[@"specifications"],@"shoppingCount":dic[@"count"],@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"shopsId":[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.shopId],@"shopsType":self.detailModel.data.product.shopsType,@"price":dic[@"price"],@"stealAge":self.detailModel.data.product.stealAge};
        NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/saveShoppingCart"];
        [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
            if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
            {
                
                NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                if ([dict[@"state"] intValue] !=1) {
                    if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                        [self gotoLogin];
                    }else
                    {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD dismissWithDelay:1.0];
                    }
                    
                    return ;
                }
                self.saveShoppingCar=[SaveShoppingCar modelWithJSON:dict];
                _countLabel.text=[NSString stringWithFormat:@"%ld",(long)self.saveShoppingCar.data.countShoppingCart];
                if ([_countLabel.text isEqualToString:@""]||[_countLabel.text isEqualToString:@"0"]) {
                    _countLabel.hidden=YES;
                }else
                {
                    _countLabel.hidden=NO;
                }
                [SVProgressHUD dismiss];
                [self  setUpWithAddSuccess];
                if ( self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
                    _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
                    self.goodsType=SpikeGoodsDetailStyle;
                }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
                {
                    _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
                    self.goodsType=SpikeGoodsDetailStyle;
                }else
                {//促销和普通
                    NSString *startdate=dic[@"startDate"];
                    NSString *enddate=dic[@"endDate"];
                    if (enddate&&![enddate isEqualToString:@""]) {
                        //            促销、秒杀
                        self.goodsType=PromotionGoodsDetailStyle;
                        _goodBaseVc.goodsBaseStyle=PromotionGoodsBaseDetailStyle;
                        _goodBaseVc.spacEndDateTime=enddate;
                        _goodBaseVc.spaceStartTime=startdate;
                    }else
                    {
                        //            普通商品
                        self.goodsType=OrdinaryGoodsDetailStyle;
                        _goodBaseVc.goodsBaseStyle=OrdinaryGoodsBaseDetailStyle;
                        _goodBaseVc.spacEndDateTime=nil;
                        _goodBaseVc.spaceStartTime=nil;
                    }
                    
                }
                
                NSString *nowTime=[MyUtil getNowTimeTimestamp3];
                self.spaceTime=[MyUtil compareTwoTime: _goodBaseVc.spacEndDateTime time2:nowTime];
                self.starSpaceTime=[MyUtil compareTwoTime:_goodBaseVc.spaceStartTime time2:nowTime];
                _goodBaseVc.code=dic[@"code"];
                self.code=dic[@"code"];
                _goodBaseVc.skuItemPrice=dic[@"price"];
                _goodBaseVc.skuItemIntrinsicPrice=dic[@"intrinsicPrice"];
                _goodBaseVc.spaceTime=self.spaceTime;
                _goodBaseVc.starSpaceTime=self.starSpaceTime;
                [_goodBaseVc.collectionView reloadData];
                NSLog(@"%@",dict);
            }
        } error:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            NSLog(@"❤️1️⃣");
        }];

    }
    //    切换规格展示不同倒计时
    if ([type isEqualToString: @"选择规格"]) {
        if ( self.detailModel.data.seckillInfo.noticeActivityStart) {//秒杀预告
            _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
            self.goodsType=SpikeGoodsDetailStyle;
        }else if (self.detailModel.data.seckillInfo.isSeckill==1)//秒杀中
        {
            NSString *startdate=dic[@"startDate"];
            NSString *enddate=dic[@"endDate"];
            if (enddate&&![enddate isEqualToString:@""])
            {
                _goodBaseVc.spacEndDateTime=enddate;
            }
            if (startdate&&![startdate isEqualToString:@""]) {
                _goodBaseVc.spaceStartTime=startdate;
            }
            _goodBaseVc.goodsBaseStyle=SpikeGoodsBaseDetailStyle;
            self.goodsType=SpikeGoodsDetailStyle;
            
        }else
        {
            NSString *startdate=dic[@"startDate"];
            NSString *enddate=dic[@"endDate"];
            if (enddate&&![enddate isEqualToString:@""]) {
                //            促销、秒杀
                self.goodsType=PromotionGoodsDetailStyle;
                _goodBaseVc.goodsBaseStyle=PromotionGoodsBaseDetailStyle;
                _goodBaseVc.spacEndDateTime=enddate;
                _goodBaseVc.spaceStartTime=startdate;
            }else
            {
                //            普通商品
                self.goodsType=OrdinaryGoodsDetailStyle;
                _goodBaseVc.goodsBaseStyle=OrdinaryGoodsBaseDetailStyle;
                _goodBaseVc.spacEndDateTime=nil;
                _goodBaseVc.spaceStartTime=nil;
            }
        }
        
        
        NSString *nowTime=[MyUtil getNowTimeTimestamp3];
        self.spaceTime=[MyUtil compareTwoTime: _goodBaseVc.spacEndDateTime time2:nowTime];
        self.starSpaceTime=[MyUtil compareTwoTime:_goodBaseVc.spaceStartTime time2:nowTime ];
        self.code=dic[@"code"];
        _goodBaseVc.detailModel= self.detailModel;
        _goodBaseVc.code=dic[@"code"];
        _goodBaseVc.skuItemPrice=dic[@"price"];
        _goodBaseVc.skuItemIntrinsicPrice=dic[@"intrinsicPrice"];
        _goodBaseVc.spaceTime=self.spaceTime;
        _goodBaseVc.starSpaceTime=self.starSpaceTime;
        [_goodBaseVc.collectionView reloadData];
    }
}

#pragma 退出界面
- (void)selfAlterViewback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (int)navBarBottom
{
    
    if (IS_iPhoneX) {
        return 44;
    } else {
        return 20;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
