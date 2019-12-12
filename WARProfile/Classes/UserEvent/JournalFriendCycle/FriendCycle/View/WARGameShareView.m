//
//  WARGameShareView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/24.
//

#import "WARGameShareView.h"

#import "WARMacros.h"
#import "Masonry.h"

#import "WARGameShareItemModel.h"

#import "WARGameShareCell.h"
#import "WARLayoutButton.h"

#import "WARMediator+Chat.h"
#import "UIImage+WARBundleImage.h"

#define kGameShareViewScale (375.0/404.5)

@interface WARGameShareView()<UITableViewDelegate,UITableViewDataSource>

/** 屏幕方向判断 */
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

/** sendToLable */
@property (nonatomic, strong) UILabel *sendToLable;
/** moreContactButton */
@property (nonatomic, strong) WARLayoutButton *moreContactButton;
/** titleView */
@property (nonatomic, strong) UIView *titleView;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** cancleButton */
@property (nonatomic, strong) UIButton *cancleButton;
/** cancleView */
@property (nonatomic, strong) UIView *cancleView;

/** grayItems */
@property (nonatomic, strong) NSMutableArray <WARGameShareItemModel *> *grayItems;
/** colorItems */
@property (nonatomic, strong) NSMutableArray <WARGameShareItemModel *> *colorItems;
/** contactsItems */
@property (nonatomic, strong) NSMutableArray <WARGameShareItemModel *> *contactsItems;
@end

@implementation WARGameShareView

#pragma mark - Initial

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addDeviceOrientationObserver];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.5];
    
    [self addSubview:self.cancleView];
    [self.cancleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(47+kSafeAreaBottom);
    }];
    [self.cancleView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(47);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-47-kSafeAreaBottom);
        make.right.mas_equalTo(self.cancleView.mas_right);
        make.left.mas_equalTo(self.cancleView.mas_left);
        make.height.mas_equalTo(329.5);
    }];
    
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-376.5-kSafeAreaBottom);
        make.right.mas_equalTo(self.cancleView.mas_right);
        make.left.mas_equalTo(self.cancleView.mas_left);
        make.height.mas_equalTo(28);
    }];
    
    [self.titleView addSubview:self.sendToLable];
    [self.sendToLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(13);
    }];
    
    [self.titleView addSubview:self.moreContactButton];
    [self.moreContactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.5);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(13);
    }];
}

- (void)dealloc {
    [self removeDeviceOrientationObserver];
}

#pragma mark - Event Response

- (void)moreContactAction:(UIButton *)button {
    [self hideShareView];
}

- (void)cancleAction:(UIButton *)button {
    [self hideShareView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideShareView];
}

