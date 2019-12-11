//
//  WARFaceSubEditViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/23.
//

#import "WARFaceSubEditViewController.h"
#import "WARSettingsCell.h"
#import "WARSettingInputCell.h"
#import "WARBirthdayFooterView.h"
#import "NSDate+WARCategory.h"

#import "WARFaceMaskModel.h"

#import "ReactiveObjC.h"

#define PlaceHolderColor HEXCOLOR(0x999999)

#define InputCellId         @"InputCellId"
#define BirthDayCellId      @"BirthDayCellId"
#define SexCheckMarkCellId  @"SexCheckMarkCellId"


@interface WARFaceSubEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WARBirthdayFooterView *footerView;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *genderString;
@property (nonatomic, copy)NSString *nickNameStr;

@property (nonatomic, strong) WARGroupHomeModel *groupHomeModel;

@end

@implementation WARFaceSubEditViewController

- (id)initWithGroupHomeModel:(WARGroupHomeModel *)groupHomeModel title:(NSString *)title {
    self = [super init];
    if (self) {
        self.groupHomeModel = groupHomeModel;
        if ([title isEqualToString:WARLocalizedString(@"群名称")]) {
            self.userInfoType = FaceSubEditGroupNameType;
        }
        else if ([title isEqualToString:WARLocalizedString(@"我的群昵称")]) {
            self.userInfoType = FaceSubEditGroupNickNameType;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

- (void)initData {
    self.genderString = self.currentFaceModel.gender;
    if (self.currentFaceModel.dateStr.length) {
        self.dateString = self.currentFaceModel.dateStr;
    }else {
        self.dateString = [self.currentFaceModel getBirthdayString];
    }
}


- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
//    self.rightButtonText = WARLocalizedString(@"保存");
    
    [self setNavigationTitle];
    [self createTableView];
}

- (void)setNavigationTitle {
    switch (self.userInfoType) {
        case FaceSubEditUserInfoNickNameType: {
            self.title = WARLocalizedString(@"昵称");
        }
            break;
        case FaceSubEditUserInfoSexType: {
            self.title = WARLocalizedString(@"性别");
        }
            break;
        case FaceSubEditUserInfoBirthdayType: {
            self.title = WARLocalizedString(@"出生日期");
        }
            break;
        case FaceSubEditGroupNameType: {
            self.title = WARLocalizedString(@"群名称");
        }
            break;
        case FaceSubEditGroupNickNameType: {
            self.title = WARLocalizedString(@"我的群昵称");
        }
            break;
        default:
            break;
    }
}

- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = commonCellHeight;
    [self.tableView registerClass:[WARSettingsCell class] forCellReuseIdentifier:BirthDayCellId];
    [self.tableView registerClass:[WARSettingInputCell class] forCellReuseIdentifier:InputCellId];
    [self.tableView registerClass:[WARSettingsCheckMarkCell class] forCellReuseIdentifier:SexCheckMarkCellId];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    tableView.scrollEnabled = NO;
    if (FaceSubEditUserInfoBirthdayType == self.userInfoType) {
        return self.view.frame.size.height - commonCellHeight - kNavigationBarHeight;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.footerView = [[WARBirthdayFooterView alloc] initWithFrame:CGRectZero];
    if (self.dateString) {
        self.footerView.datePick.date = [NSDate dateFromString:self.dateString dateFormat:DEFAULT_TIME_FORMAT];
    }
    
    @weakify(self);
    [[self.footerView.datePick rac_newDateChannelWithNilValue:[NSDate date]] subscribeNext:^(NSDate *x) {
        @strongify(self);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = DEFAULT_TIME_FORMAT;
        dateFormatter.locale = [NSLocale currentLocale];
        NSString *dateStr = [dateFormatter stringFromDate:x];
        
        WARSettingsCell *dateCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        dateCell.rightText = dateStr;
        self.dateString = dateStr;
        
        if ([self.currentFaceModel getBirthdayString]) {
            if ([self.dateString isEqualToString:[self.currentFaceModel getBirthdayString]]) {
                self.valueChanged = NO;
            }else {
                self.valueChanged = YES;
            }
        }else {
            self.valueChanged = YES;
        }
        
    }];
    
    
    return self.footerView ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCout = 1;
    
    if (FaceSubEditUserInfoSexType == self.userInfoType) {
        rowCout = 2;
    }
    
    return rowCout;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (FaceSubEditGroupNickNameType == self.userInfoType) {
        WARSettingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputCellId];
        cell.placeHolder = WARLocalizedString(@"请填写群昵称(限12字)");
        cell.inputTextFeild.text = self.groupHomeModel.accNickname;
        [cell.inputTextFeild becomeFirstResponder];
        self.nickNameStr = self.groupHomeModel.accNickname;
        @weakify(self);
        [cell.inputTextFeild.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:self.groupHomeModel.accNickname]) {
                self.valueChanged = NO;
            }else {
                self.nickNameStr = x;
                self.valueChanged = YES;
            }
        }];
        
        return cell;
    }else if (FaceSubEditGroupNameType == self.userInfoType) {
        WARSettingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputCellId];
        cell.placeHolder = WARLocalizedString(@"请填写群名称(限12字)");
        cell.inputTextFeild.text = self.groupHomeModel.groupName;
        [cell.inputTextFeild becomeFirstResponder];
        self.nickNameStr = self.groupHomeModel.groupName;
        @weakify(self);
        [cell.inputTextFeild.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:self.groupHomeModel.groupName]) {
                self.valueChanged = NO;
            }else {
                self.nickNameStr = x;
                self.valueChanged = YES;
            }
        }];
        
        return cell;
    }else if (FaceSubEditUserInfoNickNameType == self.userInfoType) {
        WARSettingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputCellId];
        cell.placeHolder = WARLocalizedString(@"请填写昵称(限12字)");
        cell.inputTextFeild.text = self.currentFaceModel.nickname;
        [cell.inputTextFeild becomeFirstResponder];
        self.nickNameStr = self.currentFaceModel.nickname;
        @weakify(self);
        [cell.inputTextFeild.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:self.currentFaceModel.nickname]) {
                self.valueChanged = NO;
            }else {
                self.nickNameStr = x;
                self.valueChanged = YES;
            }
        }];
        
        return cell;
    }else if (FaceSubEditUserInfoSexType == self.userInfoType){
        WARSettingsCheckMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:SexCheckMarkCellId];
        cell.isChecked = NO;
        if (0 == indexPath.row) {
            cell.descriptionText = WARLocalizedString(@"男");
            if ([self.genderString isEqualToString:@"M"]) {
                cell.isChecked = YES;
            }
        }else {
            if ([self.genderString isEqualToString:@"F"]) {
                cell.isChecked = YES;
            }
            cell.descriptionText = WARLocalizedString(@"女");
        }
        
        return cell;
    }else {
        WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:BirthDayCellId];
        cell.descriptionText = WARLocalizedString(@"出生日期");
        cell.rightTextColor = TextColor;
        if (self.dateString) {
            cell.rightText = self.dateString;
        }else {
            cell.rightText = WARLocalizedString(@"请选择你的出生日期");
        }
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (FaceSubEditUserInfoSexType == self.userInfoType) {
        if (0 == indexPath.row) {
            self.genderString = @"M";
        }else if (1 == indexPath.row) {
            self.genderString = @"F";
        }
        
        [tableView reloadData];
        
        if ([self.genderString isEqualToString:self.currentFaceModel.gender]) {
            self.valueChanged = NO;
        }else {
            self.valueChanged = YES;
        }
    }
}

