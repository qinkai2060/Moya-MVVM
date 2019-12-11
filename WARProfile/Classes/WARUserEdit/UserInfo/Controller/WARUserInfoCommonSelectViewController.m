//
//  WARUserInfoCommonSelectViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import "WARUserInfoCommonSelectViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARProgressHUD.h"


#import "WARCommonListTableViewCell.h"


#import "WARUserInfoSearchViewController.h"


#define kUserInputCellId @"kUserInputCellId"
#define kUserInfoCommonSelectCellId @"kUserInfoCommonSelectCellId"

@interface WARUserInfoCommonSelectViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UserInfoCommonSelectType  type;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation WARUserInfoCommonSelectViewController

- (instancetype)initWithType:(UserInfoCommonSelectType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColor(whiteColor);
    
    [self initUI];
    
    self.rightButtonText = WARLocalizedString(@"编辑");
}


- (void)initUI{
    switch (self.type) {
        case 0:
        {
            self.title = WARLocalizedString(@"书籍");
        }
            break;
        case 1:
        {
            self.title = WARLocalizedString(@"电影");
        }
            break;
        case 2:
        {
            self.title = WARLocalizedString(@"音乐");
            
        }
            break;
        case 3:
        {
            self.title = WARLocalizedString(@"游戏");
            
        }
            break;
        default:
            break;
    }
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)rightButtonAction {
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        self.rightButtonText = WARLocalizedString(@"完成");
    }else {
        self.rightButtonText = WARLocalizedString(@"编辑");
    }
    [self.tableView reloadData];
}

#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARCommonListTableViewCell"];
        cell.type = WARCommonListTableViewCellTypeOfCreate;
        cell.createLab.text = [NSString stringWithFormat:@"%@%@",WARLocalizedString(@"添加我喜欢的"),self.title];
        return cell;
    }else{
        
        WAREditTagsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCommonSelectCellId];
        if (!cell) {
            cell = [[WAREditTagsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserInfoCommonSelectCellId];
        }
        cell.isEdit = self.isEdit;
        [cell configureDataArr:self.dataArr];

        WS(weakSelf);
        cell.didSelectTagBlock = ^(NSInteger index) {
            [weakSelf.dataArr removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        };
    
        cell.didFinishEditBlock = ^{
            if (weakSelf.didFinishEditBlock) {
                weakSelf.didFinishEditBlock(weakSelf.dataArr);
            }
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case UserInfoCommonSelectTypeOfBook:
        {
            if (indexPath.row == 0) {
                WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfBook];
                WS(weakSelf);
                vc.searchBlock = ^(NSString *resultsStr) {
                    [weakSelf.dataArr addObject:resultsStr];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.didFinishEditBlock) {
                        weakSelf.didFinishEditBlock(weakSelf.dataArr);
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                
            }
            
        }
            break;
        case UserInfoCommonSelectTypeOfMovie:
        {
            if (indexPath.row == 0) {
                WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfMovie];
                WS(weakSelf);
                vc.searchBlock = ^(NSString *resultsStr) {
                    [weakSelf.dataArr addObject:resultsStr];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.didFinishEditBlock) {
                        weakSelf.didFinishEditBlock(weakSelf.dataArr);
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
             
            }
        }
            break;
        case UserInfoCommonSelectTypeOfMusic:
        {
            if (indexPath.row == 0) {
                WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfMusic];
                WS(weakSelf);
                vc.searchBlock = ^(NSString *resultsStr) {
                    [weakSelf.dataArr addObject:resultsStr];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.didFinishEditBlock) {
                        weakSelf.didFinishEditBlock(weakSelf.dataArr);
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
               
            }
        }
            break;
        case UserInfoCommonSelectTypeOfGame:
        {
            if (indexPath.row == 0) {
                WARUserInfoSearchViewController *vc = [[WARUserInfoSearchViewController alloc]initWithType:UserInfoSearchTypeOfGame];
                WS(weakSelf);
                vc.searchBlock = ^(NSString *resultsStr) {
                    [weakSelf.dataArr addObject:resultsStr];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.didFinishEditBlock) {
                        weakSelf.didFinishEditBlock(weakSelf.dataArr);
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
               
                
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - getther methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tableView registerClass:[WARCommonListTableViewCell class] forCellReuseIdentifier:@"WARCommonListTableViewCell"];
    }
    return _tableView;
}




- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
