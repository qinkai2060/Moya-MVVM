//
//  WARFriendBaseCellTopView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendTopView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "UIImageView+WebCache.h"
#import "WARDBContactModel.h"
#import "WARMacros.h"
#import "UIView+Frame.h"
#import "WARUIHelper.h"
#import "WARLayoutButton.h"
#import "WARProgressHUD.h"
#import "WARJournalFriendCycleNetManager.h"

@interface WARFriendTopView()

@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *ageImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *thirdPlatformNameLable;
@property (nonatomic, strong) UIButton *extendButton;
@property (nonatomic, strong) UIButton *adButton;
@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) NSMutableArray <UIImageView *> *platformViews;
@property (nonatomic, strong) UIView *platformContainerView;

@end

@implementation WARFriendTopView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.userImageView];
//    [self addSubview:self.sexImageView];
//    [self addSubview:self.ageImageView];
    [self addSubview:self.nameLable];
    [self addSubview:self.thirdPlatformNameLable];
    [self addSubview:self.thirdImageView];
//    [self addSubview:self.timeLable];
    [self addSubview:self.followButton];
    [self addSubview:self.extendButton];
    [self addSubview:self.adButton];
    [self addSubview:self.platformContainerView];
    
    //发布到的平台
    NSMutableArray *platformViews = [NSMutableArray array];
    UIImage *image = [UIImage war_imageName:@"rizhi_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
    for (int i = 0; i < 2; i++) {
        UIImageView *button = [[UIImageView alloc] init];
        button.image = image;
//        button.adjustsImageWhenHighlighted = NO;
//        [button addTarget:self action:@selector(platformAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.tag = WARPlatformTypeFriend;
            image = [UIImage war_imageName:@"person_zone_copy" curClass:[self class] curBundle:@"WARProfile.bundle"];
        } else if (i == 1) {
            button.tag = WARPlatformTypeFriend;
            image = [UIImage war_imageName:@"rizhi_locati_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        } else if (i == 2) {
            button.tag = WARPlatformTypeDouBan;
            image = [UIImage war_imageName:@"person_zone_copy" curClass:[self class] curBundle:@"WARProfile.bundle"];
        }
//        [button setImage:image forState:UIControlStateNormal];
        CGFloat x = (13 + 5) * 3 - (13 + 5) * (i) - 13;
        CGFloat y = 0;
        CGFloat w = 13;
        CGFloat h = 13;
        button.frame =CGRectMake(x, y, w, h);
        button.backgroundColor = [UIColor whiteColor];
        [platformViews addObject:button];
        [self.platformContainerView addSubview:button];
    }
    _platformViews = platformViews;
}

#pragma mark - Event Response

- (void)followAction:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    [WARJournalFriendCycleNetManager followWithGuyId:self.moment.accountId isFollow:button.selected completion:^(id responseObj, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            button.selected = !button.selected;
            if (button.selected) {
                strongSelf.moment.friendModel.followState = @"TRUE";
                strongSelf.followButton.left = kScreenWidth - (strongSelf.moment.isFollowDetail ? 76 : 104.5);
                strongSelf.followButton.width = 64.5;
            } else {
                strongSelf.moment.friendModel.followState = @"FALSE";
                strongSelf.followButton.left = kScreenWidth - (strongSelf.moment.isFollowDetail ? 62 : 90.5);
                strongSelf.followButton.width = 50.5;
            }
        }
        else {
            [WARProgressHUD showAutoMessage:[err description]];
        }
    }];
}

- (void)adAction:(UIButton *)button {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect toSelfFrame = [button convertRect:button.frame fromView:self];//获取button在contentView的位置
    CGRect toWindowFrame = [button convertRect:toSelfFrame toView:window];
    
    if ([self.delegate respondsToSelector:@selector(friendTopViewShowPop:indexPath:showFrame:popType:)]) {
        [self.delegate friendTopViewShowPop:self indexPath:self.indexPath showFrame:toWindowFrame popType:(WARFriendTopPopTypeAd)];
    }
}

