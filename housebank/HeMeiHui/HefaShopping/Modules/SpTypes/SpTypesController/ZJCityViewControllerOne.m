//
//  ViewController.m
//  ZJIndexcitys
//
//  Created by ZeroJ on 16/10/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJCityViewControllerOne.h"
#import "ZJCity.h"
//#import "ZJProgressHUD.h"
#import "ZJCitiesGroup.h"
#import "ZJCityTableViewCellOne.h"
#import "STAddressLocationView.h"
#import "LocationManager.h"
#import "SpTypesSearchView.h"
#import "ChineseToPinyin.h"

#import "FindRegionsModel.h"

@interface ZJCityViewControllerOne ()<UITableViewDelegate, UITableViewDataSource,CateorySearchViewDelegate,UITextFieldDelegate> {
    NSArray<ZJCitiesGroup *> *_data;
    NSMutableDictionary *cellsHeight;
    
    NSArray *_SearchData;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray<ZJCity *> *allData;
@property (copy, nonatomic) ZJCitySelectedHandler citySelectedHandler;

@property (nonatomic, strong) STAddressLocationView *locationView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) SpTypesSearchView *searchView;

@property (nonatomic, strong) NSMutableArray *dataHistoryArray;

@property (nonatomic, assign) BOOL isSearchData;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) NSMutableArray *sectionTitles;

@property (nonatomic, strong) NSMutableArray *suoYinSectionArr; // 创建索引中分区索引的数组


@end

static CGFloat const kSearchBarHeight = 40.f;
static NSString *const kHotCellId = @"kHotCellId";
static NSString *const kNormalCellId = @"kNormalCellId";

@implementation ZJCityViewControllerOne

- (instancetype)initWithDataArray:(NSArray<ZJCitiesGroup *> *)dataArray  withType:(NSInteger)type {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.dataHistoryArray = [NSMutableArray arrayWithCapacity:1];
        self.isSearchData = NO;
//        if (dataArray) {
//            _data = dataArray;
//        } else {
//            [self setupLocalData];
//        }
        self.type = type;
        self.dataSourceArr = [NSMutableArray arrayWithCapacity:1];
        self.sectionTitles = [NSMutableArray arrayWithCapacity:1];
        self.suoYinSectionArr = [NSMutableArray arrayWithCapacity:1];

        [self requestData];
    }
    return self;
}

