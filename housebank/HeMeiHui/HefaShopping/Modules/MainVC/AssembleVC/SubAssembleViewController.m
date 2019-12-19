//
//  SubAssembleViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SubAssembleViewController.h"
#import "AssembleCell.h"
#import "SDCycleScrollView.h"

@interface SubAssembleViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *HMH_tableView;
@property(nonatomic,strong)UIButton *topBtn;
@property (nonatomic , weak) UIButton *selectBtn;
@property (nonatomic, assign) NSInteger currrentPage;
@property (nonatomic, strong)SDCycleScrollView*cycleScrollView;
@property (nonatomic, strong)AssembleListModel*assembleListModel;
@property (nonatomic, strong) UIView *sectionHeaderView;
@end

@implementation SubAssembleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self HMH_createTableView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customNavBar.hidden=YES;
    
    
}
- (void)HMH_createTableView{
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight-45) style:UITableViewStylePlain];
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    //轮播器
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 100) delegate:self placeholderImage:nil];
    _cycleScrollView.autoScroll = YES; //自动滚动
//    _cycleScrollView.layer.masksToBounds=YES;
//    _cycleScrollView.layer.cornerRadius =5;
    _cycleScrollView.currentPageDotColor=[UIColor redColor];
    _cycleScrollView.imageURLStringsGroup =@[];
    [headerView addSubview:_cycleScrollView];
    
    _HMH_tableView.tableHeaderView=headerView;
    _HMH_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HMH_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.sectionHeaderView.backgroundColor=[UIColor whiteColor];
    
    NSArray *typeTitleArray=[NSArray arrayWithObjects:@"正在进行",@"即将开始",@"已结束", nil];
    for (int i=0; i<typeTitleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i+100;
        CGFloat btnWidth=84; CGFloat topSpace=20;
        CGFloat  midSpace=(ScreenW-2*20-3*btnWidth)/2;
        CGFloat  btnX=topSpace+i*(btnWidth+midSpace);
        btn.frame=CGRectMake(btnX, 10, btnWidth, 30);
        [btn setTitle:[typeTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.backgroundColor=HEXCOLOR(0xFFFFFF);
        [btn addTarget:self action:@selector(changeTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionHeaderView addSubview:btn];
        
    }
    
    [self.view addSubview:_HMH_tableView];
    self.topBtn.frame = CGRectMake(ScreenW-48-10, _HMH_tableView.bottom-48-30, 48, 48);
    [self.view addSubview:self.topBtn];
   self.contentViewSubView= [[SpTypeSearchListNoContentView alloc] initWithFrame:CGRectMake(0,260, ScreenW, ScreenH-KTopHeight-45-100)];
    [self.view addSubview:self.contentViewSubView];
    self.contentViewSubView.hidden=YES;
    UIButton *firstButton = self.sectionHeaderView.subviews[0];
    //                 _selectBtn=firstButton;
    [self changeTypeClick:firstButton]; //默认选择第一个
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
-(void)getListRequest
{
    [self.HMH_tableView.mj_header endRefreshing];
    [self.HMH_tableView.mj_footer endRefreshing];
    [SVProgressHUD show];
    NSString * promotionStatus=@"2";
    if(self.assembleChangeType== AssembleUnderwayType) {
        promotionStatus=@"2";
    }
    if (self.assembleChangeType== AssembleWillBeginType) {
        promotionStatus=@"1";
    }
    if (self.assembleChangeType== AssembleEndType) {
        promotionStatus=@"3";
    }
    NSDictionary *params=@{};
    if (self.activityId==0&&![promotionStatus isEqualToString:@"3"]) {//热门
        params = @{
                   @"pageNo":[NSString stringWithFormat:@"%ld",(long)_currrentPage],
                   @"promotionType":@"2",
                   @"promotionStatus":promotionStatus,
                   @"classId":[NSString stringWithFormat:@"%ld",(long)self.activityId],
                   @"hotSearch":@"1",
                   };
       
    }else
    {
        params = @{
                   @"pageNo":[NSString stringWithFormat:@"%ld",(long)_currrentPage],
                   @"promotionType":@"2",
                   @"promotionStatus":promotionStatus,
                   @"classId":[NSString stringWithFormat:@"%ld",(long)self.activityId],
                   };
    }
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.mall/promotion/search"];
    if (getUrlStr) {
        getUrlStr =getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request)
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
            
             NSArray *list=dict[@"data"];
             if (list.count>0) {
                 self.contentViewSubView.hidden=YES;
//                 self.assembleListModel=[[AssembleListModel alloc]initWithDictionary:dict error:nil];
                 self.assembleListModel = [AssembleListModel modelWithJSON:dict];
                 [self reFreshViewData];
             }else
             {
                 
                 if (_currrentPage>1) {
                     [self reFreshViewData];
                 }else
                 {
//                    self.assembleListModel=[[AssembleListModel alloc]initWithDictionary:dict error:nil];
                     self.assembleListModel = [AssembleListModel modelWithJSON:dict];
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
                             @"seat":@"Banner_group",
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
             
//             self.advertisementMode=[[AdvertisementMode alloc]initWithDictionary:dict error:nil];
             self.advertisementMode = [AdvertisementMode modelWithJSON:dict];
             NSMutableArray *imageArray=[[NSMutableArray alloc]init];
             if (self.advertisementMode.data.list.count>0) {
                 for (int i=0; i<self.advertisementMode.data.list.count; i++) {
                     AdvertisementListItem *PicsItem=[self.advertisementMode.data.list objectAtIndex:i];
                     
                     NSString *str= [PicsItem.imageth get_sharImage];
                     
                     [imageArray addObject:str];
                 }
             }
             
             _cycleScrollView.imageURLStringsGroup=(NSArray*)imageArray;
             if ( _cycleScrollView.imageURLStringsGroup.count<=0) {
                 _HMH_tableView.tableHeaderView.frame=CGRectZero;
                 
                 _HMH_tableView.tableHeaderView.hidden=YES;
                 
             }else
             {
                 _HMH_tableView.tableHeaderView.frame=CGRectMake(0, 0, ScreenW, 120);
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
 
}
//切换拼团类型
-(void)changeTypeClick:(UIButton *)button
{
    
    [_selectBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    _selectBtn.backgroundColor=HEXCOLOR(0xFFFFFF);
    [button setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    button.backgroundColor=HEXCOLOR(0xFF0000);
    
    _selectBtn = button;
    switch (button.tag) {
        case 100:
        {//正在进行
            self.assembleChangeType=AssembleUnderwayType;
        }
            break;
        case 101:
        {//即将开机
            self.assembleChangeType=AssembleWillBeginType;
        }
            break;
        case 102:
        {//已结束
            self.assembleChangeType=AssembleEndType;
        }
            break;
            
        default:
            break;
    }
      [self refreshData];
  
   
    
}
#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
         return   50;
    }else
    {
         return   0;
    }
    
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return self.sectionHeaderView;
    }else
    {
        return nil;
    }
  
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.assembleListModel.data.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssembleCell *assembleCell = [tableView dequeueReusableCellWithIdentifier:@"AssembleCell"];
    if (assembleCell == nil) {
        assembleCell = [[AssembleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssembleCell"];
    }
    switch (self.assembleChangeType) {
        case AssembleUnderwayType:
        {
            assembleCell.changeType=UnderwayType;
        }
            break;
        case AssembleWillBeginType:
        {
            assembleCell.changeType=WillBeginType;
        }
            break;
        case AssembleEndType:
        {
            assembleCell.changeType=EndType;
        }
            break;
            
        default:
            break;
    }
    assembleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    DataItem *dataItem=[self.assembleListModel.data objectAtIndex:indexPath.row];
    [assembleCell refreshCellWithModel:dataItem];
    return assembleCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     DataItem *dataItem=[self.assembleListModel.data objectAtIndex:indexPath.row];
    if (self.assembleChangeType==AssembleEndType) {
        dataItem.productId =dataItem.productId;
        SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
        vc.productId= [NSString stringWithFormat:@"%ld",(long) dataItem.productId ];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        dataItem.productId =dataItem.productId;
        AssembleGoodDetailViewController *vc = [[AssembleGoodDetailViewController alloc] initWithModel:dataItem];
        vc.assembleStyle=AssembleDetailStyle;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
   
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
    //    //    NSArray *imgArr = @
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
    
    
    self.topBtn.hidden = !(scrollView.contentOffset.y > 0&&self.assembleListModel.data.count>0);
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
