//
//  WARMomentTraceInfoView.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

#import "WARMomentTrackInfoView.h"

#import "WARMacros.h"

@interface WARMomentTrackInfoView()
/** title */
@property (nonatomic, strong) UILabel *mainTitleLable; 
/** 地址 */
@property (nonatomic, strong) UILabel *locationLable;
/** 分享中 */
@property (nonatomic, strong) UIButton *shareButton;
/** 激活 */
@property (nonatomic, strong) UIButton *activationButton;

/** trackType */
@property (nonatomic, assign) WARMomentTrackType trackType;
@end

@implementation WARMomentTrackInfoView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame trackType:(WARMomentTrackType)trackType {
    self = [super initWithFrame:frame];
    if (self) {
        self.trackType = trackType;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xF3F3F5);
    
    [self addSubview:self.mainTitleLable];
    [self addSubview:self.locationLable];
    [self addSubview:self.shareButton];
    [self addSubview:self.activationButton];
}

#pragma mark - Event Response

- (void)shareAction:(UIButton *)button {
    
}

- (void)activationAction:(UIButton *)button {
    
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARMomentTrackInfoLayout *)layout {
    _layout = layout;
    
    WARMomentTraceInfo *trace = layout.traceInfo;
    
    /// data
    self.mainTitleLable.text = trace.locInfo;
    self.locationLable.text = trace.location;
    switch (self.trackType) {
        case WARMomentTrackTypeMine: /// 自己探索
        {
            self.shareButton.hidden = NO;
            self.activationButton.hidden = YES;
        }
            break;
        case WARMomentTrackTypeActivation: /// 激活探索
        {
            self.shareButton.hidden = YES;
            self.activationButton.hidden = YES;
        }
            break;
        case WARMomentTrackTypeOther: /// 他人足迹
        {
            self.shareButton.hidden = YES;
            self.activationButton.hidden = NO;
        }
            break;
    }
    
    /// frame
    self.mainTitleLable.frame = layout.mainTitleF;
    self.locationLable.frame = layout.locationF;
    self.shareButton.frame = layout.shareF;
    self.activationButton.frame = layout.activitionF;
}

- (UILabel *)mainTitleLable {
    if (!_mainTitleLable) {
        _mainTitleLable = [[UILabel alloc]init];
        _mainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _mainTitleLable.numberOfLines = 1;
        _mainTitleLable.textAlignment = NSTextAlignmentLeft;
        _mainTitleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _mainTitleLable;
}

- (UILabel *)locationLable {
    if (!_locationLable) {
        _locationLable = [[UILabel alloc]init];
        _locationLable.numberOfLines = 1;
        _locationLable.textAlignment = NSTextAlignmentLeft;
        _locationLable.textColor = HEXCOLOR(0x8D93A4);
        _locationLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _locationLable;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.adjustsImageWhenHighlighted = NO;
        [_shareButton setTitle:WARLocalizedString(@"分享中") forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareButton.backgroundColor = HEXCOLOR(0xADB1BE);
        _shareButton.layer.cornerRadius = 2;
        _shareButton.layer.masksToBounds = YES;
    }
    return _shareButton;
}

- (UIButton *)activationButton {
    if (!_activationButton) {
        _activationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activationButton addTarget:self action:@selector(activationAction:) forControlEvents:UIControlEventTouchUpInside];
        _activationButton.adjustsImageWhenHighlighted = NO;
        [_activationButton setTitle:WARLocalizedString(@"激活") forState:UIControlStateNormal];
        _activationButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_activationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _activationButton.backgroundColor = HEXCOLOR(0x2CBE61);
        _activationButton.layer.cornerRadius = 2;
        _activationButton.layer.masksToBounds = YES;
    }
    return _activationButton;
}

@end
