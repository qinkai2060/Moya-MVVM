//
//  WARUserSettingNewViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/20.
//

#import "WARUserSettingNewViewController.h"
#import "WARProfileOtherViewController.h"
#import "WARUserInfoSearchViewController.h"
#import "WARUserSettingBackgroundViewController.h"
#import "WARUserSettingHeaderCell.h"
#import "WARSettingsCell.h"
#import "WARUserSettingSwitchCell.h"
#import "WARDeleteUserCell.h"
#import "WARDBFriendManager.h"
#import "WARMacros.h"
#import "WARAlertView.h"
#import "WARNetwork.h"
#import "WARProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "WARMediator+Contacts.h"
#import "WARProfileNetWorkTool.h"
#import "YYModel.h"
#import "WARMediator+Chat.h"
#import "WARMediator+User.h"
#import "Masonry.h"

@interface WARUserSettingNewViewController () <UITableViewDelegate, UITableViewDataSource, WARSettingsSwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitleArray;

@end

@implementation WARUserSettingNewViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WARLocalizedString(@"设置");
    
    if (self.guyId.length) {
        WS(weakself);
        [WARProfileNetWorkTool getOtherPersonDataWithguyId:self.guyId CallBack:^(id response) {
            weakself.userModel = [WARProfileUserModel yy_modelWithJSON:response];
            [weakself configureCellTitleArray];
            [weakself.tableView reloadData];
        } failer:^(id response) {
            [WARProgressHUD showAutoMessage:@"加载失败"];
        }];
    }
    else {
        [self configureCellTitleArray];
    }

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitleArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = BackgroundDefaultColor;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    NSString *cellTitle = array[0];
    if ([cellTitle isEqualToString:WARLocalizedString(@"删除")]) {
        return 35;
    }
    else if ([cellTitle isEqualToString:@"header"]) {
        return 0.01f;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.cellTitleArray.count - 1 == section) {
        return 50;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"不让TA看到我的动态")]) {
        return 60;
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"删除")]) {
        return 50;
    }else if ([cellTitle isEqualToString:@"header"]) {
        return 103;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:@"header"]) {
        WARUserSettingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARUserSettingHeaderCell"];
        [cell.headerImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(36, 36),self.userModel.guyMask.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        cell.nameLabel.text = self.userModel.guyMask.nickname;
        WS(weakSelf);
        cell.leftBlock = ^{
            __block BOOL isBack = NO;
            [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WARProfileOtherViewController class]]) {
                    isBack = YES;
                    *stop = YES;
                }
            }];
            if (isBack) {
                //从个人主页进来就返回
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else {
                //从其他页面进来就跳转
                UIViewController *vc = [[WARMediator sharedInstance] Mediator_viewControllerForOtherVC:weakSelf.userModel.accountId friendWay:WARFriendWayNone];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.addBlock = ^{
            WARDBFriendModel *model = [[WARDBFriendModel alloc] init];
            model.accountId = self.userModel.accountId;
            model.headId = self.userModel.guyMask.faceImg;
            NSArray *array = [NSArray arrayWithObject:model];
            UIViewController *VC = [[WARMediator sharedInstance] Mediator_CreateGroupControllerWithMemberArray:array];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        };
        return cell;
    }
    if ([cellTitle isEqualToString:WARLocalizedString(@"设置备注")] || [cellTitle isEqualToString:WARLocalizedString(@"设置当前聊天背景")] || [cellTitle isEqualToString:WARLocalizedString(@"查找聊天内容")] || [cellTitle isEqualToString:WARLocalizedString(@"举报")]) {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.descriptionText = cellTitle;
        cell.showAccessoryView = YES;
        if ([cellTitle isEqualToString:WARLocalizedString(@"设置备注")]) {
            cell.rightText = self.userModel.guySetting.remarkName;
        }
        return cell;
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"删除")]) {
        WARDeleteUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARDeleteUserCell"];
        cell.nameLabel.text = cellTitle;
        return cell;
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"不让TA看到我的动态")]) {
        WARUserSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARUserSettingSwitchCell"];
        cell.cellTitleLabel.text = cellTitle;
        cell.cellDetailLabel.text = WARLocalizedString(@"地图和朋友圈都无法查看");
        cell.item.on = [self.userModel.guySetting.momentsAccess isEqualToString:@"FALSE"] ? YES : NO;
        cell.switchBlock = ^(BOOL isOn) {
            NSString *state = isOn ? @"FALSE" : @"TRUE";
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/moment/access/%@",kDomainNetworkUrl,self.userModel.accountId,state];
            WS(weakSelf);
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    weakSelf.userModel.guySetting.momentsAccess = state;
                }else {
                    [WARProgressHUD showAutoMessage:[err description]];
                }
            }];
        };
        return cell;
    }else {
        WARSettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsSwitchCell"];
        cell.descriptionText = cellTitle;
        cell.delegate = self;
        if ([cellTitle isEqualToString:WARLocalizedString(@"聊天置顶")]) {
            cell.switchButton.on = [self.userModel.guySetting.msgTop isEqualToString:@"TRUE"] ? YES : NO;
        }else if ([cellTitle isEqualToString:WARLocalizedString(@"消息免打扰")]) {
            cell.switchButton.on = [self.userModel.guySetting.msgCall isEqualToString:@"FALSE"] ? YES : NO;
        }else if ([cellTitle isEqualToString:WARLocalizedString(@"不看TA的动态")]) {
            cell.switchButton.on = [self.userModel.guySetting.momentReceive isEqualToString:@"FALSE"] ? YES : NO;
        }else if ([cellTitle isEqualToString:WARLocalizedString(@"对TA隐身 (距离和位置)")]) {
            cell.switchButton.on = [self.userModel.guySetting.showSelf isEqualToString:@"FALSE"] ? YES : NO;
        }else if ([cellTitle isEqualToString:WARLocalizedString(@"拉黑")]) {
            cell.switchButton.on = [self.userModel.guySetting.black isEqualToString:@"TRUE"] ? YES : NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"设置备注")]) {
        WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc] initWithType:UserSettingRemark];
        vc.settingModel = self.userModel.guySetting;
        [self.navigationController pushViewController:vc animated:YES];
        WS(weakSelf);
        vc.remarkBlock = ^(NSString *remarkStr) {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/remark/name?remarkName=%@",kDomainNetworkUrl,self.userModel.accountId,remarkStr];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    weakSelf.userModel.guySetting.remarkName = remarkStr;
                    [weakSelf.tableView reloadData];
                }else {
                    [WARProgressHUD showAutoMessage:[err description]];
                }
            }];
        };
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"设置当前聊天背景")]) {
        WARUserSettingBackgroundViewController *vc = [[WARUserSettingBackgroundViewController alloc] init];
        vc.userModel = self.userModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"删除")]) {
        [WARAlertView showWithTitle:nil Message:WARLocalizedString(@"你确定要删除该好友吗？") cancelTitle:WARLocalizedString(@"取消") destructiveTitle:WARLocalizedString(@"删除") cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/friend/%@",kDomainNetworkUrl,self.userModel.accountId];
            WS(weakSelf);
            [WARNetwork deleteDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [WARDBFriendManager removeFriendWithAccountId:weakSelf.userModel.accountId];
                    [[WARMediator sharedInstance] Mediator_deleteSession:weakSelf.userModel.accountId];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"查找聊天内容")]) {
        UIViewController *VC = [[WARMediator sharedInstance] Mediator_viewSearchChatContentBySessionID:self.userModel.accountId];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - cell delegate
- (void)swithIsOn:(BOOL)isOn indexPath:(NSIndexPath*)indexPath {
    NSMutableArray *sectionArray = [self.cellTitleArray objectAtIndex:indexPath.section];
    NSString *cellTitle = [sectionArray objectAtIndex:indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"聊天置顶")]) {
        NSString *state = isOn ? @"TRUE" : @"FALSE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/msg/top/%@",kDomainNetworkUrl,self.userModel.accountId,state];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err) {
                weakSelf.userModel.guySetting.msgTop = state;
            }else {
                [WARProgressHUD showAutoMessage:[err description]];
            }
        }];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"消息免打扰")]) {
        NSString *state = isOn ? @"FALSE" : @"TRUE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/msg/call/%@",kDomainNetworkUrl,self.userModel.accountId,state];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err) {
                weakSelf.userModel.guySetting.msgCall = state;
            }else {
                [WARProgressHUD showAutoMessage:[err description]];
            }
        }];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"不看TA的动态")]) {
        NSString *state = isOn ? @"FALSE" : @"TRUE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/moment/receive/%@",kDomainNetworkUrl,self.userModel.accountId,state];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err) {
                weakSelf.userModel.guySetting.momentReceive = state;
            }else {
                [WARProgressHUD showAutoMessage:[err description]];
            }
        }];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"对TA隐身 (距离和位置)")]) {
        NSString *state = isOn ? @"FALSE" : @"TRUE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/friend/show/%@",kDomainNetworkUrl,self.userModel.accountId,state];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err) {
                weakSelf.userModel.guySetting.showSelf = state;
            }else {
                [WARProgressHUD showAutoMessage:[err description]];
            }
        }];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"拉黑")]) {
        NSString *state = isOn ? @"TRUE" : @"FALSE";
        NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/black/%@",kDomainNetworkUrl,self.userModel.accountId,state];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err) {
                weakSelf.userModel.guySetting.black = state;
            }else {
                [WARProgressHUD showAutoMessage:[err description]];
            }
        }];
    }
}