- (void)requestData{
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./data/findRegions"];
    [self requestData:nil withUrl:utrl withRequestName:@"post" withRequestType:@"post"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    cellsHeight = [NSMutableDictionary dictionary];
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

// 设置点击响应block
- (void)setupCityCellClickHandler:(ZJCitySelectedHandler)citySelectedHandler {
    _citySelectedHandler = [citySelectedHandler copy];
}
// 选中了城市的响应方法
// 三个地方需要调用: 点击了 热门城市 /搜索城市 /普通的城市
- (void)cityDidSelected:(FindRegionsModel *)model {
    if (_citySelectedHandler) {
        _citySelectedHandler(model);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_SearchData.count > 0) {
        return _SearchData.count;
    }
//    return _data.count;
    return _suoYinSectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_SearchData.count > 0) {
        if (_SearchData.count > section) {
            return [_SearchData[section] count];
        } else {
            return 0;
        }
    } else {
        if (section == 0 || section == 1) {
            return 1;
        }
        return [self.suoYinSectionArr[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_SearchData.count > 0) {
        if (_SearchData.count > indexPath.section) {
            FindRegionsModel *model = _SearchData[indexPath.section][indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
            
            cell.textLabel.text = model.name;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = RGBACOLOR(51, 51, 51, 1);
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        } else {
            return [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
    } else {
        if (indexPath.section == 0 || indexPath.section == 1) {
            if (_suoYinSectionArr.count > indexPath.section) {

                ZJCityTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:kHotCellId];
                
                if (cell == nil) {
                    cell = [[ZJCityTableViewCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHotCellId withCirysArr:_suoYinSectionArr[indexPath.section]];
                }

                __weak typeof(self) weakSelf = self;
                [cell setupCityCellClickHandler:^(FindRegionsModel *model) {
                    [weakSelf setUserDefaultWithStr:model];
                    [weakSelf cityDidSelected:model];
                }];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cellsHeight setValue:[NSNumber numberWithFloat:cell.cellHeight] forKey:[NSString stringWithFormat:@"%ld", indexPath.section]];
                return cell;

            } else {
                return [[UITableViewCell alloc] init];
            }
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];

            if (_suoYinSectionArr.count > indexPath.section && [_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
                FindRegionsModel *model = _suoYinSectionArr[indexPath.section][indexPath.row];
                if (model) {
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    cell.textLabel.textColor = RGBACOLOR(51, 51, 51, 1);
                    cell.textLabel.text = model.name;
//                    [cell refreshTableViewCellWithInfoModel:model];
                }
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_SearchData.count > 0) {
        if (_SearchData[indexPath.section] > 0) {
            return 44.f;
        }
        return 0;
    } else {
        if (indexPath.section == 0 || indexPath.section == 1) {
            if (cellsHeight.count == 0) {
                return 0;
            }
            return [[cellsHeight valueForKey:[NSString stringWithFormat:@"%ld", indexPath.section]] floatValue];
        } else {
            return 44.f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 28)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 22)];
    label.textColor = RGBACOLOR(153, 153, 153, 1);
    label.font = [UIFont systemFontOfSize:12.0];
    [contentView addSubview:label];
    
    label.text = _sectionTitles[section];

    if ([_sectionTitles[section] isEqualToString:@"历史"]) {
        label.text = @"历史访问城市";
    } else if([_sectionTitles[section] isEqualToString:@"热门"]){
        label.text = @"国内热门城市";
    }

    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_SearchData.count > section) {
        if ([_SearchData[section] count] == 0) {
            return 0;
        }
        return 28;
    }
    
    if (self.suoYinSectionArr.count > section) {
        NSArray *dataList = [self.suoYinSectionArr objectAtIndex:section];
        if ([dataList count]>0){
            return 28;
        }
    }
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_SearchData.count > 0) {
        if (_SearchData.count > indexPath.section ) {
            NSArray *arr = _SearchData[indexPath.section];
            if (arr.count > indexPath.row) {
                FindRegionsModel *cityModel = arr[indexPath.row];
                [self setUserDefaultWithStr:cityModel];
                //         把所选中的title 传到上个界面
                [self cityDidSelected:cityModel];
            }
        }
    } else {
        if (_suoYinSectionArr.count > indexPath.section) {
            NSArray *arr = _suoYinSectionArr[indexPath.section];
            if (arr.count > indexPath.row) {
                FindRegionsModel *cityModel = arr[indexPath.row];
                [self setUserDefaultWithStr:cityModel];
                [self cityDidSelected:cityModel];
            }
        }
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionTitles;
}

// 可以相应点击的某个索引, 也可以为索引指定其对应的特定的section, 默认是 section == index
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    [ZJProgressHUD showStatus:title andAutoHideAfterTime:0.5];
    return index;
}

- (NSArray<ZJCity *> *)allData {
    NSMutableArray<ZJCity *> *allData = [NSMutableArray array];
    int index = 0;
    for (FindRegionsModel *model in _dataSourceArr) {
        if (index == 0 || index == 1) {// 第一组, 热门城市忽略
            index++;
            continue;
        }
        ZJCity *city = [[ZJCity alloc] init];
        city.name = model.name;
        city.id = model.id;
        city.pinyin = model.pinyin;
        city.py = model.py;
        city.lat = model.lat;
        city.lng = model.lng;
        
        [allData addObject:city];

        index++;
    }
    return allData;
}

- (UIView *)topView{
    //
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, kSearchBarHeight + 41)];
    //
    self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44) isAddOneBtn:NO addBtnImageName:@"" addBtnTitle:@"" searchKeyStr:@"" canEidt:YES placeholderStr:@"输入城市名或拼音查询" isHaveBack:YES isHaveBottomLine:YES];
    [tView addSubview:self.searchView];
    self.searchView.delegate = self;
    self.searchView.searchTextField.delegate = self;
    self.searchView.searchTextField.speakPopView.hidden = YES;
    //
    __weak typeof(self) weakSelf = self;
    LocationManager *locationManager = [LocationManager shareTools];
    [locationManager initializeLocationService];
    [locationManager start];
    [locationManager getlocationInfo:^(NSString *locationStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [weakSelf dictionaryWithJsonString:locationStr];
            //在这里处理UI
            [weakSelf reverseGeocodeLatitude:dic[@"lat"] longitude:dic[@"lng"]];
        });
    }];

    //
    self.locationView = [[STAddressLocationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.view.frame.size.width, 41) type:self.type];
    [tView addSubview:self.locationView];
    
    return tView;
}

