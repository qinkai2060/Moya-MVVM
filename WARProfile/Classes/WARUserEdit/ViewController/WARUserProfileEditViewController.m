//
//  WARUserProfileEditViewController.m
//  Pods
//
//  Created by huange on 2017/8/23.
//
//

#import "WARUserProfileEditViewController.h"
#import "WARUserEditHeaderView.h"
#import "WARSettingsCell.h"
#import "UIImageView+WebCache.h"
#import "WARImagePickerController.h"
#import "WARUserBaseInfoEditViewController.h"
#import "WARSignatureViewController.h"
#import "WARUserTagViewController.h"
#import "WARActionSheet.h"
#import "WARCameraViewController.h"
#import "WARDBUserManager.h"
#import "WARUserSettingItem.h"
#import "WARUploadDataManager.h"

#import "UIImage+WARGeneralImage.h"

#define HeaderViewHeight 349
#define UserIconCellHeight 70
#define MaxCellCount 6

#define MySelfWithIconCellId      @"MySelfWithIconCellId"
#define CommentCellId             @"commentCellID"


@interface WARUserProfileEditViewController () <WARUserEditHeaderViewDelegate,WARImagePickerControllerDelegate,WARUserEditHeaderViewDelegate,WARUerHeaderBaseViewDelegate>

@property (nonatomic, strong) WARUserEditHeaderView *headerView;
@property (nonatomic, strong) UIImage *iconBackgroundImage;
@property (nonatomic, strong) UIImage *iconHeadImage;
@property (nonatomic, strong) NSMutableArray <WARImageItem *>*photoAlbumIcons;
@property (nonatomic, strong) NSString *iconBackgroundId;
@property (nonatomic, strong) NSString *iconHeaderId;
@property (nonatomic, strong) NSIndexPath *currentAlblumIndexPath;

@end

@implementation WARUserProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarClear = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //update user data
    if (self.dataManager) {
        self.dataManager.user = [WARDBUserManager userModel];
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationBarClear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)initData {
    self.iconBackgroundImage = nil;
    self.currentAlblumIndexPath = nil;
    self.valueChanged = NO;
    
    self.dataManager = [WARUserEditDataManager new];
    self.iconHeaderId = self.dataManager.user.headId;
    self.iconBackgroundId = self.dataManager.user.bgPicture;
    //headerData
    self.photoAlbumIcons = [[NSMutableArray alloc] init];
    for (NSString *string in self.dataManager.user.photos) {
        WARImageItem *item = [WARImageItem new];
        item.imageId = string;
        item.imageData = nil;
        [self.photoAlbumIcons addObject:item];
    }
}

- (void)initUI {
    [super initUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.title = WARLocalizedString(@"编辑资料");
    self.rightButtonText = WARLocalizedString(@"保存");
    self.navigationBarClear = YES;
    
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:CommentCellId];
    [self.tableView registerClass:[WARSettingsWithRightImageCell class] forCellReuseIdentifier:MySelfWithIconCellId];
    
    self.headerView = [WARUserEditHeaderView new];
    self.headerView.delegate = self;
    self.headerView.headerViewDelegate = self;
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.headerView.userIconImgeView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(self.view.frame.size.width, HeaderViewHeight),self.dataManager.user.bgPicture) placeholderImage:[WARUIHelper war_placeholderBackground]];
    
    [self checkInsertAddButton];
    self.headerView.imageItemArray = self.photoAlbumIcons;
    @weakify(self);
    
    [RACObserve(self.headerView, valueChanged) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.valueChanged = [x boolValue];
    }];
    self.headerView.valueChanged = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}


