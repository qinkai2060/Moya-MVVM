//
//  WARUserSettingViewController.m
//  Pods
//
//  Created by huange on 2017/9/5.
//
//

#import "WARUserSettingViewController.h"
#import "WARSettingsCell.h"
#import "WARUserSettingItem.h"
#import "WARUserSettingFooterView.h"
#import "WARUserCommentViewController.h"
#import "WARMediator+TweetComplain.h"
#import "WARMediator+Chat.h"

#import "WARUIHelper.h"
#import "WARMoveGroupViewController.h"
#import "WARGroupMangerViewController.h"
#import "WARNetwork.h"
#import "WARDBFriendManager.h"

#import "WARAlertView.h"

#define SettingsSwitchCellId      @"WARSettingsSwitchCellId"
#define CommentCellId             @"commentCellID"
#define CommentCellHeight         45

#define HeaderViewHeight         30
#define HeaderViewId              @"HeaderViewId"

@interface WARUserSettingViewController ()<UITableViewDelegate, UITableViewDataSource, WARSettingsSwitchCellDelegate>

@property (nonatomic, assign) UMainControllerPersonType personType;
@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, copy) NSString *accountId;

@end

@implementation WARUserSettingViewController

- (instancetype)initWithAccount:(NSString *)accountID type:(UMainControllerPersonType)type; {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.accountId = accountID;
        self.personType = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData

- (void)initData {
    self.dataManager = [[WARUserEditDataManager alloc] initWithAccountID:self.accountId];
    
    self.sectionDataArray = [[NSMutableArray alloc] init];
    [self.sectionDataArray addObject:[self getFirstSectionArray]];

    if (UMainControllerPersonTypeOfFriend == self.personType) {
        if (self.dataManager.contactUser.blacklist) {
            [self.sectionDataArray addObject:[self getFourthSection]];
        }else {
            [self.sectionDataArray addObject:[self getSecondSection]];
            [self.sectionDataArray addObject:[self getThirdSection]];
            [self.sectionDataArray addObject:[self getFourthSection]];
        }
    }else {
        if (self.dataManager.contactUser.blacklist) {
            [self.sectionDataArray addObject:[self getThirdSection]];
        }else {
            [self.sectionDataArray addObject:[self getSecondSection]];
            [self.sectionDataArray addObject:[self getThirdSection]];
        }
    }
}

- (NSArray *)getFirstSectionArray {
    if (UMainControllerPersonTypeOfFriend == self.personType) {
        WARUserSettingItem *commentSettingItem = [WARUserSettingItem new];
//        commentSettingItem.titleString = WARLocalizedString(@"设置备注及分组");
        commentSettingItem.titleString = WARLocalizedString(@"设置备注");
        WARUserCareGroupItem *careitem = [WARUserCareGroupItem new];
        careitem.CareString = @"关注";
        careitem.titleString = WARLocalizedString(@"设置分组");
        return @[commentSettingItem,careitem];
    }else {
        WARUserSettingItem *commentSettingItem = [WARUserSettingItem new];
        commentSettingItem.titleString = WARLocalizedString(@"设置备注");
        
        return @[commentSettingItem];
    }
}

- (NSArray *)getSecondSection {
    if (UMainControllerPersonTypeOfFriend == self.personType) {
        WARUserwitchSettingItem *item = [WARUserwitchSettingItem new];
        item.titleString = WARLocalizedString(@"特别好友");
        item.isOpen = self.dataManager.contactUser.star;
        
        WARUserwitchSettingItem *item1 = [WARUserwitchSettingItem new];
        item1.titleString = WARLocalizedString(@"聊天置顶");
        item1.isOpen = self.dataManager.contactUser.msgTop;
        
        WARUserwitchSettingItem *item2 = [WARUserwitchSettingItem new];
        item2.titleString = WARLocalizedString(@"消息免打扰");
        item2.isOpen = self.dataManager.contactUser.msgTop;
        
        return @[item, item1, item2];
    }else {
        WARUserwitchSettingItem *item = [WARUserwitchSettingItem new];
        item.titleString = WARLocalizedString(@"允许查看我的动态");
        item.isOpen = self.dataManager.contactUser.momentsAccess;
        
        WARUserwitchSettingItem *item1 = [WARUserwitchSettingItem new];
        item1.titleString = WARLocalizedString(@"接收ta的动态消息");
        item1.isOpen = self.dataManager.contactUser.momentReceive;
        
        WARUserwitchSettingItem *item2 = [WARUserwitchSettingItem new];
        item2.titleString = WARLocalizedString(@"对ta隐身（距离和位置）");
        NDLog(@"%ld",self.dataManager.contactUser.showSelf);
        item2.isOpen = !self.dataManager.contactUser.showSelf;
        
        return @[item, item1];
    }
}

- (NSArray *)getThirdSection {
    if (UMainControllerPersonTypeOfFriend == self.personType) {
        WARUserwitchSettingItem *item = [WARUserwitchSettingItem new];
        item.titleString = WARLocalizedString(@"允许查看我的动态");
        item.isOpen = self.dataManager.contactUser.momentsAccess;
        
        WARUserwitchSettingItem *item1 = [WARUserwitchSettingItem new];
        item1.titleString = WARLocalizedString(@"接收ta的动态消息");
        item1.isOpen = self.dataManager.contactUser.momentReceive;
        
        WARUserwitchSettingItem *item2 = [WARUserwitchSettingItem new];
        item2.titleString = WARLocalizedString(@"接收ta发送的消息");
        item2.isOpen = self.dataManager.contactUser.msgCall;
        
        WARUserwitchSettingItem *item3 = [WARUserwitchSettingItem new];
        item3.titleString = WARLocalizedString(@"对ta隐身（距离和位置）");
        NDLog(@"%ld",self.dataManager.contactUser.showSelf);
        item3.isOpen = !self.dataManager.contactUser.showSelf;

        return @[item, item1, item2, item3];
    }else {
        WARUserwitchSettingItem *item = [WARUserwitchSettingItem new];
        item.titleString = WARLocalizedString(@"拉黑");
        item.isOpen = self.dataManager.contactUser.blacklist;
        
        WARUserSettingItem *item1 = [WARUserSettingItem new];
        item1.titleString = WARLocalizedString(@"投诉");
        
        return @[item, item1];
    }
}

- (NSArray *)getFourthSection {
    WARUserwitchSettingItem *item = [WARUserwitchSettingItem new];
    item.titleString = WARLocalizedString(@"拉黑");
    item.isOpen = self.dataManager.contactUser.blacklist;
    
    WARUserSettingItem *item1 = [WARUserSettingItem new];
    item1.titleString = WARLocalizedString(@"投诉");
    return @[item, item1];
}

#pragma mark - init UI

- (void)initUI {
    [super initUI];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = WARLocalizedString(@"资料设置");
    
    
    UIButton * backButton = [UIButton new];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGRect frame = CGRectMake(0, 0, 40, 30);
    backButton.frame = frame;
    [backButton setImage:[WARUIHelper war_backBlack] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.navigationBarClear = NO;
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = CommentCellHeight;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:CommentCellId];
    [self.tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:SettingsSwitchCellId];
    [self.tableView registerClass:[WARCareSettingsCell class] forCellReuseIdentifier:@"cellCare"];
    [self.tableView registerNib:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewId];
    
    if(UMainControllerPersonTypeOfFriend == self.personType) {
        CGFloat totalCellHeight = HeaderViewHeight*(self.sectionDataArray.count -1);
        for (int i = 0; i < self.sectionDataArray.count; i++) {
            NSArray *tempArray = [self.sectionDataArray objectAtIndex:i];
            totalCellHeight += (commonCellHeight * tempArray.count);
        }
        CGRect footerViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - totalCellHeight - 80 - 64); //50 button height
        if (footerViewFrame.size.height < 120) {
            footerViewFrame.size.height = 120;
        }
        WARUserSettingFooterView *footerView = [[WARUserSettingFooterView alloc] initWithFrame:footerViewFrame buttonTitle:WARLocalizedString(@"删除")];
        footerView.delegate = self;
        self.tableView.tableFooterView = footerView;
    }
}

