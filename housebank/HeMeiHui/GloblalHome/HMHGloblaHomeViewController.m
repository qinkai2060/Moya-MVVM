//
//  HMHGloblaHomeViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/6.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHGloblaHomeViewController.h"
#import "UIView+addGradientLayer.h"
#import "WRNavigationBar.h"
#import "HFShouYinViewController.h"
#import "SDCycleScrollView.h"
#import "LocationView.h"
#import "DateSelectionView.h"
#import "SearchView.h"
#import "PriceAndStarView.h"
#import "MSSCalendarViewController.h"
#import "SpTypesSearchViewController.h"
#import "HFGlobalFamilayHomeStarPriceView.h"
#import "AdvertisementMode.h"
#import "HFFamilyViewController.h"
#import "HFHotelSearchViewController.h"
#import "HFGlobalFamilyViewModel.h"
@interface HMHGloblaHomeViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,MSSCalendarViewControllerDelegate,LocationViewDelegate,HFGlobalFamilayHomeStarPriceViewDelegate,CLLocationManagerDelegate,TypesSearchViewControllerDelegate,HFHotelSearchViewControllerDelegate>
@property (nonatomic, strong)SDCycleScrollView*cycleScrollView;
@property (nonatomic, strong) UITableView *HMH_tableView;
@property (nonatomic, strong) NSArray *subViewArray;
@property (nonatomic, strong) HFGlobalFamilayHomeStarPriceView *starPriceView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LocationView * locationView;
@property (nonatomic, strong) DateSelectionView *dateSelectionView;
@property (nonatomic, strong) SearchView*searchView;
@property (nonatomic, strong) PriceAndStarView*priceAndStarView;
@property (nonatomic, strong) AdvertisementMode*advertisementMode;
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@end

@implementation HMHGloblaHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.hidden=NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon"]];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"消息"]];
    WEAKSELF
    self.customNavBar.onClickLeftButton=^(void) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.customNavBar.onClickRightButton=^(void) {
        [weakSelf  topShareBtnClick];
    };
    [self initData];
    [self initHomeView];
    [self initializeLocationService];
    [self getRequestData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.customNavBar.hidden=NO;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
//    self.hidesBottomBarWhenPushed = NO;
    if (self.appearblock) {
        self.appearblock();
    }
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (self.isPushList) {
        HFFamilyViewController *vc = [[HFFamilyViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        [vc getCityName:[self.pushListDic objectForKey:@"city"] ?: self.cityName cityID:[NSString stringWithFormat:@"%@",[self.pushListDic objectForKey:@"cityId"]] ?: self.cityId pointLng:self.pointLng pointLat:self.pointLat dateStar:self.dateStar dateEnd:self.dateEnd keyWord:self.keyWord minPrice:self.minPrice maxPrice:self.maxPrice star:self.star beginTime:self.startDate endTime:self.endDate];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.isPushList = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)initData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
   
    self.cityName=@"上海";//城市名字
    self.cityId=@"164132";//城市id
    self.pointLng=@"121.480539";//经度
    self.pointLat=@"31.235929";//纬度
    self.dateStar=[formatter stringFromDate:[NSDate date]];//开始日期
    self.dateEnd= [formatter stringFromDate:beginningOfWeek];//结束日期
    self.keyWord=@"";//关键字
    self.minPrice=@"";//最小价格
    self.maxPrice=@"";//最大价格
    self.star=@"";//星级
}
-(void)getRequestData
{
    NSDictionary *params = @{
                             @"mark":@"APP",
                             @"seat":@"Banner_global_home",
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
                     
                     NSString *str=@"";
                     if (PicsItem.imageth.length > 0) {
                         NSString *str3 = [PicsItem.imageth substringToIndex:1];
                         if ([str3 isEqualToString:@"/"]) {
                             ManagerTools *manageTools =  [ManagerTools ManagerTools];
                             if (manageTools.appInfoModel) {
                                 str = [NSString stringWithFormat:@"%@%@%@%@",manageTools.appInfoModel.imageServerUrl,PicsItem.imageth,@"!PD750",IMGWH(CGSizeMake(ScreenW, 120))];
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
            
//              [self requestData:nil withUrl:@"/data/findRegions" withRequestName:@"post" withRequestType:@"post"];
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
/**
 初始化位置管理器
 */
-(void)initializeLocationService
{
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务已经打开");
    }
     _locationManager  = [[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
//      [_locationManager requestAlwaysAuthorization ];
        [_locationManager  requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精准度
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //位置信息更新最小距离，只有移动大于这个距离才更新位置信息，默认为kCLDistanceFilterNone：不进行距离限制

    }
}
-(void)initHomeView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.starPriceView];
//    自定义titleView
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.bounds=CGRectMake(0, 0, 80, 20);
    imageView.centerX=self.customNavBar.centerX;
    imageView.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [imageView setImage:[UIImage imageNamed:@"全球家 copy"]];
    [self.customNavBar addSubview:imageView];
//    轮播图
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 180) delegate:self placeholderImage:nil];
    _cycleScrollView.autoScroll = YES; // 不自动滚动
    _cycleScrollView.currentPageDotColor=[UIColor redColor];
    _cycleScrollView.backgroundColor=[UIColor clearColor];
    //  cycleScrollView.pageControlBottomOffset=20;
    _cycleScrollView.imageURLStringsGroup =@[];
    
//    定位cell
     _locationView = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,59)];
     _locationView.delegate=self;
    
//    选择日期cell
    _dateSelectionView = [[DateSelectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,72)];
    NSString *today=[MyUtil getCurrentTime];
    NSDate *tomorrowDate=[MyUtil dateFromString:today];
    NSString *tomorrowStr=[MyUtil GetTomorrowDay:tomorrowDate];
    _dateSelectionView.checkInDate.text=today;
    _dateSelectionView.departureDate.text=tomorrowStr;
    _dateSelectionView.nightsNum.text=@"共1天";
    _dateSelectionView.checkInDateTag.text=@"今天";
     _dateSelectionView.departureDateTag.text=@"明天";
    
   _startDate= [[MyUtil dateToTimestamp:[NSDate date]] integerValue];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    _endDate=[[MyUtil dateToTimestamp:beginningOfWeek] integerValue];
//    搜索cell
    _searchView=[[SearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,51)];
    
    
//    选择价格星级cell
    _priceAndStarView=[[PriceAndStarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,51)];
    self.subViewArray = [NSArray arrayWithObjects:_locationView,_dateSelectionView,_searchView,_priceAndStarView,nil];
    
    
//    搜索按钮footview
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(20, 20, ScreenW-40, 45);
    [searchBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFA8C1D).CGColor,(id)HEXCOLOR(0xFCAD3E).CGColor]];
    [searchBtn setTitle:@"查找全球家" forState:UIControlStateNormal];
    [searchBtn addTarget:nil action:@selector(searchGlobalHome) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [searchBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 23;
    [footView addSubview:searchBtn];
    
//   主视图表
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopHeight, ScreenW, ScreenH-KTopHeight-TabBarHeight) style:UITableViewStylePlain];
    _HMH_tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    _HMH_tableView.scrollEnabled = NO;
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    _HMH_tableView.tableHeaderView=_cycleScrollView;
    _HMH_tableView.tableFooterView=footView;
    [self.view addSubview:_HMH_tableView];

}

