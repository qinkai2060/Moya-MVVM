//
//  WARPrivateDistanceViewController.m
//  WARProfile
//
//  Created by huange on 2017/11/10.
//

#import "WARPrivateDistanceViewController.h"

#import "WARSettingCellItem.h"
#import "WARSettingsCell.h"
#import "WARSettingHeaderView.h"

#define numberOfSection 1
#define CheckMarkSettingCellID              @"CheckMarkSettingCellID"

@interface WARPrivateDistanceViewController ()

@property (nonatomic, strong) NSMutableArray *distanceSectionArray;

@end

@implementation WARPrivateDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init UI
- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"距离隐私");

    self.tableView.rowHeight = commonCellHeight;
    [self.tableView registerClass:[WARSettingsCheckMarkCell class] forCellReuseIdentifier:CheckMarkSettingCellID];
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.distanceSectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 10;
    }else {
        return HeaderViewDefaultHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.distanceSectionArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:CheckMarkSettingCellID];

    ((WARSettingsCheckMarkCell *)cell).descriptionText = ((WARSettingCheckMarkCellItem*)item).titleString;
    ((WARSettingsCheckMarkCell *)cell).isChecked = ((WARSettingCheckMarkCellItem*)item).checked;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    WARSettingCheckMarkCellItem *checkDefatulItem = [self.distanceSectionArray objectAtIndex:indexPath.row];
    for (WARSettingCheckMarkCellItem *item in self.distanceSectionArray) {
        item.checked = NO;
    }

    checkDefatulItem.checked = YES;

    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    [self updateScopeSettingsByIndexPath:indexPath];
}

#pragma mark - data
- (void)initDataArray {
    self.distanceSectionArray = [NSMutableArray new];

    WARSettingCheckMarkCellItem *checkDefatulItem = [WARSettingCheckMarkCellItem new];
    checkDefatulItem.titleString = WARLocalizedString(@"对所有人显示距离");
    checkDefatulItem.checked = self.dataManager.userInfo.profileSetting.allCanSeeDistance;

    WARSettingCheckMarkCellItem *onlyFriendCanSeeItem = [WARSettingCheckMarkCellItem new];
    onlyFriendCanSeeItem.titleString = WARLocalizedString(@"只对好友显示距离");
    onlyFriendCanSeeItem.checked = self.dataManager.userInfo.profileSetting.friendCanSeeDistance;

    WARSettingCheckMarkCellItem *closeItem = [WARSettingCheckMarkCellItem new];
    closeItem.titleString = WARLocalizedString(@"对所有人关闭距离");
    closeItem.checked = self.dataManager.userInfo.profileSetting.distanceClosed;

    // default
    if (!checkDefatulItem.checked && !onlyFriendCanSeeItem.checked && !closeItem.checked) {
        checkDefatulItem.checked = YES;
    }

    [self.distanceSectionArray addObject:checkDefatulItem];
    [self.distanceSectionArray addObject:onlyFriendCanSeeItem];
    [self.distanceSectionArray addObject:closeItem];
}

- (void)updateScopeSettingsByIndexPath:(NSIndexPath *)indexPath {
    DistanceScopeType type;

    switch (indexPath.row) {
        case 0:{
            type = DistanceScopeTypeAll;

            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.allCanSeeDistance = YES;
                self.dataManager.userInfo.profileSetting.friendCanSeeDistance = NO;
                self.dataManager.userInfo.profileSetting.distanceClosed = NO;
            }];
            break;
        }
        case 1:{
            type = DistanceScopeTypeFried;
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.allCanSeeDistance = NO;
                self.dataManager.userInfo.profileSetting.friendCanSeeDistance = YES;
                self.dataManager.userInfo.profileSetting.distanceClosed = NO;
            }];
            break;
        }
        case 2:{
            type = DistanceScopeTypeClose;
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.allCanSeeDistance = NO;
                self.dataManager.userInfo.profileSetting.friendCanSeeDistance = NO;
                self.dataManager.userInfo.profileSetting.distanceClosed = YES;
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

@end