/**
 返回按钮的点击事件
 */
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 搜索按钮的点击事件 此处是跳转
 */
- (void)searchBtnClick{
}

/**
 左右侧按钮的点击事件
 */
- (void)searchRightBtnClick:(UIButton *)btn{
    [self.searchView.searchTextField resignFirstResponder];
    self.searchView.searchTextField.text = @"";
}

#pragma textfieldDelegate =======
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    [self searchVideoResult];
    //    [self searchRequestDataWithSearchType:@"keyword" searchValue:_searchTextField.text searchName:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

//    NSString *searchStr = [self.searchView.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchStr.length > 0) {
        
        NSArray  *arr = [[NSArray alloc] init];
        arr = [ZJCity searchText:searchStr inDataArray:self.dataSourceArr];
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:1];
        muArr = [self createSuoYin:arr isSearch:YES];
        _SearchData = muArr;
        
        [_tableView reloadData];
    } else {
        _SearchData = [NSMutableArray arrayWithCapacity:1];
        [self requestData];
//        [self.tableView reloadData];
    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    _SearchData = [NSMutableArray arrayWithCapacity:1];
//    [self setupLocalData];
//    [self.tableView reloadData];

    [self requestData];
    return YES;
}

// 搜索具体方法的实现
- (void)searchVideoResult{
    [self.searchView.searchTextField resignFirstResponder];
    
    NSString *searchStr = [self.searchView.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchStr.length==0) {
        searchStr = nil;
    }
    if (searchStr.length>0) {
        FindRegionsModel *model = [[FindRegionsModel alloc] init];
        model.name = searchStr;
        [self setUserDefaultWithStr:model];
    }
}
// 存储数据 （历史搜索记录）
- (void)setUserDefaultWithStr:(FindRegionsModel *)searchModel{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *searchArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"SpAddressSearchText"]];
    
    if (searchArray.count){
        _dataHistoryArray = [NSMutableArray arrayWithArray:searchArray];
    }
    if (searchModel.name.length>0) {
        for (FindRegionsModel *model in _dataHistoryArray) {
            if ([model.name isEqualToString:searchModel.name]) {
                [_dataHistoryArray removeObject:model];
                break ;
            }
        }
        [_dataHistoryArray insertObject:searchModel atIndex:0];
        if (_dataHistoryArray.count >3) {
            [_dataHistoryArray removeObjectAtIndex:3];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataHistoryArray];
        [ud setObject:data forKey:@"SpAddressSearchText"];
        [ud synchronize];
    }
    
//    [self setupLocalData];
//    [self.tableView reloadData];
//    [self requestData];
}

- (void)reverseGeocodeLatitude:(NSString *)latitude longitude:(NSString *)longitude { // 先给一个经纬度
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[latitude longLongValue] longitude:[longitude longLongValue]];
    // 开始逆地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error && placemarks.count < 1) {
            // 给的经纬度可能找不到，逆地理编码不成功
        } else {
            //  编码成功(找到了具体的位置信息)
            // 输出查询到的所有地标信息
            for (CLPlacemark *placeMark in placemarks) {
                [self.locationView refreshViewWithAddress:placeMark.locality];
            } // 获取数组中第一个元素的地标信息
        }
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        [self.view addSubview:[self topView]];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.statusHeghit +  44 + 41, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit - [self statusChangedWithStatusBarH] -  44 - 41) style:UITableViewStylePlain];

        tableView.delegate = self;
        tableView.dataSource = self;
        // 注册cell