#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MaxCellCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UserIconCellHeight;
    }else {
        return commonCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.row) {
        WARSettingsWithRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:MySelfWithIconCellId];
        UIImage *image = [UIImage war_defaultUserIcon];
        NSURL *iconImageURL = kPhotoUrlWithImageSize(CGSizeMake(50, 50), self.dataManager.user.headId);
        cell.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.rightImageView sd_setImageWithURL:iconImageURL placeholderImage:image];
        
        cell.showAccessoryView = YES;
        cell.descriptionText = WARLocalizedString(@"头像");
        cell.rightImageView.clipsToBounds = YES;
        cell.rightImageView.contentMode = UIViewContentModeScaleAspectFill;

        return cell;
    }else {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellId];
        cell.showAccessoryView = YES;
        cell.rightTextColor = COLOR_WORD_GRAY_6;

        switch (indexPath.row) {
            case 1: {
                cell.descriptionText = WARLocalizedString(@"昵称");
                cell.rightText = self.dataManager.user.nickname;
            }
                break;
            case 2: {
                cell.descriptionText = WARLocalizedString(@"性别");
                if ([self.dataManager.user.gender isEqualToString:@"M"]) {
                    cell.rightText = WARLocalizedString(@"男");
                }else if ([self.dataManager.user.gender isEqualToString:@"F"]) {
                    cell.rightText = WARLocalizedString(@"女");
                }else {
                    cell.rightText = WARLocalizedString(@"请选择性别");
                    cell.rightTextColor = COLOR_WORD_GRAY_9;
                }
            }
                break;
            case 3: {
                cell.descriptionText = WARLocalizedString(@"生日");
                if (self.dataManager.user.year && self.dataManager.user.month && self.dataManager.user.day) {
                    cell.rightText = [NSString stringWithFormat:@"%@-%-@-%@",self.dataManager.user.year, self.dataManager.user.month, self.dataManager.user.day];
                }else {
                    cell.rightText = WARLocalizedString(@"请选择出生日期");
                    cell.rightTextColor = COLOR_WORD_GRAY_9;
                }
            }
                break;
            case 4: {
                cell.descriptionText = WARLocalizedString(@"签名");
                
                if (![self.dataManager.user.signature isKindOfClass:[NSNull class]] && self.dataManager.user.signature.length) {
                    cell.rightText = self.dataManager.user.signature;
                }else {
                    cell.rightText = WARLocalizedString(@"请填写个人签名");
                    cell.rightTextColor = COLOR_WORD_GRAY_9;
                }
            }
                break;
            case 5: {
                cell.descriptionText = WARLocalizedString(@"标签");
                if (self.dataManager.user.tags && self.dataManager.user.tags.count > 0) {
                    NSMutableString *tagString = [[NSMutableString alloc] init];
                    for (NSString *string in self.dataManager.user.tags) {
                        if (tagString.length > 0) {
                            [tagString appendFormat:@"、%@",string];
                        }else {
                            [tagString appendString:string];
                        }
                    }
                    cell.rightText = tagString;
                }else {
                    cell.rightText = WARLocalizedString(@"请选择标签");
                    cell.rightTextColor = COLOR_WORD_GRAY_9;
                }
            }
                break;
                
            default:{
                cell.descriptionText = WARLocalizedString(@"昵称");
                
            }
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row) {
        [self clickSelfHeaderCellAction:indexPath];
    }else {
        WARUserBaseInfoEditViewController *userInfoVC = [WARUserBaseInfoEditViewController new];
        if (1 == indexPath.row) {
            userInfoVC.userInfoType = UserInfoNickNameType;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }else if (2 == indexPath.row) {
            userInfoVC.userInfoType = UserInfoSexType;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }else if (3 == indexPath.row) {
            userInfoVC.userInfoType = UserInfoBirthdayType;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }else if (4 == indexPath.row) {
            WARSignatureViewController *signatureVC = [WARSignatureViewController new];
            [self.navigationController pushViewController:signatureVC animated:YES];
        }else if (5 == indexPath.row) {
            WARUserTagViewController *userTagVC = [WARUserTagViewController new];
            
            [self.navigationController pushViewController:userTagVC animated:YES];
        }
    }
}

#pragma mark - headerView delegate
#pragma mark backgroundHeaderIcon
- (void)clickHeaderIconAction {
    @weakify(self);
    [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"相册")
                                subTitle:nil
                        destructiveTitle:nil
                            buttonTitles:@[WARLocalizedString(@"相册"),WARLocalizedString(@"拍照")]
                             cancelTitle:WARLocalizedString(@"取消")
                      destructiveHandler:nil
                           actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                               @strongify(self);
                               if ([title isEqualToString:WARLocalizedString(@"相册")]) {
                                   [self selectImageForIconBackground];
                               }else if ([title isEqualToString:WARLocalizedString(@"拍照")]){
                                   [self takePhotoForIconBackground];
                               }
                           }
                           cancelHandler:nil
                       completionHandler:nil];
}