- (void)extendAction:(UIButton *)button {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect toSelfFrame = [button convertRect:button.frame fromView:self];//获取button在contentView的位置
    CGRect toWindowFrame = [button convertRect:toSelfFrame toView:window];
    
    if ([self.delegate respondsToSelector:@selector(friendTopViewShowPop:indexPath:showFrame:popType:)]) {
        [self.delegate friendTopViewShowPop:self indexPath:self.indexPath showFrame:toWindowFrame popType:(WARFriendTopPopTypeNormal)];
    }
}

- (void)tapUserHeader:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(friendTopViewDidUserHeader:indexPath:model:)]) {
        [self.delegate friendTopViewDidUserHeader:self indexPath:self.indexPath model:self.moment.friendModel];
    }
}

- (void)tapUserName:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(friendTopViewDidUserHeader:indexPath:model:)]) {
        [self.delegate friendTopViewDidUserHeader:self indexPath:self.indexPath model:self.moment.friendModel];
    }
}

#pragma mark - Delegate

#pragma mark - Public

- (void)showExtendView:(BOOL)show {
    self.extendButton.hidden = !show;
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
     
    if(moment.momentTypeEnum == WARMomentTypeGroup){
        self.nameLable.text = moment.groupMember.nickname;
        [self.userImageView sd_setImageWithURL:kOriginMediaUrl(moment.groupMember.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    } else {
        self.nameLable.text = moment.friendModel.nickname;
        [self.userImageView sd_setImageWithURL:kOriginMediaUrl(moment.friendModel.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    }
    
    NSString *ageText = [WARUIHelper war_birthdayToAge:moment.friendModel.year month:moment.friendModel.month day:moment.friendModel.day];
    self.ageImageView.text = ageText;
    self.ageImageView.backgroundColor = [WARUIHelper ageBgColorByGender:moment.friendModel.gender];
    self.ageImageView.hidden = !(ageText.intValue > 0);
    self.sexImageView.image = [WARUIHelper war_constellationImgWithMonth:moment.friendModel.month.integerValue day:moment.friendModel.day.integerValue gender:moment.friendModel.gender];
    
    self.userImageView.frame = moment.friendMomentLayout.userImageFrame;
    self.nameLable.frame = moment.friendMomentLayout.nameLableFrame;
    self.ageImageView.frame = moment.friendMomentLayout.ageImageFrame;
    self.sexImageView.frame = moment.friendMomentLayout.sexImageFrame;
    self.extendButton.frame = moment.friendMomentLayout.extendButtonFrame;
    self.adButton.frame = moment.friendMomentLayout.adButtonFrame;
    
    if (moment.friendModel.homeUrl) {
        self.followButton.hidden = NO;
        self.thirdImageView.hidden = NO;
        self.thirdPlatformNameLable.hidden = NO;
        [self.thirdImageView sd_setImageWithURL:moment.friendModel.thirdTypeIcon placeholderImage:[WARUIHelper war_defaultUserIcon]];
        self.thirdImageView.frame = moment.friendMomentLayout.thirdImageFrame;
        self.thirdPlatformNameLable.frame = moment.friendMomentLayout.thirdPlatformNameFrame;
        self.followButton.frame = moment.friendMomentLayout.followButtonFrame;
        self.followButton.selected = [moment.friendModel.followState isEqualToString:@"TRUE"];
        if (self.followButton.selected) {
            self.followButton.left = kScreenWidth - (self.moment.isFollowDetail ? 76 : 104.5);
            self.followButton.width = 63;
        } else {
            self.followButton.left = kScreenWidth - (self.moment.isFollowDetail ? 62 : 90.5);
            self.followButton.width = 50;
        }
    } else {
        self.followButton.hidden = YES;
        self.thirdImageView.hidden = YES;
        self.thirdPlatformNameLable.hidden = YES;
    }
    
    
    self.platformContainerView.frame = moment.friendMomentLayout.platformContainerViewFrame;
    
    if (moment.momentShowType == WARMomentShowTypeUserDiary) {
        self.platformContainerView.hidden = NO;
        self.extendButton.hidden = YES;
    } else {
        self.platformContainerView.hidden = YES;
        self.extendButton.hidden = NO;
    }
    
    if (moment.momentTypeEnum == WARMomentTypeAD){
        self.adButton.hidden = NO;
        self.extendButton.hidden = YES;
        self.followButton.hidden = YES;
    } 
}
    
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _userImageView.layer.cornerRadius = 4.0f;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeader:)];
        [_userImageView addGestureRecognizer:tapGesture];
    }
    return _userImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        UIImage *image = [UIImage war_imageName:@"weibo" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _thirdImageView = [[UIImageView alloc]init];
        _thirdImageView.contentMode = UIViewContentModeScaleToFill;
        _thirdImageView.image = image;
    }
    return _thirdImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc]init];
    }
    return _sexImageView;
}

