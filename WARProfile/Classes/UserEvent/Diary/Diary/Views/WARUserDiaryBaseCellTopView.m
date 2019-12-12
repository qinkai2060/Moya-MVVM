//
//  WARUserDiaryBaseCellTopView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARUserDiaryBaseCellTopView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARNewUserDiaryModel.h"
#import "WARNewUserDiaryMomentLayout.h"
#import "NSDate+Formatter.h"

#define kSeparatorH 0.5

@interface WARUserDiaryBaseCellTopView()

@property (nonatomic, strong) UIView * separatorView;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) NSMutableArray <UIButton *> *platformViews;

@end

@implementation WARUserDiaryBaseCellTopView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.separatorView];
    [self addSubview:self.timeLable];
//    [self addSubview:self.weatherImageView];
    
    //发布到的平台
    NSMutableArray *platformViews = [NSMutableArray array];
    
    UIImage *image = [UIImage war_imageName:@"person_home_zone" curClass:[self class] curBundle:@"WARProfile.bundle"];
    for (int i = 0; i < 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(platformAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.tag = WARUserDiaryPlatformTypeFriend;
            image = [UIImage war_imageName:@"person_home_zone" curClass:[self class] curBundle:@"WARProfile.bundle"];
        } else if (i == 1) {
            button.tag = WARUserDiaryPlatformTypeDouBan;
            image = [UIImage war_imageName:@"person_home_zone" curClass:[self class] curBundle:@"WARProfile.bundle"];
        } else if (i == 2) {
            button.tag = WARUserDiaryPlatformTypeFriend;
            image = [UIImage war_imageName:@"person_home_zone" curClass:[self class] curBundle:@"WARProfile.bundle"];
        } 
        [button setImage:image forState:UIControlStateNormal];
        CGFloat x = 9 + (12 + 3) * (i);
        CGFloat y = 49 + kSeparatorH;
        CGFloat w = 12;
        CGFloat h = 12;
        button.frame =CGRectMake(x, y, w, h);
        button.backgroundColor = [UIColor whiteColor];
        [platformViews addObject:button];
        [self addSubview:button];
    }
    _platformViews = platformViews;
}

#pragma mark - Event Response

- (void)platformAction:(UIButton *)button {
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMoment:(WARNewUserDiaryMoment *)moment {
    _moment = moment;
    
    self.timeLable.attributedText = moment.publishTimeAttributedString;
    self.weatherImageView.image = nil;
    switch (moment.weatherType) {
        case WARWeatherTypeSunny:
        {
            self.weatherImageView.image = [UIImage war_imageName:@"weather_sunny" curClass:[self class] curBundle:@"WARProfile.bundle"];
            break;
        }
        case WARWeatherTypeCloudy:
        {
            self.weatherImageView.image = [UIImage war_imageName:@"weather_cloudy" curClass:[self class] curBundle:@"WARProfile.bundle"];
            break;
        }
        case WARWeatherTypeRain:
        {
            self.weatherImageView.image = [UIImage war_imageName:@"weather_rain" curClass:[self class] curBundle:@"WARProfile.bundle"];
            break;
        }
    }
    
}
 
- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.frame = CGRectMake(0, 0, kScreenWidth, kSeparatorH);
        _separatorView.backgroundColor = HEXCOLOR(0xE1E1DF);
    }
    return _separatorView;
}

- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.frame = CGRectMake(7, 20 + kSeparatorH, 63.5, 20);
        _timeLable.font = [UIFont systemFontOfSize:12];
        _timeLable.textColor = HEXCOLOR(0x8D93A4);
    }
    return _timeLable;
}

- (UIImageView *)weatherImageView{
    if (!_weatherImageView) {//weather_rain  //weather_cloudy  //weather_sunny 
        _weatherImageView = [[UIImageView alloc]init];
        _weatherImageView.frame = CGRectMake(9, 49 + kSeparatorH, 12, 12);
    }
    return _weatherImageView;
}

- (NSMutableArray <UIButton *> *)platformViews {
    if (!_platformViews) {
        _platformViews = [NSMutableArray array];
    }
    return _platformViews;
}


@end
