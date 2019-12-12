//
//  WARFaceManagerViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import "WARFaceManagerViewController.h"
#import "WARFaceManagerNavBar.h"

#import "WARImagePickerController.h"
#import "WARCameraViewController.h"

#import "WARFaceMaskView.h"
#import "WARModal.h"
#import "WARUserPrivateStateView.h"

#import "WARSettingsCell.h"
#import "WARUserTagsBaseTableViewCell.h"

#import "WARFaceMaskViewModel.h"
#import "WARUserProvinceModel.h"
#import "WARUserInfoLocalFileManager.h"

#import "WARUserBaseInfoEditViewController.h"
#import "WARSignatureViewController.h"
#import "WARFaceSubEditViewController.h"
#import "WARFaceSignatureViewController.h"
#import "WARUserProvinceViewController.h"
#import "WARUserInfoCommonListViewController.h"
#import "WARUserPrivateStateViewController.h"
#import "WARUserInfoSearchViewController.h"
#import "WARUserInfoCreateNewTagViewController.h"
#import "WARUserInfoCommonSelectViewController.h"

#import "WARProfileFaceView.h"
#import "WARProfileUserModel.h"

#import "UIColor+HEX.h"
#import "WARFaceMaskModel.h"
#import "WARMediator+Contacts.h"

@interface WARFaceManagerViewController () <UITableViewDataSource, UITableViewDelegate, WARProfileFaceViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WARFaceManagerNavBar *navBar;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) WARFaceMaskView *faceV;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cellTitleArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;

@property (nonatomic, strong) WARFaceMaskModel *currentFaceModel;
@property (nonatomic, strong) WARFaceMaskViewModel *faceViewModel;

// 保存用户修改后的头像
@property (nonatomic, strong) UIImage *iconHeadImage;
// 保存用户修改后的背景图
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) WARProfileFaceView *maskView;

@property (nonatomic, copy) NSString *memberCount;

@property (nonatomic, strong) NSArray *updateFoodArray;

@end

@implementation WARFaceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:@"WARFaceManagerValueChanged" object:nil];
    
    self.view.backgroundColor = kColor(whiteColor);
//    self.title = WARLocalizedString(@"编辑不同形象");
//    self.rightButtonText =WARLocalizedString(@"保存");
    
    self.sectionTitleArray = @[WARLocalizedString(@"形象分组名称"),WARLocalizedString(@"基本资料"),WARLocalizedString(@"个人信息"),WARLocalizedString(@"兴趣标签")];
    self.cellTitleArray = @[@[@""],@[WARLocalizedString(@"头像"),WARLocalizedString(@"形象"),WARLocalizedString(@"昵称"),WARLocalizedString(@"性别"),WARLocalizedString(@"出生日期"),WARLocalizedString(@"个性签名")],@[WARLocalizedString(@"家乡"),WARLocalizedString(@"行业"),WARLocalizedString(@"职业"),WARLocalizedString(@"情感状况"),WARLocalizedString(@"学校"),WARLocalizedString(@"公司"),WARLocalizedString(@"聊天菜单")],@[WARLocalizedString(@"美食"),WARLocalizedString(@"运动"),WARLocalizedString(@"旅游"),WARLocalizedString(@"书籍"),WARLocalizedString(@"电影"),WARLocalizedString(@"音乐"),WARLocalizedString(@"游戏"),WARLocalizedString(@"其他")]];
    
    [self bindViewModel];
    [self.faceViewModel.getFacesCommand execute:nil];

    [self initUI];
    
    UITapGestureRecognizer *headerViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTapAction:)];
    [self.headerView addGestureRecognizer:headerViewTap];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)bindViewModel{
    @weakify(self)
    [RACObserve(self, faceViewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
    }];
    
    [self.faceViewModel.getFacesCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
//                self.faceV.dataArr = self.faceViewModel.faces;
//                NSInteger faceIndex = 0;
//                if (self.curFaceId.length) {
//
//                    for (int i = 0; i < self.faceViewModel.faces.count; i++) {
//                        WARFaceMaskModel *item = self.faceViewModel.faces[i];
//                        if ([item.faceId isEqualToString:self.curFaceId]) {
//                            faceIndex = i;
//                            break;
//                        }
//                    }
//
//                    if (faceIndex) {
//                        [self.faceV autoScrollToIndex:faceIndex];
//                    }
//
//                }
//                [self scrollFaceWithIndex:faceIndex];
                
               [self refreshMaskViewDataSource];
                
                //滑动到当前页
                NSInteger faceIndex = 0;
                if (self.curFaceId.length) {
                    for (int i = 0; i < self.faceViewModel.faces.count; i++) {
                        WARFaceMaskModel *item = self.faceViewModel.faces[i];
                        if ([item.maskId isEqualToString:self.curFaceId]) {
                            self.memberCount = item.friendCount;
                            faceIndex = i;
                            break;
                        }
                    }
                    if (faceIndex) {
                        [self.maskView scrollToIndex:faceIndex];
                    }
                }
                [self scrollFaceWithIndex:faceIndex];
            }
        }];
    }];
    
    [self.faceViewModel.saveCurrentFaceCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
            }else{
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"error")];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceDataDidChange" object:nil];
        }];
    }];
    
    [self.faceViewModel.createFaceCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
//                self.faceV.dataArr = self.faceViewModel.faces;
//                NSInteger lastIndex = self.faceViewModel.faces.count-1;
//                [self.faceV autoScrollToIndex:lastIndex];
                
                [self refreshMaskViewDataSource];
                
                [self.maskView scrollToIndex:self.faceViewModel.faces.count-1];
                [self scrollFaceWithIndex:self.faceViewModel.faces.count-1];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceDataDidChange" object:nil];
            }
        }];
    }];
    
    [self.faceViewModel.deleteFaceCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
//                self.faceV.dataArr = self.faceViewModel.faces;
                
                [self refreshMaskViewDataSource];
                
                [self.maskView scrollToIndex:0];
                [self scrollFaceWithIndex:0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceDataDidChange" object:nil];
            }
        }];
    }];
}

