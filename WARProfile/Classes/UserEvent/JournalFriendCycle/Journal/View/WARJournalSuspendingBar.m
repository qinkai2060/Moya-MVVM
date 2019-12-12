//
//  WARJournalSuspendingBar.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARJournalSuspendingBar.h"
#import "WARImageButton.h"
#import "ReactiveObjC.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARMacros.h"

@interface WARJournalSuspendingBar()

/** friendButton */
@property (nonatomic, strong) WARImageButton *friendButton;
/** footprintButton */
@property (nonatomic, strong) WARImageButton *footprintButton;
/** otherFootprintButton */
@property (nonatomic, strong) WARImageButton *otherFootprintButton;
/** groupMomentButton */
@property (nonatomic, strong) WARImageButton *groupMomentButton;

/** herderType */
@property (nonatomic, assign) WARJournalTableHeaderType herderType;
@end

@implementation WARJournalSuspendingBar
  
- (instancetype)initWithFrame:(CGRect)frame herderType:(WARJournalTableHeaderType)herderType {
    self = [super initWithFrame:frame];
    if (self) {
        self.herderType = herderType;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    switch (self.herderType) {
        case WARJournalTableHeaderTypeMine:
        {
            [self initMineSubViews];
        }
            break;
        case WARJournalTableHeaderTypeOther:
        {
            [self initOtherSubViews];
        }
            break;
    }
}

- (void)initMineSubViews {
    [self addSubview:self.groupMomentButton];
    [self.groupMomentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(8.5);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
    
    [self addSubview:self.footprintButton];
    [self.footprintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.5);
        make.right.mas_equalTo(self.groupMomentButton.mas_left).offset(-8);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
    
    [self addSubview:self.friendButton];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.5);
        make.right.mas_equalTo(self.footprintButton.mas_left).offset(-8);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
}

- (void)initOtherSubViews {
    [self addSubview:self.otherFootprintButton];
    [self.otherFootprintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(8.5);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
}

- (void)configFriendBadge:(NSInteger)friendBadge {
    [self.friendButton setBadgeValue:friendBadge];
}

- (void)configFootprintBadge:(NSInteger)footprintBadge {
    [self.footprintButton setBadgeValue:footprintBadge];
}

- (void)configGroupMomentBadge:(NSInteger)groupMomentBadge {
    [self.groupMomentButton setBadgeValue:groupMomentBadge];
}

- (WARImageButton *)friendButton {
    if (!_friendButton) {
        UIImage *image = [UIImage war_imageName:@"homepage_moment_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _friendButton = [WARImageButton buttonWithType:UIButtonTypeCustom];
//        _friendButton.backgroundColor = [UIColor clearColor];
        _friendButton.iconView.image = image;
        __weak typeof(self) weakSelf = self;
        [[_friendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.didFriendBlock) {
                strongSelf.didFriendBlock();
            }
        }];
    }
    return _friendButton;
}

- (WARImageButton *)footprintButton {
    if (!_footprintButton) {
        UIImage *image = [UIImage war_imageName:@"map_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _footprintButton = [WARImageButton buttonWithType:UIButtonTypeCustom];
//        _footprintButton.backgroundColor = [UIColor clearColor];
        _footprintButton.iconView.image = image;
        __weak typeof(self) weakSelf = self;
        [[_footprintButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.didFootprintBlock) {
                strongSelf.didFootprintBlock();
            }
        }];
    }
    return _footprintButton;
}

- (WARImageButton *)otherFootprintButton {
    if (!_otherFootprintButton) {
        UIImage *image = [UIImage war_imageName:@"map_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _otherFootprintButton = [WARImageButton buttonWithType:UIButtonTypeCustom];
//        _otherFootprintButton.backgroundColor = [UIColor clearColor];
        _otherFootprintButton.iconView.image = image;
        __weak typeof(self) weakSelf = self;
        [[_otherFootprintButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.didFootprintBlock) {
                strongSelf.didFootprintBlock();
            }
        }];
    }
    return _otherFootprintButton;
}

- (WARImageButton *)groupMomentButton {
    if (!_groupMomentButton) {
        UIImage *image = [UIImage war_imageName:@"groupPage_noti_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _groupMomentButton = [WARImageButton buttonWithType:UIButtonTypeCustom];
//        _groupMomentButton.backgroundColor = [UIColor clearColor];
        _groupMomentButton.iconView.image = image;
        __weak typeof(self) weakSelf = self;
        [[_groupMomentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.didGroupMomentBlock) {
                strongSelf.didGroupMomentBlock();
            }
        }];
    }
    return _groupMomentButton;
}

@end
