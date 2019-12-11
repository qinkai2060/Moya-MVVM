//
//  WARPopHorizontalMenu.m
//  WARPopHorizontalMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import "WARPopHorizontalMenu.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIView+SDAutoLayout.h"
#import "WARMomentCellOperationMenu.h"
// changeable
#define WARDefaultMargin                     4.f
#define WARDefaultMenuTextMargin             6.f
#define WARDefaultMenuIconMargin             6.f
#define WARDefaultMenuCornerRadius           5.f
#define WARDefaultAnimationDuration          0.2
// unchangeable, change them at your own risk
#define KSCREEN_WIDTH                       [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT                      [[UIScreen mainScreen] bounds].size.height
#define WARDefaultBackgroundColor            [UIColor clearColor]
#define WARDefaultTintColor                  [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.f]
#define WARDefaultSeparatorColor                  [UIColor colorWithRed:((float)((0xcccccc & 0xFF0000) >> 16)) / 255.0 green:((float)((0xcccccc & 0xFF00) >> 8)) / 255.0 blue:((float)(0xcccccc & 0xFF)) / 255.0 alpha:1]
#define WARDefaultTextColor                  [UIColor whiteColor]
#define WARDefaultMenuFont                   [UIFont systemFontOfSize:14.f]
#define WARDefaultMenuWidth                  180.f
#define WARDefaultMenuIconSize               22.f
#define WARDefaultMenuRowHeight              39.f
#define WARDefaultMenuBorderWidth            0.8
#define WARDefaultMenuArrowWidth             8.f
#define WARDefaultMenuArrowHeight            10.f
#define WARDefaultMenuArrowWidth_R           12.f
#define WARDefaultMenuArrowHeight_R          12.f
#define WARDefaultMenuArrowRoundRadius       4.f

static NSString  *const WARPopHorizontalMenuTableViewCellIndentifier = @"WARPopHorizontalMenuTableViewCellIndentifier";
static NSString  *const WARPopHorizontalMenuImageCacheDirectory = @"com.WARPopHorizontalMenuImageCache";
/**
 *  WARPopHorizontalMenuArrowDirection
 */
typedef NS_ENUM(NSUInteger, WARPopHorizontalMenuArrowDirection) {
    /**
     *  Up
     */
    WARPopHorizontalMenuArrowDirectionUp,
    /**
     *  Down
     */
    WARPopHorizontalMenuArrowDirectionDown,
};

#pragma mark - WARPopHorizontalMenuConfiguration

@interface WARPopHorizontalMenuConfiguration ()

@end

@implementation WARPopHorizontalMenuConfiguration

+ (WARPopHorizontalMenuConfiguration *)defaultConfiguration
{
    static dispatch_once_t once = 0;
    static WARPopHorizontalMenuConfiguration *configuration;
    dispatch_once(&once, ^{ configuration = [[WARPopHorizontalMenuConfiguration alloc] init]; });
    return configuration;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuRowHeight = WARDefaultMenuRowHeight;
        self.menuWidth = WARDefaultMenuWidth;
        self.textColor = COLOR_WORD_GRAY_6;//WARDefaultTextColor;
        self.textFont = WARDefaultMenuFont;
        self.tintColor = [UIColor whiteColor];//WARDefaultTintColor;
        self.borderColor = WARDefaultTintColor;
        self.borderWidth = 0;//WARDefaultMenuBorderWidth;
        self.textAlignment = NSTextAlignmentLeft;
        self.ignoreImageOriginalColor = NO;
        self.allowRoundedArrow = NO;
        self.menuTextMargin = WARDefaultMenuTextMargin;
        self.menuIconMargin = WARDefaultMenuIconMargin;
        self.animationDuration = WARDefaultAnimationDuration;
        self.needArrow = YES;
    }
    return self;
}

@end

#pragma mark - WARPopHorizontalMenuCell

@interface WARPopHorizontalMenuCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *menuNameLabel;

@end

@implementation WARPopHorizontalMenuCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.menuNameLabel];
         
    }
    return self;
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