#pragma mark tableView deletate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }else {
        return HeaderViewHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    self.tableView.tableFooterView.hidden = self.dataManager.contactUser.blacklist;

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableCellWithIdentifier:HeaderViewId];
    if (nil == headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderViewId];
    }
    headerView.backgroundColor =  HEXCOLOR(0xf4f4f4);
    headerView.contentView.backgroundColor = HEXCOLOR(0xf4f4f4);
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.sectionDataArray objectAtIndex:section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingsCell *settingCell = [tableView dequeueReusableCellWithIdentifier:CommentCellId];
    WARSettingsSwitchCell *switchSettingCell = [tableView dequeueReusableCellWithIdentifier:SettingsSwitchCellId];
    WARCareSettingsCell  *careCell = [tableView dequeueReusableCellWithIdentifier:@"cellCare"];
    NSArray *sectionArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    WARUserSettingItem *item = [sectionArray objectAtIndex:indexPath.row];
    if ([item isMemberOfClass:[WARUserwitchSettingItem class]]) {
        WARUserwitchSettingItem *switchSettingItem = (WARUserwitchSettingItem *)item;
        switchSettingCell.descriptionText = switchSettingItem.titleString;
        switchSettingCell.switchButton.on = switchSettingItem.isOpen;
        switchSettingCell.delegate = self;
        
        if (indexPath.row == 2) {
            if ([self.model.guySetting.msgCall isEqualToString:@"TRUE"]) {
                switchSettingCell.switchButton.on = YES;
            }else {
                switchSettingCell.switchButton.on = NO;
            }
        }

        return switchSettingCell;
    }else if ([item isKindOfClass:[WARUserCareGroupItem class]]){
        WARUserCareGroupItem *careitem = (WARUserCareGroupItem *)item;
        
        careCell.textlb.text = careitem.titleString;
        careCell.grouplb.text = careitem.CareString;
        return careCell;
    }
    
    else {
        settingCell.showAccessoryView = YES;
        settingCell.descriptionText = item.titleString;
        
        return settingCell;
    }
  
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *sectionArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    WARUserwitchSettingItem *item = [sectionArray objectAtIndex:indexPath.row];
    if ([item.titleString isEqualToString:WARLocalizedString(@"设置备注")]) {
        WARUserCommentViewController *commentVC = [[WARUserCommentViewController alloc] initWithAccount:self.accountId type:self.personType];
        [self.navigationController pushViewController:commentVC animated:YES];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"投诉")]) {
        UIViewController *complainVC = [[WARMediator sharedInstance] Mediator_viewControllerForTweetComplain:@{@"id":self.accountId,@"type":@(1)}];
        
        [self.navigationController pushViewController:complainVC animated:YES];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"设置分组")]){
        WARMoveGroupViewController *moveVC = [[WARMoveGroupViewController alloc] init];
       // WARGroupMangerViewController *moveVC = [[WARGroupMangerViewController alloc] init];
        [self.navigationController pushViewController:moveVC animated:YES];
    }
}

