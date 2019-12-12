//
//  WARMessageSettingViewController.m
//  Pods
//
//  Created by huange on 2017/8/15.
//
//

#import "WARMessageSettingViewController.h"
#import "WARMMessageNotifiController.h"

#import "WARSettingHeaderView.h"

#define CommentSettingCellID                @"CommentSettingCellID"
#define SwithcSettingCellID                 @"SwithcSettingCellID"
#define WARSettingsSwitchWithDetailCellID   @"WARSettingsSwitchWithDetailCell"
#define WARSettingsWARTimePickerCellID      @"WARTimePickerCellId"

#define CommentHeaderID      @"headerId"
#define CommentFooterID                     @"CommentFooterID"

#define TimeSelecterCellHeight 260

/*************** picker cell  ************/
#define NumberOfComponents 2
#define NumberOfRowInComponents 24

@interface WARMessageSettingViewController () <WARSettingsSwitchCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WARTimePickerCellDelegate>

@property (nonatomic, strong) NSMutableArray *pickerCellItemArray;
@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, strong) WARSettingSelectTimeCellItem *currentSelectedItem;
@property (nonatomic, strong) WARSettingSelectTimeCellItem *defaultSelectedItem;
@property (nonatomic, strong) WARSettingWithRightTextCellItem *disPlaySelectedTimeItem;

@end

