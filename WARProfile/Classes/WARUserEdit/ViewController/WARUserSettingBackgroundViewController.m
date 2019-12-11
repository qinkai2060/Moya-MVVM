//
//  WARUserSettingBackgroundViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/20.
//

#import "WARUserSettingBackgroundViewController.h"
#import "WARSettingsCell.h"
#import "WARMacros.h"
#import "WARNetwork.h"

#import "WARImagePickerController.h"
#import "WARCameraViewController.h"
#import "WARUploadDataManager.h"
#import "WARUploadManager.h"
#import "WARProgressHUD.h"
#import "WARActionSheet.h"

@interface WARUserSettingBackgroundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitleArray;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation WARUserSettingBackgroundViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WARLocalizedString(@"聊天背景");
    
    self.cellTitleArray = @[@[WARLocalizedString(@"应用默认背景图")],@[WARLocalizedString(@"拍照"),WARLocalizedString(@"从手机相册选择")]];
    
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Response

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = BackgroundDefaultColor;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.groupId || self.userModel) {
        return [[UIView alloc] init];
    }else if (section == 1) {
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = BackgroundDefaultColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 10, kScreenWidth, 44);
        [button setBackgroundColor:UIColorWhite];
        [button setTitle:WARLocalizedString(@"将背景应用到所有聊天场景") forState:UIControlStateNormal];
        [button setTitleColor:TextColor forState:UIControlStateNormal];
        [button.titleLabel setFont:kFont(16)];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerV addSubview:button];
        return footerV;
    }else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.groupId || self.userModel) {
        return 0;
    }else if (section == 1) {
        return self.view.frame.size.height - 44 * 3 - 10 * 2;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"应用默认背景图")]) {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.descriptionText = cellTitle;
        return cell;
    }else {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.descriptionText = cellTitle;
        cell.showAccessoryView = YES;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.cellTitleArray[indexPath.section];
    NSString *cellTitle = array[indexPath.row];
    if ([cellTitle isEqualToString:WARLocalizedString(@"应用默认背景图")]) {
        [self requestBackground:nil];
        self.urlString = nil;
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"拍照")]) {
        [self takePhotoForHeadIcon];
    }else if ([cellTitle isEqualToString:WARLocalizedString(@"从手机相册选择")]) {
        [self selectPhotoForHeaderIcon];
    }
}

#pragma mark - Private

- (void)requestBackground:(NSString *)imageId {
    if (self.groupId.length) {
        //群设置的
        NSString *url = [NSString stringWithFormat:@"/cont-app/group/user/%@/background",self.groupId];
        [WARNetwork fetchDataWithType:WARPostType uri:url stringParams:imageId completion:^(id responseObj, NSError *err) {
            if (!err) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置成功")];
            }else {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置失败")];
            }
        }];
    }else if (self.userModel) {
        //他人设置的
        NSString *url = [NSString stringWithFormat:@"/cont-app/guy/%@/background",self.userModel.accountId];
        [WARNetwork fetchDataWithType:WARPostType uri:url stringParams:imageId completion:^(id responseObj, NSError *err) {
            if (!err) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置成功")];
            }else {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置失败")];
            }
        }];
    }else {
        //个人设置的
        NSString *url = @"/cont-app/user/setting/background";
        [WARNetwork fetchDataWithType:WARPostType uri:url stringParams:imageId completion:^(id responseObj, NSError *err) {
            if (!err) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置成功")];
            }else {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置失败")];
            }
        }];
    }
}

- (void)selectPhotoForHeaderIcon {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    
    imagePickerVc.didFinishPickingPhotosHandle = ^ (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if ([photos isKindOfClass:[NSURL class]]) {
            ;
        } else if ([photos isKindOfClass:[NSArray class]]){
            [self uploadHeaderIconImage:[photos objectAtIndex:0]];
        }
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhotoForHeadIcon {
    WARCameraViewController *vc = [WARCameraViewController new];
    vc.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            ;
        } else if ([item isKindOfClass:[UIImage class]]){
            [self uploadHeaderIconImage:item];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)uploadHeaderIconImage:(UIImage *)image {
    WS(weakSelf);
    [MBProgressHUD showLoad];
    [[WARUploadManager shared] uploadImage:image uploadMoudle:WARUploadDataMoudleOfContact succeccBlock:^(NSString *urlStr) {
        [MBProgressHUD hideHUD];
        [weakSelf requestBackground:urlStr];
        weakSelf.urlString = urlStr;
    } failureBlock:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)buttonClick {
    [WARActionSheet actionSheetWithTitle:nil
                                subTitle:nil
                        destructiveTitle:nil
                            buttonTitles:@[WARLocalizedString(@"将背景应用到所有聊天场景")]
                             cancelTitle:WARLocalizedString(@"取消")
                      destructiveHandler:nil
                           actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                               NSString *url = @"/cont-app/user/setting/background/all/TRUE";
                               [WARNetwork fetchDataWithType:WARPostType uri:url stringParams:self.urlString completion:^(id responseObj, NSError *err) {
                                   if (!err) {
                                       [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置成功")];
                                   }else {
                                       [WARProgressHUD showAutoMessage:WARLocalizedString(@"设置失败")];
                                   }
                               }];
                           }
                           cancelHandler:nil
                       completionHandler:nil];
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = BackgroundDefaultColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:@"WARSettingsCell"];
    }
    return _tableView;
}


@end