#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.subViewArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"gloableHomeCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:(UIView *)[self.subViewArray objectAtIndex:indexPath.row]];
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return ((UIView *)[self.subViewArray objectAtIndex:indexPath.row]).frame.size.height;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    switch (indexPath.row) {
        case 0:
        {//选择地址
         
            ZJCityViewControllerOne *vc = [[ZJCityViewControllerOne alloc] initWithDataArray:nil withType:1];
            vc.hidesBottomBarWhenPushed=YES;
            __weak typeof(self) weakSelf = self;
            [vc setupCityCellClickHandler:^(FindRegionsModel *model) {
                self.cityId = [NSString stringWithFormat:@"%ld",model.id];
                self.pointLng=model.lng;
                self.pointLat=model.lat;
                self.cityName=model.name;
                _locationView.positionLable.text=model.name;
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {//日期
            [self  showCalendarView];
        }
            break;
        case 2:
        {
            HFHotelSearchViewController *searchVC = [[HFHotelSearchViewController alloc] initWithViewModel:self.viewModel withType:HFHotelSearchViewControllerOther];
             searchVC.hidesBottomBarWhenPushed=YES;
//             searchVC.searchTypes=GlobalHomeSearchType;
            [searchVC setUpKeyWord:self.keyWord];
             searchVC.delegate=self;
            [self.navigationController pushViewController:searchVC animated:NO];
        }
            break;
        case 3:
        {
              [self.starPriceView show];
            
            
        }
            break;
            
        default:
            break;
    }
  
}

//跳转消息
-(void)topShareBtnClick
{
    HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
    newsView.isMore=YES;
    [newsView setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/shopping/news/news.html"]];
    newsView.fromeSource=@"globleNewsVC";
    newsView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:newsView animated:YES];
}
#pragma mark LocationView delegate
//开启定位
- (void)didUpdateLocations
{
    _locationView.subView.userInteractionEnabled=NO;
    [_locationManager startUpdatingLocation];
    
}
//展示日期选择器
-(void)showCalendarView
{
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.navigationController.tabBarController.tabBar.hidden=YES;
    cvc.limitMonth = 12;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.calendarType = MSSCalendarHotelType;
    cvc.beforeTodayCanTouch = NO;// 今天之前的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之后的日期是否可以点击
    cvc.startDate = _startDate;// 选中开始时间
    cvc.endDate = _endDate;// 选中结束时间
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = NO;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    //弹出NavigationController
    cvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //设置NavigationController根视图
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:cvc];
    //设置NavigationController的模态模式，即NavigationController的显示方式
    navigation.modalPresentationStyle = UIModalPresentationOverFullScreen;
    cvc.navigationController.navigationBar.hidden=YES;
    //加载模态视图
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
     _locationView.subView.userInteractionEnabled=YES;
    [_locationManager stopUpdatingLocation];
}
/**
 定位管理器回调方法。我的位置
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"%lu",(unsigned long)locations.count);
    //    CLLocation * location = locations.lastObject;
    CLLocation * location = [locations objectAtIndex:0];
    //    纬度
    //    CLLocationDegrees latitude = location.coordinate.latitude;
    //    经度
    //    CLLocationDegrees longitude = location.coordinate.longitude;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        for (CLPlacemark *place in array) {
        // NSLog(@"addressDictionary,%@",place.addressDictionary);//地址的所有信息
        // NSString *FormattedAddressLines=[place.addressDictionary objectForKey:@"FormattedAddressLines"];//地址全信息
        // NSString *Country=[place.addressDictionary objectForKey:@"Country"];//国家
        // NSString *State=[place.addressDictionary objectForKey:@"State"];//省。
             NSString *City=[place.addressDictionary objectForKey:@"City"];//市
         NSString *SubLocality=[place.addressDictionary objectForKey:@"SubLocality"];//区
         NSString *Street=[place.addressDictionary objectForKey:@"Street"];//街道
//         NSString *subThoroughfare=[place.addressDictionary objectForKey:@"subThoroughfare"];//子街道
//         NSString *Name=[place.addressDictionary objectForKey:@"Name"];//小区名称
            _locationView.positionLable.text=[NSString stringWithFormat:@"%@,%@ %@",City,SubLocality,Street];
            self.cityName=City;
            self.pointLat=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
            self.pointLng=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
//            获取城市ID
             [self  reloadRequestCityID];
            
        }
    }];
     [_locationManager stopUpdatingLocation];
    
    
}
//日期回调
- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
  
    self.dateStar=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate]];
    self.dateEnd=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate]];
    self.startDate = startDate;
    self.endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"MM月dd日"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate: [NSDate dateWithTimeIntervalSince1970:startDate] toDate: [NSDate dateWithTimeIntervalSince1970:endDate] options:0];
    _dateSelectionView.checkInDate.text=startDateString;
    _dateSelectionView.departureDate.text=endDateString;
//    NSDate * startDay=[MyUtil timestampToDate:_startDate];
//    NSDate * endDay=[MyUtil timestampToDate:_endDate];
//    NSString* days= [MyUtil getDays:startDay endDay:endDay];
    _dateSelectionView.nightsNum.text = [NSString stringWithFormat:@"共%ld天",(long)delta.day];
    _dateSelectionView.checkInDateTag.text=[self getWeekDayFordate:startDate];
    _dateSelectionView.departureDateTag.text=[self getWeekDayFordate:endDate];
}
#pragma mark - 星级价格 回调
- (void)popupView:(HFGlobalFamilayHomeStarPriceView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    HFFilterPriceModel *filterPrice;
    if (array.count>0) {
        filterPrice=[array objectAtIndex:0];
    }
    NSLog(@"%@",filterPrice.selectTitle);
    NSLog(@"%@",filterPrice.starSelectTitle);
     NSLog(@"%@",filterPrice.minfloat);
     NSLog(@"%@",filterPrice.maxfloat);
    NSLog(@"%ld",(long)filterPrice.star);
     NSLog(@"%@",filterPrice.starSelect);
    NSString *text=[NSString stringWithFormat:@"%@/%@",filterPrice.selectTitle,filterPrice.starSelectTitle];
    _priceAndStarView.contionLable.text=text;
    _priceAndStarView.contionLable.textColor=HEXCOLOR(0x333333);
    self.minPrice=filterPrice.minfloat;
    self.maxPrice=filterPrice.maxfloat;
    self.star=filterPrice.starSelect;
    
}
#pragma mark - 搜索代理
- (void)BringBackSearchText:(NSString *)searchText
{
    self.keyWord=searchText;
    _searchView.searchTextField.text=searchText;
}
- (void)hotelViewController:(HFHotelSearchViewController*)viewController keyWord:(NSString*)keyWord {
    self.keyWord=keyWord;
    _searchView.searchTextField.text=keyWord;
}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    AdvertisementListItem *iteam=[self.advertisementMode.data.list objectAtIndex:index];
    [HFCarRequest updateClickNumber:[NSString stringWithFormat:@"iteam.ID"]];
    if ([NSString stringWithFormat:@"%@",iteam.linkContent].length >0&&iteam.linkType == 2) {
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
        [vc setShareUrl:iteam.linkContent];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //    if ([NSString stringWithFormat:@"%@",iteam.linkContent].length >0&&iteam.linkType == 1) {
    //
    //        SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
    //        vc.productId  = [NSString stringWithFormat:@"%@",iteam.linkContent];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    
}
//查找全球家
-(void)searchGlobalHome
{
    HFFamilyViewController *vc = [[HFFamilyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [vc getCityName:self.cityName cityID:self.cityId pointLng:self.pointLng pointLat:self.pointLat dateStar:self.dateStar dateEnd:self.dateEnd keyWord:self.keyWord minPrice:self.minPrice maxPrice:self.maxPrice star:self.star beginTime:self.startDate endTime:self.endDate];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (HFGlobalFamilayHomeStarPriceView *)starPriceView {
    if (!_starPriceView) {
        _starPriceView = [[HFGlobalFamilayHomeStarPriceView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithFilter:[HFFilterPriceModel priceStarData2]];
        _starPriceView.hidden = YES;
        _starPriceView.delegate = self;
    }
    return _starPriceView;
}
#pragma mark 数据请求 =====get put=====获取城市ID
- (void)reloadRequestCityID
{
    NSDictionary *params = @{
                             @"regionName":self.cityName,
                             @"sid":[HFCarShoppingRequest sid],
                             };
    [SVProgressHUD show];
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./data/regionName"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:params success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         [SVProgressHUD dismiss];
         if ( [request.responseJSONObject isKindOfClass:[NSArray class]])
         {
              _locationView.subView.userInteractionEnabled=YES;
             
             NSDictionary *dict = (NSDictionary*)[request.responseJSONObject  objectAtIndex:0];
           
             self.cityId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
             
         }
         
     } error:^(__kindof YTKBaseRequest * _Nonnull request) {
          _locationView.subView.userInteractionEnabled=YES;
         [SVProgressHUD dismiss];
         [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
         [SVProgressHUD dismissWithDelay:1.0];
         NSLog(@"❤️1️⃣");
     }];
    
}
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName withRequestType:(NSString *)requestType{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求格式
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain",@"application/x-javascript", nil];
    manager.requestSerializer.timeoutInterval = 20.f;
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",CurrentEnvironment,url];
    
    __weak typeof(self)weakSelf = self;
    if ([requestType isEqualToString:@"post"]){ // 商品列表请求
        [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf getSeconddata:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            
        }];
    }
}
// 列表
- (void)getSeconddata:(id)data{
    NSArray *resArr = data;
    for (NSDictionary *dic in resArr) {
        FindRegionsModel *model = [[FindRegionsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataSourceArr addObject:model];
    }
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (HFGlobalFamilyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFGlobalFamilyViewModel alloc] init];
    }
    return _viewModel;
}
- (NSString *)getWeekDayFordate:(NSTimeInterval)data {
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
     NSString *newDatestr=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data]];

        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSTimeInterval thirdPerDay = 24 * 60 * 60*2;
        NSDate *today = [[NSDate alloc] init];
        NSDate *tomorrow, *thirdterday;
      //        今天、明天、后天
        tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
        thirdterday = [today dateByAddingTimeInterval: thirdPerDay];
    
        NSString * todayString = [[today description] substringToIndex:10];
        NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
        NSString * thirddayString = [[thirdterday description] substringToIndex:10];
 
        NSString * dateString = [newDatestr substringToIndex:10];
        
        if ([dateString isEqualToString:todayString])
        {
            
            return @"今天";
        } else if ([dateString isEqualToString:tomorrowString])
        {
           
            return @"明天";
        }else if ([dateString isEqualToString:thirddayString])
        {
          
            return @"后天";
        }
        else
        {
            NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *newDate=[NSDate dateWithTimeIntervalSince1970:data];
            NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
            NSString *weekStr = [weekday objectAtIndex:components.weekday];
            return weekStr;
        }

    
   
}
@end
