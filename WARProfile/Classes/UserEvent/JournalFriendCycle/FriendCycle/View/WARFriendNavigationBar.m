//
//  WARFriendNavigationBar.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/31.
//

#import "WARFriendNavigationBar.h"
#import "UIView+Frame.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
 
#define kHeaderView (347)

@interface WARFriendNavigationBar()

@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIButton *rightbutton;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UIButton *eventButton;

@end

@implementation WARFriendNavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews {
    [self addSubview:self.button];
    [self addSubview:self.rightbutton];
    [self addSubview:self.titleButton];
    [self addSubview:self.eventButton];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(11);
        make.top.equalTo(self).mas_offset(13+kStatusBarHeight);
//        make.width.equalTo(@60);
//        make.height.equalTo(@30);
    }];
    [self.rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(13+kStatusBarHeight);
        make.right.equalTo(self).offset(-14);
//        make.width.equalTo(@45);
//        make.height.equalTo(@30);
    }];
    
//    [self.eventButton mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.edges.mas_equalTo(self);
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)scrollWithScale:(CGFloat)scale fontScale:(CGFloat)fontScale changeAlpha:(BOOL)changeAlpha{
    CGFloat detal = 1 - scale;
//    NSLog(@"detal:%.2f---scale:%.2f---fontScale:%.2f",detal,scale,fontScale);
    
    UIColor *backgroundColor;
    UIColor *titleColor;
    UIColor *itemColor;
    UIFont *titleFont;
    if (changeAlpha) {
        backgroundColor = [HEXCOLOR(0xF3F3F3) colorWithAlphaComponent:scale];
        titleColor = [[UIColor blackColor] colorWithAlphaComponent:scale];
        itemColor = [UIColor colorWithWhite:1 alpha:scale];

        self.button.alpha = detal;
        self.rightbutton.alpha = detal;
    }else {
        backgroundColor = HEXCOLOR(0xF3F3F3);
        titleColor = [UIColor blackColor];
        itemColor = UIColorWhite;
    }
    titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * ((fontScale > 1 ? 1 : fontScale) <= 0.4 ? 0.4 : (fontScale > 1 ? 1 : fontScale))];
    
    self.backgroundColor = backgroundColor;
    [self.titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = titleFont;
    
    if (scale > 0) {
        [self.button setImage:[self imageCompressWithSimple:[UIImage war_imageName:@"back_pengyouquanb" curClass:[self class] curBundle:@"WARProfile.bundle"] scale:fontScale] forState:UIControlStateNormal];
        [self.button setTitleColor:titleColor forState:UIControlStateNormal];
        
        self.button.titleLabel.font = titleFont;
        
        [_rightbutton setImage:[self imageCompressWithSimple:[UIImage war_imageName:@"mail_friend_carema3" curClass:[self class] curBundle:@"WARProfile.bundle"] scale:fontScale] forState:UIControlStateNormal];
        
        self.button.alpha = 1;
        self.rightbutton.alpha = 1;
    }
    else {
        [self.button setImage:[UIImage war_imageName:@"back_pengyouquan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
        [_rightbutton setImage:[UIImage war_imageName:@"mail_friend_carema2" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }

//    [self setNeedsDisplay];
    CGFloat titleW = 200;
    CGFloat titleH = 30;
    CGFloat titleX = (kScreenWidth - titleW) * 0.5;
    CGFloat titleY = (self.height - kStatusBarHeight - titleH) * 0.5 + kStatusBarHeight;
    self.titleButton.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(11);
        make.centerY.equalTo(self.titleButton);
    }];
    [self.rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-14);
        make.centerY.equalTo(self.titleButton);
    }];
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale {
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(size); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)lefttHandlerClick:(UIButton*)btn{
    if (self.leftHandler) {
        self.leftHandler();
    }
}
- (void)rightHandlerClick:(UIButton*)btn{
    if (self.rightHandler) {
        self.rightHandler();
    }
}
- (void)didBarEvent:(UIButton*)btn{
    if (self.didBarHandler) {
        self.didBarHandler();
    }
}

- (void)titleHandlerClick {
    [self scrollWithScale:1 fontScale:1 changeAlpha:YES];
    if (self.titleHandler) {
        self.titleHandler();
    }
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setImage:[UIImage war_imageName:@"back_pengyouquan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_button setTitle:@" 发现" forState:UIControlStateNormal];
        _button.adjustsImageWhenHighlighted = NO;
        [_button addTarget:self action:@selector(lefttHandlerClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _button;
}
- (UIButton *)rightbutton{
    if (!_rightbutton) {
        _rightbutton = [[UIButton alloc] init];
        [_rightbutton setImage:[UIImage war_imageName:@"mail_friend_carema" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        _rightbutton.adjustsImageWhenHighlighted = NO;
        [_rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightbutton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightbutton addTarget:self action:@selector(rightHandlerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightbutton;
} 
- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        _titleButton.adjustsImageWhenHighlighted = NO;
        [_titleButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0] forState:UIControlStateNormal];
        [_titleButton setTitle:@"朋友圈" forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [_titleButton addTarget:self action:@selector(titleHandlerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}
- (UIButton *)eventButton{
    if (!_eventButton) {
        _eventButton = [[UIButton alloc] init];
        _eventButton.adjustsImageWhenHighlighted = NO;
        [_eventButton addTarget:self action:@selector(didBarEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eventButton;
}

@end