- (void)refreshMaskViewDataSource {
    NSMutableArray *array = [NSMutableArray array];
    [self.faceViewModel.faces enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARFaceMaskModel *model = obj;
        WARProfileMasksModel *maskModel = [[WARProfileMasksModel alloc] init];
        maskModel.faceImg = model.faceImg;
        maskModel.defaults = model.defaults;
        [array addObject:maskModel];
    }];
    self.maskView.dataSource = array;
}

- (void)initUI{
    [self.headerView addSubview:self.backgroundImageView];
    [self.headerView addSubview:self.addButton];
    [self.headerView addSubview:self.maskView];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.frame;
    CGFloat height =  WAR_IS_IPHONE_X ? kScreenWidth / 375.0 * 275 + 24 : kScreenWidth / 375.0 * 275;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.tableHeaderView = self.headerView;
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(WAR_IS_IPHONE_X ? (64+24):64);
    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.headerView);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(WAR_IS_IPHONE_X ? 77 + 24 : 77);
        make.width.height.mas_equalTo(30);
    }];
}

- (void)addButtonClick {
    [self addNewFace];
}

- (void)backArrowButonClick {
    if (self.valueChanged) {
        [WARAlertView showWithTitle:nil
                            Message:WARLocalizedString(@"保存本次编辑？")
                        cancelTitle:WARLocalizedString(@"不保存")
                        actionTitle:WARLocalizedString(@"保存")
                      cancelHandler:^(LGAlertView * _Nonnull alertView) {
                          [self.navigationController popViewControllerAnimated:YES];
                      } actionHandler:^(LGAlertView * _Nonnull alertView) {
                          [self saveButtonClick];
                      }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveButtonClick {
    // 保存所有面具
    self.valueChanged = NO;
    [self.faceViewModel saveAllMasks:self.faceViewModel.faces];
}

// 新增面具
- (void)addNewFace{
//    self.valueChanged = NO;
    [self.faceViewModel.createFaceCommand execute:nil];
}

// 滑动面具
- (void)scrollFaceWithIndex:(NSInteger)index{
    if (index < self.faceViewModel.faces.count) {
        self.currentFaceModel = self.faceViewModel.faces[index];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = CGSizeMake(kScreenWidth, kScreenWidth / 375.0 * 275);
            [self.backgroundImageView sd_setImageWithURL:kPhotoUrlWithImageSize(size, self.currentFaceModel.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
            [self.tableView reloadData];
        });
    }
}

// 删除面具
- (void)deleteFaceWithIndex:(NSInteger)index{
    if (index < self.faceViewModel.faces.count) {
        WARFaceMaskModel *faceM = self.faceViewModel.faces[index];
        
        if (faceM.defaults) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"此形象不能删除")];
        }else{
            @weakify(self);
            [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"该形象将被删除，形象下的成员将被移至公开形象")
                                        subTitle:nil
                                destructiveTitle:nil
                                    buttonTitles:@[WARLocalizedString(@"确认删除")]
                                     cancelTitle:WARLocalizedString(@"取消")
                              destructiveHandler:nil
                                   actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                       @strongify(self);
                                       [self.faceViewModel.deleteFaceCommand execute:faceM.maskId];
                                   }
                                   cancelHandler:nil
                               completionHandler:nil];
        }
    }
}

- (void)headerViewTapAction:(UITapGestureRecognizer *)tap{
    [self clickBgimgAction];
}

