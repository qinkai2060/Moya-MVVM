//
//  SpSpikeViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/15.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpSpikeViewController.h"
#import "UIView+addGradientLayer.h"
#import "MenuItemCell.h"
#import "SubSpikeViewController.h"

@interface SpSpikeViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UIView *titleView;
@property (strong , nonatomic)UICollectionView *collectionView;

@end

@implementation SpSpikeViewController
#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KTopHeight, ScreenW, _gf_menuHeight) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册
        [_collectionView registerClass:[MenuItemCell class] forCellWithReuseIdentifier:@"MenuItemCell"];
        [self.titleView addSubview:_collectionView];
    }
    return _collectionView;
    
}
#pragma mark - LazyLoad
- (UIScrollView *)scrollView
{
    CGFloat scrollViewY = _gf_menuHeight + _gf_menuY;
        scrollViewY = _gf_menuHeight + _gf_menuY + KTopHeight;
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,scrollViewY, ScreenW, ScreenH-scrollViewY)];
        if (@available(iOS 11.0, *)) {
            /** iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置 */
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.backgroundColor=[UIColor orangeColor];
        self.scrollView.contentSize = CGSizeMake(self.view.dc_width *self.gf_titles.count , 0);
        //      设置偏移量
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.gf_menuHeight  = 56;
    _gf_menuY = 0;
    self.pageTag=@"fy_mall_secKill";
    self.customNavBar.hidden=YES;
    //    设置状态栏背景色
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden=YES;
    //    设置内部试图置顶//取消导航栏自动适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor blueColor];
    //自定义d顶部背景视图
    self.titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, KTopHeight+_gf_menuHeight)];
    [self.titleView   addGradualLayerWithColores:@[(__bridge id)HEXCOLOR(0xFF0000).CGColor,(__bridge id)HEXCOLOR(0xFF2E5D).CGColor] ];
    [self.view addSubview:self.titleView];
    //   自定义返回按钮
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(10, StatusBarHeight+10, 20, 20);
    [leftbtn setImage:[UIImage imageNamed:@"首页-返回白色"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:leftbtn];
    //    自定义返回按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(ScreenW -10-20, StatusBarHeight+10, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"forward111"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(forwardClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:rightBtn];
    //    自定义titleView
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.center=self.navigationItem.titleView.center;
    imageView.bounds=CGRectMake(0, 0, 87, 19);
    imageView.centerX=self.titleView.centerX;
    imageView.centerY=rightBtn.centerY+1;
    [imageView setImage:[UIImage imageNamed:@"texttext"]];
    [self.titleView addSubview:imageView];
    
    CGFloat segmentedControlY = _gf_menuY;
    if (self.navigationController && !self.navigationController.navigationBar.hidden) {
        segmentedControlY = _gf_menuY + KTopHeight;
    }
    
    [self getRequestData];
    [self.view bringSubviewToFront:self.titleView];//始终放在最上层
    
   
}
-(void)getRequestData
{
    [SVProgressHUD show];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/activity/time-limited-spike/times-list"];
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
//             self.spikeTimeListModel=[[SpikeTimeListModel alloc]initWithDictionary:dict error:nil];
             self.spikeTimeListModel=[SpikeTimeListModel modelWithJSON:dict];
             [self initialization];
//             [self setupContentView];

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.gf_selectIndex) {
        self.gf_selectIndex =self.resetselectIndex;
    }
   
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    self.customNavBar.hidden=YES;
//    self.navigationController.navigationBar.hidden=YES;
//    [self setNavBgColor:[UIColor clearColor]];
//
//
//}
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.titleView];//始终放在最上层
}

