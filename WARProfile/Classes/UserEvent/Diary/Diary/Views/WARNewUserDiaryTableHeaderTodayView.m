//
//  WARNewUserDiaryTableHeaderTodayView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARNewUserDiaryTableHeaderTodayView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARNetwork.h"
#import "NSString+Size.h"
#import "WARMacros.h"
#import "WARUserDiaryManager.h"
#import "WARDBUser.h"
#import "WARDBUserManager.h"

@interface WARNewUserDiaryTableHeaderTodayView()<WARNewUserDiaryTodayItemViewDeleagte>

/** 今天 */
@property (nonatomic, strong) UILabel *todayLable;
/** 记录今天 */
@property (nonatomic, strong) WARNewUserDiaryTodayItemView *recordTodayView;
/** 朋友圈 */
@property (nonatomic, strong) WARNewUserDiaryTodayItemView *friendView;
/** 草稿箱 */
@property (nonatomic, strong) WARNewUserDiaryTodayItemView *publishView;

@property (nonatomic, strong) RLMNotificationToken *userModelnotification;

@end

@implementation WARNewUserDiaryTableHeaderTodayView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
        [self addRealmObserver];
        
        [self loadData];
    }
    return self;
}

- (void)dealloc {
    [self.userModelnotification invalidate];
}

- (void)setupUI {
    [self addSubview:self.todayLable];
    [self addSubview:self.recordTodayView];
    [self addSubview:self.friendView];
    [self addSubview:self.publishView];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [WARUserDiaryManager loadUserDiaryUnread:^(bool hasUnread, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!err) {
            [strongSelf.friendView showTipView:hasUnread];
        }
    }];
}

- (void)addRealmObserver {
    __weak typeof(self) weakSelf = self;
    WARDBUser *dbUser = [WARDBUser user];
    self.userModelnotification = [dbUser addNotificationBlock:^(BOOL deleted, NSArray<RLMPropertyChange *> * _Nullable changes, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }else{
            if (changes.count) {
                for (RLMPropertyChange *property in changes) {
                    if ([property.name isEqualToString:@"unReadMementsCount"] ||
                        [property.name isEqualToString:@"latestNoticationHeaderId"]) {
                        
                        WARNewUserDiaryTodayItemModel *item = strongSelf.friendView.item;
                        item.unreadMomentCount = [WARDBUserManager unreadMomentCount];
                        strongSelf.friendView.item = item;
                    }
                }
            }
        }
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARNewUserDiaryTodayItemViewDeleagte

- (void)userDiaryTodayItemView:(WARNewUserDiaryTodayItemView *)userDiaryTodayItemView didItemType:(WARNewUserDiaryTodayType)itemType {
    if ([self.delegate respondsToSelector:@selector(userDiaryTodayView:didItemType:)]) {
        [self.delegate userDiaryTodayView:self didItemType:itemType];
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (UILabel *)todayLable{
    if (!_todayLable) {
        _todayLable = [[UILabel alloc]init];
        _todayLable.frame = CGRectMake(AdaptedWidth(13), 20, 72, 72);
        _todayLable.font = [UIFont systemFontOfSize:18];
        _todayLable.textColor = HEXCOLOR(0x303036);
        _todayLable.text = @"今天";
        _todayLable.textAlignment = NSTextAlignmentLeft;
    }
    return _todayLable;
}

- (WARNewUserDiaryTodayItemView *)recordTodayView {
    if (!_recordTodayView) {
        WARNewUserDiaryTodayItemModel *item = [[WARNewUserDiaryTodayItemModel alloc]init];
        item.title = @"记录今天";
        item.icon = @"person_camera_copy";
        item.showTip = NO;
        item.itemType = WARNewUserDiaryTodayTypeRecordToday;
        
        _recordTodayView = [[WARNewUserDiaryTodayItemView alloc]init];
        _recordTodayView.frame = CGRectMake(AdaptedWidth(87), 20, 72, 72);
        _recordTodayView.item = item;
        _recordTodayView.delegate = self;
        _recordTodayView.backgroundColor = [UIColor whiteColor];
    }
    return _recordTodayView;
}

- (WARNewUserDiaryTodayItemView *)friendView {
    if (!_friendView) {
        WARNewUserDiaryTodayItemModel *item = [[WARNewUserDiaryTodayItemModel alloc]init];
        item.title = @"朋友圈";
        item.icon = @"person_zone_copy";
        item.showTip = YES;
        item.itemType = WARNewUserDiaryTodayTypeFriend;
        
        _friendView = [[WARNewUserDiaryTodayItemView alloc]init];
        _friendView.item = item;
        _friendView.delegate = self;
        _friendView.frame = CGRectMake(AdaptedWidth(87)+ AdaptedWidth(24)+ 72, 20, 72, 72);
        _friendView.backgroundColor = [UIColor whiteColor];
    }
    return _friendView;
}

- (WARNewUserDiaryTodayItemView *)publishView {
    if (!_publishView) {
        WARNewUserDiaryTodayItemModel *item = [[WARNewUserDiaryTodayItemModel alloc]init];
        item.title = WARLocalizedString(@"发布");
        item.icon = @"person_release";
        item.showTip = NO;
        item.itemType = WARNewUserDiaryTodayTypePublish;
        
        _publishView = [[WARNewUserDiaryTodayItemView alloc]init];
        _publishView.item = item;
        _publishView.delegate = self;
        _publishView.frame = CGRectMake(AdaptedWidth(87) + 2 * (AdaptedWidth(24)+ 72), 20, 72, 72);
        _publishView.backgroundColor = [UIColor whiteColor];
    }
    return _publishView;
}

@end

#pragma mark - WARNewUserDiaryTodayItemView

@interface WARNewUserDiaryTodayItemView()

/** 红点 */
@property (nonatomic, strong) UIView *redTipView;
/** imageView */
@property (nonatomic, strong) UIImageView *imageView;
/** titleLable */
@property (nonatomic, strong) UILabel *titleLable;
/** button */
@property (nonatomic, strong) UIButton *didButton;
/** tipMessageLable */
@property (nonatomic, strong) UILabel *tipMessageLable;

@end

@implementation WARNewUserDiaryTodayItemView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.didButton.layer.borderWidth = 0.5;
    self.didButton.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
    self.didButton.layer.cornerRadius = 3;
//    self.layer.masksToBounds = YES;
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.didButton];
    [self addSubview:self.redTipView];
    [self addSubview:self.tipMessageLable];
    
    [self.didButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(23);
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-12);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(11);
    }];
    [self.redTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(6.5);
        make.top.mas_equalTo(self).offset(-6.5);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [self.tipMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.didButton.mas_bottom).offset(7);
        make.height.mas_equalTo(16);
        make.centerX.mas_equalTo(self);
    }];
}


