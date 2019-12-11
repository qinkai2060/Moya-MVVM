//
//  WARJournalTableHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalTableHeaderView.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "UIView+Frame.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

#define kWARJournalTableHeaderViewMineHeight 133
#define kWARJournalTableHeaderViewOtherHeight 44

@interface WARJournalTableHeaderView()

/** herderType */
@property (nonatomic, assign) WARJournalTableHeaderType herderType;

@end

@implementation WARJournalTableHeaderView

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
    [self addSubview:self.friendItem];
    [self.friendItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.footprintItem];
    [self.footprintItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.friendItem.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.groupMomentItem];
    [self.groupMomentItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.footprintItem.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)initOtherSubViews {
    [self addSubview:self.otherFootprintItem];
    [self.otherFootprintItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

+ (CGFloat)herderHeightWithHeaderType:(WARJournalTableHeaderType)herderType {
    switch (herderType) {
        case WARJournalTableHeaderTypeMine:
        {
            return kWARJournalTableHeaderViewMineHeight;
        }
            break;
        case WARJournalTableHeaderTypeOther:
        {
            return kWARJournalTableHeaderViewOtherHeight;
        }
            break;
    }
}

- (WARJournalTableHeaderItemView *)friendItem {
    if(!_friendItem){
        UIImage *image = [UIImage war_imageName:@"person_zone_copy" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _friendItem = [[WARJournalTableHeaderItemView alloc] init];
        [_friendItem configIcon:image title:WARLocalizedString(@"朋友圈") badge:0 userIconId:nil];
        __weak typeof(self) weakSelf = self;
        _friendItem.didItemBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.didFriendBlock) {
                strongSelf.didFriendBlock();
            }
        };
    }
    return _friendItem;
}

- (WARJournalTableHeaderItemView *)footprintItem {
    if(!_footprintItem){
        UIImage *image = [UIImage war_imageName:@"rizhi_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _footprintItem = [[WARJournalTableHeaderItemView alloc] init];
        [_footprintItem configIcon:image title:WARLocalizedString(@"我的足迹") badge:0 userIconId:nil];
        __weak typeof(self) weakSelf = self;
        _footprintItem.didItemBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.didFootprintBlock) {
                strongSelf.didFootprintBlock();
            }
        };
    }
    return _footprintItem;
}
    
- (WARJournalTableHeaderItemView *)groupMomentItem {
    if(!_groupMomentItem){
        UIImage *image = [UIImage war_imageName:@"group_moment_noti" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _groupMomentItem = [[WARJournalTableHeaderItemView alloc] init];
        [_groupMomentItem configIcon:image title:WARLocalizedString(@"群主动态和通知") badge:0 userIconId:nil];
        [_groupMomentItem hideLine:YES];
        __weak typeof(self) weakSelf = self;
        _groupMomentItem.didItemBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.didGroupMomentBlock) {
                strongSelf.didGroupMomentBlock();
            }
        };
    }
    return _groupMomentItem;
}
 

- (WARJournalTableHeaderItemView *)otherFootprintItem {
    if(!_otherFootprintItem){
        UIImage *image = [UIImage war_imageName:@"rizhi_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _otherFootprintItem = [[WARJournalTableHeaderItemView alloc] init];
        [_otherFootprintItem hideLine:YES];
        [_otherFootprintItem configIcon:image title:WARLocalizedString(@"TA的足迹") badge:0 userIconId:nil];
        __weak typeof(self) weakSelf = self;
        _otherFootprintItem.didItemBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.didFootprintBlock) {
                strongSelf.didFootprintBlock();
            }
        };
    }
    return _otherFootprintItem;
}

@end


@interface WARJournalTableHeaderItemView()

/** iconView */
@property (nonatomic, strong) UIImageView *iconView;
/** title */
@property (nonatomic, strong) UILabel *titleLable;
/** badgeLable */
@property (nonatomic, strong) UILabel *badgeLable;
/** userIconView */
@property (nonatomic, strong) UIImageView *userIconView;
/** dotView */
@property (nonatomic, strong) UIView *dotView;
/** arrow */
@property (nonatomic, strong) UIImageView *arrowView;
/** eventButton */
@property (nonatomic, strong) UIButton *eventButton;
/** line */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WARJournalTableHeaderItemView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.iconView];
    [self addSubview:self.titleLable];
    [self addSubview:self.badgeLable];
    [self addSubview:self.userIconView];
    [self.userIconView addSubview:self.dotView];
    [self addSubview:self.arrowView];
    [self addSubview:self.eventButton];
    [self.eventButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-17.5);
        make.left.mas_equalTo(17.5);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Public