#pragma mark - cell delegate
- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    NSMutableArray *sectionArray = [self.sectionDataArray objectAtIndex:indexPath.section];
    WARUserwitchSettingItem *item = [sectionArray objectAtIndex:indexPath.row];
     @weakify(self);
    if ([item.titleString isEqualToString:WARLocalizedString(@"特别好友")]) {
        [self.dataManager setUserIsStartFriendByAccount:self.accountId isStart:isOn successBlock:^(id successData) {
           
            [WARDBContactManager updateContactWithAccountId:self.accountId star:isOn];
            
        } failedBlock:nil];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"聊天置顶")]) {
        [self.dataManager setUserIsTopFriendByAccount:self.accountId isStart:isOn successBlock:^(id successData) {
            if (isOn && successData) {
                [WARDBContactManager updateContactWithAccountId:self.accountId msgTop:isOn msgTopTime:successData];
            }else if (!isOn) {
                [WARDBContactManager updateContactWithAccountId:self.accountId msgTop:isOn msgTopTime:nil];
            }

        } failedBlock:nil];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"消息免打扰")]) {
        @weakify(self);
        NSString *value = isOn ? @"TRUE" : @"FALSE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/msg/call/%@",kDomainNetworkUrl,self.accountId,value];
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            @strongify(self);
            if (!err) {
            }
        }];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"允许查看我的动态")]) {
        [self.dataManager setUserMomentAccessByAccount:self.accountId isLetHeSeeMyTweet:isOn successBlock:^(id successData) {

            [WARDBContactManager updateContactWithAccountId:self.accountId momentsAccess:isOn];

        } failedBlock:nil];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"接收ta的动态消息")]) {
        [self.dataManager setMyselfReceiveHisTweetMessageByAccout:self.accountId isReceiveMessage:isOn successBlock:^(id successData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [kNotificationCenter postNotificationName:kNotificationDidChangeReceiveHisTweetMessage object:nil userInfo:@{@"accountId" :self.accountId,
                                                                                                     @"isOn" : @(isOn)}];
            });
            
            [WARDBContactManager updateContactWithAccountId:self.accountId momentReceive:isOn];
            
        } failedBlock:nil];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"接收ta发送的消息")]) {
        [self.dataManager setMyselfReceiveHisSentMessageByAccout:self.accountId isReceiveMessage:isOn successBlock:^(id successData) {
            
            [WARDBContactManager updateContactWithAccountId:self.accountId msgCall:isOn];
            
        } failedBlock:nil];
    }else if ([item.titleString isEqualToString:WARLocalizedString(@"对ta隐身（距离和位置）")]) {
        [self.dataManager setHeCanSeeMyDistanceByAccount:self.accountId isLetHeSee:isOn successBlock:^(id successData) {
            
            [WARDBContactManager updateContactWithAccountId:self.accountId showSelf:!isOn];
            
        } failedBlock:nil];

    }else if ([item.titleString isEqualToString:WARLocalizedString(@"拉黑")]) {
        item.isOpen = !item.isOpen;
        [self blackListActionBy:isOn];
    }
}

