//
//  WARPrivateSettingsViewController.m
//  Pods
//
//  Created by huange on 2017/8/9.
//
//

#import "WARPrivateSettingsViewController.h"
#import "WARSeeSBViewController.h"
#import "WARAddMySelfWayViewController.h"
#import "WARPrivateDistanceViewController.h"
#import "WARPrivatePersonListViewController.h"
#import "WARMediator+Chat.h"

#import "WARSettingCellItem.h"
#import "WARSettingsCell.h"
#import "WARSettingHeaderView.h"
#import "WARPrivateSettingsDetailCell.h"

#define numberOfSection 2

#define CommentSettingCellID                @"CommentSettingCellID"
#define SwithcSettingCellID                 @"SwithcSettingCellID"
#define CheckMarkSettingCellID              @"CheckMarkSettingCellID"
#define WARSettingsSwitchWithDetailCellID   @"WARSettingsSwitchWithDetailCell"

#define CommentHeaderID      @"headerId"

//section zero
#define AddMyWay  WARLocalizedString(@"搜索到我的方式")
#define DistancePrivate WARLocalizedString(@"距离隐私")
#define BlackList WARLocalizedString(@"黑名单")

@interface WARPrivateSettingsViewController () <WARSettingsSwitchCellDelegate>

@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, strong) NSMutableArray *distanceSectionArray;

@end

@implementation WARPrivateSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.sectionDataArray = [[NSMutableArray alloc] initWithCapacity:numberOfSection];
    //    self.distanceSectionArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < numberOfSection; i++) { //i is section
        switch (i) { // j is row in each section
            case 0: {
                [self.sectionDataArray addObject:[self getFirstSectionArray]];
            }
                break;
            case 1: {
                [self.sectionDataArray addObject:[self getTweetSectionArray]];
            }
                break;
            case 2: {
                [self.sectionDataArray addObject:[self getDistanceSectionArray]];
            }
                break;
            default:
                break;
        }
    }
    
    [self updateDistanceCell];
}

- (void)initData {
    [super initData];

}

- (void)updateDistanceCell {
    WARSettingWithRightTextCellItem *item = [[self.sectionDataArray objectAtIndex:0] objectAtIndex:3];

    if (self.dataManager.userInfo.profileSetting.friendCanSeeDistance) {
        item.rightText = WARLocalizedString(@"只对好友显示距离");
    }else if (self.dataManager.userInfo.profileSetting.allCanSeeDistance) {
        item.rightText = WARLocalizedString(@"对所有人显示距离");
    }else if (self.dataManager.userInfo.profileSetting.distanceClosed) {
        item.rightText = WARLocalizedString(@"对所有人关闭距离");
    }else {
        item.rightText = @"";
    }

    [self.tableView reloadData];
}

- (NSMutableArray *)getFirstSectionArray {
    NSMutableArray *itemArray = [NSMutableArray new];
    
    for (int j = 0; j < 5; j++) {
        if (0 == j) {
            WARSettingSwitchCellItem *item = [WARSettingSwitchCellItem new];
            item.titleString = WARLocalizedString(@"加我为好友时需要验证");
            item.open = self.dataManager.userInfo.profileSetting.addNeedConfirm;

            [itemArray addObject:item];
        }
        
        if (1 == j) {
            WARSettingSwitchCellItem *item = [WARSettingSwitchCellItem new];
            item.titleString = WARLocalizedString(@"邀请我入群时需要验证");
            item.open = self.dataManager.userInfo.profileSetting.toGroupNeedConfirm;

            [itemArray addObject:item];
        }
        
        if (2 == j) {
            WARSettingCellItem *item = [WARSettingCellItem new];
            item.titleString = AddMyWay;
            
            [itemArray addObject:item];
        }

        if (3 == j) {
            WARSettingWithRightTextCellItem *item = [WARSettingWithRightTextCellItem new];
            item.titleString = DistancePrivate;

            [itemArray addObject:item];
        }
        
        if (4 == j) {
            WARSettingCellItem *item = [WARSettingCellItem new];
            item.titleString = BlackList;
            
            [itemArray addObject:item];
        }
    }

    return itemArray;
}

