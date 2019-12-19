//
//  HFFamilyViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamilyViewController.h"
#import "WRNavigationBar.h"
#import "HFGlobalFamilyViewModel.h"
#import "HFGlobalSearchReultHomeView.h"
#import "HFNavBarTitleView.h"
#import "HFHotelSearchViewController.h"
#import "MSSCalendarViewController.h"
#import "HFShouYinViewController.h"
#import "HFHotelDataModel.h"

@interface HFFamilyViewController ()<MSSCalendarViewControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)HFGlobalSearchReultHomeView *homeView;
@property(nonatomic,strong)HFNavBarTitleView *titleView;
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@end

@implementation HFFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self getCityName:@"南京" cityID:@"164132" pointLng:@"121.3654125" pointLat:@"30.98542154" dateStar:@"2019-04-23" dateEnd:@"2019-04-25" keyWord:@"格林" minPrice:@"0" maxPrice:@"100" star:@"4"];
    [self setNav];
    [self hh_setsubview];
    [self bindViewModel];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if(self.navigationController.viewControllers.count > 1) {
        
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}
- (void)hh_setsubview {
    [SVProgressHUD show];
    [self.view addSubview:self.homeView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)bindViewModel {
    @weakify(self)
    [self.viewModel.getSearchSubjc subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        HFHotelSearchViewController *vc = [[HFHotelSearchViewController alloc] initWithViewModel:self.viewModel withType:HFHotelSearchViewControllerDefault];
        [vc setUpKeyWord:self.titleView.searchBtn.currentTitle];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:NO];
        
    }];
    [self.viewModel.getDateSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self showCalendarView];
    }];
    [self.viewModel.getCitySubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        ZJCityViewControllerOne *vc = [[ZJCityViewControllerOne alloc] initWithDataArray:nil withType:1];
        vc.hidesBottomBarWhenPushed=YES;
        __weak typeof(self) weakSelf = self;
        [vc setupCityCellClickHandler:^(FindRegionsModel *model) {
            self.viewModel.cityId = model.id;
            self.viewModel.localPointLng=model.lng.length == 0 ?@"":model.lng;
            self.viewModel.localPointLat=model.lat.length == 0 ?@"":model.lat;
            [self.titleView cityName:model.name date:@"" keyWord:@""];
            self.viewModel.pageNo = 1;
            [self.viewModel.getRegionDatCommand execute:nil];
            [self.viewModel.getHotelDataCommand execute:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.didDetailSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFHotelDataModel *model = (HFHotelDataModel*)x;
        HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
        newsView.isMore=YES;

        [newsView setShareUrl:[NSString stringWithFormat:@"%@/html/home/#/global/hotelDetails?sid=%@&hotelId=%@&startDate=%@&endDate=%@",fyMainHomeUrl,[HFCarShoppingRequest sid],[NSString stringWithFormat:@"%ld",model.hotelId], [self.viewModel.bookStar stringByReplacingOccurrencesOfString:@"-" withString:@""] , [self.viewModel.bookEnd stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
        newsView.fromeSource=@"globleNewsVC";

//        [newsView setShareUrl:[NSString stringWithFormat:@"%@/html/home/#/global/hotelDetails?hotelId=%@&startDate=%@&endDate=%@",fyMainHomeUrl,[NSString stringWithFormat:@"%ld",model.hotelId], [self.viewModel.bookStar stringByReplacingOccurrencesOfString:@"-" withString:@""] , [self.viewModel.bookEnd stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
//
//        [self.viewModel.bookStar componentsSeparatedByString:@"-"];
//        newsView.fromeSource=@"globleNewsVC";
        newsView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsView animated:YES];

    }];
}
- (void)setNav {
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setNavBarShadowImageHidden:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationItem.titleView = self.titleView;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_message"] style:UIBarButtonItemStyleDone target:self action:@selector(fowardClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HMH_back_light"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}
- (void)backClick {
//    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getCityName:(NSString*)cityName cityID:(NSString*)cityId pointLng:(NSString*)pointLng pointLat:(NSString*)pointLat dateStar:(NSString*)dateStar dateEnd:(NSString*)dateEnd keyWord:(NSString*)keyWord minPrice:(NSString*)minPrice maxPrice:(NSString*)maxPrice star:(NSString*)star beginTime:(NSInteger)begin endTime:(NSInteger)endtime {
    if (dateStar.length != 0 &&dateEnd.length!=0) {
        [self.titleView cityName:cityName date:[NSString stringWithFormat:@"住%@\n离%@",[dateStar substringWithRange:NSMakeRange(5, 5)],[dateEnd substringWithRange:NSMakeRange(5, 5)]] keyWord:keyWord];
        [self.viewModel.setKeyWordSubjc sendNext:keyWord];
    }
    
    self.viewModel.cityId = cityId.length == 0 ? @"":cityId;
    self.viewModel.localPointLat = pointLat.length == 0 ?@"":pointLat;
    self.viewModel.localPointLng =  pointLng.length == 0 ?@"":pointLng;
    self.viewModel.bookStar = dateStar.length == 0 ?@"":dateStar;
    self.viewModel.bookEnd = dateEnd.length == 0 ?@"":dateEnd;
    self.viewModel.keyword = keyWord.length == 0 ?@"":keyWord;
    self.viewModel.minPrice = minPrice.length == 0 ?@"0":minPrice;
    self.viewModel.maxPrice = maxPrice.length == 0 ?@"":maxPrice;
    self.viewModel.star = star.length == 0 ?@"0":star;
    self.viewModel.beginTime = begin;
    self.viewModel.endTime = endtime;
    self.viewModel.pageNo = 1;
    [self.viewModel.getRegionDatCommand execute:nil];
    [self.viewModel.getHotelDataCommand execute:nil];
}
- (void)fowardClick {
    HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
    newsView.isMore=YES;
    [newsView setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/shopping/news/news.html"]];
    newsView.fromeSource=@"globleNewsVC";
    newsView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:newsView animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
//    self.hidesBottomBarWhenPushed = YES;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"appearNo" object:nil];
    [self setNav];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmiss" object:nil];
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.viewModel.bookStar=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate]];
    self.viewModel.bookEnd=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate]];
    if (self.viewModel.bookStar.length != 0 &&self.viewModel.bookEnd.length!=0) {
        [self.titleView cityName:@"" date:[NSString stringWithFormat:@"住%@\n离%@",[self.viewModel.bookStar substringWithRange:NSMakeRange(5, 5)],[self.viewModel.bookEnd substringWithRange:NSMakeRange(5, 5)]] keyWord:@""];

    }

    
}
-(void)showCalendarView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
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
    cvc.startDate = self.viewModel.beginTime;// 选中开始时间
    cvc.endDate = self.viewModel.endTime;// 选中结束时间
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
- (HFGlobalSearchReultHomeView *)homeView {
    if (!_homeView) {
        CGFloat navH = IS_iPhoneX ?(64+24):64;
        _homeView = [[HFGlobalSearchReultHomeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-navH) WithViewModel:self.viewModel];
    }
    return _homeView;
}
- (HFGlobalFamilyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFGlobalFamilyViewModel alloc] init];
    }
    return _viewModel;
}
- (HFNavBarTitleView *)titleView {
    if(!_titleView) {
        _titleView = [[HFNavBarTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-90-20, 30) WithViewModel:self.viewModel];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _titleView.layer.cornerRadius = 15;
        _titleView.layer.masksToBounds = YES;
    }
    return _titleView;
}
@end