#pragma mark - private
//基础数据
- (void)initialization {
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor=[UIColor whiteColor];
//    self.gf_titles= @[@"8:00",@"10:00",@"12:00",@"14:00",@"16:00",@"18:00",@"20:00"];
//    self.gf_subTitles= @[@"已结束",@"已结束",@"已结束",@"抢购中",@"即将开始",@"即将开始",@"即将开始"];
    self.gf_titles=[NSMutableArray new];
    self.gf_subTitles=[NSMutableArray new];
    for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
        NSDictionary*timesItem=(NSDictionary*)[self.spikeTimeListModel.data.times objectAtIndex:i];
        NSString *timeStr=@"";
        timeStr=[timesItem objectForKey:@"timeParagraph"];
        NSString *state=[NSString stringWithFormat:@"%@",[timesItem objectForKey:@"state"]];
        [self.gf_titles addObject:timeStr];
        NSString *str=@"";
        switch ([state integerValue]) {
            case 1:
                {
                    str=@"抢购中";
                }
                break;
            case 2:
            {
                str=@"已开抢";
            }
                break;
            case 3:
            {
                str=@"即将开始";
            }
                break;
            case 4:
            {
               str=@"明日开抢";
            }
                break;
            case 5:
            {
               str=@"下期开抢";
            }
                break;
            case 6:
            {
                str=@"往期回顾";
            }
                break;

            default:
                str=[NSString stringWithFormat:@"状态%@",state];
                break;
        }
        [self.gf_subTitles addObject:str];
    }
    for (int i = 0; i <self.gf_titles.count; i ++) {
        NSDictionary*timesItem=[self.spikeTimeListModel.data.times objectAtIndex:i];
        SubSpikeViewController *vc    = [[SubSpikeViewController alloc] init];
        vc.activityId=[[NSString stringWithFormat:@"%@",[timesItem objectForKey:@"activityId"]] integerValue];
        vc.stateStr = self.gf_subTitles[i];
        NSLog(@"%ld",vc.activityId);
        [self addChildViewController:vc];
    }
    
    [_collectionView reloadData];
    [HFKefuButton kefuBtn:self];
  [self performSelector:@selector(setNewUpContentView) withObject:nil afterDelay:0.3];
}

- (void)setNewUpContentView {
    int index=0;
     for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
         NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
         if ([self setSelectIndexWithDic:dic withIndex:i]&&[self setSelectIndexWithDic:dic withIndex:i]!=0) {
               index =  [self setSelectIndexWithDic:dic withIndex:i];
         }
     }
     self.gf_selectIndex= index;
}

//布局
- (void)setupContentView {
//状态 1：抢购中，2：已开抢，3：即将开始，4：明日开抢，5：下期开抢，6：往期回顾
//   抢购中> 已开抢>即将开始>往期回顾。
    if (self.gf_titles.count>0) {
        int tag=10000;
        for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
            NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
            
            if ([str isEqualToString:@"5"] ) {
                tag=i;
            }
        }
        for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
            NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
            
            if ([str isEqualToString:@"4"] ) {
                tag=i;
            }
        }
        for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
            NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
            
            if ([str isEqualToString:@"3"] ) {
                tag=i;
            }
        }
        for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
            NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
            
            if ([str isEqualToString:@"2"] ) {
                tag=i;
            }
        }
        for (int i=0; i<self.spikeTimeListModel.data.times.count; i++) {
             NSDictionary *dic=  [self.spikeTimeListModel.data.times objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
          
            if ([str isEqualToString:@"1"] ) {
                tag=i;
            }
          }
        if (tag==10000) {
            if (self.gf_titles.count>2) {
                self.gf_selectIndex=2;
            }else
            {
                self.gf_selectIndex=0;
            }
         }else
         {
                self.gf_selectIndex=tag;
         }
      
       
    }
    
}

- (int)setSelectIndexWithDic:(NSDictionary *)dic withIndex:(int)index {
    if ([dic.allKeys containsObject:@"defaultSelected"]) {
        NSNumber * defaultSelected = [dic objectForKey:@"defaultSelected"];
        if ([defaultSelected intValue] == 1) {
            return index;
        }else {
            return 0;
        }
    }
    return 0;
}