- (void)selectImageForIconBackground {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    
    @weakify(self);
    imagePickerVc.didFinishPickingPhotosHandle = ^ (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        
        if ([photos isKindOfClass:[NSURL class]]) {
            ;
        } else if ([photos isKindOfClass:[NSArray class]]){
            self.iconBackgroundImage = [photos objectAtIndex:0];
            [self uploadHeaderBackgroundImage];
        }
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhotoForIconBackground {
    WARCameraViewController *vc = [WARCameraViewController new];
    vc.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            ;
        } else if ([item isKindOfClass:[UIImage class]]){
            self.iconBackgroundImage = (UIImage*)item;;
            [self uploadHeaderBackgroundImage];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)uploadHeaderBackgroundImage {
    [MBProgressHUD showLoad];
    [self.dataManager updateLoadImage:@[self.iconBackgroundImage] successBlock:^(id successData) {
        [MBProgressHUD hideHUD];
        if (successData && [successData isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)successData;
            if (array && array.count > 0) {
                NSString *imgId = [array objectAtIndex:0];
                self.iconBackgroundId = imgId;
                self.headerView.userIconImgeView.image = self.iconBackgroundImage;
                self.valueChanged = YES;
            }
        }
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
    }];
}


#pragma mark self header Icon
- (void)clickSelfHeaderCellAction:(NSIndexPath *)indexPath {
    @weakify(self);
    [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"相册")
                                subTitle:nil
                        destructiveTitle:nil
                            buttonTitles:@[WARLocalizedString(@"相册"),WARLocalizedString(@"拍照")]
                             cancelTitle:WARLocalizedString(@"取消")
                      destructiveHandler:nil
                           actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                               @strongify(self);
                               if ([title isEqualToString:WARLocalizedString(@"相册")]) {
                                   [self selectPhotoForHeaderIcon:indexPath];
                               }else if ([title isEqualToString:WARLocalizedString(@"拍照")]){
                                   [self takePhotoForHeadIcon:indexPath];
                               }
                           }
                           cancelHandler:nil
                       completionHandler:nil];
}

- (void)takePhotoForHeadIcon:(NSIndexPath *)indexPath {
    WARCameraViewController *vc = [WARCameraViewController new];
    vc.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            ;
        } else if ([item isKindOfClass:[UIImage class]]){
            self.iconHeadImage = (UIImage*)item;
            [self uploadHeaderIconImage:indexPath];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)selectPhotoForHeaderIcon:(NSIndexPath *)indexPath {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    
    imagePickerVc.didFinishPickingPhotosHandle = ^ (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if ([photos isKindOfClass:[NSURL class]]) {
            ;
        } else if ([photos isKindOfClass:[NSArray class]]){
            self.iconHeadImage = [photos objectAtIndex:0];
            [self uploadHeaderIconImage:indexPath];
        }
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)uploadHeaderIconImage:(NSIndexPath *)indexPath {
    @weakify(self);

    [MBProgressHUD showLoad];
    [self.dataManager updateLoadImage:@[self.iconHeadImage] successBlock:^(id successData) {
        @strongify(self);

        [MBProgressHUD hideHUD];
        if (successData && [successData isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)successData;
            if (array && array.count > 0) {
                NSString *imgId = [array objectAtIndex:0];

                WARSettingsWithRightImageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.rightImageView.clipsToBounds = YES;
                cell.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.rightImageView.image = self.iconHeadImage;

                self.iconHeaderId = imgId;
                self.valueChanged = YES;
            }

        }
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
    }];
}

#pragma mark - Album
- (void)disSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.headerView.imageItemArray.count) {
        WARImageItem *item = [self.headerView.imageItemArray objectAtIndex:indexPath.row];

        if ([item.imageId isEqualToString:DefaultLastItem]) {
            @weakify(self);
            [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"相册")
                                        subTitle:nil
                                destructiveTitle:nil
                                    buttonTitles:@[WARLocalizedString(@"相册"),WARLocalizedString(@"拍照")]
                                     cancelTitle:WARLocalizedString(@"取消")
                              destructiveHandler:nil
                                   actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                       @strongify(self);
                                       if ([title isEqualToString:WARLocalizedString(@"相册")]) {
                                           [self selectImge];
                                       }else if ([title isEqualToString:WARLocalizedString(@"拍照")]){
                                           [self takePhotoForAlbum:indexPath];
                                       }
                                   }
                                   cancelHandler:nil
                               completionHandler:nil];
        }else {
            @weakify(self);
            [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"替换/删除")
                                        subTitle:nil
                                destructiveTitle:nil
                                    buttonTitles:@[WARLocalizedString(@"删除"),WARLocalizedString(@"相册"),WARLocalizedString(@"拍照")]
                                     cancelTitle:WARLocalizedString(@"取消")
                              destructiveHandler:nil
                                   actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                       @strongify(self);
                                       if ([title isEqualToString:WARLocalizedString(@"删除")]) {
                                           [self.photoAlbumIcons removeObjectAtIndex:indexPath.row];
                                           [self checkInsertAddButton];
                                           self.valueChanged = YES;
                                           [self.headerView reloadData];
                                       }else if ([title isEqualToString:WARLocalizedString(@"相册")]) {
                                           [self replaceExistImage:indexPath];
                                       }else if ([title isEqualToString:WARLocalizedString(@"拍照")]){
                                           [self takePhotoForAlbum:indexPath];
                                       }
                                   }
                                   cancelHandler:nil
                               completionHandler:nil];        
        }
    }
}