#pragma mark - Private

- (void)configureCellTitleArray {
    if ([self.userModel.friendRelation isEqualToString:@"FRIEND"]) {
        self.cellTitleArray = @[@[@"header"],@[WARLocalizedString(@"设置备注"),WARLocalizedString(@"设置当前聊天背景")],@[WARLocalizedString(@"查找聊天内容")],@[WARLocalizedString(@"聊天置顶"),WARLocalizedString(@"消息免打扰")],@[WARLocalizedString(@"不让TA看到我的动态"),WARLocalizedString(@"不看TA的动态"),WARLocalizedString(@"对TA隐身 (距离和位置)")],@[WARLocalizedString(@"拉黑"),WARLocalizedString(@"举报")],@[WARLocalizedString(@"删除")]];
    }else {
        self.cellTitleArray = @[@[WARLocalizedString(@"设置备注"),WARLocalizedString(@"设置当前聊天背景")],@[WARLocalizedString(@"查找聊天内容")],@[WARLocalizedString(@"不让TA看到我的动态"),WARLocalizedString(@"不看TA的动态"),WARLocalizedString(@"对TA隐身 (距离和位置)")],@[WARLocalizedString(@"拉黑"),WARLocalizedString(@"举报")]];
    }
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BackgroundDefaultColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WARUserSettingHeaderCell class] forCellReuseIdentifier:@"WARUserSettingHeaderCell"];
        [_tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:@"WARSettingsCell"];
        [_tableView registerClass:[WARSettingsSwitchCell class] forCellReuseIdentifier:@"WARSettingsSwitchCell"];
        [_tableView registerClass:[WARUserSettingSwitchCell class] forCellReuseIdentifier:@"WARUserSettingSwitchCell"];
        [_tableView registerClass:[WARDeleteUserCell class] forCellReuseIdentifier:@"WARDeleteUserCell"];
        
    }
    return _tableView;
}

@end