#pragma mark - Event Response

- (void)didAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(userDiaryTodayItemView:didItemType:)]) {
        [self.delegate userDiaryTodayItemView:self didItemType:self.item.itemType];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)showTipView:(BOOL)show {
    self.redTipView.hidden = !show;
}

- (void)setItem:(WARNewUserDiaryTodayItemModel *)item {
    _item = item;
    
    self.redTipView.hidden = !item.showTip;
    UIImage *image = [UIImage war_imageName:item.icon curClass:[self class] curBundle:@"WARProfile.bundle"];
    self.imageView.image = image;
    self.titleLable.text = item.title;
    self.didButton.tag = item.itemType;
    
    switch (item.itemType) {
        case WARNewUserDiaryTodayTypeRecordToday:
        {
            self.tipMessageLable.hidden = YES;
        }
            break;
        case WARNewUserDiaryTodayTypeFriend:
        {
            self.tipMessageLable.hidden = !(item.unreadMomentCount > 0);
            self.tipMessageLable.textColor = HEXCOLOR(0xffffff);
            self.tipMessageLable.backgroundColor =  HEXCOLOR(0xF2604D);
            NSString *text = [NSString stringWithFormat:@"%@%ld",WARLocalizedString(@"消息"),item.unreadMomentCount];
            self.tipMessageLable.text = text ;
            
            [self.tipMessageLable sizeToFit];
            CGFloat width = self.tipMessageLable.width;
            [self.tipMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.didButton.mas_bottom).offset(7);
                make.height.mas_equalTo(16);
                make.width.mas_equalTo(width + 10);
                make.centerX.mas_equalTo(self);
            }];
        }
            break;
        case WARNewUserDiaryTodayTypePublish:
        {
            self.tipMessageLable.hidden = NO;//!(item.drafsCount > 0);
            self.tipMessageLable.textColor = HEXCOLOR(0x8D93A4);
            self.tipMessageLable.backgroundColor =  HEXCOLOR(0xF4F4F4);
            NSString *text = [NSString stringWithFormat:@"%@%ld",WARLocalizedString(@"草稿"),item.drafsCount];
            self.tipMessageLable.text = text ;
            
            [self.tipMessageLable sizeToFit];
            CGFloat width = self.tipMessageLable.width;
            [self.tipMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.didButton.mas_bottom).offset(7);
                make.height.mas_equalTo(16);
                make.width.mas_equalTo(width + 10);
                make.centerX.mas_equalTo(self);
            }];
        }
            break;
    }
}

- (UIView *)redTipView {
    if (!_redTipView) {
        _redTipView = [[UIView alloc]init];
        _redTipView.frame = CGRectMake(0, 0, 13, 13);
        _redTipView.layer.cornerRadius = 6.5;
        _redTipView.layer.masksToBounds = YES;
        _redTipView.backgroundColor = HEXCOLOR(0xF2604D);
    }
    return _redTipView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        //        _titleLable.frame = CGRectMake(AdaptedWidth(20), AdaptedWidth(17) + kSeparatorH, 120, 12);
        _titleLable.font = [UIFont systemFontOfSize:11];
        _titleLable.textColor = HEXCOLOR(0x8D93A4);
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = HEXCOLOR(0x8D93A4);
    }
    return _titleLable;
}

- (UIButton *)didButton {
    if (!_didButton) {
        _didButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _didButton.backgroundColor = [UIColor clearColor];
        _didButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_didButton addTarget:self action:@selector(didAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _didButton;
}

- (UILabel *)tipMessageLable{
    if (!_tipMessageLable) {
        _tipMessageLable = [[UILabel alloc]init];
        _tipMessageLable.font = [UIFont systemFontOfSize:10];
        _tipMessageLable.textColor = HEXCOLOR(0xffffff);
        _tipMessageLable.textAlignment = NSTextAlignmentCenter;
        _tipMessageLable.layer.cornerRadius = 8;
        _tipMessageLable.layer.masksToBounds = YES;
        _tipMessageLable.backgroundColor =  HEXCOLOR(0xF2604D);
        _tipMessageLable.text = [NSString stringWithFormat:@"%@51",WARLocalizedString(@"消息")];
    }
    return _tipMessageLable;
}

@end

#pragma mark - WARNewUserDiaryTodayItemModel

@implementation WARNewUserDiaryTodayItemModel

@end