- (void)checkInsertAddButton {
    if (self.photoAlbumIcons.count < 8) {
        BOOL isExistDefaultPlusIcon = NO;
        for (NSInteger i =  self.photoAlbumIcons.count - 1; i >= 0; i--) {
            WARImageItem *item = [self.photoAlbumIcons objectAtIndex:i];
            NSString *itemString = item.imageId;
            if ([itemString isEqualToString:DefaultLastItem]) {
                isExistDefaultPlusIcon = YES;
                break;
            }
        }
        
        if (!isExistDefaultPlusIcon) {
            WARImageItem *item = [WARImageItem new];
            item.imageId = DefaultLastItem;
            [self.photoAlbumIcons addObject:item]; //"+" item
        }
    }
}

- (void)takePhotoForAlbum:(NSIndexPath *)indexPath {
    WS(weakSelf);
    WARCameraViewController *vc = [WARCameraViewController new];
    vc.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            ;
        } else if ([item isKindOfClass:[UIImage class]]){
            @weakify(self);
            [MBProgressHUD showLoad];

            [self.dataManager updateLoadImage:@[(UIImage*)item] successBlock:^(id successData) {
                @strongify(self);
                [MBProgressHUD hideHUD];
                NSArray *array = (NSArray*)successData;
                if (array && array.count > 0) {
                    WARImageItem *imageItem = [WARImageItem new];
                    NSString *imageId = [array objectAtIndex:0];
                    imageItem.imageId = imageId;
                    imageItem.imageData = (UIImage*)item;

                    WARImageItem *currentItem = [self.photoAlbumIcons objectAtIndex:indexPath.row];
                    if ([currentItem.imageId isEqualToString:DefaultLastItem]) {
                        [self.photoAlbumIcons insertObject:imageItem atIndex:indexPath.row];
                    }else {
                        [self.photoAlbumIcons replaceObjectAtIndex:indexPath.row withObject:imageItem];
                    }
                    self.valueChanged = YES;
                }

                [self.headerView reloadData];
            } failedBlock:^(id failedData) {
                [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
                [MBProgressHUD hideHUD];
            }];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - WARImagePickerControllerDelegate
- (void)imagePickerController:(WARImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    WS(weakSelf);

    [MBProgressHUD showLoad];
    [self.dataManager updateLoadImage:photos successBlock:^(id successData) {
        [MBProgressHUD hideHUD];

        [self.photoAlbumIcons removeLastObject];

        NSArray *array = (NSArray*)successData;
        if (array && array.count > 0) {
            for (int i= 0 ; i < array.count; i++) {
                NSString *imgId = array[i];

                WARImageItem *item = [WARImageItem new];
                item.imageId = imgId;
                if (i < photos) {
                    item.imageData = photos[i];
                }
                [self.photoAlbumIcons addObject:item];
            }
        }

        NDLog(@"photoAlbumIcons  ===   %@",self.photoAlbumIcons);

        [self checkInsertAddButton];
        self.headerView.imageItemArray = self.photoAlbumIcons;
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
    }];
}

- (void)selectImge {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:(9 - self.photoAlbumIcons.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)replaceExistImage:(NSIndexPath *)indexPath {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    
    @weakify(self);
    imagePickerVc.didFinishPickingPhotosHandle = ^ (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        
        if ([photos isKindOfClass:[NSURL class]]) {
            ;
        } else if ([photos isKindOfClass:[NSArray class]]){
            [MBProgressHUD showLoad];
            [self.dataManager updateLoadImage:photos successBlock:^(id successData) {
                [MBProgressHUD hideHUD];
                NSArray *array = (NSArray*)successData;
                if (array && array.count > 0) {
                    NSString *imageId = [array objectAtIndex:0];

                    WARImageItem *item = [WARImageItem new];
                    item.imageId = imageId;
                    if (photos.count) {
                        item.imageData = [photos objectAtIndex:0];
                    }

                    [self.photoAlbumIcons replaceObjectAtIndex:indexPath.row withObject:item];
                }

                [self.headerView reloadData];
            } failedBlock:^(id failedData) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
            }];
        }
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)rightButtonAction {
    [self saveData];
}

- (void)saveData {
    [MBProgressHUD showLoad];
    
    [self.dataManager saveImagesIdsByBgImage:self.iconBackgroundId headIdId:self.iconHeaderId albumArray:self.photoAlbumIcons successBlock:^(id successData) {
        [MBProgressHUD hideHUD];
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
        self.valueChanged = NO;
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
    }];
}

@end