//        [tableView registerClass:[ZJCityTableViewCellOne class] forCellReuseIdentifier:kHotCellId];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kNormalCellId];
        // 行高度
        tableView.rowHeight = 44.f;
        // sectionHeader 的高度
        tableView.sectionHeaderHeight = 28.f;
        // sectionIndexBar上的文字的颜色
        tableView.sectionIndexColor = [UIColor lightGrayColor];
        // 普通状态的sectionIndexBar的背景颜色
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        // 选中sectionIndexBar的时候的背景颜色
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 数据请求 =====get put=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName withRequestType:(NSString *)requestType{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求格式
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain",@"application/x-javascript", nil];
    manager.requestSerializer.timeoutInterval = 20.f;
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",CurrentEnvironment,url];
    
    __weak typeof(self)weakSelf = self;
    if ([requestType isEqualToString:@"post"]){ // 商品列表请求
        [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf getSeconddata:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            if (self.listDataSource.count > 0) {
            //                [self.listDataSource removeAllObjects];
            //            }
            //            [self.listMainView.tableView reloadData];
            //
            //            self.noContentImageName = @"SpType_search_noContent";
            //            self.noContentText = @"抱歉，这个星球找不到呢！";
            //            [self showNoContentView];
            //
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.userInfo[@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alertView show];

        }];
    }
}
// 列表
- (void)getSeconddata:(id)data{
    NSArray *resArr = data;
    for (NSDictionary *dic in resArr) {
        FindRegionsModel *model = [[FindRegionsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataSourceArr addObject:model];
    }
    
    self.suoYinSectionArr = [self createSuoYin:self.dataSourceArr isSearch:NO];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)createSuoYin :(NSArray*)dataArrary isSearch:(BOOL)isSearch{
    
    //建立索引
    UILocalizedIndexedCollation *indexCollection = [UILocalizedIndexedCollation currentCollation];
    if (self.sectionTitles.count > 0) {
        [self.sectionTitles removeAllObjects];
    }

    [self.sectionTitles addObjectsFromArray:[indexCollection sectionTitles]];
    if (!isSearch) {
        [self.sectionTitles insertObject:@"历史" atIndex:0];
        [self.sectionTitles insertObject:@"热门" atIndex:1];
    }
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];

    //tableView 会被分成个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++){
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    /*
     for (NSString *moblieNum in dataArrary)
     {
     PersonInfoModel *cUser = [_personModelsDictionary objectForKey:moblieNum];
     //getUserName是实现中文拼音检索的核心，见NameIndex类
     */
    for (int i=0;i<dataArrary.count;i++){
        
        FindRegionsModel *cUser = dataArrary[i];
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        
        if (cUser) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:cUser.name];
            if (firstLetter.length>0) {
                NSInteger section = [indexCollection sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:cUser];
            }else{
                if (sortedArray.count>0) {
                    NSMutableArray *array = [sortedArray lastObject];
                    [array addObject:cUser];
                }
            }
        }
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
     NSArray *searchArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"SpAddressSearchText"]];

    if (searchArray.count){
        self.dataHistoryArray = [NSMutableArray arrayWithArray:searchArray];
    }
    NSDictionary *addDic = @{@"title":@"历史",@"cities":self.dataHistoryArray};
    
    NSArray *hotCityArr = @[ @{@"id":@"2",
        @"name":@"北京",
        @"pinyin":@"beijing",
        @"py":@"bj",
        @"sort":@"1",
        @"lng":@"116.413384",
        @"lat":@"39.910925",
        @"hidden":@"0"},
                            
     @{@"id":@"194237",
        @"name":@"杭州",
        @"pinyin":@"hangzhou",
        @"py":@"hz",
        @"sort":@"1",
        @"lng":@"120.155070",
        @"lat":@"30.274084",
        @"hidden":@"0"},
                            
     @{@"id":@"490588",
        @"name":@"广州",
        @"pinyin":@"guangzhou",
        @"py":@"gz",
        @"sort":@"2",
        @"lng":@"113.264434",
        @"lat":@"23.129162",
        @"hidden":@"0"},
                            
     @{@"id":@"552771",
        @"name":@"成都",
        @"pinyin":@"chengdu",
        @"py":@"cd",
        @"sort":@"2",
        @"lng":@"104.066541",
        @"lat":@"30.572269",
        @"hidden":@"0"},
                            
     @{@"id":@"177286",
        @"name":@"苏州",
        @"pinyin":@"suzhou",
        @"py":@"sz",
        @"sort":@"13",
        @"lng":@"120.585315",
        @"lat":@"31.298886",
        @"hidden":@"0"},
                            
     @{@"id":@"495090",
        @"name":@"深圳",
        @"pinyin":@"shen",
        @"py":@"s",
        @"sort":@"3",
        @"lng":@"114.057868",
        @"lat":@"22.543099",
        @"hidden":@"0"},
                            
     @{@"id":@"170309",
        @"name":@"南京",
        @"pinyin":@"nanjing",
        @"py":@"nj",
        @"sort":@"4",
        @"lng":@"118.796877",
        @"lat":@"32.060255",
        @"hidden":@"0"},
                            
     @{@"id":@"7449",
        @"name":@"天津",
        @"pinyin":@"tianjing",
        @"py":@"tj",
        @"sort":@"5",
        @"lng":@"117.200983",
        @"lat":@"39.084158",
        @"hidden":@"0"},
                            
     @{@"id":@"540509",
        @"name":@"重庆",
        @"pinyin":@"chongqing",
        @"py":@"cq",
        @"sort":@"16",
        @"lng":@"106.551556",
        @"lat":@"29.563009",
        @"hidden":@"0"},
                            
     @{@"id":@"251087",
        @"name":@"厦门",
        @"pinyin":@"xiamen",
        @"py":@"xm",
        @"sort":@"15",
        @"lng":@"118.089425",
        @"lat":@"24.479833",
        @"hidden":@"0"},
                            
     @{@"id":@"427716",
        @"name":@"武汉",
        @"pinyin":@"wuhan",
        @"py":@"wh",
        @"sort":@"1",
        @"lng":@"114.305392",
        @"lat":@"30.593098",
        @"hidden":@"0"},
                            
    @{@"id":@"654043",
        @"name":@"西安",
        @"pinyin":@"xiang",
        @"py":@"xa",
        @"sort":@"18",
        @"lng":@"108.940174",
        @"lat":@"34.341568",
        @"hidden":@"0"},
                           ];