@implementation WARMessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appWillEnterForegroundNotification {
    [self.sectionDataArray removeObjectAtIndex:0];
    [self.sectionDataArray insertObject:[self getFirstSectionData] atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Data
- (void)initData {
    [super initData];
    
    self.sectionDataArray = [NSMutableArray arrayWithCapacity:7];
    [self.sectionDataArray addObject:[self getFirstSectionData]];
    [self.sectionDataArray addObject:[self getSecondSectionData]];
    [self.sectionDataArray addObject:[self getThirdSectionData]];
    [self.sectionDataArray addObject:[self getTweetReactData]];
    [self.sectionDataArray addObject:[self getFourthSectionData]];

    
    WARSettingSwitchCellItem *item = [WARSettingSwitchCellItem new];
    item.titleString = WARLocalizedString(@"勿扰模式");
//    item.detailString =  WARLocalizedString(@"开启后，在设定时间段内不会有声音或震动提示");
    item.open = self.dataManager.userInfo.profileSetting.messageSetting.doNotDisTurb;
    item.messageSettingType = MessageSwitchDotDisTurb;
    
    //displaySelected Time item
    self.disPlaySelectedTimeItem = [WARSettingWithRightTextCellItem new];
    self.disPlaySelectedTimeItem.titleString = WARLocalizedString(@"选择时段");
    NSMutableArray *datePickArray = [NSMutableArray arrayWithObjects:item, nil];
    if (item.open) {
        [datePickArray addObject:self.disPlaySelectedTimeItem];
    }
    [self.sectionDataArray addObject:datePickArray];

    
    //date picker
    self.pickerCellItemArray = [NSMutableArray new];
    for (int i = 0; i < 24; i++) {
        WARSettingSelectTimeCellItem *timeItem = [WARSettingSelectTimeCellItem new];
        timeItem.titleString = nil;
        timeItem.fromTime = i;
        timeItem.endTime = i;
        [self.pickerCellItemArray addObject:timeItem];
    }
    
    self.currentSelectedItem = [WARSettingSelectTimeCellItem new];
    self.currentSelectedItem.fromTime = self.dataManager.userInfo.profileSetting.messageSetting.fromTime;
    self.currentSelectedItem.endTime = self.dataManager.userInfo.profileSetting.messageSetting.toTime;
    
    self.defaultSelectedItem = [WARSettingSelectTimeCellItem new];
    self.defaultSelectedItem.fromTime = self.dataManager.userInfo.profileSetting.messageSetting.fromTime;
    self.defaultSelectedItem.endTime = self.dataManager.userInfo.profileSetting.messageSetting.toTime;
    
    self.disPlaySelectedTimeItem.rightText = [self dateStringBySelectedItem:self.defaultSelectedItem];
}

- (NSArray *)getFirstSectionData {
    NSMutableArray *settingSArray = [NSMutableArray new];

    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    WARSettingWithRightTextCellItem *item = [WARSettingWithRightTextCellItem new];
    item.titleString = WARLocalizedString(@"接收通知提醒");

    if (UIUserNotificationTypeNone == setting.types) {
        item.rightText = WARLocalizedString(@"已关闭");
        [settingSArray addObject:item];

        //
        WARSettingCellItem *itemSetting = [WARSettingCellItem new];
        itemSetting.titleString = WARLocalizedString(@"开启通知提醒，避免错过重要消息");
        [settingSArray addObject:itemSetting];
    }else {
        item.rightText = WARLocalizedString(@"已开启");
        [settingSArray addObject:item];
    }

    return settingSArray;
}

- (NSArray *)getSecondSectionData {
    WARSettingSwitchCellItem *item0 = [WARSettingSwitchCellItem new];
    item0.titleString = WARLocalizedString(@"接收新消息通知");
    item0.open = self.dataManager.userInfo.profileSetting.messageSetting.reveiveNewMessage;
    item0.messageSettingType = MessageSwitchReceiveNewMessageType;

    WARSettingSwitchCellItem *item = [WARSettingSwitchCellItem new];
    item.titleString = WARLocalizedString(@"通知显示新消息详情");
    item.open = self.dataManager.userInfo.profileSetting.messageSetting.disPlayDetail;
    item.messageSettingType = MessageSwitchDisplayDetailMessageType;

    return @[item0,item];
}

- (NSArray *)getTweetReactData {
    WARSettingSwitchCellItem *item0 = [WARSettingSwitchCellItem new];
    item0.titleString = WARLocalizedString(@"朋友圈互动提醒");
    item0.open = self.dataManager.userInfo.profileSetting.messageSetting.friendCycleInteraction;
    item0.messageSettingType = MessageSwitchFriendCycleInteractionType;
    
    WARSettingSwitchCellItem *item = [WARSettingSwitchCellItem new];
    item.titleString = WARLocalizedString(@"我的足迹互动提醒");
    item.open = self.dataManager.userInfo.profileSetting.messageSetting.myTrackInteraction;
    item.messageSettingType = MessageSwitchMyTrackInteractionType;
    
    WARSettingSwitchCellItem *item2 = [WARSettingSwitchCellItem new];
    item2.titleString = WARLocalizedString(@"群动态互动提醒");
    item2.open = self.dataManager.userInfo.profileSetting.messageSetting.groupDynamicsInteraction;
    item2.messageSettingType = MessageSwitchGroupDynamicsInteractionType;
    
    WARSettingSwitchCellItem *item3 = [WARSettingSwitchCellItem new];
    item3.titleString = WARLocalizedString(@"相册互动提醒");
    item3.open = self.dataManager.userInfo.profileSetting.messageSetting.albumInteraction;
    item3.messageSettingType = MessageSwitchAlbumInteractionType;
    
    WARSettingSwitchCellItem *item4 = [WARSettingSwitchCellItem new];
    item4.titleString = WARLocalizedString(@"收藏互动提醒");
    item4.open = self.dataManager.userInfo.profileSetting.messageSetting.collectionInteraction;
    item4.messageSettingType = MessageSwitchCollectionInteractionType;

    return @[item0,item,item2,item3,item4];
}

- (NSArray *)getThirdSectionData {
    WARSettingSwitchCellItem *item2 = [WARSettingSwitchCellItem new];
    item2.titleString = WARLocalizedString(@"邀请入群通知");
    item2.messageSettingType = MessageSwitchInviteToGroupType;
    item2.open = self.dataManager.userInfo.profileSetting.messageSetting.inviteToGroup;

    WARSettingSwitchCellItem *item3 = [WARSettingSwitchCellItem new];
    item3.titleString = WARLocalizedString(@"审核加群申请通知");
    item3.messageSettingType = MessageSwitchConfirmToGroupType;
    item3.open = self.dataManager.userInfo.profileSetting.messageSetting.confirmToGroup;

    return @[item2,item3];
}

- (NSArray *)getFourthSectionData {
//    WARSettingCellItem *item1 = [WARSettingCellItem new];
//    item1.titleString = WARLocalizedString(@"消息通知设置");

    WARSettingSwitchCellItem *item2 = [WARSettingSwitchCellItem new];
    item2.titleString = WARLocalizedString(@"声音");
    item2.messageSettingType = MessageSwitchSound;
    item2.open = self.dataManager.userInfo.profileSetting.messageSetting.sound;
    
    WARSettingSwitchCellItem *item3 = [WARSettingSwitchCellItem new];
    item3.titleString = WARLocalizedString(@"振动");
    item3.messageSettingType = MessageSwitchShake;
    item3.open = self.dataManager.userInfo.profileSetting.messageSetting.shake;
    
    return @[item2,item3];
}

#pragma mark - UI
- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"消息通知");
    
    [self.tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:CommentSettingCellID];
    [self.tableView registerClass:[WARSettingHeaderView class] forHeaderFooterViewReuseIdentifier:CommentHeaderID];
    [self.tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:SwithcSettingCellID];
    [self.tableView registerClass:[WARSettingsSwitchWithDetailCell class] forCellReuseIdentifier:WARSettingsSwitchWithDetailCellID];
    [self.tableView registerClass:[WARTimePickerCell class] forCellReuseIdentifier:WARSettingsWARTimePickerCellID];
    [self.tableView registerClass:[WARSettingsFooterView class] forHeaderFooterViewReuseIdentifier:CommentFooterID];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = BackgroundDefaultColor;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArray = [self.sectionDataArray objectAtIndex:section];
    return itemArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    NSArray *itemArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    NSObject *item = [itemArray objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[WARSettingSelectTimeCellItem class]]) {
        height = TimeSelecterCellHeight;
    }
    
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 10;
    }else if ( section == self.sectionDataArray.count - 1) {
        return 0.01f;
    }else {
        return HeaderViewDefaultHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return [self getTheStringHeight:WARLocalizedString(@"如要开启或关闭wander的推送通知，请在iPhone的“设置”-“通知”功能中，找到“wander”进行设置") setFont:14 withWidth:kScreenWidth - 30] + 6.5 * 2;
    }
    else if (1 == section) {
        return [self getTheStringHeight:WARLocalizedString(@"关闭新消息详情后，通知将不显示发送人和具体内容") setFont:14 withWidth:kScreenWidth - 30] + 6.5 * 2;
    }else if (5 == section) {
        return [self getTheStringHeight:WARLocalizedString(@"开启勿扰模式后，在设定时间段内推送不会有声音或震动提示") setFont:14 withWidth:kScreenWidth - 30] + 6.5 * 2;
    }else {
        return 0.01f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WARSettingHeaderView *headerView = (WARSettingHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentHeaderID];
    headerView.contentView.backgroundColor = HEXCOLOR(0xF4F4F4);
//    headerView.backgroundColor = HEXCOLOR(0xF4F4F4);

    switch (section) {
        case 1: {
            headerView.titleLabel.text = WARLocalizedString(@"消息通知");
            break;
        }
        case 2: {
            headerView.titleLabel.text = WARLocalizedString(@"群组通知");
            break;
        }
        case 3: {
            headerView.titleLabel.text = WARLocalizedString(@"动态提醒");
            break;
        }
        case 4: {
            headerView.titleLabel.text = WARLocalizedString(@"应用内提醒");
            break;
        }
        default:
            headerView.titleLabel.text = @"";
            break;
    }

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WARSettingsFooterView *footerView = (WARSettingsFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentFooterID];
    footerView.contentView.backgroundColor = HEXCOLOR(0xF4F4F4);
//    footerView.backgroundColor = HEXCOLOR(0xF4F4F4);
    footerView.titleLabel.attributedText = nil;
    footerView.titleLabel.text = nil;
    switch (section) {
        case 0: {
            footerView.titleLabel.attributedText = [self attributedStringWithString:WARLocalizedString(@"如要开启或关闭wander的推送通知，请在iPhone的“设置”-“通知”功能中，找到“wander”进行设置")];
            break;
        }
        case 1: {
            footerView.titleLabel.attributedText = [self attributedStringWithString:WARLocalizedString(@"关闭新消息详情后，通知将不显示发送人和具体内容")];
            break;
        }
        case 5: {
            footerView.titleLabel.attributedText = [self attributedStringWithString:WARLocalizedString(@"开启勿扰模式后，在设定时间段内推送不会有声音或震动提示")];
            break;
        }
        default:
            break;
    }

    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [((NSArray*)[self.sectionDataArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;

    if ([item isKindOfClass:[WARSettingSwitchWithDetailCellItem class]]){ //WARSettingCheckMarkCellItem
        cell = (WARSettingsSwitchWithDetailCell *)[tableView dequeueReusableCellWithIdentifier:WARSettingsSwitchWithDetailCellID];
        ((WARSettingsSwitchWithDetailCell *)cell).descriptionText = ((WARSettingSwitchWithDetailCellItem*)item).titleString;
        ((WARSettingsSwitchWithDetailCell *)cell).detailString = ((WARSettingSwitchWithDetailCellItem*)item).detailString;
        ((WARSettingsSwitchWithDetailCell *)cell).delegate = self;
        ((WARSettingsSwitchWithDetailCell *)cell).switchButton.on = ((WARSettingSwitchWithDetailCellItem*)item).open;
    }else if ([item isKindOfClass:[WARSettingWithRightTextCellItem class]]) {
        cell = (WARSettingsCell *)[tableView dequeueReusableCellWithIdentifier:CommentSettingCellID];
        ((WARSettingsCell *)cell).descriptionText = ((WARSettingCellItem*)item).titleString;
        ((WARSettingsCell *)cell).showAccessoryView = NO;
        ((WARSettingsCell *)cell).rightText = ((WARSettingWithRightTextCellItem*)item).rightText;
        ((WARSettingsCell *)cell).rightTextColor = ThreeLevelTextColor;
        ((WARSettingsCell *)cell).leftTextColor = TextColor;
    }else if ([item isKindOfClass:[WARSettingSwitchCellItem class]]) {
        cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwithcSettingCellID];
        ((WARSettingsSwitchCell *)cell).descriptionText = ((WARSettingSwitchCellItem*)item).titleString;
        ((WARSettingsSwitchCell *)cell).delegate = self;
        ((WARSettingsSwitchCell *)cell).switchButton.on = ((WARSettingSwitchCellItem*)item).open;
    }else if ([item isMemberOfClass:[WARSettingCellItem class]]) {
        cell = (WARSettingsCell *)[tableView dequeueReusableCellWithIdentifier:CommentSettingCellID];
        ((WARSettingsCell *)cell).descriptionText = ((WARSettingCellItem*)item).titleString;
        ((WARSettingsCell *)cell).showAccessoryView = YES;
        ((WARSettingsCell *)cell).rightText = nil;
        ((WARSettingsCell *)cell).rightTextColor = ThreeLevelTextColor;
        ((WARSettingsCell *)cell).leftTextColor = TextColor;
        if ([((WARSettingCellItem*)item).titleString isEqualToString:WARLocalizedString(@"开启通知提醒，避免错过重要消息")]) {
            ((WARSettingsCell *)cell).leftTextColor = ThemeColor;
        }
    }else {
        WARTimePickerCell *pickCell = (WARTimePickerCell*)[tableView dequeueReusableCellWithIdentifier:WARSettingsWARTimePickerCellID];
       
        pickCell.timePickerView.dataSource = self;
        pickCell.timePickerView.delegate = self;
        pickCell.delegate = self;
        
        [pickCell.timePickerView selectRow:self.defaultSelectedItem.fromTime inComponent:0 animated:NO];
        [pickCell.timePickerView selectRow:self.defaultSelectedItem.endTime inComponent:1 animated:NO];

        cell = pickCell;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (0 == indexPath.section) {
        if (1 == indexPath.row) {// enter system setting
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else if (self.sectionDataArray.count - 1 == indexPath.section && 1 == indexPath.row) {
        NSInteger cellCount = [tableView numberOfRowsInSection:indexPath.section];
        if (cellCount > 2) {// alread have time piker cell do nothing
            //            [self removePickTimeCell:indexPath pickerTimeItem:self.defaultSelectedItem];
        }else {
            [self insertPickTimeCell:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] pickerTimeItem:self.defaultSelectedItem];
        }
    }
}

- (void)insertPickTimeCell:(NSIndexPath*)indexPath pickerTimeItem:(WARSettingSelectTimeCellItem *)item{
    if (!item) {
        return;
    }
    
    NSMutableArray *tempMutableArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    [tempMutableArray addObject:item];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)removePickTimeCell:(NSIndexPath*)indexPath pickerTimeItem:(WARSettingSelectTimeCellItem *)item{
    if (!item) {
        return;
    }
    
    [self.sectionDataArray removeObject:item];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)dateStringBySelectedItem:(WARSettingSelectTimeCellItem*)item {
    NSString *dateString = nil;
    if (item.fromTime < item.endTime) {
        dateString = [NSString stringWithFormat:@"%@%@",WARLocalizedString(@"每日"),[NSString stringWithFormat:@"%ld:00-%ld:00",item.fromTime,item.endTime]];
    }else {
        NSString *dayStringTemp = WARLocalizedString(@"每日");
        NSString *nextDay = WARLocalizedString(@"次日");
        
        dateString = [NSString stringWithFormat:@"%@%ld:00-%@%ld:00",dayStringTemp,item.fromTime,nextDay,item.endTime];

    }
    
    return dateString;
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : ThreeLevelTextColor}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    return attrString;
}

- (CGFloat)getTheStringHeight:(NSString *)string setFont:(CGFloat)font withWidth:(CGFloat)width {
    if (string == nil || [string isEqualToString:@""]) {
        return 0;
    }
    NSMutableAttributedString  *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:2];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:font]
                    range:range];

    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:dic
                                           context:nil].size;
    return textSize.height;
}