#pragma mark - data handle
- (void)backAction {
    if (FaceSubEditGroupNickNameType == self.userInfoType) {
        if (self.nickNameStr.length > 12) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"最多12个字")];
            return;
        }
        
        self.groupHomeModel.accNickname = self.nickNameStr;
        
        if (self.editBlock) {
            self.editBlock(self.nickNameStr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (FaceSubEditGroupNameType == self.userInfoType) {
        if (self.nickNameStr.length > 12) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"最多12个字")];
            return;
        }
        
        self.groupHomeModel.groupName = self.nickNameStr;
        
        if (self.editBlock) {
            self.editBlock(self.nickNameStr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (FaceSubEditUserInfoNickNameType == self.userInfoType) {
        if (self.nickNameStr.length > 12) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"最多12个字")];
            return;
        }
        if (![self.currentFaceModel.nickname isEqualToString:self.nickNameStr]) {
            self.currentFaceModel.nickname = self.nickNameStr;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceManagerValueChanged" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (FaceSubEditUserInfoSexType == self.userInfoType){
        self.currentFaceModel.gender = self.genderString;
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        if (![[self.currentFaceModel getBirthdayString] isEqualToString:self.dateString]) {
            self.currentFaceModel.dateStr = self.dateString;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceManagerValueChanged" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
