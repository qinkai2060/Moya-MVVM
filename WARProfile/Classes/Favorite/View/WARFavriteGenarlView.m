//
//  WARFavriteGenarlView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteGenarlView.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARConfigurationMacros.h"
#import "WARFavriteNetWorkTool.h"
#import "YYModel.h"
#import "WARFavriteCreatEditeViewController.h"
#import "WARMediator+Publish.h"
#import "UIView+BlockGesture.h"
@implementation WARFavriteGenarlView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [WARFavriteGenarlView drarectAngle:self.cornarView corners:UIRectCornerTopRight|UIRectCornerTopLeft size:CGSizeMake(8, 8)];
        [self initNotiFication];
        
    }
    return self;
}
- (void)initSubViews {
    [self addSubview:self.bgv];
    [self addSubview:self.cornarView];
    [self.cornarView addSubview:self.headerBtn];
    [self.cornarView addSubview:self.lineV];
    [self.cornarView addSubview:self.toolView];
    [self.cornarView addSubview:self.segementView];
    [self.cornarView addSubview:self.contenView];
}
- (void)initNotiFication {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topNoti:) name:@"top" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingClick:) name:@"editingClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favriteClick:) name:@"favriteClick" object:nil];
}
- (void)topNoti:(NSNotification*)noti {
}
- (void)editingClick:(NSNotification*)noti {
    [WARFavriteGenarlView dissmiss];
    WARFavoriteInfoModel *model = noti.object;

    if (self.vc&&self.linkURL) {
        UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForBookmarksEditBoardVC:self.linkURL bookmarkId:model.favoriteId];
        [self.vc.navigationController pushViewController:publishVC animated:YES];
    }
    
}