-(UILabel *)menuNameLabel
{
    if (!_menuNameLabel) {
        _menuNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _menuNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _menuNameLabel;
}

-(void)setupWithMenuImage:(id )menuImage title:(NSString *)title {
    WARPopHorizontalMenuConfiguration *configuration = [WARPopHorizontalMenuConfiguration defaultConfiguration];
    
    CGFloat margin = (configuration.menuRowHeight - WARDefaultMenuIconSize)/2.f;
    CGRect iconImageRect = CGRectMake(configuration.menuIconMargin, margin - WARDefaultMenuArrowHeight * 0.5, WARDefaultMenuIconSize, WARDefaultMenuIconSize);
    
    UIImage *image = nil;
    if ([menuImage isKindOfClass:[UIImage class]]) {
        image = (UIImage *)menuImage;
    }else {
        image = [UIImage war_imageName:menuImage curClass:[self class] curBundle:@"WARProfile.bundle"];
    }
    
    CGRect newiconImageRect = CGRectMake(iconImageRect.origin.x + (iconImageRect.size.width - image.size.width) /2 , iconImageRect.origin.y + (iconImageRect.size.height - image.size.height) /2 , image.size.width, image.size.height);
    
    self.iconImageView.frame = newiconImageRect;
    self.iconImageView.tintColor = configuration.textColor;
    self.iconImageView.image = image;
    
    CGFloat menuNameX = newiconImageRect.origin.x + newiconImageRect.size.width + configuration.menuTextMargin;
    CGRect menuNameRect = CGRectMake(menuNameX, - WARDefaultMenuArrowHeight * 0.5, configuration.menuWidth - menuNameX - configuration.menuTextMargin, configuration.menuRowHeight);
    
    if (!menuImage) {
        menuNameRect = CGRectMake(configuration.menuTextMargin,  - WARDefaultMenuArrowHeight * 0.5, configuration.menuWidth - configuration.menuTextMargin*2, configuration.menuRowHeight);
    }else{
        self.iconImageView.frame = newiconImageRect;
        self.iconImageView.tintColor = configuration.textColor;
        self.iconImageView.image = image; 
    }
    
    if (title) {
        self.menuNameLabel.frame = menuNameRect;
        self.menuNameLabel.font = configuration.textFont;
        self.menuNameLabel.textColor = configuration.textColor;
        self.menuNameLabel.textAlignment = configuration.textAlignment;
        self.menuNameLabel.text = title;
    } else {
        self.menuNameLabel.text = @"";
        newiconImageRect = CGRectMake((self.bounds.size.width - image.size.width) / 2 , iconImageRect.origin.y + (iconImageRect.size.height - image.size.height) /2 , image.size.width, image.size.height);
        self.iconImageView.frame = newiconImageRect;
    }
}

@end



#pragma mark - WARPopHorizontalMenuView

@interface WARPopHorizontalMenuView ()
@property (nonatomic, assign) WARPopHorizontalMenuArrowDirection arrowDirection;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;

@end

@implementation WARPopHorizontalMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = HEXCOLOR(0x4B5054);
    UIImage *likeImage = [UIImage war_imageName:@"momentheart_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
    UIImage *commentImage = [UIImage war_imageName:@"momentcomment_n" curClass:[self class] curBundle:@"WARProfile.bundle"];
    _likeButton = [self creatButtonWithTitle:@"赞" image:likeImage selImage:likeImage target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:commentImage selImage:commentImage target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = HEXCOLOR(0x373C40);
    
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 0;
    
    _likeButton.sd_layout
    .leftSpaceToView(self, margin)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(89.5);
    
    centerLine.sd_layout
    .leftSpaceToView(_likeButton, margin)
    .topSpaceToView(self, 7.5)
    .bottomSpaceToView(self, 7.5)
    .widthIs(0.5);
    
    _commentButton.sd_layout
    .leftSpaceToView(centerLine, margin)
    .topEqualToView(_likeButton)
    .bottomEqualToView(_likeButton)
    .widthRatioToView(_likeButton, 1);
    
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -5);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
}



-(CGFloat)menuArrowWidth
{
    return [WARPopHorizontalMenuConfiguration defaultConfiguration].allowRoundedArrow ? WARDefaultMenuArrowWidth_R : WARDefaultMenuArrowWidth;
}
-(CGFloat)menuArrowHeight
{
    return [WARPopHorizontalMenuConfiguration defaultConfiguration].allowRoundedArrow ? WARDefaultMenuArrowHeight_R : WARDefaultMenuArrowHeight;
}

-(void)showWithFrame:(CGRect )frame
          anglePoint:(CGPoint )anglePoint
      imageNameArray:(NSArray *)imageNameArray
      titleArray:(NSArray *)titleArray
    shouldAutoScroll:(BOOL)shouldAutoScroll
      arrowDirection:(WARPopHorizontalMenuArrowDirection)arrowDirection
           doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
{
    self.frame = frame;
    
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}

-(void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint
{
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL allowRoundedArrow = [WARPopHorizontalMenuConfiguration defaultConfiguration].allowRoundedArrow;
    BOOL needArrow = [WARPopHorizontalMenuConfiguration defaultConfiguration].needArrow;

    CGFloat offset = 2.f*WARDefaultMenuArrowRoundRadius*sinf(M_PI_4/2.f);
    CGFloat roundcenterHeight = offset + WARDefaultMenuArrowRoundRadius*sqrtf(2.f);
    CGPoint roundcenterPoint = CGPointMake(anglePoint.x, roundcenterHeight);
    
    switch (_arrowDirection) {
        case WARPopHorizontalMenuArrowDirectionUp:{
            if (needArrow) {
                if (allowRoundedArrow) {
                    [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight - 2.f*WARDefaultMenuArrowRoundRadius) radius:2.f*WARDefaultMenuArrowRoundRadius startAngle:M_PI_2 endAngle:M_PI_4*3.f clockwise:YES];
                    [path addLineToPoint:CGPointMake(anglePoint.x + WARDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y - WARDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                    [path addArcWithCenter:roundcenterPoint radius:WARDefaultMenuArrowRoundRadius startAngle:M_PI_4*7.f endAngle:M_PI_4*5.f clockwise:NO];
                    [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), self.menuArrowHeight - offset/sqrtf(2.f))];
                    [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, self.menuArrowHeight - 2.f*WARDefaultMenuArrowRoundRadius) radius:2.f*WARDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
                } else {
                    [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight)];
                    [path addLineToPoint:anglePoint];
                    [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, self.menuArrowHeight)];
                }
            }
            
            [path addLineToPoint:CGPointMake( WARDefaultMenuCornerRadius, self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(WARDefaultMenuCornerRadius, self.menuArrowHeight + WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake( 0, self.bounds.size.height - WARDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(WARDefaultMenuCornerRadius, self.bounds.size.height - WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - WARDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - WARDefaultMenuCornerRadius, self.bounds.size.height - WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , WARDefaultMenuCornerRadius + self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - WARDefaultMenuCornerRadius, WARDefaultMenuCornerRadius + self.menuArrowHeight) radius:WARDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path closePath];
            
        }break;
        case WARPopHorizontalMenuArrowDirectionDown:{
            
            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);
            if (needArrow) {
                if (allowRoundedArrow) {
                    [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*WARDefaultMenuArrowRoundRadius) radius:2.f*WARDefaultMenuArrowRoundRadius startAngle:M_PI_2*3 endAngle:M_PI_4*5.f clockwise:NO];
                    [path addLineToPoint:CGPointMake(anglePoint.x + WARDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y + WARDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                    [path addArcWithCenter:roundcenterPoint radius:WARDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_4*3.f clockwise:YES];
                    [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), anglePoint.y - self.menuArrowHeight + offset/sqrtf(2.f))];
                    [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*WARDefaultMenuArrowRoundRadius) radius:2.f*WARDefaultMenuArrowRoundRadius startAngle:M_PI_4*7 endAngle:M_PI_2*3 clockwise:NO];
                } else {
                    [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
                    [path addLineToPoint:anglePoint];
                    [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
                }
            }
            
            [path addLineToPoint:CGPointMake( WARDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(WARDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight - WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0, WARDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(WARDefaultMenuCornerRadius, WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - WARDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - WARDefaultMenuCornerRadius, WARDefaultMenuCornerRadius) radius:WARDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (WARDefaultMenuCornerRadius + self.menuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - WARDefaultMenuCornerRadius, anglePoint.y - (WARDefaultMenuCornerRadius + self.menuArrowHeight)) radius:WARDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path closePath];
            
        }break;
        default:
            break;
    }
    
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = [WARPopHorizontalMenuConfiguration defaultConfiguration].borderWidth;
    _backgroundLayer.fillColor = [WARPopHorizontalMenuConfiguration defaultConfiguration].tintColor.CGColor;
    _backgroundLayer.strokeColor = [WARPopHorizontalMenuConfiguration defaultConfiguration].borderColor.CGColor;
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
}


@end


#pragma mark WARPopHorizontalMenu

@interface WARPopHorizontalMenu () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) WARPopHorizontalMenuView *popMenuView;
@property (nonatomic, strong) WARPopHorizontalMenuDoneBlock doneBlock;
@property (nonatomic, strong) WARPopHorizontalMenuDismissBlock dismissBlock;

//@property (nonatomic, strong) WARMomentCellOperationMenu *popMenuView;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) NSArray<NSString*> *menuImageArray;
@property (nonatomic, strong) NSArray<NSString*> *menuTitleArray;
@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@end

@implementation WARPopHorizontalMenu

+ (WARPopHorizontalMenu *)sharedInstance
{
    static dispatch_once_t once = 0;
    static WARPopHorizontalMenu *shared;
    dispatch_once(&once, ^{ shared = [[WARPopHorizontalMenu alloc] init]; });
    return shared;
}

#pragma mark - Public Method

+ (void) showFromSenderFrame:(CGRect )senderFrame 
                  imageArray:(NSArray *)imageArray
                   doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
                dismissBlock:(WARPopHorizontalMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame imageNameArray:imageArray titleArray:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}


+ (void) showFromSenderFrame:(CGRect )senderFrame
                  imageArray:(NSArray *)imageArray
                  titleArray:(NSArray *)titleArray
                   doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
                dismissBlock:(WARPopHorizontalMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame imageNameArray:imageArray titleArray:titleArray doneBlock:doneBlock dismissBlock:dismissBlock];
}

+(void)dismiss
{
    [[self sharedInstance] dismiss];
}

#pragma mark - Private Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

-(WARPopHorizontalMenuView *)popMenuView
{
    if (!_popMenuView) {
        _popMenuView = [[WARPopHorizontalMenuView alloc] initWithFrame:CGRectMake(0, 0, 180, 39)];
        _popMenuView.alpha = 0;
        __weak typeof(self) weakSelf = self;
        _popMenuView.likeButtonClickedOperation = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.doneBlock) {
                strongSelf.doneBlock(0);
            }
            [strongSelf dismiss];
        };
        _popMenuView.commentButtonClickedOperation = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.doneBlock) {
                strongSelf.doneBlock(1);
            }
            [strongSelf dismiss];
        };
    }
    return _popMenuView;
}

