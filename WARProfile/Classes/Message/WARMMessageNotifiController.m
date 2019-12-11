//
//  WARMMessageNotifiController.m
//  Pods
//
//  Created by huange on 2017/8/16.
//
//

#import "WARMMessageNotifiController.h"

#define SwithcSettingCellID                 @"SwithcSettingCellID"
#define WARSettingsSwitchWithDetailCellID   @"WARSettingsSwitchWithDetailCell"

@interface WARMMessageNotifiController () <WARSettingsSwitchCellDelegate>

@end

@implementation WARMMessageNotifiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    [super initData];
    
    WARSettingSwitchCellItem *item0 = [WARSettingSwitchCellItem new];
    item0.titleString = WARLocalizedString(@"接收新消息通知");
    item0.open = self.dataManager.userInfo.profileSetting.messageSetting.reveiveNewMessage;
    item0.messageSettingType = MessageSwitchReceiveNewMessageType;
    
    WARSettingSwitchWithDetailCellItem *item = [WARSettingSwitchWithDetailCellItem new];
    item.titleString = WARLocalizedString(@"通知显示新消息详情");
    item.detailString =  WARLocalizedString(@"关闭后，新消息通知将不显示发送人和具体内容");
    item.open = self.dataManager.userInfo.profileSetting.messageSetting.disPlayDetail;
    item.messageSettingType = MessageSwitchDisplayDetailMessageType;
    
    self.settinsItemArray = [NSMutableArray arrayWithObjects:item0,item, nil];
}

- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"消息通知设置");
    
    self.tableView.rowHeight = commonCellHeight;
    [self.tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:SwithcSettingCellID];
    [self.tableView registerClass:[WARSettingsSwitchWithDetailCell class] forCellReuseIdentifier:WARSettingsSwitchWithDetailCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.settinsItemArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    
    if ([item isKindOfClass:[WARSettingSwitchCellItem class]]) {
        cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwithcSettingCellID];
        ((WARSettingsSwitchCell *)cell).descriptionText = ((WARSettingSwitchCellItem*)item).titleString;
        ((WARSettingsSwitchCell *)cell).delegate = self;
        ((WARSettingsSwitchCell *)cell).switchButton.on = ((WARSettingSwitchCellItem*)item).open;
        
    }else if ([item isKindOfClass:[WARSettingSwitchWithDetailCellItem class]]){ //WARSettingCheckMarkCellItem
        cell = (WARSettingsSwitchWithDetailCell *)[tableView dequeueReusableCellWithIdentifier:WARSettingsSwitchWithDetailCellID];
        ((WARSettingsSwitchWithDetailCell *)cell).descriptionText = ((WARSettingSwitchWithDetailCellItem*)item).titleString;
        ((WARSettingsSwitchWithDetailCell *)cell).detailString = ((WARSettingSwitchWithDetailCellItem*)item).detailString;
        ((WARSettingsSwitchWithDetailCell *)cell).delegate = self;
        ((WARSettingsSwitchWithDetailCell *)cell).switchButton.on = ((WARSettingSwitchWithDetailCellItem*)item).open;
    }
    return cell;
}

- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    WARSettingSwitchCellItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
    
    if (MessageSwitchReceiveNewMessageType == item.messageSettingType) {
        [kRealm transactionWithBlock:^{
            self.dataManager.userInfo.profileSetting.messageSetting.reveiveNewMessage = isOn;
        }];
        
        [self.dataManager messageReceiveNewMessage:isOn Success:nil failed:nil];
    }else if (MessageSwitchDisplayDetailMessageType == item.messageSettingType) {
        [kRealm transactionWithBlock:^{
            self.dataManager.userInfo.profileSetting.messageSetting.disPlayDetail = isOn;
        }];
        
        [self.dataManager messagDisplayDetail:isOn Success:nil failed:nil];
    }
}

@end