- (NSMutableArray *)getTweetSectionArray {
    NSMutableArray *itemArray = [NSMutableArray new];
    
    for (int j = 0; j < 3; j++) {
        if (0 == j) {
            WARSettingCellItem *item = [WARSettingCellItem new];
            item.titleString = WARLocalizedString(@"不让TA看我的动态");
            
            [itemArray addObject:item];
        }
        
        if (1 == j) {
            WARSettingCellItem *item = [WARSettingCellItem new];
            item.titleString = WARLocalizedString(@"不看TA的动态");
            
            [itemArray addObject:item];
        }
        
        if (2 == j) {
            WARSettingCellItem *item = [WARSettingCellItem new];
            item.titleString = WARLocalizedString(@"对TA隐身 (距离和位置)");
            
            [itemArray addObject:item];
        }
    }
    
    return itemArray;
}

- (NSMutableArray *)getDistanceSectionArray {
    WARSettingSwitchWithDetailCellItem *item = [WARSettingSwitchWithDetailCellItem new];
    item.titleString = WARLocalizedString(@"距离开关");
    item.detailString =  WARLocalizedString(@"关闭后，所有人看不到你的距离和活跃时间");
    item.open = self.dataManager.userInfo.profileSetting.distanceClosed;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:item, nil];
    
    WARSettingCheckMarkCellItem *checkDefatulItem = [WARSettingCheckMarkCellItem new];
    checkDefatulItem.titleString = WARLocalizedString(@"对所有人显示距离");
    checkDefatulItem.checked = self.dataManager.userInfo.profileSetting.allCanSeeDistance;
    
    WARSettingCheckMarkCellItem *onlyFriendCanSeeItem = [WARSettingCheckMarkCellItem new];
    onlyFriendCanSeeItem.titleString = WARLocalizedString(@"只对好友可见");
    onlyFriendCanSeeItem.checked = self.dataManager.userInfo.profileSetting.friendCanSeeDistance;
    
    WARSettingCheckMarkCellItem *startFriendCanSeeItem = [WARSettingCheckMarkCellItem new];
    startFriendCanSeeItem.titleString = WARLocalizedString(@"只对星标好友可见");
    startFriendCanSeeItem.checked = self.dataManager.userInfo.profileSetting.startCanSeeDistance;
    
    // default
    if (!checkDefatulItem.checked && !onlyFriendCanSeeItem.checked && !startFriendCanSeeItem.checked) {
        checkDefatulItem.checked = YES;
    }

    [self.distanceSectionArray addObject:checkDefatulItem];
    [self.distanceSectionArray addObject:onlyFriendCanSeeItem];
    [self.distanceSectionArray addObject:startFriendCanSeeItem];
    
    if (item.open) {
        [tempArray addObjectsFromArray:self.distanceSectionArray];
    }

    return tempArray;
}