- (void)valueChange {
    self.valueChanged = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat navbarH = WAR_IS_IPHONE_X ? (64+24):64;
    CGFloat height =  WAR_IS_IPHONE_X ? kScreenWidth / 375.0 * 275 + 24 : kScreenWidth / 375.0 * 275;
    //计算导航栏的透明度
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = height - navbarH ;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    self.navBar.backImageView.alpha = alpha;
}

#pragma mark - WARProfileFaceViewDelegate
- (void)faceView:(WARProfileFaceView*)faceView didShowItemAtIndex:(NSInteger)itemIndex{
    WARFaceMaskModel *model = self.faceViewModel.faces[itemIndex];
    self.memberCount = model.friendCount;
    [self scrollFaceWithIndex:itemIndex];
}

#pragma mark - UITableView data Source & UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionTitle = self.sectionTitleArray[indexPath.section];
    NSString *cellTitle = self.cellTitleArray[indexPath.section][indexPath.row];
    if ([sectionTitle containsString:WARLocalizedString(@"形象分组名称")]) {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        if (self.currentFaceModel.remark.length) {
            cell.descriptionText = self.currentFaceModel.remark;
            cell.leftTextColor = TextColor;
        }
        else {
            cell.descriptionText = WARLocalizedString(@"可以对不同人设置不同面");
            cell.leftTextColor = DisabledTextColor;
        }
        cell.showAccessoryView = self.currentFaceModel.defaults ? NO : YES;
        cell.rightText = @"";
        return cell;
    }
    else if ([sectionTitle isEqualToString:WARLocalizedString(@"基本资料")]) {
        if ([cellTitle isEqualToString:WARLocalizedString(@"头像")]) {
            WARSettingsWithRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsWithRightImageCell"];
            
            UIImage *image = [WARUIHelper war_defaultUserIcon];
            NSURL *iconImageURL = kPhotoUrlWithImageSize(CGSizeMake(30, 30), self.currentFaceModel.faceImg);
            [cell.rightImageView sd_setImageWithURL:iconImageURL placeholderImage:image];
            
            cell.showAccessoryView = YES;
            cell.descriptionText = cellTitle;
            cell.rightImageView.clipsToBounds = YES;
            cell.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            return cell;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"形象")]) {
            WARSettingsWithRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsWithRightImageCell"];
            
            UIImage *image = [WARUIHelper war_defaultUserIcon];
            NSURL *iconImageURL = kPhotoUrlWithImageSize(CGSizeMake(30, 54), self.currentFaceModel.lookImg);
            [cell.rightImageView sd_setImageWithURL:iconImageURL placeholderImage:image];
            
            cell.showAccessoryView = YES;
            cell.descriptionText = cellTitle;
            cell.rightImageView.clipsToBounds = YES;
            cell.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            return cell;
        }else {
            WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];

            cell.leftTextColor = TextColor;
            cell.showAccessoryView = YES;
            cell.rightTextColor = TextColor;
            cell.descriptionText = cellTitle;
            
            if ([cellTitle isEqualToString:WARLocalizedString(@"昵称")]) {
                cell.rightText = self.currentFaceModel.nickname;
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"性别")]) {
                if ([self.currentFaceModel.gender isEqualToString:@"M"]) {
                    cell.rightText = WARLocalizedString(@"男");
                }else if ([self.currentFaceModel.gender isEqualToString:@"F"]) {
                    cell.rightText = WARLocalizedString(@"女");
                }else {
                    cell.rightText = WARLocalizedString(@"请选择性别");
                    cell.rightTextColor = DisabledTextColor;
                }
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"出生日期")]) {
                if(self.currentFaceModel.dateStr.length){
                    cell.rightText = self.currentFaceModel.dateStr;
                }else if (self.currentFaceModel.year && self.currentFaceModel.month && self.currentFaceModel.day) {
                    cell.rightText = [NSString stringWithFormat:@"%@-%@-%@",self.currentFaceModel.year, self.currentFaceModel.month, self.currentFaceModel.day];
                }else {
                    cell.rightText = WARLocalizedString(@"请选择出生日期");
                    cell.rightTextColor = DisabledTextColor;
                }
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"个性签名")]) {
                cell.isHideBottomLine = YES;
                if (![self.currentFaceModel.signature isKindOfClass:[NSNull class]] && self.currentFaceModel.signature.length) {
                    cell.rightText = self.currentFaceModel.signature;
                }else {
                    cell.rightText = WARLocalizedString(@"请填写个人签名");
                    cell.rightTextColor = DisabledTextColor;
                }
            }
            return cell;
        }
    }
    else if ([sectionTitle isEqualToString:WARLocalizedString(@"个人信息")]) {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARSettingsCell"];
        cell.leftTextColor = TextColor;
        cell.showAccessoryView = YES;
        cell.rightTextColor = TextColor;
        cell.descriptionText = cellTitle;
        if ([cellTitle isEqualToString:WARLocalizedString(@"家乡")]) {
            if (!self.currentFaceModel.province.length && !self.currentFaceModel.city.length) {
                cell.rightText = WARLocalizedString(@"请填写家乡");
                cell.rightTextColor = DisabledTextColor;
            }
            else {
                NSString *string;
                if (self.currentFaceModel.province.length) {
                    string = self.currentFaceModel.province;
                }
                
                if (self.currentFaceModel.city.length) {
                    string = [NSString stringWithFormat:@"%@ %@",string,self.currentFaceModel.city];
                }
                cell.rightText = string;
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"行业")]) {
            cell.rightText = self.currentFaceModel.industry.length ? self.currentFaceModel.industry : WARLocalizedString(@"请选择行业");
            cell.rightTextColor = self.currentFaceModel.industry.length ? TextColor : DisabledTextColor;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"职业")]) {
            cell.rightText = self.currentFaceModel.job.length ? self.currentFaceModel.job : WARLocalizedString(@"请选择职业");
            cell.rightTextColor = self.currentFaceModel.job.length ? TextColor : DisabledTextColor;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"情感状况")]) {
            cell.rightText = self.currentFaceModel.affectiveState.length ? self.currentFaceModel.showAffectiveString : WARLocalizedString(@"请选择情感状况");
            cell.rightTextColor = self.currentFaceModel.affectiveState.length ? TextColor : DisabledTextColor;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"学校")]) {
            cell.rightText = self.currentFaceModel.school.length ? self.currentFaceModel.school : WARLocalizedString(@"请选择学校");
            cell.rightTextColor = self.currentFaceModel.school.length ? TextColor : DisabledTextColor;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"公司")]) {
            cell.rightText = self.currentFaceModel.company.length ? self.currentFaceModel.company : WARLocalizedString(@"请选择公司");
            cell.rightTextColor = self.currentFaceModel.company.length ? TextColor : DisabledTextColor;
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"聊天菜单")]) {
            cell.rightText = self.currentFaceModel.chatMenus.count ? WARLocalizedString(@"已配置") : WARLocalizedString(@"未配置");
            cell.rightTextColor = self.currentFaceModel.chatMenus.count ? TextColor : DisabledTextColor;
        }
        return cell;
    }
    else if ([sectionTitle isEqualToString:WARLocalizedString(@"兴趣标签")]) {
        BOOL hasData = NO;
        NSArray *dataArr;
        NSString *decribeString;
        if ([cellTitle isEqualToString:WARLocalizedString(@"美食")]) {
            if (self.currentFaceModel.delicacies.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.delicacies;
            }else{
                decribeString = WARLocalizedString(@"请添加美食标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"运动")]) {
            if (self.currentFaceModel.sports.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.sports;
            }else{
                decribeString = WARLocalizedString(@"请添加运动标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"旅游")]) {
            if (self.currentFaceModel.tourisms.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.tourisms;
            }else{
                decribeString = WARLocalizedString(@"请添加旅游标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"书籍")]) {
            if (self.currentFaceModel.books.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.books;
            }else{
                decribeString = WARLocalizedString(@"请添加书籍标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"电影")]) {
            if (self.currentFaceModel.films.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.films;
            }else{
                decribeString = WARLocalizedString(@"请添加电影标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"音乐")]) {
            if (self.currentFaceModel.musics.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.musics;
            }else{
                decribeString = WARLocalizedString(@"请添加音乐标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"游戏")]) {
            if (self.currentFaceModel.games.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.games;
            }else{
                decribeString = WARLocalizedString(@"请添加游戏标签");
            }
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"其他")]) {
            if (self.currentFaceModel.others.count) {
                hasData = YES;
                dataArr = self.currentFaceModel.others;
            }else{
                decribeString = WARLocalizedString(@"请添加其他标签");
            }
        }
        
        if (hasData) {
            WARUserTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARUserTagsTableViewCell"];
            [cell configureDataArr:dataArr title:cellTitle];
            return cell;
        }else{
            WARUserNoTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARUserNoTagsTableViewCell"];
            [cell configureTitle:cellTitle describeText:decribeString];
            return cell;
        }
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionTitle = self.sectionTitleArray[indexPath.section];
    NSString *cellTitle = self.cellTitleArray[indexPath.section][indexPath.row];
    if ([cellTitle containsString:WARLocalizedString(@"形象")]) {
        return 68;
    }
    if ([sectionTitle containsString:WARLocalizedString(@"兴趣标签")]) {
        return UITableViewAutomaticDimension;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc]init];
    headerV.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12.5, kScreenWidth, 14)];
    titleLabel.font = kFont(14);
    titleLabel.textColor = ThreeLevelTextColor;
    titleLabel.text = self.sectionTitleArray[section];
    [headerV addSubview: titleLabel];
    
    if ([self.sectionTitleArray[section] containsString:WARLocalizedString(@"形象分组名称")]) {
        NSString *string = self.sectionTitleArray[section];
        string = [string stringByAppendingString:[NSString stringWithFormat:@"(共%@人)",self.memberCount]];
        titleLabel.text = string;
    }
    
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sectionTitle = self.sectionTitleArray[indexPath.section];
    NSString *cellTitle = self.cellTitleArray[indexPath.section][indexPath.row];
    if ([sectionTitle containsString:WARLocalizedString(@"形象分组名称")]) {
        if (!self.currentFaceModel.defaults) {
            WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfRemark];
            vc.currentFaceModel = self.currentFaceModel;
            WS(weakSelf);
            vc.remarkBlock = ^(NSString *remarkStr) {
                weakSelf.currentFaceModel.remark = remarkStr;
                [weakSelf.tableView reloadData];
                weakSelf.valueChanged = YES;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([sectionTitle isEqualToString:WARLocalizedString(@"基本资料")]) {
        if ([cellTitle isEqualToString:WARLocalizedString(@"头像")]) {
            [self clickSelfHeaderCellAction:indexPath];
        }else if ([cellTitle isEqualToString:WARLocalizedString(@"形象")]) {
            [self clickSelfHeaderCellAction:indexPath];
        }else {
            WARFaceSubEditViewController *userInfoVC = [WARFaceSubEditViewController new];
            userInfoVC.currentFaceModel = self.currentFaceModel;
            if ([cellTitle isEqualToString:WARLocalizedString(@"昵称")]) {
                userInfoVC.userInfoType = UserInfoNickNameType;
                [self.navigationController pushViewController:userInfoVC animated:YES];
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"性别")]) {
//                userInfoVC.userInfoType = UserInfoSexType;
//                [self.navigationController pushViewController:userInfoVC animated:YES];
                WS(weakSelf);
                [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"性别修改")
                                            subTitle:nil
                                    destructiveTitle:nil
                                        buttonTitles:@[WARLocalizedString(@"男"),WARLocalizedString(@"女")]
                                         cancelTitle:WARLocalizedString(@"取消")
                                  destructiveHandler:nil
                                       actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                           NSString *gender = [title isEqualToString:WARLocalizedString(@"男")] ? @"M" : @"F";
                                           if (![gender isEqualToString:weakSelf.currentFaceModel.gender]) {
                                               weakSelf.valueChanged = YES;
                                               weakSelf.currentFaceModel.gender = gender;
                                               [weakSelf.tableView reloadData];
                                           }
                                       }
                                       cancelHandler:nil
                                   completionHandler:nil];
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"出生日期")]) {
                userInfoVC.userInfoType = UserInfoBirthdayType;
                [self.navigationController pushViewController:userInfoVC animated:YES];
            }
            else if ([cellTitle isEqualToString:WARLocalizedString(@"个性签名")]) {
                WARFaceSignatureViewController *signatureVC = [WARFaceSignatureViewController new];
                signatureVC.currentFaceModel = self.currentFaceModel;
                [self.navigationController pushViewController:signatureVC animated:YES];
            }
        }
    }
    else if ([sectionTitle isEqualToString:WARLocalizedString(@"个人信息")]) {
        if ([cellTitle isEqualToString:WARLocalizedString(@"家乡")]) {
            WARUserProvinceViewController *vc = [[WARUserProvinceViewController alloc]init];
            WS(weakSelf);
            vc.userHometownBlock = ^(WARUserProvinceModel *provinceM, WARUserCityModel *cityM) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.province = provinceM.provinceName;
                weakSelf.currentFaceModel.provinceCode = provinceM.provinceCode;
                
                weakSelf.currentFaceModel.city = cityM.cityName;
                weakSelf.currentFaceModel.cityCode = cityM.cityCode;
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"行业")]) {
            WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfIndustry title:WARLocalizedString(@"行业") selectType:UserInfoCommonListSelectTypeOfSignal];
            
            NSArray *allFoodsArray = [WARUserInfoLocalFileManager allIndustries];
            NSMutableArray *foodArray = [NSMutableArray arrayWithArray:allFoodsArray];
            __block BOOL isHave = NO;
            [allFoodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *food = obj;
                if ([self.currentFaceModel.industry isEqualToString:food]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave && self.currentFaceModel.industry.length) {
                [foodArray insertObject:self.currentFaceModel.industry atIndex:0];
            }
            vc.dataArr = foodArray;
            if (self.currentFaceModel.industry.length) {
                vc.lastSelectArray = [NSArray arrayWithObject:self.currentFaceModel.industry];
            }
            WS(weakSelf);
            vc.didSelectItemBlock = ^(NSString *itemStr) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.industry = itemStr;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"职业")]) {
            WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfWork title:WARLocalizedString(@"职业") selectType:UserInfoCommonListSelectTypeOfSignal];
            
            NSArray *allFoodsArray = [WARUserInfoLocalFileManager allJobs];
            NSMutableArray *foodArray = [NSMutableArray arrayWithArray:allFoodsArray];
            __block BOOL isHave = NO;
            [allFoodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *food = obj;
                if ([self.currentFaceModel.job isEqualToString:food]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave && self.currentFaceModel.job.length) {
                [foodArray insertObject:self.currentFaceModel.job atIndex:0];
            }
            vc.dataArr = foodArray;
            if (self.currentFaceModel.job.length) {
                vc.lastSelectArray = [NSArray arrayWithObject:self.currentFaceModel.job];
            }
            WS(weakSelf);
            vc.didSelectItemBlock = ^(NSString *itemStr) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.job = itemStr;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"情感状况")]) {
//            WARUserPrivateStateViewController *vc = [[WARUserPrivateStateViewController alloc]initWithStateStr:self.currentFaceModel.affectiveState showStateStr:self.currentFaceModel.showAffectiveString];
//
//            WS(weakSelf);
//            vc.didSelectStateBlock = ^(NSString *string) {
//                weakSelf.currentFaceModel.affectiveState = string;
//                [weakSelf.tableView reloadData];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
            
            WARUserPrivateStateView *view = [[WARUserPrivateStateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 227) state:self.currentFaceModel.affectiveState];
            
            WARModal *modal = [WARModal modalWithContentView:view];
            modal.hideWhenTouchOutside = YES;
            modal.positionMode = WARModelPositionCenterBottom;
            [modal show:YES];
            view.cancelBlock = ^{
                [modal hide:YES];
            };
            WS(weakSelf);
            view.confirmBlock = ^(NSString *string) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.affectiveState = string;
                [weakSelf.tableView reloadData];
                [modal hide:YES];
            };
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"学校")]) {
            WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfSchool];
            WS(weakSelf);
            vc.searchBlock = ^(NSString *resultsStr) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.school = resultsStr;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"公司")]) {
            WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfCompany];
            WS(weakSelf);
            vc.searchBlock = ^(NSString *resultsStr) {
                weakSelf.valueChanged = YES;
                weakSelf.currentFaceModel.company = resultsStr;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellTitle isEqualToString:WARLocalizedString(@"聊天菜单")]) {
            WS(weakSelf);
            UIViewController *vc = [[WARMediator sharedInstance] Mediator_ChatCostumMenuViewControllerWithMaskId:self.currentFaceModel.maskId menuArray:self.currentFaceModel.chatMenus callback:^(NSArray *menuArray) {
                weakSelf.currentFaceModel.chatMenus = menuArray;
                [weakSelf.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
     else if ([sectionTitle isEqualToString:WARLocalizedString(@"兴趣标签")]) {
         if ([cellTitle isEqualToString:WARLocalizedString(@"美食")]) {
             WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfFood title:WARLocalizedString(@"美食") selectType:UserInfoCommonListSelectTypeOfMulti];
             
             NSArray *allFoodsArray = [WARUserInfoLocalFileManager allFoods];
             NSMutableArray *foodArray = [NSMutableArray arrayWithArray:allFoodsArray];
             [self.currentFaceModel.delicacies enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 NSString *str = obj;
                 __block BOOL isHave = NO;
                 [allFoodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     NSString *food = obj;
                     if ([str isEqualToString:food]) {
                         isHave = YES;
                         *stop = YES;
                     }
                 }];
                 if (!isHave) {
                     [foodArray insertObject:str atIndex:0];
                 }
             }];
             vc.dataArr = foodArray;
             vc.lastSelectArray = self.currentFaceModel.delicacies;
             WS(weakSelf);
             vc.didSureBlock = ^(NSArray *selectArr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.delicacies = selectArr;
                 [weakSelf.tableView reloadData];
             };
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"运动")]) {
             WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfSports title:WARLocalizedString(@"运动") selectType:UserInfoCommonListSelectTypeOfMulti];
             
             NSArray *allFoodsArray = [WARUserInfoLocalFileManager allSports];
             NSMutableArray *foodArray = [NSMutableArray arrayWithArray:allFoodsArray];
             [self.currentFaceModel.sports enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 NSString *str = obj;
                 __block BOOL isHave = NO;
                 [allFoodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     NSString *food = obj;
                     if ([str isEqualToString:food]) {
                         isHave = YES;
                         *stop = YES;
                     }
                 }];
                 if (!isHave) {
                     [foodArray insertObject:str atIndex:0];
                 }
             }];
             NSArray *dataArr = foodArray;
             vc.dataArr = dataArr;
             vc.lastSelectArray = self.currentFaceModel.sports;
             WS(weakSelf);
             vc.didSureBlock = ^(NSArray *selectArr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.sports = selectArr;
                 [weakSelf.tableView reloadData];
             };
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"旅游")]) {
             WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfTravel title:WARLocalizedString(@"旅游") selectType:UserInfoCommonListSelectTypeOfMulti];
             
             NSArray *allFoodsArray = [WARUserInfoLocalFileManager allTravels];
             NSMutableArray *foodArray = [NSMutableArray arrayWithArray:allFoodsArray];
             [self.currentFaceModel.tourisms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 NSString *str = obj;
                 __block BOOL isHave = NO;
                 [allFoodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     NSString *food = obj;
                     if ([str isEqualToString:food]) {
                         isHave = YES;
                         *stop = YES;
                     }
                 }];
                 if (!isHave) {
                     [foodArray insertObject:str atIndex:0];
                 }
             }];
             NSArray *dataArr = foodArray;
             vc.dataArr = dataArr;
             vc.lastSelectArray = self.currentFaceModel.tourisms;
             WS(weakSelf);
             vc.didSureBlock = ^(NSArray *selectArr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.tourisms = selectArr;
                 [weakSelf.tableView reloadData];
             };
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"书籍")]) {
             WARUserInfoCommonSelectViewController *vc = [[WARUserInfoCommonSelectViewController alloc]initWithType:UserInfoCommonSelectTypeOfBook];
             NSMutableArray *mArr = [NSMutableArray array];
             [mArr addObjectsFromArray:self.currentFaceModel.books];
             vc.dataArr = mArr;
             WS(weakSelf);
             vc.didFinishEditBlock = ^(NSArray *arr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.books = arr;
                 [weakSelf.tableView reloadData];
             };
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"电影")]) {
             WARUserInfoCommonSelectViewController *vc = [[WARUserInfoCommonSelectViewController alloc]initWithType:UserInfoCommonSelectTypeOfMovie];
             NSMutableArray *mArr = [NSMutableArray array];
             [mArr addObjectsFromArray:self.currentFaceModel.films];
             vc.dataArr = mArr;
             WS(weakSelf);
             vc.didFinishEditBlock = ^(NSArray *arr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.films = arr;
                 [weakSelf.tableView reloadData];
             };
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"音乐")]) {
             WARUserInfoCommonSelectViewController *vc = [[WARUserInfoCommonSelectViewController alloc]initWithType:UserInfoCommonSelectTypeOfMusic];
             NSMutableArray *mArr = [NSMutableArray array];
             [mArr addObjectsFromArray:self.currentFaceModel.musics];
             vc.dataArr = mArr;
             WS(weakSelf);
             vc.didFinishEditBlock = ^(NSArray *arr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.musics = arr;
                 [weakSelf.tableView reloadData];
             };
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"游戏")]) {
             WARUserInfoCommonSelectViewController *vc = [[WARUserInfoCommonSelectViewController alloc]initWithType:UserInfoCommonSelectTypeOfGame];
             NSMutableArray *mArr = [NSMutableArray array];
             [mArr addObjectsFromArray:self.currentFaceModel.games];
             vc.dataArr = mArr;
             WS(weakSelf);
             vc.didFinishEditBlock = ^(NSArray *arr) {
                 weakSelf.valueChanged = YES;
                 weakSelf.currentFaceModel.games = arr;
                 [weakSelf.tableView reloadData];
             };
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else if ([cellTitle isEqualToString:WARLocalizedString(@"其他")]) {
             WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfOther];
             WS(weakSelf);
             vc.addBlock = ^(NSString *tagStr) {
                 weakSelf.valueChanged = YES;
                 NSMutableArray *mArr = [NSMutableArray array];
                 if (weakSelf.currentFaceModel.others.count) {
                     [mArr addObjectsFromArray:weakSelf.currentFaceModel.others];
                 }
                 [mArr addObject:tagStr];
                 weakSelf.currentFaceModel.others = [NSArray arrayWithArray:mArr];
                 [weakSelf.tableView reloadData];
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             };
             [self.navigationController pushViewController:vc animated:YES];
         }
    }
}