- (void)favriteClick:(NSNotification*)noti {
    [WARFavriteGenarlView dissmiss];
    WARFavoriteInfoModel *model = noti.object;
}
- (void)loadNetWork {
    WS(weakself);
    [WARFavriteNetWorkTool postFavoriteDatalistWithlistWithcallback:^(id response) {
        weakself.datasource = [weakself dataSource:response];
    } failer:^(id response) {
        
    }];
}
- (NSMutableArray*)dataSource:(id) response {
    NSArray *array = [NSArray yy_modelArrayWithClass:[WARFavoriteInfoModel class] json:response];
    
    // 分组
    NSMutableArray *sourceData = [NSMutableArray arrayWithArray:array];
    NSArray *typeArr = [sourceData valueForKeyPath:@"favoriteType"];
    NSSet *typeSet = [NSSet setWithArray:typeArr];
    NSMutableArray *datasource = [NSMutableArray array];
    [typeSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *typeDict = [NSMutableDictionary dictionary];
        [typeDict setObject:obj forKey:@"favoriteType"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favoriteType LIKE %@ ",obj];
        NSArray *indexArray = [sourceData filteredArrayUsingPredicate:predicate];
        [typeDict setObject:indexArray forKey:@"favorite"];
        [datasource addObject:typeDict];
        
    }];
    NSMutableDictionary *typeDict = [NSMutableDictionary dictionary];
    [typeDict setObject:@"全部" forKey:@"favoriteType"];
    [typeDict setObject:array forKey:@"favorite"];
    [datasource insertObject:typeDict atIndex:0];
    return datasource;
}
+ (void)show:(UIViewController*)showVC atVC:(UIViewController*)addVC withUrl:(NSString*)url {

    WARFavriteGenarlView *fav = [[WARFavriteGenarlView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];;

         CGFloat navH =  WAR_IS_IPHONE_X ? 64+24:44+20;
    fav.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    fav.alpha = 0;
    [addVC.view addSubview:fav];
    [fav loadNetWork];
    [UIView animateWithDuration:0.3 animations:^{
        fav.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            fav.cornarView.frame = CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH);
            fav.headerBtn.selected = YES;
            
        }];
        
    }];
    fav.linkURL = url;
    fav.vc = showVC;

}
- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
+ (void)dissmiss {
    
    WARFavriteGenarlView *fav = nil;
    UIViewController *showVC = [WARFavriteGenarlView currentViewController];
    
    for (UIView  *v in showVC.view.subviews) {
        if ([v isKindOfClass:[WARFavriteGenarlView class]]) {
            fav = v;
            break;
        }
    }
    fav.canScroll = NO;
    CGFloat navH =  WAR_IS_IPHONE_X ? 64+24:44+20;
    [UIView animateWithDuration:0.25 animations:^{
         fav.cornarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-navH);
        fav.headerBtn.selected = NO;
    } completion:^(BOOL finished) {
            fav.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
           
            fav.alpha = 0;
            [fav removeFromSuperview];
           [showVC dismissViewControllerAnimated:NO completion:nil];
        }];
        
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"top" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editingClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"favriteClick" object:nil];
}
- (void)setDatasource:(NSArray *)datasource {
    _datasource = datasource;
    self.segementView.segementArr = datasource;
    self.contenView.typeContenArray = datasource;
}
+ (void)drarectAngle:(UIView*)v corners:(UIRectCorner)corners size :(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, v.frame.size.height) byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, kScreenWidth,  v.frame.size.height);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowOffset = CGSizeMake(0, 1);
    v.layer.shadowOpacity = 1.5f;
    v.layer.shadowPath = maskPath.CGPath;
    maskLayer.path = maskPath.CGPath;
  
    v.layer.mask = maskLayer;
}
- (UIView *)bgv {
    if (!_bgv) {
        _bgv = [[UIView alloc] initWithFrame:self.bounds];
        [_bgv addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [WARFavriteGenarlView dissmiss];
        }];
    }
    return _bgv;
}
- (void)headerClick:(UIButton*)btn {
     CGFloat navH =  WAR_IS_IPHONE_X ? 64+24:44+20;
    if (self.canScroll) {
        btn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.cornarView.frame = CGRectMake(0,navH, kScreenWidth, kScreenHeight-navH);
            self.contenView.userInteractionEnabled = YES;
            self.canScroll = NO;
            
        }];
  
    }else{
        btn.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.cornarView.frame = CGRectMake(0,kScreenHeight-190-39-50-40, kScreenWidth, kScreenHeight-navH);
            self.contenView.userInteractionEnabled = NO;
            self.canScroll = YES;
            
        }];
        
    }
}
- (void)favriteGenarContentView:(WARFavriteGenarContentView *)view moveEndAtIndex:(NSInteger)index {
    [self.segementView.collectionVSegment selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}
- (void)favriteGenarSegementView:(WARFavriteGenarSegementView *)view didSelectIndexPath:(NSIndexPath *)indexpath {
    [self.contenView selectIndex:indexpath.item];
}
- (WARFavriteGenarSegementView *)segementView {
    if (!_segementView) {
        _segementView = [[WARFavriteGenarSegementView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), kScreenWidth, 40)];
        _segementView.delegate = self;
        
    }
    return _segementView;
}
- (WARFavriteGenarContentView *)contenView {
    if (!_contenView) {
        _contenView = [[WARFavriteGenarContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segementView.frame), kScreenWidth, CGRectGetHeight(self.cornarView.frame)-CGRectGetMaxY(self.segementView.frame))];
        _contenView.delegate = self;
//        _contenView.userInteractionEnabled = NO;
    }
    return _contenView;
}
- (UIView *)cornarView {
    if (!_cornarView) {
        CGFloat navH =  WAR_IS_IPHONE_X ? 64+24:44+20;
        _cornarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-navH)];
        _cornarView.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        swipeGesture.delegate = self;
        [_cornarView addGestureRecognizer:swipeGesture];
//        [_cornarView.headerBtn addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cornarView;
}
- (UIButton *)headerBtn {
    if (!_headerBtn) {
        CGFloat tabH =  WAR_IS_IPHONE_X ? 40+34:40;
        _headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, tabH-1)];//chat_gift_down
        [_headerBtn setImage:[UIImage war_imageName:@"chat_gift_slide" curClass:[self class] curBundle:@"WARMainMap.bundle"] forState:UIControlStateNormal];
        [_headerBtn setImage:[UIImage war_imageName:@"chat_gift_down" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
        [_headerBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        _headerBtn.titleLabel.font = kFont(15);
        [_headerBtn addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBtn;
}
- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 44, kScreenWidth-20, 1)];
        _lineV.backgroundColor = SeparatorColor;
    }
    return _lineV;
}
- (WARTopToolView *)toolView {
    if (!_toolView) {
        _toolView = [[WARTopToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerBtn.frame)+7, kScreenWidth, 50)];
        _toolView.hotBtn.hidden = YES;
        _toolView.lineV.hidden = YES;
        WS(weakself);
        _toolView.creatBlock = ^{
            if (weakself.vc) {
                [WARFavriteGenarlView dissmiss];
                
                WARFavriteCreatEditeViewController *editingVC = [[WARFavriteCreatEditeViewController alloc] initWithType:2 withlinkURL:weakself.linkURL];
                [weakself.vc.navigationController pushViewController:editingVC animated:NO];
            }
        };
    }
    return _toolView;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    return NO;