#pragma mark - date picker cell delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return NumberOfComponents;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return NumberOfRowInComponents;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component  {
    
    return commonCellHeight;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    WARSettingSelectTimeCellItem *item = [self.pickerCellItemArray objectAtIndex:row];
    
    NSString *timeString = nil;
    NSInteger fromTime = item.fromTime;
    NSInteger endTime = item.endTime;
    if (0 == component) {
        if (fromTime < 0) {
            timeString = [NSString stringWithFormat:@"0%ld:00",fromTime];
        }else {
            timeString = [NSString stringWithFormat:@"%ld:00",fromTime];
        }
    }else if (1 == component){
        if (endTime < 0) {
            timeString = [NSString stringWithFormat:@"0%ld:00",endTime];
        }else {
            timeString = [NSString stringWithFormat:@"%ld:00",endTime];
        }
    }
    
    return timeString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    WARSettingSelectTimeCellItem *item = [self.pickerCellItemArray objectAtIndex:row];

    if (0 == component) {
        self.currentSelectedItem.fromTime = item.fromTime;
    }else if (1 == component) {
        self.currentSelectedItem.endTime = item.endTime;
    }
}

#pragma mark picker cell delegate

- (void)cancelButtonAction:(NSIndexPath*)indexPath {
    [self removeTimerPickerCell:indexPath];
}


