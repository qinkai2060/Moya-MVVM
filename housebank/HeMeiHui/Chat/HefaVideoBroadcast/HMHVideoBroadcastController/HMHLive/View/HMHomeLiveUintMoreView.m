//
//  HMHomeLiveUintMoreView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHomeLiveUintMoreView.h"

@interface HMHomeLiveUintMoreView()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *moreButton;

@end

@implementation HMHomeLiveUintMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setSubview];
        
        [self bindMessage];
    }
    return self;
}


- (void)setSubview {
    
    UILabel *titleLabel = [UILabel wd_labelWithText:@"直播频道" font:16 textColorStr:@"#333333"];
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:0];
    self.moreButton = moreButton;
    [self addSubview:moreButton];
    [moreButton setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [moreButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:[UIFont systemFontOfSize:WScale(13)]];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(self.mas_leading).mas_offset(WScale(15));
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.width.mas_equalTo(WScale(70));
    }];
    
}

- (void)bindMessage {
    
    @weakify(self)
    [[self.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self sendNotificationName:HMHliveMoreNotification Object:self.moreModel];
    }];
    
}

- (void)setType:(HMHomeLiveMoreType)type {
    _type = type;
    
    NSString *title = nil;
    switch (type) {
        case HMHomeLiveMoreType_Channel:
        {
            title = @"直播频道";
            break;
        }
        case HMHomeLiveMoreType_Consult:
        {
            title = @"最新资讯";
            break;
        }
        case HMHomeLiveMoreType_ShortVideo:
        {
            title = @"短视频";
            break;
        }
        case HMHomeLiveMoreType_Recommend:
        {
            title = @"编辑推荐";
            break;
        }
        case HMHomeLiveMoreType_Activity:
        {
            //这块后加的 model 跟之前的格式不一样
            self.moreModel = [[HMHLiveMoreModel alloc] init];
            self.moreModel.text = @"活动精选";
            self.moreButton.hidden = YES;
            title = @"活动精选";
            break;
        }
        default:
            break;
    }
    
    if (title) {
        [self.titleLabel setText:title];
    }
}

@end