-(CGFloat)menuArrowWidth
{
    return [WARPopHorizontalMenuConfiguration defaultConfiguration].allowRoundedArrow ? WARDefaultMenuArrowWidth_R : WARDefaultMenuArrowWidth;
}
-(CGFloat)menuArrowHeight
{
    return [WARPopHorizontalMenuConfiguration defaultConfiguration].allowRoundedArrow ? WARDefaultMenuArrowHeight_R : WARDefaultMenuArrowHeight;
}

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

- (void) showForSender:(UIView *)sender
           senderFrame:(CGRect )senderFrame
        imageNameArray:(NSArray<NSString*> *)imageNameArray
        titleArray:(NSArray<NSString*> *)titleArray
             doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
          dismissBlock:(WARPopHorizontalMenuDismissBlock)dismissBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backgroundView addSubview:self.popMenuView];
        [[self backgroundWindow] addSubview:self.backgroundView];
        
        self.sender = sender;
        self.senderFrame = senderFrame;
        self.doneBlock = doneBlock;
        self.dismissBlock = dismissBlock;
        self.menuImageArray = imageNameArray;
        self.menuTitleArray = titleArray;
        
        [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth = 180;
        
        [self adjustPopOverMenu];
    });
}

-(void)adjustPopOverMenu
{
    
    [self.backgroundView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    
    CGRect senderRect ;
    
    if (self.sender) {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
    }else{
        senderRect = self.senderFrame;
    }
    if (senderRect.origin.y > KSCREEN_HEIGHT) {
        senderRect.origin.y = KSCREEN_HEIGHT;
    }
    
    CGFloat menuHeight = [WARPopHorizontalMenuConfiguration defaultConfiguration].menuRowHeight;
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width)/2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    BOOL shouldAutoScroll = NO;
    WARPopHorizontalMenuArrowDirection arrowDirection;
    
    if (senderRect.origin.y + senderRect.size.height/2  < KSCREEN_HEIGHT/2) {
        arrowDirection = WARPopHorizontalMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
    }else{
        arrowDirection = WARPopHorizontalMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;
        
    }
    
    if (menuArrowPoint.x + [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth/2 + WARDefaultMargin > KSCREEN_WIDTH) {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (KSCREEN_WIDTH - [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth - WARDefaultMargin), [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth - self.menuArrowWidth - WARDefaultMargin);
        menuX = KSCREEN_WIDTH - [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth - WARDefaultMargin;
    }else if ( menuArrowPoint.x - [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth/2 - WARDefaultMargin < 0){
        menuArrowPoint.x = MAX( WARDefaultMenuCornerRadius + self.menuArrowWidth, menuArrowPoint.x - WARDefaultMargin);
        menuX = WARDefaultMargin;
    }else{
        menuArrowPoint.x = [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth/2;
        menuX = senderRect.origin.x + (senderRect.size.width)/2 - [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth/2;
    }
    menuRect = CGRectMake(menuX - senderRect.size.width - 15.5, (senderRect.origin.y - (senderRect.size.height) * 0.5), [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth, menuHeight);
  
    [self prepareToShowWithMenuRect:menuRect
                     menuArrowPoint:menuArrowPoint
                   shouldAutoScroll:shouldAutoScroll
                     arrowDirection:arrowDirection];
    
    [self show];
}

-(void)prepareToShowWithMenuRect:(CGRect)menuRect menuArrowPoint:(CGPoint)menuArrowPoint shouldAutoScroll:(BOOL)shouldAutoScroll arrowDirection:(WARPopHorizontalMenuArrowDirection)arrowDirection
{
    CGPoint anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 0);
    if (arrowDirection == WARPopHorizontalMenuArrowDirectionDown) {
        anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 1);
    }
    _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
    
    [_popMenuView showWithFrame:menuRect
                     anglePoint:menuArrowPoint
                 imageNameArray:self.menuImageArray
                     titleArray:self.menuTitleArray
               shouldAutoScroll:shouldAutoScroll
                 arrowDirection:arrowDirection
                      doneBlock:^(NSInteger selectedIndex) {
                          [self doneActionWithSelectedIndex:selectedIndex];
                      }];
    
    [self setAnchorPoint:anchorPoint forView:_popMenuView];
    
    _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}


-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    CGPoint point = [touch locationInView:_popMenuView];
//    NSString *classString = NSStringFromClass([touch.view class]);
//    if ([classString isEqualToString:@"UIView"]) {
//        if (!CGRectContainsPoint(CGRectMake(0, 0, [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth, [WARPopHorizontalMenuConfiguration defaultConfiguration].menuRowHeight), point)) {
//            [self dismiss];
//        }
//        return NO;
//    }else if (CGRectContainsPoint(CGRectMake(0, 0, [WARPopHorizontalMenuConfiguration defaultConfiguration].menuWidth, [WARPopHorizontalMenuConfiguration defaultConfiguration].menuRowHeight), point)) {
//        [self doneActionWithSelectedIndex:0];
//        return NO;
//    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

#pragma mark - show animation

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:WARDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 1;
                         _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

#pragma mark - dismiss animation

- (void)dismiss
{
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectedIndex:-1];
}

#pragma mark - doneActionWithSelectedIndex

-(void)doneActionWithSelectedIndex:(NSInteger)selectedIndex
{
    [UIView animateWithDuration:WARDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 0;
                         _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }completion:^(BOOL finished) {
                         if (finished) {
                             [self.popMenuView removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             if (selectedIndex < 0) {
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             }else{
                                 if (self.doneBlock) {
                                     self.doneBlock(selectedIndex);
                                 }
                             }
                         }
                     }];
}
@end