// 更改背景图
#pragma mark - update User header Img
- (void)clickBgimgAction{
    @weakify(self);
    [WARActionSheet actionSheetWithTitle:nil
                                subTitle:nil
                        destructiveTitle:nil
                            buttonTitles:@[WARLocalizedString(@"相册"),WARLocalizedString(@"拍照")]
                             cancelTitle:WARLocalizedString(@"取消")
                      destructiveHandler:nil
                           actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                               @strongify(self);
                               if ([title isEqualToString:WARLocalizedString(@"相册")]) {
                                   [self selectImageForBackground];
                               }else if ([title isEqualToString:WARLocalizedString(@"拍照")]){
                                   [self takePhotoForBackground];
                               }
                           }
                           cancelHandler:nil
                       completionHandler:nil];
}

- (void)selectImageForBackground {
    WARImagePickerController *imagePickerVc = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    
    @weakify(self);
    imagePickerVc.didFinishPickingPhotosHandle = ^ (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        
        if ([photos isKindOfClass:[NSURL class]]) {
            ;
        } else if ([photos isKindOfClass:[NSArray class]]){
            self.backgroundImage = [photos objectAtIndex:0];
            [self uploadHeaderBackgroundImage];
        }
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhotoForBackground {
    WARCameraViewController *vc = [WARCameraViewController new];
    vc.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            ;
        } else if ([item isKindOfClass:[UIImage class]]){
            self.backgroundImage = (UIImage*)item;;
            [self uploadHeaderBackgroundImage];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)uploadHeaderBackgroundImage {
    [MBProgressHUD showLoad];
    @weakify(self);
    [self.faceViewModel updateLoadImage:@[self.backgroundImage] successBlock:^(id successData) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if (successData && [successData isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)successData;
            if (array && array.count > 0) {
                NSString *imgId = [array objectAtIndex:0];
                
                CGSize size = CGSizeMake(kScreenWidth, kScreenWidth / 375.0 * 275);
                [self.backgroundImageView sd_setImageWithURL:kPhotoUrlWithImageSize(size, imgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
                
                self.currentFaceModel.bgId = imgId;
                self.valueChanged = YES;
            }
        }
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
    }];
}


// 更改头像
#pragma mark - update User header Img
- (void)clickSelfHeaderCellAction:(NSIndexPath *)indexPath {
    @weakify(self);
    [WARActionSheet actionSheetWithTitle:nil
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

- (void)uploadHeaderIconImage:(NSIndexPath *)indexPath {
    @weakify(self);
    [MBProgressHUD showLoad];
    [self.faceViewModel updateLoadImage:@[self.iconHeadImage] successBlock:^(id successData) {
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
                
                if (indexPath.row == 0) {
                    //修改滑动视图的头像
                    [self.faceViewModel.faces enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WARFaceMaskModel *model = obj;
                        if (model == self.currentFaceModel) {
                            model.faceImg = self.iconHeadImage;
                        }
                    }];
                    self.maskView.dataSource = self.faceViewModel.faces;
                    
                    self.currentFaceModel.faceImg = imgId;
                    [self.faceV reloadFaces];
                }
                else if (indexPath.row == 1) {
                    self.currentFaceModel.lookImg = imgId;
                }
                self.valueChanged = YES;
            }
            
        }
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"上传图片失败")];
    }];

}