//}
- (void)swipeGesture:(UIPanGestureRecognizer*)swipeGesture {
    
     CGFloat navH =  WAR_IS_IPHONE_X ? 64+24:44+20;
     CGFloat nearbyVh = 105*3 + (WAR_IS_IPHONE_X ? 40+34:40);
    
    CGPoint translation = [swipeGesture translationInView:self.cornarView];
    CGRect nearbyRect = self.cornarView.frame;
    nearbyRect.origin.y = self.cornarView.frame.origin.y + translation.y;
    CGFloat middleY = kScreenHeight-190-39-50-40;
 //   NSLog(@"%.f %.f %.f",nearbyRect.origin.y,navH,(kScreenHeight-190-39-50-40+55));
       if (swipeGesture.state ==  UIGestureRecognizerStateBegan) {
           
           
       }else if (swipeGesture.state ==  UIGestureRecognizerStateChanged) {
           if (translation.y<0) {
               
               if ( nearbyRect.origin.y >=(navH)) {
                   
                    self.cornarView.frame = nearbyRect;
                
               }
    
               //向上滑动
           }else{
               self.cornarView.frame = nearbyRect;
           }

       }else {
           NDLog(@"%.f %.f",(kScreenHeight-190-39-50-40-55) ,self.cornarView.frame.origin.y);
           if (self.cornarView.frame.origin.y >navH+55 &&self.cornarView.frame.origin.y < (kScreenHeight-190-39-50-40-55)) {
               [UIView animateWithDuration:0.25 animations:^{
                   self.cornarView.frame = CGRectMake(0,kScreenHeight-190-39-50-40, kScreenWidth, kScreenHeight-navH);
                   self.contenView.userInteractionEnabled = NO;
                   self.canScroll = YES;
                    self.headerBtn.selected = NO;
               }];
           }else if (self.cornarView.frame.origin.y > middleY+30){
               [WARFavriteGenarlView dissmiss];
             
           }else if (self.cornarView.frame.origin.y < middleY-30){
               self.cornarView.frame = CGRectMake(0,navH, kScreenWidth, kScreenHeight-navH);
               self.contenView.userInteractionEnabled = YES;
               self.canScroll = YES;
               self.headerBtn.selected = YES;
           }
       }

//    if (swipeGesture.state ==  UIGestureRecognizerStateBegan) {
//        //[self.cornarView inBottomStarPan];
//    } else if ( swipeGesture.state ==  UIGestureRecognizerStateEnded) {
//        if (self.cornarView.frame.origin.y < (kScreenHeight-nearbyVh)-55 ) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.cornarView.frame = CGRectMake(0,nagH, kScreenWidth, kScreenHeight-nagH);
////                [self.cornarView inTopPan];
//            }];
//
//        }  else if (self.cornarView.frame.origin.y>(kScreenHeight-nearbyVh)-55 &&self.nearbyV.frame.origin.y<(kScreenHeight-nearbyVh)) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.cornarView.frame = CGRectMake(0,kScreenHeight-nearbyVh, kScreenWidth, kScreenHeight-nagH);
//               // [self.nearbyV inBottomStarPan];
//            }];
//
//        }   else if (self.cornarView.frame.origin.y > (kScreenHeight-nearbyVh)+55 ) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.cornarView.frame = CGRectMake(0,kScreenHeight-(WAR_IS_IPHONE_X ? 40+34:40), kScreenWidth, kScreenHeight-nagH);
//               // [self.nearbyV inBottomPan];
//            }];
//
//        } else if (self.nearbyV.frame.origin.y>(kScreenHeight-nearbyVh) &&self.nearbyV.frame.origin.y<(kScreenHeight-nearbyVh)+55) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.cornarView.frame = CGRectMake(0,kScreenHeight-nearbyVh, kScreenWidth, kScreenHeight-nagH);
//               // [self.nearbyV inBottomStarPan];
//            }];
//
//        }
//
//    }
    [swipeGesture setTranslation:CGPointZero inView:self.cornarView];
}
@end
