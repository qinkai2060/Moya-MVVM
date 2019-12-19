//
//  CategoryMainView.m
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesMainView.h"
#import "SpTypesSearchViewController.h"
#import "SPtypeVoiceSearchView.h"
@interface SpTypesMainView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) NSMutableArray *leftDataSource;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionArr;
@property (nonatomic, strong) SPtypeVoiceSearchView * voiceView;
@end

@implementation SpTypesMainView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.leftDataSource = [NSMutableArray arrayWithCapacity:1];
        self.collectionArr = [NSMutableArray arrayWithCapacity:1];
        
        [self createView];
        // 分类一级页面
        [self createPostOneLevelCategoryRequest];
    }
    return self;
}

// 当无数据时 在主页面刷新UI
- (void)refreshMainUI{
    if (self.leftDataSource.count == 0) {
        // 分类一级页面
        [self createPostOneLevelCategoryRequest];
    }
}

// 分类一级页面
- (void)createPostOneLevelCategoryRequest{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];

    NSDictionary *dic = @{
                          @"pid":@"",
                          @"sid":sidStr,
                          @"terminal":@"P_TERMINAL_MOBILE"
                          };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/firstLevelClassify"];
    [self requestData:dic withUrl:utrl withRequestName:@"" withRequestType:@"post"];
}
// 分类二级界面
- (void)createGetSecondLevelRequestWithPid:(NSString *)pidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./product/secondLevelClassify"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?pid=%@&sid=%@&terminal=P_TERMINAL_MOBILE",utrl,pidStr,sidStr];
    [self requestData:nil withUrl:urlStr withRequestName:@"" withRequestType:@"get"];
}

- (void)createView{
//    //
//    if (self.type == 1) {
//        self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44) isAddOneBtn:NO addBtnImageName:@"" addBtnTitle:@"" searchKeyStr:@"" canEidt:NO placeholderStr:@"" isHaveBack:NO isHaveBottomLine:YES];
//        [self addSubview:self.searchView];
//    }else {
//        self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44) isAddOneBtn:NO addBtnImageName:@"" addBtnTitle:@"" searchKeyStr:@"" canEidt:NO placeholderStr:@"" isHaveBack:YES isHaveBottomLine:YES];
//        [self addSubview:self.searchView];
//    }
//
//
    [self addSubview:self.voiceView];
    [[self.voiceView.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SpTypesSearchViewController *searchVC = [[SpTypesSearchViewController alloc] init];
        searchVC.hidesBottomBarWhenPushed = YES;
        [[UIViewController visibleViewController].navigationController pushViewController:searchVC animated:YES];
    }];
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.voiceView.frame), ScreenW / 11 * 3, self.frame.size.height - CGRectGetMaxY(self.voiceView.frame)) style:UITableViewStylePlain];
    self.leftTableView.backgroundColor = [UIColor whiteColor];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate  = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.leftTableView];
    
    //
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftTableView.frame), self.leftTableView.frame.origin.y, 1, self.leftTableView.frame.size.height)];
    line.backgroundColor = RGBACOLOR(229, 229, 229, 1);
    [self addSubview:line];
    
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
//    layout.minimumInteritemSpacing = 5;
    //最小两行之间的间距