#pragma mark - init UI
- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"隐私设置");
    
    self.tableView.rowHeight = commonCellHeight;
    [self.tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:CommentSettingCellID];
    [self.tableView registerClass:[WARSettingHeaderView class] forHeaderFooterViewReuseIdentifier:CommentHeaderID];
    [self.tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:SwithcSettingCellID];
    [self.tableView registerClass:[WARSettingsCheckMarkCell class] forCellReuseIdentifier:CheckMarkSettingCellID];
    [self.tableView registerClass:[WARSettingsSwitchWithDetailCell class] forCellReuseIdentifier:WARSettingsSwitchWithDetailCellID];
    [self.tableView registerClass:[WARPrivateSettingsDetailCell class] forCellReuseIdentifier:@"WARPrivateSettingsDetailCell"];
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)[self.sectionDataArray objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 10;
    }else {
        return HeaderViewDefaultHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return [[UIView alloc] init];
    }
    WARSettingHeaderView *headerView = (WARSettingHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentHeaderID];
    headerView.contentView.backgroundColor = BackgroundDefaultColor;
    headerView.backgroundColor = BackgroundDefaultColor;
    if (1 == section) {
        headerView.titleLabel.text = WARLocalizedString(@"动态权限设置");
    }else {
        headerView.titleLabel.text = WARLocalizedString(@"距离权限设置");
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 59;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [((NSArray*)[self.sectionDataArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    
    if ([item isMemberOfClass:[WARSettingSwitchCellItem class]]) {
        cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwithcSettingCellID];
        ((WARSettingsSwitchCell *)cell).descriptionText = ((WARSettingSwitchCellItem*)item).titleString;
        ((WARSettingsSwitchCell *)cell).delegate = self;
        ((WARSettingsSwitchCell *)cell).switchButton.on = ((WARSettingSwitchCellItem*)item).open;

    }else if ([item isKindOfClass:[WARSettingWithRightTextCellItem class]]) {
        cell = (WARSettingsCell *)[tableView dequeueReusableCellWithIdentifier:CommentSettingCellID];
        ((WARSettingsCell *)cell).descriptionText = ((WARSettingWithRightTextCellItem*)item).titleString;
        ((WARSettingsCell *)cell).rightText = ((WARSettingWithRightTextCellItem*)item).rightText;
        ((WARSettingsCell *)cell).rightTextColor = DisabledTextColor;
        ((WARSettingsCell *)cell).rightTextFontSize = 16;
        ((WARSettingsCell *)cell).showAccessoryView = YES;
    }else if ([item isKindOfClass:[WARSettingCellItem class]]) {
        if (indexPath.row == 0) {
            cell = (WARPrivateSettingsDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"WARPrivateSettingsDetailCell"];
            ((WARPrivateSettingsDetailCell *)cell).cellTitleLabel.text = ((WARSettingWithRightTextCellItem*)item).titleString;
            ((WARPrivateSettingsDetailCell *)cell).cellDetailLabel.text = WARLocalizedString(@"地图和朋友圈都无法查看");
            return cell;
        }
        cell = (WARSettingsCell *)[tableView dequeueReusableCellWithIdentifier:CommentSettingCellID];
        ((WARSettingsCell *)cell).descriptionText = ((WARSettingCellItem*)item).titleString;
        ((WARSettingsCell *)cell).showAccessoryView = YES;
    }else if ([item isMemberOfClass:[WARSettingSwitchWithDetailCellItem class]]){ //WARSettingCheckMarkCellItem
        cell = (WARSettingsSwitchWithDetailCell *)[tableView dequeueReusableCellWithIdentifier:WARSettingsSwitchWithDetailCellID];
        ((WARSettingsSwitchWithDetailCell *)cell).descriptionText = ((WARSettingSwitchWithDetailCellItem*)item).titleString;
        ((WARSettingsSwitchWithDetailCell *)cell).detailString = ((WARSettingSwitchWithDetailCellItem*)item).detailString;
        ((WARSettingsSwitchWithDetailCell *)cell).delegate = self;
        ((WARSettingsSwitchWithDetailCell *)cell).switchButton.on = ((WARSettingSwitchWithDetailCellItem*)item).open;
    }else { //WARSettingCheckMarkCellItem
        cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:CheckMarkSettingCellID];
        
        ((WARSettingsCheckMarkCell *)cell).descriptionText = ((WARSettingCheckMarkCellItem*)item).titleString;
        ((WARSettingsCheckMarkCell *)cell).isChecked = ((WARSettingCheckMarkCellItem*)item).checked;
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [((NSArray*)[self.sectionDataArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    
    if (0 == indexPath.section) {
        WARSettingCellItem *cellItem = (WARSettingCellItem *)item;
        if ([cellItem.titleString isEqualToString:AddMyWay]) {
            WARAddMySelfWayViewController *addMyselfVC = [WARAddMySelfWayViewController new];
            [self.navigationController pushViewController:addMyselfVC animated:YES];
        }else if ([cellItem.titleString isEqualToString:DistancePrivate]) {
            WARPrivateDistanceViewController *private = [WARPrivateDistanceViewController new];
            [self.navigationController pushViewController:private animated:YES];
        }else if ([cellItem.titleString isEqualToString:BlackList]) {
            WARPrivatePersonListViewController *vc = [[WARPrivatePersonListViewController alloc] init];
            vc.type = WARPrivatePersonTypeBlack;
            [self.navigationController pushViewController:vc animated:YES];
//            UIViewController *blackListVC = [[WARMediator sharedInstance] Mediator_viewControllerForBlackList];
//            [self.navigationController pushViewController:blackListVC animated:YES];
        }
    }else if (1 == indexPath.section) {
        WARPrivatePersonListViewController *vc = [[WARPrivatePersonListViewController alloc] init];
        if (0 == indexPath.row) {
            vc.type = WARPrivatePersonTypeMomentNoAccess;
        }else if (1 == indexPath.row) {
            vc.type = WARPrivatePersonTypeMomentNoReceive;
        }else if (2 == indexPath.row) {
            vc.type = WARPrivatePersonTypeLocationNoShow;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == numberOfSection - 1) {
        NSMutableArray *itemsArray = [self.sectionDataArray objectAtIndex:indexPath.section];
        if (indexPath.row > 0) {//第一个cell是个开关，先排除
            for (int i = 1 ; i < itemsArray.count; i++) {
                WARSettingCheckMarkCellItem *item = [itemsArray objectAtIndex:i];
                item.checked = NO;
            }
            
            WARSettingCheckMarkCellItem *item = [itemsArray objectAtIndex:indexPath.row];
            item.checked = YES;
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            
            [self updateScopeSettingsByIndexPath:indexPath];
        }
    }else {
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - cell delegate
- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    if (0 == indexPath.section) {//frend recommand reference section
        if (0 == indexPath.row) { // frend recommand cell
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.addNeedConfirm = isOn;
            }];
            [self.dataManager addFriendNeedConfirmSwitch:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
        }else if (1 == indexPath.row) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.toGroupNeedConfirm = isOn;
            }];
            [self.dataManager toGroupNeedConfirmSwitch:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
        }
    }else if (1 == indexPath.section) {//broadcast cell
        if(0 == indexPath.row) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.broadcast = isOn;
            }];
            
            [self.dataManager broadcastSwitch:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
        }
    }else if (indexPath.section == numberOfSection - 1) {

        [kRealm transactionWithBlock:^{
            self.dataManager.userInfo.profileSetting.distanceClosed = isOn;
        }];
        
        [self.dataManager distanceSwitch:isOn Success:^(id successData) {
            ;
        } failed:^(id failedData) {
            ;
        }];
        
        NSMutableArray *array = [self.sectionDataArray objectAtIndex:indexPath.section];
        WARSettingSwitchWithDetailCellItem *item = [array objectAtIndex:indexPath.row];
        item.open = isOn;
        if (isOn) {
            [array addObjectsFromArray:self.distanceSectionArray];
        }else {
            [array removeObjectsInRange:NSMakeRange(1, array.count - 1)];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:array.count -1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)updateScopeSettingsByIndexPath:(NSIndexPath *)indexPath {
    DistanceScopeType type;
    
    if (indexPath.row > 0) {//first row is switch
        switch (indexPath.row) {
            case 1:{
                type = DistanceScopeTypeAll;
                
                [kRealm transactionWithBlock:^{
                    self.dataManager.userInfo.profileSetting.allCanSeeDistance = YES;
                    self.dataManager.userInfo.profileSetting.friendCanSeeDistance = NO;
                    self.dataManager.userInfo.profileSetting.startCanSeeDistance = NO;
                }];
                break;
            }
            case 2:{
                type = DistanceScopeTypeFried;
                [kRealm transactionWithBlock:^{
                    self.dataManager.userInfo.profileSetting.allCanSeeDistance = NO;
                    self.dataManager.userInfo.profileSetting.friendCanSeeDistance = YES;
                    self.dataManager.userInfo.profileSetting.startCanSeeDistance = NO;
                }];
                break;
            }
            case 3:{
                type = DistanceScopeTypeStar;
                [kRealm transactionWithBlock:^{
                    self.dataManager.userInfo.profileSetting.allCanSeeDistance = NO;
                    self.dataManager.userInfo.profileSetting.friendCanSeeDistance = NO;
                    self.dataManager.userInfo.profileSetting.startCanSeeDistance = YES;
                }];
                break;
            }
            default: {
                type = DistanceScopeTypeAll;
                break;
            }
        }
        

        [self.dataManager distanceScopeByType:type Success:^(id successData) {
            ;
        } failed:^(id failedData) {
            ;
        }];        
    }
}

@end
