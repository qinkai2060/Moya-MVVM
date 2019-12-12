//
//  WARFavriteGenarlView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import <UIKit/UIKit.h>
#import "WARTopToolView.h"
#import "WARFavriteGenarContentView.h"
#import "WARFavriteGenarSegementView.h"
#import "WARFavoriteModel.h"

@interface WARFavriteGenarlView : UIView <WARFavriteGenarContentViewDelegate,WARFavriteGenarSegementViewDelegate, UIGestureRecognizerDelegate>
/**tool*/
@property (nonatomic,strong) WARTopToolView *toolView;

@property(nonatomic,strong) UIButton *headerBtn;

@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIView *bgv;
@property (nonatomic,strong) UIView *cornarView;

@property (nonatomic,strong) WARFavriteGenarContentView *contenView;

@property (nonatomic,strong) WARFavriteGenarSegementView *segementView;

@property (nonatomic,strong) NSArray *datasource;

@property (nonatomic,assign) BOOL canScroll;

@property (nonatomic,strong) UIViewController *vc;

@property (nonatomic,strong) NSString *linkURL;

+ (void)show:(UIViewController*)showVC atVC:(UIViewController*)addVC withUrl:(NSString*)url;
@end
