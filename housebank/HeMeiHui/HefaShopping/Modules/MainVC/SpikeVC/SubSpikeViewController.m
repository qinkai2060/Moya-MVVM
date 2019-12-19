//
//  SubSpikeViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/19.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SubSpikeViewController.h"
#import "SpikeListCell.h"
#import "SDCycleScrollView.h"

@interface SubSpikeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *HMH_tableView;
@property(nonatomic,strong)UIButton *topBtn;
@property (nonatomic, assign) NSInteger currrentPage;
@property (nonatomic, strong)SDCycleScrollView*cycleScrollView;
@property (nonatomic, strong)SpikeDataList *spikeDataList;
@end

@implementation SubSpikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self HMH_createTableView];
    //Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customNavBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
}
- (void)HMH_createTableView{
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight-56) style:UITableViewStylePlain];
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
//轮播器
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, ScreenW-30, 100) delegate:self placeholderImage:nil];
    _cycleScrollView.autoScroll = YES; // 不自动滚动
    _cycleScrollView.currentPageDotColor=[UIColor redColor];
    _cycleScrollView.backgroundColor=[UIColor clearColor];
//  cycleScrollView.pageControlBottomOffset=20;
    _cycleScrollView.imageURLStringsGroup =@[];
    [headerView addSubview:_cycleScrollView];
    
    _HMH_tableView.tableHeaderView=headerView;
    _HMH_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_HMH_tableView];
    self.topBtn.frame = CGRectMake(ScreenW-48-10, _HMH_tableView.bottom-48-30, 48, 48);
    [self.view addSubview:self.topBtn];
    self.contentViewSubView= [[SpTypeSearchListNoContentView alloc] initWithFrame:CGRectMake(0,200, ScreenW, ScreenH-KTopHeight-45-100)];
    [self.view addSubview:self.contentViewSubView];
    self.contentViewSubView.hidden=YES;
    [self refreshData];
    WEAKSELF
    // 下拉刷新
    _HMH_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _HMH_tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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

/**
 if(model.stock == 0) {
 model.stateStr = @"已抢光";
 model.progress = 1.0;
 }else */
- (void)setSpikeDataList:(SpikeDataList *)spikeDataList {
    _spikeDataList = spikeDataList;
    for (ListItemmodel *model in spikeDataList.data.spikes.list) {
        if ([self.stateStr isEqualToString:@"即将开始"] || [self.stateStr isEqualToString:@"明日开抢"]|| [self.stateStr isEqualToString:@"下期开抢"]) {
            model.stateStr = @"即将开始";
            model.progress = 0.0;
        }else if ([self.stateStr isEqualToString:@"抢购中"] || [self.stateStr isEqualToString:@"已开抢"] ) {
            if((model.stock - model.purchasedQuantity <= 0 || model.stock == 0)&&model.purchasedQuantity != 0) {
                model.stateStr = @"已抢光";
                model.progress = 1.0;
                
            }else {
                model.stateStr = @"去抢购";
                model.progress = (model.purchasedQuantity/(model.stock*1.0))*1.0;
            }
        }else {
            model.stateStr = @"已结束";
            model.progress = (model.purchasedQuantity/(model.stock*1.0))*1.0;
        }
    }
}
-(void)getListRequest
{
    [self.HMH_tableView.mj_header endRefreshing];
    [self.HMH_tableView.mj_footer endRefreshing];
    [SVProgressHUD show];
    NSDictionary *params = @{
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_currrentPage],
                             @"pageSize":@"20",
                             @"activityId":[NSString stringWithFormat:@"%ld",(long)self.activityId],
                            };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/activity/time-limited-spike/list"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request)
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
             NSArray *list=dict[@"data"][@"spikes"][@"list"];
             if (list.count>0 && [dict[@"data"][@"spikes"][@"list"] isKindOfClass:[NSArray class]]) {
                  self.contentViewSubView.hidden=YES;
//                self.spikeDataList=[[SpikeDataList alloc]initWithDictionary:dict error:nil];
                 self.spikeDataList=[SpikeDataList modelWithJSON:dict];
                 [self reFreshViewData];
             }else
             {
                 if (_currrentPage>1) {
                     [self reFreshViewData];
                 }else
                 {
//                     self.spikeDataList=[[SpikeDataList alloc]initWithDictionary:dict error:nil];
                     self.spikeDataList = [SpikeDataList modelWithJSON:dict];
                     [self reFreshViewData];
                      self.contentViewSubView.hidden=NO;
                 }
             }
           
             NSLog(@"%@",dict);
         }
         
     }error:^(__kindof YTKBaseRequest * _Nonnull request) {
         [SVProgressHUD dismiss];
         [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
         [SVProgressHUD dismissWithDelay:1.0];
         NSLog(@"❤️1️⃣");
     }];
}