#pragma mark - getter methods
- (WARFaceMaskView *)faceV{
    if (!_faceV) {
        _faceV = [[WARFaceMaskView alloc]init];
        _faceV.type = WARFaceMaskViewTypeOfFaceMask;
    }
    return _faceV;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.backgroundColor = kColor(whiteColor);
        [_tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:@"WARSettingsCell"];
        [_tableView registerClass:[WARSettingsWithRightImageCell class] forCellReuseIdentifier:@"WARSettingsWithRightImageCell"];
        [_tableView registerClass:[WARUserTagsTableViewCell class] forCellReuseIdentifier:@"WARUserTagsTableViewCell"];
        [_tableView registerClass:[WARUserNoTagsTableViewCell class] forCellReuseIdentifier:@"WARUserNoTagsTableViewCell"];
    }
    return _tableView;
}

- (WARFaceMaskViewModel *)faceViewModel{
    if (!_faceViewModel) {
        _faceViewModel = [[WARFaceMaskViewModel alloc]init];
    }
    return _faceViewModel;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor grayColor];
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

- (UIButton *)addButton{
    if(!_addButton){
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage war_imageName:@"image_add" curClass:self.class curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIImageView *)backgroundImageView{
    if(!_backgroundImageView){
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [WARUIHelper war_placeholderBackground];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (WARProfileFaceView *)maskView {
    if(!_maskView){
        CGFloat height =  WAR_IS_IPHONE_X ? kScreenWidth / 375.0 * 120 + 24 : kScreenWidth / 375.0 * 120;
        _maskView = [[WARProfileFaceView alloc] initWithFrame:CGRectMake(50, height, kScreenWidth - 100, kScreenWidth / 375.0 * 90)];
        _maskView.delegate = self;
        _maskView.longPressBlock = ^(NSInteger index) {
            [self deleteFaceWithIndex:index];
        };
    }
    return _maskView;
}

- (NSString *)memberCount{
    if(!_memberCount){
        _memberCount = @"0";
    }
    return _memberCount;
}

- (WARFaceManagerNavBar *)navBar{
    if(!_navBar){
        _navBar = [[WARFaceManagerNavBar alloc] init];
        _navBar.backImageView.alpha = 0;
        WS(weakSelf);
        _navBar.backBlock = ^{
            [weakSelf backArrowButonClick];
        };
        _navBar.saveBlock = ^{
            [weakSelf saveButtonClick];
        };
    }
    return _navBar;
}

@end
