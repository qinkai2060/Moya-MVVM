//
//  WARPrivatePersonListViewController.m
//  WARProfile
//
//  Created by Hao on 2018/6/29.
//

#import "WARPrivatePersonListViewController.h"
#import "WARPrivatePersonListCell.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARNetwork.h"
#import "WARPrivatePersonModel.h"
#import "YYModel.h"

@interface WARPrivatePersonListViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *dataKeyArray;
@property (nonatomic, strong) NSMutableArray *phoneDataArray;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) NSArray *searchDataArray;

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, copy) NSString *searchText;

@end

@implementation WARPrivatePersonListViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.type) {
        case WARPrivatePersonTypeBlack:
            self.title = WARLocalizedString(@"黑名单");
            break;
        case WARPrivatePersonTypeMomentNoAccess:
            self.title = WARLocalizedString(@"不让TA看我的动态");
            break;
        case WARPrivatePersonTypeMomentNoReceive:
            self.title = WARLocalizedString(@"不看TA的动态");
            break;
        case WARPrivatePersonTypeLocationNoShow:
            self.title = WARLocalizedString(@"对TA隐身");
            break;
        default:
            break;
    }
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:WARLocalizedString(@"解除") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightButton = rightButton;
    
    //顶部搜索视图
    self.searchView = [[UIView alloc] init];
    self.searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, kScreenWidth, 49);
    searchBar.barTintColor = [UIColor whiteColor];
    [searchBar setBackgroundImage:[UIImage new]];
    searchBar.placeholder = WARLocalizedString(@"搜索");
    searchBar.delegate = self;
    [self.searchView addSubview:searchBar];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(12, 49, kScreenWidth - 24, 1)];
    lineV.backgroundColor = SeparatorColor;
    [self.searchView addSubview:lineV];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self configureTableView];
    
    [self getListData];
}

#pragma mark - Event Response

- (void)rightButtonAction {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [self.rightButton setTitle:WARLocalizedString(@"完成") forState:UIControlStateNormal];
    }else {
        [self.rightButton setTitle:WARLocalizedString(@"解除") forState:UIControlStateNormal];
    }
}