//设置选中索引
- (void)setGf_selectIndex:(NSInteger)selectIndex {
    _gf_selectIndex = selectIndex;
    self.resetselectIndex=selectIndex;
    [self selectItemAtIndex:selectIndex];
    [self scrollControllerAtIndex:selectIndex];
}
// 设置选中指定下标的item
- (void)selectItemAtIndex:(NSInteger)selectIndex {
//  UICollectionView的设置默认选择方法必须reloadData后再进行指定cell设置
    [_collectionView reloadData];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    CGRect curItemFrame = CGRectMake(selectIndex * ScreenW/5, 0, ScreenW/5, self.gf_menuHeight);

    [self refreshContentOffsetItemFrame:curItemFrame];
}
//滚动到当前页面
- (void)scrollControllerAtIndex:(NSInteger)index {
    CGFloat offsetX = index * ScreenW;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    [self addChildVC:index];
   
   
}
#pragma mark - 添加子控制器View
-(void)addChildVC:(NSInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview)
    return; //判断添加就不用再添加了
    
    childVc.view.frame = CGRectMake(index * _scrollView.dc_width,0, _scrollView.dc_width, _scrollView.dc_height);
    
    [_scrollView addSubview:childVc.view];
}
#pragma mark - <UIScrollViewDelegate>

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView==_scrollView){
         NSInteger index = _scrollView.contentOffset.x / _scrollView.dc_width;
        self.gf_selectIndex=(int)index;
    }
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.gf_titles.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.titleText=[self.gf_titles objectAtIndex:indexPath.row];
    cell.titleColor=[UIColor blackColor];
    /** 标题文字颜色 */
    cell.titleColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    /** 标题文字字体 */
    cell.titleTextFont=[UIFont systemFontOfSize:19 weight:UIFontWeightSemibold];
    /** 标题label的高度 */
    cell.titleLabelHeight=25;
    
    /** 副标题内容 */
    cell.subTitleText=[self.gf_subTitles objectAtIndex:indexPath.row];
    /** 副标题文字颜色 */
    cell.subTitleColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    /** 副标题文字字体 */
    cell.subTitleTextFont=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    /** 副标题label的高度 */
    cell.subTitleLabelHeight=15;
    if(cell.selected) {
        cell.titleColor=[[UIColor whiteColor]colorWithAlphaComponent:1];
        cell.subTitleColor=[[UIColor whiteColor]colorWithAlphaComponent:1];
        
    }else{
        cell.titleColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        cell.subTitleColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        
    }
  
//    cell.backgroundColor=[UIColor greenColor];
    //cell.backgroundColor=HEXCOLOR(0XF7F7F7);
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(ScreenW/5, 50);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   MenuItemCell * cell = (MenuItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleColor=[[UIColor whiteColor]colorWithAlphaComponent:1];
    cell.subTitleColor=[[UIColor whiteColor]colorWithAlphaComponent:1];
    _gf_selectIndex = indexPath.row;
    self.resetselectIndex=_gf_selectIndex;
    [self selectItemAtIndex:indexPath.row];
    [self scrollControllerAtIndex:indexPath.row];
//      [self  scrollControllerAtIndex:indexPath.row];
//    [self refreshContentOffsetItemFrame:cell.frame];
}

// 让选中的item位于中间
- (void)refreshContentOffsetItemFrame:(CGRect)frame {
    CGFloat itemX      = frame.origin.x;
    CGFloat width      = ScreenW/5;
    CGSize contentSize = _collectionView.contentSize;
    
    CGFloat targetX = 0.0;
    if (itemX <= width*2) {
        targetX = 0;
    } else {
        if (itemX<contentSize.width-width*2) {
           targetX=itemX-width*2;
        }else
        {
            if (itemX>=ScreenW-width) {
                targetX=contentSize.width-ScreenW;
            }else
            {
                targetX=0;
            }
            
        }
    }
    [_collectionView setContentOffset:CGPointMake(targetX, 0) animated:YES];

}

//返回
- (void)Goback {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)forwardClick
{
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }

    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"pageTag":self.pageTag,@"sid":[HFCarShoppingRequest sid],@"terminal":[HFCarRequest terminal]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
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
//
//- (void)dealloc {
//    _scrollView.delegate = nil;
//    // 移除所有子控制器
//    for (UIViewController *vc in self.childViewControllers) {
//        [vc willMoveToParentViewController:self];
//        [vc removeFromParentViewController];
//    }
//}




@end