//    layout.minimumLineSpacing = 5;
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftTableView.frame) + 1, CGRectGetMaxY(self.voiceView.frame),ScreenW - CGRectGetMaxX(self.leftTableView.frame) - 1,self.frame.size.height - CGRectGetMaxY(self.voiceView.frame)) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];

    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self addSubview:self.collectionView];
    
    //这种是自定义cell不带xib的注册
    [self.collectionView registerClass:[SpTypesRightCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell1"];
    
    //这是头部与脚部的注册
    [_collectionView registerClass:[SpTypesHeaderCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpTypesLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell == nil) {
        cell = [[SpTypesLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_leftDataSource.count > indexPath.row) {
        SpTypeFirstLevelModel *model = _leftDataSource[indexPath.row];
        [cell refreshLeftCellWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_leftDataSource.count > indexPath.row) {
        for (SpTypeFirstLevelModel *model in _leftDataSource) {
            model.isSelected = NO;
        }
        SpTypeFirstLevelModel *model = _leftDataSource[indexPath.row];
        model.isSelected = YES;
        
        [self createGetSecondLevelRequestWithPid:model.levelId];
    }
    [self.leftTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

#pragma mark collectionView delegate
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionArr.count;
}

//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_collectionArr.count > section) {
        SpTypeFirstLevelModel *model = _collectionArr[section];
        return [model.list count];
    }
    return 0;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SpTypesRightCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell1" forIndexPath:indexPath];
    if (_collectionArr.count > indexPath.section) {
        SpTypeFirstLevelModel *model = _collectionArr[indexPath.section];
        if (model.list.count > indexPath.row) {
            [cell refreshCellWithModel:model.list[indexPath.row]];
        }
    }
    return cell;
}

//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SpTypesHeaderCollectionView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];

        if (_collectionArr.count > indexPath.section) {
            SpTypeFirstLevelModel *model = _collectionArr[indexPath.section];
            [headerView refreshHeaderViewWithModel:model];
        }

        [headerView.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        headerView.moreBtn.tag = 2000+ indexPath.section;
        return headerView;
    }else{
        return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    }
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
//    if (_sectionGriditemArr.count > section) {
//        if ([_sectionGriditemArr[section] count] == 0) {
//            return CGSizeMake(0, 0);
//        }
//    }
    return CGSizeMake(ScreenW - ScreenW / 11 * 3 - 1, 70);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW - ScreenW / 11 * 3 - 35) / 3, (ScreenW -  ScreenW / 11 * 3 - 40) / 3 + 40);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(collectionViewCellSelectedWithIndexSection:indexRow:dataSourceArr:)]) {
        if (_collectionArr.count > indexPath.section) {
            SpTypeFirstLevelModel *model = _collectionArr[indexPath.section];
            [self.delegate collectionViewCellSelectedWithIndexSection:indexPath.section indexRow:indexPath.row dataSourceArr:model.list];
        }
    }
}

// 更多按钮的点击事件
- (void)moreBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(collectionViewSectionMoreBtnClickWithSection:dataSourceModel:)]) {
        
        if (_collectionArr.count > (btn.tag - 2000)) {
            SpTypeFirstLevelModel *model = _collectionArr[(btn.tag - 2000)];
            [self.delegate collectionViewSectionMoreBtnClickWithSection:btn.tag - 2000 dataSourceModel:model];
        }
    }
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
    if ([requestType isEqualToString:@"get"]){ // 分类 二级列表
        [manager GET:urlstr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf getSeconddata:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    } else if ([requestType isEqualToString:@"post"]){ // 分类 一级列表
        [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self getPrcessdata:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}
// 获取二级分类信息
- (void)getSeconddata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        if (self.collectionArr.count > 0) {
            [self.collectionArr removeAllObjects];
        }
        for (NSDictionary *listDic in dataDic[@"productClassList"]) {
            SpTypeFirstLevelModel *productModel = [[SpTypeFirstLevelModel alloc] init];
            [productModel setValuesForKeysWithDictionary:listDic];
            [self.collectionArr addObject:productModel];
//            for (NSDictionary *secDic in listDic[@"list"]) {
//                SpTypeFirstLevelModel *model = [[SpTypeFirstLevelModel alloc] init];
//                [model setValuesForKeysWithDictionary:secDic];
//            }
        }
        [self.collectionView reloadData];
        // 设置偏移量
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UICollectionViewLayoutAttributes * attrs = [self.collectionView layoutAttributesForItemAtIndexPath: indexPath];
        [self.collectionView setContentOffset:CGPointMake(0, attrs.frame.origin.y - 70)];
    }
}

// 获一级分类信息
- (void)getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        int index = 0;
        if (self.leftDataSource.count > 0) {
            [self.leftDataSource removeAllObjects];
        }

        for (NSDictionary *listDic in dataDic[@"productClassList"]) {
                    
            SpTypeFirstLevelModel *model = [[SpTypeFirstLevelModel alloc] init];
            [model setValuesForKeysWithDictionary:listDic];
            if (index == 0) {
                model.isSelected = YES;
                
                [self createGetSecondLevelRequestWithPid:model.levelId];
            }
            [self.leftDataSource addObject:model];
            index ++;
        }
        [self.leftTableView reloadData];
    }
}

- (SPtypeVoiceSearchView *)voiceView {
    if(!_voiceView){
        _voiceView = [[SPtypeVoiceSearchView alloc]init];
        _voiceView.frame = CGRectMake(0, 0, ScreenW, 44);
    }
    return _voiceView;
}
@end
