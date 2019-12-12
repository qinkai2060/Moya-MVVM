//
//  WARCycleOfFriendNavigationBar.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/10.
//

#import "WARCycleOfFriendNavigationBar.h"

#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
//#import "UIImage+Tint.h"

#import "Masonry.h"
#import "WARMacros.h"

@interface WARCycleOfFriendNavigationBar()

@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIButton *filterButton;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UIButton *eventButton;

@end

@implementation WARCycleOfFriendNavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews {
    [self addSubview:self.backButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.filterButton];
    [self addSubview:self.titleButton];
    [self addSubview:self.eventButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).mas_offset(kStatusBarHeight);
        make.centerY.equalTo(self.titleButton);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(self.height - kStatusBarHeight));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).mas_offset(11+kStatusBarHeight);
        make.top.equalTo(self).mas_offset(kStatusBarHeight);
        make.right.equalTo(self).offset(-14);//-14
        make.width.mas_equalTo(22);
        make.centerY.equalTo(self.titleButton);
        make.height.mas_equalTo(self.rightButton.mas_width).multipliedBy(1);
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).mas_offset(11+kStatusBarHeight);
        make.top.equalTo(self).mas_offset(kStatusBarHeight);
        make.right.equalTo(self.rightButton.mas_left).offset(-16);
        make.centerY.equalTo(self.titleButton);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(self.filterButton.mas_width).multipliedBy(1);
    }];
    //    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self).mas_offset(11+kStatusBarHeight);