#pragma mark - Delegate
#pragma mark UITableView data Source & UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARGameShareCell *cell = [WARGameShareCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.items = self.contactsItems;
        [cell hideLine:YES];
    } else if (indexPath.section == 1) {
        cell.items = self.colorItems;
        [cell hideLine:NO];
    } else {
        cell.items = self.grayItems;
        [cell hideLine:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 101;
    } else if (indexPath.section == 1) {
        return 120;
    } else {
        return 106;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Observer

- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange {
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    
    switch (_currentOrientation) {
        case UIInterfaceOrientationPortrait: { /// 竖屏
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            
        }
            break;
        default: break;
    }
}

#pragma mark - Public

- (void)showShareView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (UILabel *)sendToLable {
    if (!_sendToLable) {
        _sendToLable = [[UILabel alloc]init];
        _sendToLable.text = WARLocalizedString(@"转发到");
        _sendToLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _sendToLable.textColor = HEXCOLOR(0x8D93A4);
        _sendToLable.textAlignment = NSTextAlignmentLeft;
    }
    return _sendToLable;
}

- (WARLayoutButton *)moreContactButton {
    if (!_moreContactButton) {
        UIImage *image = [UIImage war_imageName:@"enter" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _moreContactButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        [_moreContactButton setTitle:WARLocalizedString(@"更多联系人") forState:UIControlStateNormal];
        [_moreContactButton setImage:image forState:UIControlStateNormal];
        [_moreContactButton setTitleColor:HEXCOLOR(0x386DB4) forState:UIControlStateNormal];
        _moreContactButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _moreContactButton.layoutStyle = LayoutButtonStyleLeftTitleRightImage;
        _moreContactButton.midSpacing = 3.5;
        _moreContactButton.imageSize = CGSizeMake(9, 10);
        [_moreContactButton addTarget:self action:@selector(moreContactAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreContactButton;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.backgroundColor = HEXCOLOR(0xFCFCFC);
        [_cancleButton setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
        [_cancleButton setTitleColor:HEXCOLOR(0x343C4F) forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _titleView;
}

- (UIView *)cancleView {
    if (!_cancleView) {
        _cancleView = [[UIView alloc]init];
        _cancleView.backgroundColor = HEXCOLOR(0xFCFCFC);
    }
    return _cancleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.allowsSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HEXCOLOR(0xEEEEEE);
        _tableView.userInteractionEnabled = YES;
//        [_tableView registerClass:[WARMediumPublicHeaderView class] forHeaderFooterViewReuseIdentifier:kWARMediumPublicHeaderViewId];
//        [_tableView registerClass:[WARMediumPublicGroupCell class] forCellReuseIdentifier:kWARMediumPublicGroupCellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray<WARGameShareItemModel *> *)grayItems {
    if (!_grayItems) {
        _grayItems = [NSMutableArray <WARGameShareItemModel *>array];
        
        WARGameShareItemModel *item1 = [[WARGameShareItemModel alloc]init];
        item1.name = WARLocalizedString(@"收藏");
        item1.localHeadId = @"browser_collection";
        WARGameShareItemModel *item2 = [[WARGameShareItemModel alloc]init];
        item2.name = WARLocalizedString(@"举报");
        item2.localHeadId = @"browser_history";
        WARGameShareItemModel *item3 = [[WARGameShareItemModel alloc]init];
        item3.name = WARLocalizedString(@"复制链接");
        item3.localHeadId = @"browser_link";
        WARGameShareItemModel *item4 = [[WARGameShareItemModel alloc]init];
        item4.name = WARLocalizedString(@"浏览器打开");
        item4.localHeadId = @"friend_browser";
        WARGameShareItemModel *item5 = [[WARGameShareItemModel alloc]init];
        item5.name = WARLocalizedString(@"加入首页");
        item5.localHeadId = @"friend_home";
        
        [_grayItems addObject:item1];
        [_grayItems addObject:item2];
        [_grayItems addObject:item3];
        [_grayItems addObject:item4];
        [_grayItems addObject:item5];
    }
    return _grayItems;
}

- (NSMutableArray<WARGameShareItemModel *> *)colorItems {
    if (!_colorItems) {
        _colorItems = [NSMutableArray array];
        
        WARGameShareItemModel *item1 = [[WARGameShareItemModel alloc]init];
        item1.name = WARLocalizedString(@"朋友圈");
        item1.localHeadId = @"browser_friend";
        WARGameShareItemModel *item2 = [[WARGameShareItemModel alloc]init];
        item2.name = WARLocalizedString(@"地图");
        item2.localHeadId = @"browser_map";
        WARGameShareItemModel *item3 = [[WARGameShareItemModel alloc]init];
        item3.name = WARLocalizedString(@"公众圈");
        item3.localHeadId = @"browser_public";
        WARGameShareItemModel *item4 = [[WARGameShareItemModel alloc]init];
        item4.name = WARLocalizedString(@"群主");
        item4.localHeadId = @"browser_group";
        WARGameShareItemModel *item5 = [[WARGameShareItemModel alloc]init];
        item5.name = WARLocalizedString(@"直接转发\n（公开）");
        item5.localHeadId = @"browser_sent";
        
        [_colorItems addObject:item1];
        [_colorItems addObject:item2];
        [_colorItems addObject:item3];
        [_colorItems addObject:item4];
        [_colorItems addObject:item5];
    }
    return _colorItems;
}

- (NSMutableArray<WARGameShareItemModel *> *)contactsItems {
    if (!_contactsItems) {
        _contactsItems = [NSMutableArray array];
        
        NSArray *tempArrray = [[WARMediator sharedInstance] Mediator_RecentlyContactPerson];
        for (NSDictionary *dict in tempArrray) {
            WARGameShareItemModel *item = [[WARGameShareItemModel alloc]init];
            item.name = dict[@"name"];
            item.headId = dict[@"headId"];
            item.accountId = dict[@"accountId"];
            
            [_contactsItems addObject:item];
        }
        NDLog(@"tempArrray:%@",tempArrray);
    }
    return _contactsItems;
}

@end