- (void)blackListActionBy:(BOOL)isOn {
    [MBProgressHUD showLoad];
    @weakify(self);
    if (isOn) {
        [self.dataManager addBlackListByAccount:self.accountId successBlock:^(id successData) {
            [MBProgressHUD hideHUD];
            
            [WARDBContactManager updateContactWithAccountId:self.accountId blacklist:isOn];
            
        } failedBlock:nil];
    }else {
        [self.dataManager removeBlackListByAccount:self.accountId successBlock:^(id successData) {
             @strongify(self);
            [MBProgressHUD hideHUD];
            
            [WARDBContactManager updateContactWithAccountId:self.accountId blacklist:NO];
            [self updateUI:NO];
            
        } failedBlock:nil];
    }
}

- (void)updateUI:(BOOL)isOn {
    if (UMainControllerPersonTypeOfFriend == self.personType) {
        if (isOn) {
            [self.sectionDataArray removeObjectAtIndex:1];
            [self.sectionDataArray removeObjectAtIndex:1];
            
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            [self.sectionDataArray insertObject:[self getSecondSection] atIndex:1];
            [self.sectionDataArray insertObject:[self getThirdSection] atIndex:2];
            
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1]  withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else {
        if (isOn) {
            [self.sectionDataArray removeObjectAtIndex:1];
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
        }else {
            [self.sectionDataArray insertObject:[self getSecondSection] atIndex:1];
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1]  withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    [self.tableView reloadData];
}

-(void)clickButtonAction {
    
    [WARAlertView showWithTitle:nil Message:WARLocalizedString(@"你确定删除该好友吗？") cancelTitle:WARLocalizedString(@"取消") destructiveTitle:WARLocalizedString(@"删除") cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        [MBProgressHUD showLoad];
//        @weakify(self);
//        [self.dataManager remveFriendByAccount:self.accountId successBlock:^(id successData) {
//            @strongify(self);
//            [MBProgressHUD hideHUD];
//
//            [WARDBContactManager deleteContactByID:self.dataManager.contactUser.accountId];
//
//            [[WARMediator sharedInstance] Mediator_deleteSession:self.accountId];
//
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        } failedBlock:nil];
        @weakify(self);
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/friend/%@",kDomainNetworkUrl,self.accountId];
        [WARNetwork deleteDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            @strongify(self);
            [MBProgressHUD hideHUD];
            if (!err) {
                [WARDBFriendManager removeFriendWithAccountId:self.accountId];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    
    }];
}

@end