//        make.top.equalTo(self).mas_offset(kStatusBarHeight);
//        make.right.equalTo(self).offset(-14);//-14
////        make.centerX.equalTo(self).offset(kScreenWidth - 14 - 25);
//        make.centerY.equalTo(self.titleButton);
//        make.height.mas_equalTo(self.rightButton.mas_width).multipliedBy(1);
//    }];
//    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self).mas_offset(11+kStatusBarHeight);
//        make.top.equalTo(self).mas_offset(kStatusBarHeight);
//        make.right.equalTo(self.rightButton.mas_left).offset(-8 );
//        make.centerY.equalTo(self.titleButton);
//        make.width.mas_equalTo(@(self.height - kStatusBarHeight));
//        make.height.mas_equalTo(self.filterButton.mas_width).multipliedBy(1);
//    }];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(kStatusBarHeight);
        make.centerX.equalTo(self);
        make.width.equalTo(@200);
        make.height.mas_equalTo(self).mas_offset(self.height - kStatusBarHeight);
    }];
    
    //    [self.eventButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //       make.edges.mas_equalTo(self);
    //    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)scrollWithScale:(CGFloat)scale fontScale:(CGFloat)fontScale changeAlpha:(BOOL)changeAlpha{
    UIColor *backgroundColor;
    UIColor *titleColor;
    UIFont *titleFont;
    UIColor *itemColor;
    if (changeAlpha) {
        backgroundColor = [HEXCOLOR(0xF3F3F3) colorWithAlphaComponent:scale];
        titleColor = [HEXCOLOR(0x343C4F) colorWithAlphaComponent:scale];
        itemColor = [UIColor colorWithWhite:1 alpha:scale];
    }else {
        backgroundColor = HEXCOLOR(0xF3F3F3);
        titleColor = HEXCOLOR(0x343C4F);
        itemColor = UIColorWhite;
    }
    titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * fontScale];
    
    self.backgroundColor = backgroundColor;
    [self.titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = titleFont;
    
    if (scale > 0) {
//        [self.backButton setTitle:@"      " forState:UIControlStateNormal];
        [self.backButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage war_imageName:@"back_pengyouquanb" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage war_imageName:@"mail_friend_carema3" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.filterButton setImage:[UIImage war_imageName:@"message_group_nor" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
 
//        [self.backButton setImage:[self imageCompressWithSimple:[UIImage war_imageName:@"back_pengyouquanb" curClass:[self class] curBundle:@"WARProfile.bundle"] scale:fontScale] forState:UIControlStateNormal];
//        self.backButton.titleLabel.font = titleFont;
//        [self.rightButton setImage:[self imageCompressWithSimple:[UIImage war_imageName:@"mail_friend_carema3" curClass:[self class] curBundle:@"WARProfile.bundle"] scale:fontScale] forState:UIControlStateNormal];
//        [self.filterButton setImage:[self imageCompressWithSimple:[UIImage war_imageName:@"message_group_nor" curClass:[self class] curBundle:@"WARProfile.bundle"] scale:fontScale] forState:UIControlStateNormal];
    } else {
//        [self.backButton setTitle:@" 发现" forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage war_imageName:@"back_pengyouquan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self.rightButton setImage:[UIImage war_imageName:@"mail_friend_carema2" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.filterButton setImage:[UIImage war_imageName:@"message_group" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    
//    CGFloat titleW = 200;
//    CGFloat titleH = (self.height > kStatusBarAndNavigationBarHeight ? kStatusBarAndNavigationBarHeight : self.height) - kStatusBarHeight;
//    CGFloat titleX = (kScreenWidth - titleW) * 0.5;
//    CGFloat titleY = kStatusBarHeight;
//    self.titleButton.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
//    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-7);
//        make.width.mas_equalTo(@(self.height - kStatusBarHeight)).multipliedBy(1);
//    }];
//    [self.filterButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.rightButton.mas_left).offset(-7);
//        make.width.mas_equalTo(@(self.height - kStatusBarHeight)).multipliedBy(1);
//    }];
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale {
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    
    scaledWidth = scaledWidth < 16 ? 16 : scaledWidth;
    scaledHeight = scaledHeight < 16 ? 16 : scaledHeight;
    
    UIGraphicsBeginImageContext(size); // this will crop
//    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    [image drawInRect:CGRectMake(0,0,MIN(scaledWidth, scaledHeight),MIN(scaledWidth, scaledHeight))];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)leftClick:(UIButton*)btn{
    if (self.didLeftItemBlcok) {
        self.didLeftItemBlcok();
    }
}
- (void)rightClick:(UIButton*)btn{
    if (self.didRightItemBlcok) {
        self.didRightItemBlcok();
    }
}
- (void)filterClick:(UIButton*)btn{
    if (self.didFilterBlock) {
        self.didFilterBlock();
    }
}
- (void)didBarEvent:(UIButton*)btn{
    self.height = kStatusBarAndNavigationBarHeight;
    
    if (self.didBarBlock) {
        self.didBarBlock();
    }
}
- (void)titleClick {
    [self scrollWithScale:1 fontScale:1 changeAlpha:YES];
    self.height = kStatusBarAndNavigationBarHeight;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage war_imageName:@"back_pengyouquan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
//        _backButton.backgroundColor = [UIColor purpleColor];
        [_backButton setTitle:@"发现" forState:UIControlStateNormal];
        _backButton.adjustsImageWhenHighlighted = NO;
        [_backButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _backButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _backButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setImage:[UIImage war_imageName:@"mail_friend_carema2" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
//        _rightButton.backgroundColor = [UIColor blueColor];
        _rightButton.adjustsImageWhenHighlighted = NO;
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIButton *)filterButton{
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] init];
        [_filterButton setImage:[UIImage war_imageName:@"message_group" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
//        _filterButton.backgroundColor = [UIColor orangeColor];
        _filterButton.adjustsImageWhenHighlighted = NO;
        [_filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _filterButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_filterButton addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        _titleButton.adjustsImageWhenHighlighted = NO;
//        _titleButton.backgroundColor = [UIColor redColor];
        [_titleButton setTitleColor:[HEXCOLOR(0x343C4F) colorWithAlphaComponent:0] forState:UIControlStateNormal];
        [_titleButton setTitle:WARLocalizedString(@"朋友圈") forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [_titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
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