//                             ("北京", "北京", "2", "116.407526", "39.904030"));
//    mHotCities.add(new HotCity("杭州", "浙江", "194237", "120.155070", "30.274084"));
//    mHotCities.add(new HotCity("广州", "广东", "490588", "113.264434", "23.129162"));
//    mHotCities.add(new HotCity("成都", "四川", "552771", "104.066541", "30.572269"));
//    mHotCities.add(new HotCity("苏州", "江苏", "177286", "120.585315", "31.298886"));
//    mHotCities.add(new HotCity("深圳", "深圳", "495090", "114.057868", "22.543099"));
//    mHotCities.add(new HotCity("南京", "江苏", "170309", "118.796877", "32.060255"));
//    mHotCities.add(new HotCity("天津", "天津", "7449", "117.200983", "39.084158"));
//    mHotCities.add(new HotCity("重庆", "重庆", "540509", "106.551556", "29.563009"));
//    mHotCities.add(new HotCity("厦门", "福建", "251087", "118.089425", "24.479833"));
//    mHotCities.add(new HotCity("武汉", "湖北", "427716", "114.305392", "30.593098"));
//    mHotCities.add(new HotCity("西安", "陕西", "654043", "108.940174", "34.341568"));
    
    NSMutableArray *hotArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *cityDic in hotCityArr) {
        FindRegionsModel *model = [[FindRegionsModel alloc] init];
        [model setValuesForKeysWithDictionary:cityDic];
        [hotArr addObject:model];
    }
    if (!isSearch) {
        [sortedArray insertObject:self.dataHistoryArray atIndex:0];
        [sortedArray insertObject:hotArr atIndex:1];
    }
    
    return sortedArray;
}

@end