- (void)confirmButtonAction:(NSIndexPath*)indexPath {
    NSIndexPath *disPlaySelectedTimeIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    WARSettingsCell *displayTimeCell = (WARSettingsCell*)[self.tableView cellForRowAtIndexPath:disPlaySelectedTimeIndexPath];
    displayTimeCell.rightText = [self dateStringBySelectedItem:self.currentSelectedItem];
    
    [kRealm transactionWithBlock:^{
        self.dataManager.userInfo.profileSetting.messageSetting.fromTime = self.currentSelectedItem.fromTime;
        self.dataManager.userInfo.profileSetting.messageSetting.toTime = self.currentSelectedItem.endTime;
    }];
    
    //必须打开的情况下，才可以店家确认，所以第一个参数写死YES
    [self.dataManager messageDoNotDisturb:YES timeStrig:[self currentTimeString] Success:nil failed:nil];
    
    [self removeTimerPickerCell:indexPath];
}

- (void)removeTimerPickerCell:(NSIndexPath *)indexPath {
    NSMutableArray *doNotDistrubCellArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    
    [doNotDistrubCellArray removeLastObject];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)currentTimeString {
    NSString *fromTime = [NSString stringWithFormat:@"%ld:00",self.currentSelectedItem.fromTime];
    NSString *toTime = [NSString stringWithFormat:@"%ld:00",self.currentSelectedItem.endTime];
    
    NSString *timePeriodString = [NSString stringWithFormat:@"%@-%@",fromTime,toTime];

    return timePeriodString;
}