#pragma mark - Delegate
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.isSearching = NO;
        self.tableView.sc_indexViewDataSource = self.dataKeyArray;
    } else {
        self.isSearching = YES;
        self.tableView.sc_indexViewDataSource = nil;
    }
    self.searchText = searchText;
    self.searchDataArray = [self searchFriendWithString:searchText];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearching) {
        return 1;
    }
    return self.dataKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.searchDataArray.count;
    }
    NSArray *array = [self.dataDict objectForKey:[self.dataKeyArray objectAtIndex:section]];
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSearching) {
        return [UIView new];
    }
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = BackgroundDefaultColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4.5, kScreenWidth, 13)];
    label.text = self.dataKeyArray[section];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = ThreeLevelTextColor;
    [headerV addSubview:label];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearching) {
        return 0.01f;
    }
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARPrivatePersonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARPrivatePersonListCell"];
    if (self.isSearching) {
        cell.model = self.searchDataArray[indexPath.row];
//        [cell configureCellWithSearchString:self.searchText];
    }
    else {
        NSArray *array = [self.dataDict objectForKey:[self.dataKeyArray objectAtIndex:indexPath.section]];
        array = [NSArray yy_modelArrayWithClass:[WARPrivatePersonModel class] json:array];
        cell.model = array[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.dataDict objectForKey:[self.dataKeyArray objectAtIndex:indexPath.section]];
    array = [NSArray yy_modelArrayWithClass:[WARPrivatePersonModel class] json:array];
    WARPrivatePersonModel *model = array[indexPath.row];
    switch (self.type) {
        case WARPrivatePersonTypeBlack:
        {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/black/%@",kDomainNetworkUrl,model.accountId,@"FALSE"];
            WS(weakSelf);
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [weakSelf getListData];
                }
            }];
        }
            break;
        case WARPrivatePersonTypeMomentNoAccess:
        {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/moment/access/%@",kDomainNetworkUrl,model.accountId,@"TRUE"];
            WS(weakSelf);
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [weakSelf getListData];
                }
            }];
        }
            break;
        case WARPrivatePersonTypeMomentNoReceive:
        {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/moment/receive/%@",kDomainNetworkUrl,model.accountId,@"TRUE"];
            WS(weakSelf);
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [weakSelf getListData];
                }
            }];
        }
            break;
        case WARPrivatePersonTypeLocationNoShow:
        {
            NSString *url = [NSString stringWithFormat:@"%@/cont-app/guy/%@/friend/show/%@",kDomainNetworkUrl,model.accountId,@"TRUE"];
            WS(weakSelf);
            [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [weakSelf getListData];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

- (void)getListData{
    NSString *urlString = nil;
    switch (self.type) {
        case WARPrivatePersonTypeBlack:
            urlString = @"cont-app/guy/list/black";
            break;
        case WARPrivatePersonTypeMomentNoAccess:
            urlString = @"cont-app/guy/list/moment/noaccess";
            break;
        case WARPrivatePersonTypeMomentNoReceive:
            urlString = @"cont-app/guy/list/moment/noreceive";
            break;
        case WARPrivatePersonTypeLocationNoShow:
            urlString = @"cont-app/guy/list/location/noshow";
            break;
        default:
            break;
    }
    WS(weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,urlString];
    [WARNetwork getDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
        if (!err) {
            weakSelf.dataDict = responseObj;
            NSArray *keyArray = weakSelf.dataDict.allKeys;
            keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result  = [obj1 compare:obj2];
                return result;
            }];
            weakSelf.dataKeyArray = keyArray;
            weakSelf.tableView.sc_indexViewDataSource = weakSelf.dataKeyArray;
            [weakSelf.tableView reloadData];
            
            [weakSelf.phoneDataArray removeAllObjects];
            [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = [weakSelf.dataDict objectForKey:[weakSelf.dataKeyArray objectAtIndex:idx]];
                array = [NSArray yy_modelArrayWithClass:[WARPrivatePersonModel class] json:array];
                [weakSelf.phoneDataArray addObjectsFromArray:array];
            }];
            
            switch (weakSelf.type) {
                case WARPrivatePersonTypeBlack:
                    weakSelf.title = [NSString stringWithFormat:@"%@(%ld)",WARLocalizedString(@"黑名单"),weakSelf.phoneDataArray.count];
                    break;
                case WARPrivatePersonTypeMomentNoAccess:
                    weakSelf.title = [NSString stringWithFormat:@"%@(%ld)",WARLocalizedString(@"不让TA看我的动态"),weakSelf.phoneDataArray.count];
                    break;
                case WARPrivatePersonTypeMomentNoReceive:
                    weakSelf.title = [NSString stringWithFormat:@"%@(%ld)",WARLocalizedString(@"不看TA的动态"),weakSelf.phoneDataArray.count];
                    break;
                case WARPrivatePersonTypeLocationNoShow:
                    weakSelf.title = [NSString stringWithFormat:@"%@(%ld)",WARLocalizedString(@"对TA隐身"),weakSelf.phoneDataArray.count];
                    break;
                default:
                    break;
            }
        }
    }];
}

- (NSArray *)searchFriendWithString:(NSString *)searchString {
    NSMutableArray *resultArray = [NSMutableArray array];
    if (self.phoneDataArray.count) {
        [self.phoneDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARPrivatePersonModel *model = obj;
            if ([model.namePinyin containsString:searchString] || [model.friendName containsString:searchString]) {
                [resultArray addObject:model];
            }
        }];
    }
    return resultArray;
}

- (void)configureTableView {
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    indexViewConfiguration.indexItemSelectedBackgroundColor = DisabledTextColor;
    indexViewConfiguration.indexItemTextColor = SubTextColor;
    self.tableView.sc_indexViewConfiguration = indexViewConfiguration;
    //    self.tableView.sc_translucentForTableViewInNavigationBar = YES;
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorWhite;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 55;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[WARPrivatePersonListCell class] forCellReuseIdentifier:@"WARPrivatePersonListCell"];
    }
    return _tableView;
}

- (NSMutableArray *)phoneDataArray{
    if(!_phoneDataArray){
        _phoneDataArray = [NSMutableArray array];
    }
    return _phoneDataArray;
}
@end
