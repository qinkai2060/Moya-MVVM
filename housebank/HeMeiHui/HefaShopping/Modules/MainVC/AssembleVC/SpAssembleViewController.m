//
//  SpAssembleViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpAssembleViewController.h"
#import "SubAssembleViewController.h"
#import "AssembleSubViewTool.h"
#import "AssembleSearchViewController.h"

#define TopSpacing 20.0
#define MidSpacing 22.0
#define FootSpacing 20.0
#define topScroHeight 45.0
@interface SpAssembleViewController ()<UIScrollViewDelegate>
/** 标题按钮地下的指示器 */
@property (weak ,nonatomic) UIView *indicatorView;
/** 记录上一次选中的Button */
@property (nonatomic , weak) UIButton *selectBtn;
@end

@implementation SpAssembleViewController
#pragma mark - LazyLoad
- (UIScrollView *)topScrollView
{
    
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,KTopHeight, ScreenW, topScroHeight)];
        if (@available(iOS 11.0, *)) {
            /** iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置 */
            _topScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _topScrollView.backgroundColor=[UIColor orangeColor];
         CGFloat buttonW =  (ScreenW- TopSpacing-FootSpacing-MidSpacing*6)/7;
        self.topScrollView.contentSize = CGSizeMake(MidSpacing *(self.titlesArray.count-1)+buttonW*self.titlesArray.count+TopSpacing+FootSpacing , 0);
        //      设置偏移量
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.pagingEnabled = NO;
        _topScrollView.bounces = NO;
        _topScrollView.delegate = self;
        [self.view addSubview:_topScrollView];
        
    }
    return _topScrollView;
}
#pragma mark - LazyLoad
- (UIScrollView *)pageScrollView
{
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,KTopHeight+topScroHeight, ScreenW, ScreenH-KTopHeight-topScroHeight)];
        if (@available(iOS 11.0, *)) {
            /** iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置 */
            _pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _pageScrollView.backgroundColor=[UIColor orangeColor];
        self.pageScrollView.contentSize = CGSizeMake(ScreenW *self.titlesArray.count , 0);
        //      设置偏移量
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        [self.view addSubview:_pageScrollView];
        
    }
    return _pageScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon"]];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward2"]];
    self.pageTag=@"fy_mall_group_buy_1yuan";
    //    [self.customNavBar wr_setBackgroundAlpha:0];
    WEAKSELF
    self.customNavBar.onClickLeftButton=^(void) {
         [SVProgressHUD dismiss];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.customNavBar.onClickRightButton=^(void) {
        [weakSelf  topShareBtnClick];
    };
    //    自定义titleView
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.bounds=CGRectMake(0, 0, 80, 20);
    imageView.centerX=self.customNavBar.centerX;
    imageView.centerY=self.customNavBar.centerY+StatusBarHeight/2;
//    [imageView setImage:[UIImage imageNamed:@"1元拼团"]];
    [self.customNavBar addSubview:imageView];
    
    NSArray *titles = @[@"路径",@"帮助"];
    UIView * bgView = [[UIView alloc] init];
    //    bgView.alpha=0;
    bgView.frame=CGRectMake(YQP(265) , [self navBarBottom], YQP(60), 44);
    [self.customNavBar addSubview:bgView];
    
    CGFloat buttonW = YQP(20); CGFloat buttonH = 20; CGFloat buttonY = 12; CGFloat space = 20;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonX =i*(buttonW +space);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        NSString *imageName=[titles objectAtIndex:i];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(searchAndStrategyClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
    }
    
//      self.titlesArray= @[@"热门",@"服装",@"居家",@"婴童",@"食品",@"美妆",@"保健",@"男装",@"手机",@"电器",@"鞋包",@"百货",@"汽车",@"水果",@"运动"];
      [self getRequestData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customNavBar.hidden=NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.customNavBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
    [self setNavBgColor:[UIColor clearColor]];
 
    
}
-(void)getRequestData
{
    [SVProgressHUD show];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/activity/group-buying/get-classifications"];
    [HFCarShoppingRequest requestURL:utrl baseHeaderParams:@{} requstType:YTKRequestMethodPOST params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request)
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
//             self.assembleModel=[[AssembleClassifications alloc]initWithDictionary:dict error:nil];
             self.assembleModel = [AssembleClassifications modelWithJSON:dict];
             [self initialization];
             [self setupContentView];
             
             NSLog(@"%@",dict);
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
//初始化数据
-(void)initialization
{
    self.titlesArray=self.assembleModel.data.classifications;
}
//初始化页面
-(void)setupContentView
{
   
    self.topScrollView.backgroundColor=[UIColor whiteColor];
    self.pageScrollView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i< self.titlesArray.count; i++) {
        ClassificationsItem  *itemModel=[self.titlesArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:itemModel.name forState:0];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonW =  (ScreenW- TopSpacing-FootSpacing-MidSpacing*6)/7;
        CGFloat buttonX =TopSpacing+i*(buttonW+MidSpacing);
        CGFloat buttonY =13;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, 20);
        [self.topScrollView addSubview:button];
        
        SubAssembleViewController *VC=[[SubAssembleViewController alloc]init];
        VC.activityId=itemModel.ID;
        [self addChildViewController:VC];
    }
    UIButton *firstButton = self.topScrollView.subviews[0];
    [self topBottonClick:firstButton]; //默认选择第一个
    
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [UIColor redColor];
    
    indicatorView.dc_height = 2;
    indicatorView.dc_y = self.topScrollView.dc_height - indicatorView.dc_height;
    
    [firstButton.titleLabel sizeToFit];
    indicatorView.dc_width = firstButton.titleLabel.dc_width;
    indicatorView.dc_centerX = firstButton.dc_centerX;
    
    [self.topScrollView addSubview:indicatorView];
}
//顶部分类切换器
-(void)topBottonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    _selectBtn = button;
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    [self setGf_selectIndex:button.tag];
}
#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView==_pageScrollView){
        NSInteger index = _pageScrollView.contentOffset.x / _pageScrollView.dc_width;
        UIButton *button=self.topScrollView.subviews[index];
        [self topBottonClick:button];
    }
}
//设置选中索引
- (void)setGf_selectIndex:(NSInteger)selectIndex {
    _gf_selectIndex = selectIndex;
    CGFloat buttonW =  (ScreenW- TopSpacing-FootSpacing-MidSpacing*6)/7;
    CGFloat buttonX =TopSpacing+selectIndex*(buttonW+MidSpacing);
    CGRect curItemFrame = CGRectMake(buttonX, 0, buttonW, 20);
    [self refreshContentOffsetItemFrame:curItemFrame];
    [self scrollControllerAtIndex:selectIndex];
}
//滚动到当前页面
- (void)scrollControllerAtIndex:(NSInteger)index {
    CGFloat offsetX = index * ScreenW;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.pageScrollView setContentOffset:offset animated:YES];
    [self addChildVC:index];
}
#pragma mark - 添加子控制器View
-(void)addChildVC:(NSInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview)
        return; //判断添加就不用再添加了
    
    childVc.view.frame = CGRectMake(index * _pageScrollView.dc_width,0, _pageScrollView.dc_width, _pageScrollView.dc_height);
    switch (childVc.view.tag) {
        case 0:
            {
                childVc.view.backgroundColor=[UIColor whiteColor];
            }
            break;
        case 1:
        {
             childVc.view.backgroundColor=[UIColor blackColor];
        }
            break;
        case 2:
        {
             childVc.view.backgroundColor=[UIColor grayColor];
        }
            break;
        case 3:
        {
           childVc.view.backgroundColor=[UIColor redColor];
        }
            break;
        case 4:
        {
             childVc.view.backgroundColor=[UIColor greenColor];
        }
            break;
        case 5:
        {
             childVc.view.backgroundColor=[UIColor blueColor];
        }
            break;
        case 6:
        {
             childVc.view.backgroundColor=[UIColor yellowColor];
        }
            break;
            
        default:
        {
           childVc.view.backgroundColor=[UIColor brownColor];
        }
            break;
    }
    [_pageScrollView addSubview:childVc.view];
}
// 让选中的item位于中间
- (void)refreshContentOffsetItemFrame:(CGRect)frame {
    CGFloat itemX      = frame.origin.x;
    CGFloat width      = frame.size.width;
    CGSize contentSize = _topScrollView.contentSize;
    CGFloat buttonTopX =TopSpacing+3*(width+MidSpacing);
    CGFloat buttonFootX=FootSpacing+3*(width+MidSpacing);
    CGFloat targetX = 0.0;
    if (itemX <= buttonTopX) {
        targetX = 0;
    } else {
        if (itemX<contentSize.width-buttonFootX) {
            targetX=itemX-buttonTopX;
        }else
        {
            targetX=contentSize.width-ScreenW;
        }
    }
    [_topScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
}
#pragma mark - 头部按钮点击
- (void)searchAndStrategyClick:(UIButton *)button
{
    
    switch (button.tag) {
        case 100:
            {//搜索
                AssembleSearchViewController *vc = [[AssembleSearchViewController alloc] init];
                [self.navigationController pushViewController:vc animated:NO];
            }
            break;
        case 101:
        {//攻略
            [AssembleSubViewTool showAssembleStrategySubView:nil];
        }
            break;
            
        default:
            break;
    }
}
-(void)topShareBtnClick
{
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageTag":self.pageTag,@"sid":[HFCarShoppingRequest sid],@"terminal":[HFCarRequest terminal]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
        {
    
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
//            data =     {
//                shareDesc = "\U62fc\U56e2\U6298\U4e0a\U6298\Uff0c\U7269\U8d85\U6240\U503c";

            if ([dict[@"state"] intValue] !=1) {
                [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
                return ;
             }
            NSNumber * justUrl = [NSNumber numberWithBool:YES];
            NSDictionary *dic = @{
                                  @"shareDesc":dict[@"data"][@"shareDesc"],
                                  @"shareImageUrl":dict[@"data"][@"shareImageUrl"],
                                  @"shareTitle":dict[@"data"][@"shareTitle"],
                                  @"shareUrl":dict[@"data"][@"shareUrl"],
                                  @"justUrl":justUrl,
                                  };
           
            [ShareTools  shareWithContent:dic];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

//自定义导航条始终放在最上层
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.customNavBar];
}
- (int)navBarBottom
{
    
    if (IS_iPhoneX) {
        return 44;
    } else {
        return 20;
    }
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
