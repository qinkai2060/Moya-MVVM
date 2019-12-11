//
//  WARAddMySelfWayViewController.m
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import "WARAddMySelfWayViewController.h"
#import "WARSettingHeaderView.h"

#define numberOfSection 2

#define SwithcSettingCellID                 @"SwithcSettingCellID"
#define CommentHeaderID                     @"headerId"
#define CommentFooterID                     @"CommentFooterID"


@interface WARAddMySelfWayViewController () <WARSettingsSwitchCellDelegate>

@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, strong) NSArray *searchWayArray;
@property (nonatomic, strong) NSArray *addWayArray;

@end

@implementation WARAddMySelfWayViewController

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
    
    WARSettingSwitchCellItem *accItem = [WARSettingSwitchCellItem new];
    accItem.titleString = WARLocalizedString(@"账号");
    accItem.open = self.dataManager.userInfo.profileSetting.addMeByAccount;
    
    WARSettingSwitchCellItem *phoneItem = [WARSettingSwitchCellItem new];
    phoneItem.titleString = WARLocalizedString(@"手机号");
    phoneItem.open = self.dataManager.userInfo.profileSetting.addMeByPhone;
    
//    WARSettingSwitchCellItem *QRItem = [WARSettingSwitchCellItem new];
//    QRItem.titleString = WARLocalizedString(@"二维码");
//    QRItem.open = self.dataManager.userInfo.profileSetting.addMeByQR;
//
//    WARSettingSwitchCellItem *persionCard = [WARSettingSwitchCellItem new];
//    persionCard.titleString = WARLocalizedString(@"个人名片");
//    persionCard.open = self.dataManager.userInfo.profileSetting.searchByCard;
    
    self.searchWayArray = @[accItem, phoneItem];
//    self.addWayArray = @[QRItem,persionCard];
    
//    self.sectionDataArray = [[NSMutableArray alloc] initWithObjects:self.searchWayArray, self.addWayArray,nil];
    self.sectionDataArray = [[NSMutableArray alloc] initWithObjects:self.searchWayArray,nil];;
}

- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"搜索到我的方式");
    
    self.tableView.rowHeight = commonCellHeight;

    [self.tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:SwithcSettingCellID];
    [self.tableView registerClass:[WARSettingHeaderView class] forHeaderFooterViewReuseIdentifier:CommentHeaderID];
    [self.tableView registerClass:[WARSettingsFooterView class] forHeaderFooterViewReuseIdentifier:CommentFooterID];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)[self.sectionDataArray objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return HeaderViewDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HeaderViewDefaultHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WARSettingHeaderView *headerView = (WARSettingHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentHeaderID];
    headerView.contentView.backgroundColor = BackgroundDefaultColor;
    headerView.backgroundColor = BackgroundDefaultColor;
    
    if (0 == section) {
        headerView.titleLabel.text = WARLocalizedString(@"可以被搜索到的方式");
    }else {
        headerView.titleLabel.text = WARLocalizedString(@"可以被添加的方式");
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WARSettingsFooterView *footerView = (WARSettingsFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentFooterID];
    footerView.contentView.backgroundColor = BackgroundDefaultColor;
    footerView.backgroundColor = BackgroundDefaultColor;

    if (1 == section) {
//        footerView.titleLabel.text = WARLocalizedString(@"关闭后，不会被其他用户通过相应方式搜到");
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.contentView.backgroundColor = [UIColor whiteColor];
    }else {
        footerView.titleLabel.text = WARLocalizedString(@"关闭后，其他用户将不能通过上述方式找到你");
    }
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingSwitchCellItem *item = (WARSettingSwitchCellItem*)[((NSArray*)[self.sectionDataArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    
    WARSettingsSwitchCell *cell = (WARSettingsSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwithcSettingCellID];
    cell.descriptionText = item.titleString;
    cell.delegate = self;
    cell.switchButton.on = item.open;
    
    return cell;
}

- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            [self.dataManager addMyselfWayByType:addMyselfWayAccount switchOpen:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
            
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.addMeByAccount = isOn;
            }];
        }else if (1 == indexPath.row){
            [self.dataManager addMyselfWayByType:addMyselfWayPhone switchOpen:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
            
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.addMeByPhone = isOn;
            }];
        }
    }else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            [self.dataManager cansearchWayType:addMyselfWayByQRcode switchOpen:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.searchByQRCode = isOn;
            }];
        }else if (1 == indexPath.row){
            [self.dataManager cansearchWayType:addMyselfWayByCard switchOpen:isOn Success:^(id successData) {
                ;
            } failed:^(id failedData) {
                ;
            }];
            
            [kRealm transactionWithBlock:^{
                self.dataManager.userInfo.profileSetting.searchByCard = isOn;
            }];
        }
    }
}

@end