- (NSString *)defaultTimeString {
    NSString *fromTime = [NSString stringWithFormat:@"%ld:00",self.defaultSelectedItem.fromTime];
    NSString *toTime = [NSString stringWithFormat:@"%ld:00",self.defaultSelectedItem.endTime];
    
    NSString *timePeriodString = [NSString stringWithFormat:@"%@-%@",fromTime,toTime];
    
    return timePeriodString;
}

#pragma mark - switch delegate
- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    NSMutableArray *tempMutableArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    WARSettingSwitchCellItem *item = [tempMutableArray objectAtIndex:indexPath.row];
    item.open = isOn;
    
    if (MessageSwitchDotDisTurb == item.messageSettingType) {
        [kRealm transactionWithBlock:^{
            self.dataManager.userInfo.profileSetting.messageSetting.doNotDisTurb = isOn;
        }];
        NSIndexPath *handleCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        if (isOn) {
            [tempMutableArray addObject:self.disPlaySelectedTimeItem];
            [self.tableView insertRowsAtIndexPaths:@[handleCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataManager messageDoNotDisturb:YES timeStrig:[self defaultTimeString] Success:nil failed:nil];

        }else {
            NSRange shouldRemovedObjectsRange = NSMakeRange(1, tempMutableArray.count - 1);
            [tempMutableArray removeObjectsInRange:shouldRemovedObjectsRange];

            NSMutableArray *indexPathArray = [NSMutableArray array];
            for (int i = 0; i < shouldRemovedObjectsRange.length; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow: i+1 inSection:indexPath.section ];
                [indexPathArray addObject:tempIndexPath];
            }
            
            [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            //close Do not Disturb
            [self.dataManager messageDoNotDisturb:NO timeStrig:nil Success:nil failed:nil];
        }
    }else {
        if (MessageSwitchSound == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.sound = isOn;
            }];
            
            [self.dataManager messageSettingSoundOpen:isOn Success:nil failed:nil];
        }else if (MessageSwitchShake == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.shake = isOn;
            }];
            
            [self.dataManager messageSettingShakeOpen:isOn Success:nil failed:nil];
        }else if (MessageSwitchReceiveNewMessageType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.reveiveNewMessage = isOn;
            }];

            [self.dataManager messageReceiveNewMessage:isOn Success:nil failed:nil];
        }else if (MessageSwitchDisplayDetailMessageType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.disPlayDetail = isOn;
            }];

            [self.dataManager messagDisplayDetail:isOn Success:nil failed:nil];
        }else if (MessageSwitchInviteToGroupType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.inviteToGroup = isOn;
            }];

            [self.dataManager messagInviteToGroupOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchConfirmToGroupType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.confirmToGroup = isOn;
            }];

            [self.dataManager messagconfirmToGroupOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchTweetReactType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.tweetReact = isOn;
            }];

            [self.dataManager messagTweetReactOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchActiveReactType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.activeReact = isOn;
            }];

            [self.dataManager messagActiviteReactOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchActiveParticipateRemindType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.activeParticipateRemind = isOn;
            }];

            [self.dataManager messagActiviteParticipateRemindOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchFriendCycleInteractionType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.friendCycleInteraction = isOn;
            }];
            
            [self.dataManager messageFriendCycleInteractionOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchMyTrackInteractionType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.myTrackInteraction = isOn;
            }];
            
            [self.dataManager messageMyTrackInteractionOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchGroupDynamicsInteractionType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.groupDynamicsInteraction = isOn;
            }];
            
            [self.dataManager messageGroupDynamicsInteractionOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchAlbumInteractionType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.albumInteraction = isOn;
            }];
            
            [self.dataManager messageAlbumInteractionOpen:isOn Success:nil failed:nil];
        }
        else if (MessageSwitchCollectionInteractionType == item.messageSettingType) {
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.messageSetting.collectionInteraction = isOn;
            }];
            
            [self.dataManager messageCollectionInteractionOpen:isOn Success:nil failed:nil];
        }
    }
}

@end
