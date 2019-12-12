//
//  WARUserInfoSearchViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserInfoSearchViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARProgressHUD.h"
#import "WARNetwork.h"

#import "WARCommonListTableViewCell.h"

#define kSchoolCellId @"kSchoolCellId"

@interface WARUserInfoSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *filteredStr;
}

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UserInfoSearchType  type;
@property (nonatomic, strong) NSMutableArray *resultsArr;

@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation WARUserInfoSearchViewController

- (instancetype)initWithType:(UserInfoSearchType)type{
    if (self = [super init]) {

        self.type = type;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    switch (self.type) {
        case UserInfoSearchTypeOfSchool:{
            self.title = WARLocalizedString(@"添加学校");
            self.textField.placeholder = WARLocalizedString(@"添加学校信息");
        }
            break;
        case UserInfoSearchTypeOfBook:{
            self.title = WARLocalizedString(@"书籍");
            self.textField.placeholder = WARLocalizedString(@"请输入书籍名称");

        }
            break;
        case UserInfoSearchTypeOfMovie:{
            self.title = WARLocalizedString(@"电影");
            self.textField.placeholder = WARLocalizedString(@"请输入电影名称");

        }
            break;
        case UserInfoSearchTypeOfMusic:{
            self.title = WARLocalizedString(@"音乐");
            self.textField.placeholder = WARLocalizedString(@"请输入音乐名称");

        }
            break;
        case UserInfoSearchTypeOfGame:{
            self.title = WARLocalizedString(@"游戏");
            self.textField.placeholder = WARLocalizedString(@"请输入游戏名称");

        }
            break;
        case UserInfoSearchTypeOfCompany:{
            self.title = WARLocalizedString(@"添加公司");
            self.textField.placeholder = WARLocalizedString(@"请输入公司名称");
            
        }
            break;
        case UserInfoSearchTypeOfRemark:{
            self.title = WARLocalizedString(@"形象分组");
            self.textField.placeholder = WARLocalizedString(@"填写形象分组");
            self.textField.text = self.currentFaceModel.remark;
        }
            break;
        case UserInfoSearchTypeOfTag:{
            self.title = WARLocalizedString(@"自定义标签");
            self.textField.placeholder = WARLocalizedString(@"新建自定义标签");
        }
             break;
        case UserSettingRemark:{
            self.title = WARLocalizedString(@"设置备注");
            self.textField.placeholder = WARLocalizedString(@"添加备注名 (限12字）");
            self.textField.text = self.settingModel.remarkName;
        }
             break;
        default:
            break;
    }
}


- (void)initUI{

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGFloat headerHeight = [self.headerV systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect headerFrame = self.headerV.frame;
    headerFrame.size.height = headerHeight;
    self.headerV.frame = headerFrame;
    
    self.tableView.tableHeaderView = self.headerV;
    
}

- (void)backAction {
    if (self.type == UserInfoSearchTypeOfRemark) {
        if (!self.textField.text.length) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"分组名称不能为空")];
            return;
        }
        if (filteredStr.length > 20) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多20个字")];
            return;
        }
        if ([self.currentFaceModel.remark isEqualToString:self.textField.text]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else {
            if (self.remarkBlock) {
                self.remarkBlock(filteredStr);
            }
        }
    }else if (self.type == UserInfoSearchTypeOfTag) {
        if (filteredStr.length > 10) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多10个字")];
            return;
        }
        if (self.remarkBlock) {
            self.remarkBlock(filteredStr);
        }
    }else if (self.type == UserSettingRemark) {
        if (filteredStr.length > 12) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多12个字")];
            return;
        }
        if ([self.settingModel.remarkName isEqualToString:self.textField.text]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else {
            if (self.remarkBlock) {
                self.remarkBlock(filteredStr);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    filteredStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (filteredStr.length) {
        switch (self.type) {
            case UserInfoSearchTypeOfSchool:{
                [self searchWithSearchType:@"SCHOOL" key:filteredStr];
            }
                break;
            case UserInfoSearchTypeOfBook:{
                [self searchWithSearchType:@"BOOK" key:filteredStr];
            }
                break;
            case UserInfoSearchTypeOfMovie:{
                [self searchWithSearchType:@"MOVIE" key:filteredStr];
            }
                break;
            case UserInfoSearchTypeOfMusic:{
                [self searchWithSearchType:@"MUSIC" key:filteredStr];
            }
                break;
            case UserInfoSearchTypeOfGame:{
                [self searchWithSearchType:@"GAME" key:filteredStr];
            }
                break;
            case UserInfoSearchTypeOfCompany:{
                [self.resultsArr removeAllObjects];
                [self.resultsArr addObject:filteredStr];
                [self.tableView reloadData];

            }
                break;
            default:
                break;
        }
    }else{
        [self.resultsArr removeAllObjects];
        [self.tableView reloadData];
    }

    return YES;
}

- (void)searchWithSearchType:(NSString *)searchType key:(NSString *)key{
    if (key.length) {
        NSString *string = [NSString stringWithFormat:@"warehouse-app/search/label/%@/list",searchType];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,string];
        WS(weakSelf);
        [WARNetwork postDataFromURI:url params:@{@"title":key} completion:^(id responseObj, NSError *err) {
            if (!err) {
                if (!kObjectIsEmpty(responseObj)) {
                    if ([responseObj isKindOfClass:[NSArray class]]) {
                        NSMutableArray *arr = [NSMutableArray array];
                        [arr addObjectsFromArray:responseObj];
                        weakSelf.resultsArr = arr;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                    }
                }else{
                    [WARProgressHUD showAutoMessage:WARLocalizedString(@"没有结果")];
                }
            }else{
                [WARProgressHUD showAutoMessage:WARLocalizedString(responseObj[@"state"])];
            }
        }];
    }else{
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"请填写内容进行搜索")];
    }
}

#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolCellId];
    if (!cell) {
        cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchoolCellId];
    }
    cell.type = WARCommonListTableViewCellTypeOfNormal;
    NSString *string = self.resultsArr[indexPath.row];
    [cell configureText:string];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = self.resultsArr[indexPath.row];
    
    if (self.type == UserInfoSearchTypeOfSchool || self.type == UserInfoSearchTypeOfCompany) {
        if (string.length > 30) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多30个字")];
            return;
        }
    }
    
    if (self.searchBlock) {
        self.searchBlock(string);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}





#pragma mark - getther methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = COLOR_WORD_GRAY_E;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSMutableArray *)resultsArr{
    if (!_resultsArr) {
        _resultsArr = [NSMutableArray array];
    }
    return _resultsArr;
}

- (UIView *)headerV{
    if (!_headerV) {
        _headerV = [[UIView alloc]init];
        [_headerV addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(-20);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = COLOR_WORD_GRAY_E;
        [_headerV addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textField.mas_bottom).offset(9);
            make.left.right.equalTo(self.textField);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _headerV;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

@end
