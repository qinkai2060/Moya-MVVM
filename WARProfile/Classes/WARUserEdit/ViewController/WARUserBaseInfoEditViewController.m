//
//  WARUserBaseInfoEditViewController.m
//  Pods
//
//  Created by huange on 2017/8/24.
//
//

#import "WARUserBaseInfoEditViewController.h"
#import "WARSettingsCell.h"
#import "WARSettingInputCell.h"
#import "WARBirthdayFooterView.h"
#import "NSDate+WARCategory.h"

#define InputCellId         @"InputCellId"
#define BirthDayCellId      @"BirthDayCellId"
#define SexCheckMarkCellId  @"SexCheckMarkCellId"

@interface WARUserBaseInfoEditViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WARBirthdayFooterView *footerView;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *genderString;

@end

@implementation WARUserBaseInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationBarClear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataManager = [WARUserEditDataManager new];
    self.genderString = self.dataManager.user.gender;
    self.dateString = [self getBirthdayString];
}

- (NSString *)getBirthdayString {
    NSString *birthday = nil;
    if (self.dataManager.user.year && self.dataManager.user.month && self.dataManager.user.day) {
        birthday =  [NSString stringWithFormat:@"%@-%@-%@",self.dataManager.user.year,self.dataManager.user.month,self.dataManager.user.day];
    }else {
        birthday = nil;
    }
    return birthday;
}

- (void)initUI {
    [super initUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.rightButtonText = WARLocalizedString(@"保存");
    self.navigationBarClear = NO;
    
    [self setNavigationTitle];
    [self createTableView];
}

- (void)setNavigationTitle {
    switch (self.userInfoType) {
        case UserInfoNickNameType: {
            self.title = WARLocalizedString(@"昵称");
        }
            break;
        case UserInfoSexType: {
            self.title = WARLocalizedString(@"性别");
        }
            break;
        case UserInfoBirthdayType: {
            self.title = WARLocalizedString(@"生日");
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
        make.top.equalTo(self.view.mas_top);
        make.left.right.bottom.equalTo(self.view);
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (UserInfoBirthdayType == self.userInfoType) {
        CGRect footerViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - commonCellHeight - 15 - 64); //50 button height
        
        return footerViewFrame.size.height;
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
        
        if ([self getBirthdayString]) {
            if ([self.dateString isEqualToString:[self getBirthdayString]]) {
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
    
    if (UserInfoSexType == self.userInfoType) {
        rowCout = 2;
    }
    
    return rowCout;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UserInfoNickNameType == self.userInfoType) {
        WARSettingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputCellId];
        cell.placeHolder = WARLocalizedString(@"请填写昵称(限12个字符)");
        cell.inputTextFeild.text = self.dataManager.user.nickname;
        [cell.inputTextFeild becomeFirstResponder];
        
        @weakify(self);
        [cell.inputTextFeild.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:self.dataManager.user.nickname]) {
                self.valueChanged = NO;
            }else {
                self.valueChanged = YES;
            }
            
            if (x.length > 12) {
                cell.inputTextFeild.text = [cell.inputTextFeild.text substringWithRange:NSMakeRange(0, 12)];
            }
        }];
        
        return cell;
    }else if (UserInfoSexType == self.userInfoType){
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
        cell.descriptionText = WARLocalizedString(@"生日");
        if (self.dateString) {
            cell.rightText = self.dateString;
        }else {
            cell.rightText = WARLocalizedString(@"请选择你的生日");
        }
        
        cell.rightTextColor = PlaceHolderColor;
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (UserInfoSexType == self.userInfoType) {
        if (0 == indexPath.row) {
            self.genderString = @"M";
        }else if (1 == indexPath.row) {
            self.genderString = @"F";
        }
        
        [tableView reloadData];
        
        if ([self.genderString isEqualToString:self.dataManager.user.gender]) {
            self.valueChanged = NO;
        }else {
            self.valueChanged = YES;
        }
    }
}

#pragma mark - data handle
- (void)rightButtonAction {
    if (UserInfoNickNameType == self.userInfoType) {
        WARSettingInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (!cell.inputTextFeild.text.length) {
            [MBProgressHUD showAutoMessage:WARLocalizedString(@"请正确输入昵称")];
            
            return;
        }
        
        [self.dataManager changeNickNameWithName:cell.inputTextFeild.text successBlock:^(id successData) {
            [MBProgressHUD hideHUD];
            [self showSaveSuccess];
        } failedBlock:^(id failedData) {
            [MBProgressHUD hideHUD];
        }];
    }else if (UserInfoSexType == self.userInfoType){
        [MBProgressHUD showLoad];

       [self.dataManager changeGenderWithGender:self.genderString successBlock:^(id successData) {
           [MBProgressHUD hideHUD];
           [self showSaveSuccess];
       } failedBlock:^(id failedData) {
           [MBProgressHUD hideHUD];
       }];
        
    }else {
        [MBProgressHUD showLoad];

        [self.dataManager changeBirthdayWithDate:self.dateString successBlock:^(id successData) {
            [MBProgressHUD hideHUD];
            [self showSaveSuccess];
        } failedBlock:^(id failedData) {
            [MBProgressHUD hideHUD];
        }];
    }
}

- (void)showSaveSuccess {
    [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