- (void)configIcon:(UIImage *)icon
             title:(NSString *)title
             badge:(NSInteger)badge
        userIconId:(NSString *)userIconId {
    
    _iconView.image = icon;
    _titleLable.text = title;
    _badgeLable.text = [NSString stringWithFormat:@"%ld",badge];
    
    if (userIconId  && userIconId.length > 0) {
        [_userIconView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(32, 32), userIconId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        _userIconView.hidden = NO;
    } else {
        _userIconView.hidden = YES;
    }
    
    [self layoutWithTitle:title badge:badge];
}

- (void)configBadge:(NSInteger)badge
         userIconId:(NSString *)userIconId {
    _badgeLable.text = [NSString stringWithFormat:@"%ld",badge];
    
    if (userIconId && userIconId.length > 0) {
        [_userIconView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(32, 32), userIconId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        _userIconView.hidden = NO;
    } else {
        _userIconView.hidden = YES;
    }
    
    [self layoutWithTitle:_titleLable.text badge:badge];
}

    - (void)hideLine:(BOOL)hide {
        self.lineView.hidden = hide;
    }
#pragma mark - Private

- (void)layoutWithTitle:(NSString *)title badge:(NSInteger)badge {
    CGFloat iconViewX = 15;
    CGFloat iconViewY = 11.5;
    CGFloat iconViewW = 21;
    CGFloat iconViewH = 21;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    CGFloat titleLableW = [title widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16] constrainedToHeight:44];
    CGFloat titleLableH = 16;
    CGFloat titleLableX = self.iconView.right + 15;
    CGFloat titleLableY = (44 - titleLableH) * 0.5;
    self.titleLable.frame = CGRectMake(titleLableX, titleLableY, titleLableW, titleLableH);
    
    CGFloat badgeLableW = [[NSString stringWithFormat:@"%ld",badge] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] constrainedToHeight:44];
    CGFloat badgeLableH = 18;
    CGFloat badgeLableX = self.titleLable.right + 10;
    CGFloat badgeLableY = (44 - badgeLableH) * 0.5;
    if (badge <= 0) {
        badgeLableW = 0;
    } else if (badgeLableW <= 18) {
        badgeLableW = 18;
    } else {
        badgeLableW += 9;
    }
    self.badgeLable.frame = CGRectMake(badgeLableX, badgeLableY, badgeLableW, badgeLableH);
    
    CGFloat userIconViewW = 32;
    CGFloat userIconViewH = 32;
    CGFloat userIconViewX = kScreenWidth - 36 - userIconViewW;
    CGFloat userIconViewY = (44 - userIconViewH) * 0.5;
    self.userIconView.frame = CGRectMake(userIconViewX, userIconViewY, userIconViewW, userIconViewH);
    
    CGFloat dotViewW = 9;
    CGFloat dotViewH = 9;
    CGFloat dotViewX = userIconViewW - dotViewW * 0.5;
    CGFloat dotViewY = - dotViewH * 0.5;
    self.dotView.frame = CGRectMake(dotViewX, dotViewY, dotViewW, dotViewH);
    
    CGFloat arrowViewW = 22;
    CGFloat arrowViewH = 22;
    CGFloat arrowViewX = kScreenWidth - 10 - arrowViewW;
    CGFloat arrowViewY = (44 - arrowViewH) * 0.5;
    self.arrowView.frame = CGRectMake(arrowViewX, arrowViewY, arrowViewW, arrowViewH);
    
}

#pragma mark - Setter And Getter

- (UIImageView *)iconView {
    if(!_iconView){
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
//        _iconView.layer.cornerRadius = 15;
//        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)titleLable {
    if(!_titleLable){
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _titleLable;
}

- (UILabel *)badgeLable {
    if(!_badgeLable){
        _badgeLable = [[UILabel alloc] init];
        _badgeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _badgeLable.textColor = HEXCOLOR(0xffffff);
        _badgeLable.backgroundColor = HEXCOLOR(0xF2604D);
        _badgeLable.textAlignment = NSTextAlignmentCenter;
        _badgeLable.layer.cornerRadius = 9.0;
        _badgeLable.layer.masksToBounds = YES;
    }
    return _badgeLable;
}

- (UIImageView *)userIconView {
    if(!_userIconView){
        _userIconView = [[UIImageView alloc] init];
        _userIconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _userIconView;
}

- (UIView *)dotView {
    if(!_dotView){
        _dotView = [[UIView alloc] init];
        _dotView.backgroundColor = HEXCOLOR(0xF2604D);
        _dotView.layer.cornerRadius = 4.5;
        _dotView.layer.masksToBounds = YES;
    }
    return _dotView;
}


- (UIImageView *)arrowView {
    if(!_arrowView){
        _arrowView = [[UIImageView alloc] init];
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowView.layer.masksToBounds = YES;
        _arrowView.image = [UIImage war_imageName:@"arrow_open_q" curClass:[self class] curBundle:@"WARProfile.bundle"];
    }
    return _arrowView;
}

- (UIButton *)eventButton {
    if(!_eventButton){
        _eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        @weakify(self);
        [[_eventButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.didItemBlock){
                self.didItemBlock();
            }
        }];
    }
    return _eventButton;
}
    
    - (UIView *)lineView {
        if(!_lineView){
            _lineView = [[UIView alloc] init];
            _lineView.backgroundColor = HEXCOLOR(0xeeeeee);
        }
        return _lineView;
    }

@end