- (UILabel *)ageImageView {
    if (!_ageImageView) {
        _ageImageView = [[UILabel alloc]init];
        _ageImageView.font = [UIFont systemFontOfSize:10];
        _ageImageView.textAlignment = NSTextAlignmentCenter;
        _ageImageView.textColor = [UIColor whiteColor];
//        _ageImageView.backgroundColor = [WARUIHelper ageBgColorByGender:];
    }
    return _ageImageView;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = HEXCOLOR(0x576B95);
        _nameLable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserName:)];
        [_nameLable addGestureRecognizer:tapGesture];
    }
    return _nameLable;
}

- (UILabel *)thirdPlatformNameLable {
    if (!_thirdPlatformNameLable) {
        _thirdPlatformNameLable = [[UILabel alloc]init];
        _thirdPlatformNameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _thirdPlatformNameLable.textAlignment = NSTextAlignmentLeft;
        _thirdPlatformNameLable.textColor = HEXCOLOR(0x737373);
        _thirdPlatformNameLable.userInteractionEnabled = YES;
        _thirdPlatformNameLable.text = WARLocalizedString(@"用户");
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserName:)];
        [_thirdPlatformNameLable addGestureRecognizer:tapGesture];
    }
    return _thirdPlatformNameLable;
}

- (UIButton *)adButton {
    if (!_adButton) {
        UIImage *image = [UIImage war_imageName:@"guanggao" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        UIImage *selectedImage = [UIImage war_imageName:@"rankinglist_up" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adButton addTarget:self action:@selector(adAction:) forControlEvents:UIControlEventTouchUpInside];
        [_adButton setImage:image forState:UIControlStateNormal];
//        [_extendButton setImage:selectedImage forState:UIControlStateSelected];
        _adButton.imageView.contentMode = UIViewContentModeCenter;
        _adButton.hidden = YES;
    }
    return _adButton;
}

- (UIButton *)extendButton {
    if (!_extendButton) {
        UIImage *image = [UIImage war_imageName:@"person_zone_moreq" curClass:[self class] curBundle:@"WARProfile.bundle"];
        //        UIImage *selectedImage = [UIImage war_imageName:@"rankinglist_up" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extendButton addTarget:self action:@selector(extendAction:) forControlEvents:UIControlEventTouchUpInside];
        [_extendButton setImage:image forState:UIControlStateNormal];
        //        [_extendButton setImage:selectedImage forState:UIControlStateSelected];
        _extendButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _extendButton;
}

- (UIButton *)followButton {
    if (!_followButton) {
        UIImage *image = [UIImage war_imageName:@"guanzhu" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"yiguanzhu" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [_followButton setImage:image forState:UIControlStateNormal];
        [_followButton setImage:selectedImage forState:UIControlStateSelected];
        _followButton.imageView.contentMode = UIViewContentModeCenter;
        
//        _followButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
//        [_followButton setTitle:@"取消关注" forState:UIControlStateNormal];
//        _followButton.layer.borderWidth = 0.5;
//        _followButton.layer.borderColor =HEXCOLOR(0xF46D12).CGColor;
    }
    return _followButton;
}


- (NSMutableArray <UIImageView *> *)platformViews {
    if (!_platformViews) {
        _platformViews = [NSMutableArray array];
    }
    return _platformViews;
}

- (UIView *)platformContainerView {
    if (!_platformContainerView) {
        _platformContainerView = [[UIView alloc] init];
        _platformContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _platformContainerView;
}


@end