-(void)reFreshViewData
{
    NSDictionary *params = @{
                             @"mark":@"APP",
                             @"seat":@"Banner_limit",
                             };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./Advertising/advertisingAllocationDetailListH5OrApp"];
        [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request)
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
                 
//                 self.advertisementMode=[[AdvertisementMode alloc]initWithDictionary:dict error:nil];
                 self.advertisementMode = [AdvertisementMode modelWithJSON:dict];
                 NSMutableArray *imageArray=[[NSMutableArray alloc]init];
                 if (self.advertisementMode.data.list.count>0) {
                     for (int i=0; i<self.advertisementMode.data.list.count; i++) {
                         AdvertisementListItem *PicsItem=[self.advertisementMode.data.list objectAtIndex:i];
                      
                         NSString *str=@"";
                         if (PicsItem.imageth.length > 0) {
                             NSString *str3 = [PicsItem.imageth substringToIndex:1];
                             if ([str3 isEqualToString:@"/"]) {
                                 ManagerTools *manageTools =  [ManagerTools ManagerTools];
                                 if (manageTools.appInfoModel) {
                                     str = [NSString stringWithFormat:@"%@%@%@%@/roundrect/10",manageTools.appInfoModel.imageServerUrl,PicsItem.imageth,@"!PD750",IMGWH(CGSizeMake(ScreenW, 120))];
                                     
                                     //   [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                                 }
                             }else
                             {
                                 str = [NSString stringWithFormat:@"%@%@%@/roundrect/10",PicsItem.imageth,@"!PD750",IMGWH(CGSizeMake(ScreenW, 120))];
                             }
                         }
                         [imageArray addObject:str];
                     }
                 }
            
                 _cycleScrollView.imageURLStringsGroup=(NSArray*)imageArray;
                 if ( _cycleScrollView.imageURLStringsGroup.count<=0) {
                      _HMH_tableView.tableHeaderView.frame=CGRectZero;
                    
                     _HMH_tableView.tableHeaderView.hidden=YES;
                     
                 }else
                 {
                      _HMH_tableView.tableHeaderView.frame=CGRectMake(0, 0, ScreenW, 180);
                      _HMH_tableView.tableHeaderView.hidden=NO;
                 }
                 [self.HMH_tableView reloadData];
                 NSLog(@"%@",dict);
             }
    
         } error:^(__kindof YTKBaseRequest * _Nonnull request) {
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
             NSLog(@"❤️1️⃣");
         }];
   
    [self.HMH_tableView reloadData];
}
#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.spikeDataList.data.spikes.list.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        SpikeListCell *spikeCell = [tableView dequeueReusableCellWithIdentifier:@"SpikeListCell"];
        if (spikeCell == nil) {
            spikeCell = [[SpikeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpikeListCell"];
        }
    spikeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [spikeCell refreshCellWithModel:[self.spikeDataList.data.spikes.list objectAtIndex:indexPath.row]];
        return spikeCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
//      SpikeGoodDetailViewController
//    GetProductListByConditionModel *list = [[GetProductListByConditionModel alloc] init];
    ListItemmodel *iteamModel=[self.spikeDataList.data.spikes.list objectAtIndex:indexPath.row];
    SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
    vc.productId = [NSString stringWithFormat:@"%ld",(long)iteamModel.productId];
//    促销疯抢、名品
     vc.goodsType=PromotionGoodsDetailStyle;
//   秒杀切换goodsStyle为下
//     vc.goodsStyle=GoodsDetailStyleSpike;
    [self.navigationController pushViewController:vc animated:YES];
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//        return nil;
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    AdvertisementListItem *iteam=[self.advertisementMode.data.list objectAtIndex:index];
    [HFCarRequest updateClickNumber:[NSString stringWithFormat:@"iteam.ID"]];
    if ([NSString stringWithFormat:@"%@",iteam.linkContent].length >0&&iteam.linkType == 2) {
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
        [vc setShareUrl:iteam.linkContent];
         vc.isMore = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([NSString stringWithFormat:@"%@",iteam.linkContent].length >0&&iteam.linkType == 1) {
       
        SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
        vc.productId  = [NSString stringWithFormat:@"%@",iteam.linkContent];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    NSMutableArray *picUrlArray=[[NSMutableArray alloc]init];
//    NSArray *imgArr = _shufflingArray;
//
//    if (imgArr.count > index) {
//        self.selectImageTap = [NSMutableArray arrayWithCapacity:1];
//        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
//         如果有 则取出  存到数组中*/
//        for (int i = 0; i < imgArr.count; i++) {
//            [_selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
//        }
//
//        if (_selectImageTap.count > 0) {
//            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
//            // 传入图片数组
//            pictureVC.picArray = _selectImageTap;
//            pictureVC.picUrlArray = imgArr;
//            // 标记点击的是哪一张图片
//            pictureVC.touchIndex = index;
//            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
//            CLPresent *present = [CLPresent sharedCLPresent];
//            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
//            pictureVC.transitioningDelegate = present;
//
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            [window.rootViewController presentViewController:pictureVC animated:YES completion:nil];
//        }
//    }
    NSLog(@"点击了%zd轮播图",index);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    self.topBtn.hidden = !(scrollView.contentOffset.y > 0&&self.spikeDataList.data.spikes.list.count>0);
}
- (void)topClick {
    
    [self.HMH_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] init];
        [_topBtn setImage:[UIImage imageNamed:@"float"] forState:UIControlStateNormal];
                _topBtn.hidden = YES;
        [_topBtn addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}


@end
