//
//  ShopListViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopDetailTableViewCell.h"
#import "UIView+addGradientLayer.h"
#import "UILable+addSetWidthAndheight.h"
#import "SpGoodsDetailViewController.h"
#import "SVProgressHUD.h"
#import "GSKeyChainDataManager.h"
@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger currrentPage;
@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.customNavBar.hidden=NO;
    /** 指定边缘要延伸的方向 */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /** 自动滚动调整，默认为YES */
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    //  从屏幕边缘计算（默认）
    //  self.edgesForExtendedLayout =UIRectEdgeAll;
    
}
- (void)createView{
    WEAKSELF
    self.customNavBar.hidden=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"首页-返回白色"]];
    //    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward2"]];
    [self.customNavBar wr_setBackgroundAlpha:0];
    //    self.customNavBar.onClickRightButton=^(void) {
    //        [weakSelf  topShareBtnClick];
    //    };
    self.customNavBar.titleLabelColor = [UIColor blackColor];
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        /** iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置 */
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView=[self  creatTableViewHeader];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self refreshData];
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    
}
- (void)refreshData {
    _currrentPage = 1;
    [self getListRequest];
}

- (void)loadMoreData {
    _currrentPage ++;
    [self getListRequest];
}
-(void)getListRequest
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD show];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./getShopDetailByShopId"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"moduleId":@"0",@"shopId":self.shopId ?: [NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.shopId],@"pageNo":[NSString stringWithFormat:@"%ld",(long)_currrentPage],@"pageSize":@"20",@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request)
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
             NSArray *list=dict[@"data"][@"PRODUCT_MODULE"];
             if (list.count>0) {
//                 self.ShopdetailModel=[[ShopDetailModel alloc]initWithDictionary:dict error:nil];
                 self.ShopdetailModel = [ShopDetailModel modelWithJSON:dict];
             }
             
             if ([self.ShopdetailModel.data.shopInfomation.shopInfo.isFollow isEqualToString:@"1"]) {
                 
                 [_tfollowBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                 
             }else
             {
                 [_tfollowBtn setTitle:@"+ 收藏" forState:UIControlStateNormal];
             }
             [self resetRequestData];
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

-(UIView *)creatTableViewHeader
{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 150+StatusBarHeight-20)];
    _bagImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 150+StatusBarHeight-20)];
    _bagImage.userInteractionEnabled = YES;
    _bagImage.layer.masksToBounds = YES;
    _bagImage.layer.cornerRadius = 5;
    //    _bagImage.image=[UIImage imageNamed:@"店铺logo"];
    _bagImage.contentMode=UIViewContentModeScaleAspectFit;
    [_headerView addSubview:_bagImage];
    
    _headerBagView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 150+StatusBarHeight-20)];
    _headerBagView.alpha=0.6;
    _headerBagView.backgroundColor=HEXCOLOR(0X000000);
    [_headerView addSubview:_headerBagView];
    /**店铺图标 */
    _iconImg=[[UIImageView alloc]init];
    _iconImg.frame=CGRectMake(15, _headerBagView.height-30-40, 40, 40);
    _iconImg.layer.masksToBounds = YES;
    _iconImg.layer.cornerRadius = 5;
    [_headerView addSubview:_iconImg];
    /* 店铺标记 */
    _shopMarkLabel=[[UILabel alloc]init];
    _shopMarkLabel.frame=CGRectMake(_iconImg.rightX, _headerBagView.height-30-40,0, 20);
    _shopMarkLabel.font = PFR13Font;
    _shopMarkLabel.textColor=HEXCOLOR(0xFFFFFF);
    //    [_shopMarkLabel addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    //    NSMutableAttributedString *str = [NSMutableAttributedString setupAttributeString:@"" indentationText:@"良心店"];
    //    _shopMarkLabel.attributedText = str;
    //    [_headerView addSubview:_shopMarkLabel];
    /** 店铺名字 */
    _nameLab=[[UILabel alloc]init];
    _nameLab.frame=CGRectMake(_shopMarkLabel.rightX+5, _headerBagView.height-30-40, 150, 20);
    _nameLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    _nameLab.textColor=HEXCOLOR(0xFFFFFF);
    [_headerView addSubview:_nameLab];
    /**关注数 */
    _followCountLab=[[UILabel alloc]init];
    _followCountLab.frame=CGRectMake(_iconImg.rightX+5, _headerBagView.height-30-20, 100, 20);
    _followCountLab.font = PFR12Font;
    _followCountLab.textColor=HEXCOLOR(0xFFFFFF);
    [_headerView addSubview:_followCountLab];
    /** 关注按钮 */
    //    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame= CGRectMake(23*KWidth_Scale+i*KWidth_Scale*70, titleView.bottom+top, 50*KWidth_Scale, 75*KWidth_Scale);
    //    //        button.backgroundColor=[UIColor redColor];
    //    [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
    //    [button setTitle:btnTitles[i] forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
    //    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [button setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    //
    //    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    //    //        top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
    //    //        left : 为正数的时候往右偏移,为负数的时候往左偏移;
    //    //        bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
    //    //        right :为正数的时候往左偏移,为负数的时候往右偏移;
    //    //        CGSize titleSize = button.titleLabel.bounds.size;
    //    CGSize imageSize = button.imageView.bounds.size;
    //    //        button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width, 0, -titleSize.width);
    //    button.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height+10,  -imageSize.width,0, 0);
    //    button.tag = 331+i;
    //    [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [shareView addSubview:button];
    //
    _tfollowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _tfollowBtn.frame=CGRectMake(ScreenW-15-58, _headerBagView.height-38-24, 58, 24);
    [_tfollowBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    //    [_tfollowBtn setImage:[UIImage imageNamed:@"CombinedShape"] forState:UIControlStateNormal];
    [_tfollowBtn setTitle:@"+ 收藏" forState:UIControlStateNormal];
    //    [_tfollowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,  _tfollowBtn.imageView.image.size.width, 0,- _tfollowBtn.imageView.image.size.width)];
    //    [_tfollowBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -_tfollowBtn.titleLabel.bounds.size.width, 0, _tfollowBtn.titleLabel.bounds.size.width)];
    [_tfollowBtn addTarget:self action:@selector(saveFollow:) forControlEvents:UIControlEventTouchUpInside];
    _tfollowBtn.layer.cornerRadius = 13;
    _tfollowBtn.layer.masksToBounds = YES;
    _tfollowBtn.titleLabel.font=PFR12Font;
    _tfollowBtn.titleLabel.textColor=HEXCOLOR(0xFFFFFF);
    
    [_headerView addSubview:_tfollowBtn];
    return _headerView;
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ShopdetailModel.data.PRODUCT_MODULE.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
    if (cell == nil) {
        cell = [[ShopDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productModeItem=[self.ShopdetailModel.data.PRODUCT_MODULE objectAtIndex:indexPath.row];
    [cell reSetVDataValue:cell.productModeItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
    PRODUCT_MODULEItem *item=[self.ShopdetailModel.data.PRODUCT_MODULE objectAtIndex:indexPath.row];
    SpGoodsDetailVC.productId =[NSString stringWithFormat:@"%ld",(long)item.productId];
    [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 145;
}
#pragma mark 分享按钮点击
//- (void)topShareBtnClick
//{
//    WEAKSELF
////    if (self.HMH_videoModel) {
//    NSString *shareUrlStr;
//    PopAppointViewControllerToos *tools = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
//    if (tools.popWindowUrlsArrary.count) {
//        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
//            if([model.pageTag isEqualToString:@"fy_video_play"]) {
//
//                shareUrlStr = [NSString stringWithFormat:@"%@?vno=%@&shareId=%@",model.url,self.HMH_videoModel.vno,[self getUserUidStr]];
//            }
//        }
//    }
//    if (shareUrlStr.length > 0) {
//        NSDictionary *dic = @{
//                              @"shareDesc":self.HMH_videoModel.videoAbstract,
//                              @"shareImageUrl":[self coverImageUrlStr],
//                              @"shareTitle":self.HMH_videoModel.title,
//                              @"shareUrl":shareUrlStr,
//                              @"longUrl":@"",
//                              @"shareWeixinUrl":shareUrlStr
//                              };
//        [_shareTool doShare:dic];
//    }
//}
//     [weakSelf setUpAlterViewControllerWith:[DCShareToViewController new] WithDistance:300 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
//}
-(void)resetRequestData
{
    [self.tableView reloadData];
    ShopInfo*shopeInfo=[[ShopInfo alloc]init];
    shopeInfo=self.ShopdetailModel.data.shopInfomation.shopInfo;
   
    [_bagImage sd_setImageWithURL:[NSURL URLWithString:[shopeInfo.shopImagePath get_sharImage]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
   
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[shopeInfo.imagePath get_sharImage]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    _nameLab.text=shopeInfo.shopsName;
    _followCountLab.text=[NSString stringWithFormat:@"%ld人收藏",(long)shopeInfo.vermicelliNumberFollow];
    
    
}
-(void)saveFollow:(UIButton*)sender
{
    [SVProgressHUD show];
    //                projectId为productid为收藏商品。 为shopid为关注店铺
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/addMyfollow"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{@"shopUserId":[NSString stringWithFormat:@"%ld",(long)self.ShopdetailModel.data.shopInfomation.shopInfo.userId],@"projectId":[NSString stringWithFormat:@"%ld",(long)self.detailModel.data.product.shopId],@"followType":@"SHOP",@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
            NSDictionary *dataDic=[dict objectForKey:@"data"];
            if (dataDic&&![dataDic isKindOfClass:[NSNull class]]) {
                NSString * isFollow=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isFollow"]];
                          NSString * vermicelliNumber=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"vermicelliNumber"]];
                          if ([vermicelliNumber isEqualToString:@""]||vermicelliNumber==nil) {
                              _followCountLab.text=[NSString stringWithFormat:@"%@人收藏",@"0"];
                          }else
                          {
                              _followCountLab.text=[NSString stringWithFormat:@"%@人收藏",vermicelliNumber];
                          }
                          
                          if ([isFollow isEqualToString:@"1"]) {
                              [_tfollowBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                          }else
                          {
                              [_tfollowBtn setTitle:@"+ 收藏" forState:UIControlStateNormal];
                          }
            }
          
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
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
