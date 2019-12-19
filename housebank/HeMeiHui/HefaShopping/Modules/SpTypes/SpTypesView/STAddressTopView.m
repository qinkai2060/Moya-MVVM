//
//  STAddressTopView.m
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STAddressTopView.h"
#import "STShoppingAddressCollectionViewCell.h"
#import "STAddressHeaderCollectionView.h"
#import "ChineseToPinyin.h"

@interface STAddressTopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *historyCityArr;
@property (nonatomic, strong) NSMutableArray *hotCityArr;

@property (nonatomic, strong) NSMutableArray *sectionTitles; // 区头的title数组
@property (nonatomic, strong) NSMutableArray *suoYinSectionArr; // 创建索引中分区索引的数组
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView * headerLine;

@end

@implementation STAddressTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _sectionTitles = [[NSMutableArray alloc] initWithCapacity:1];
        _suoYinSectionArr = [[NSMutableArray alloc] initWithCapacity:1];
        _historyCityArr = [[NSMutableArray alloc] initWithCapacity:1];
        _hotCityArr = [[NSMutableArray alloc] initWithCapacity:1];

        [self createView];
        
    }
    return self;
}

- (void)createView{
    NSArray *arr = @[@"阿城区",@"吧",@"成",@"的",@"额",@"发",@"购",@"好",@"想",@"要",@"哦",@"品",@"去",@"喏",@"说",@"他",@"u",@"再",@"别",@"v",@"e为",@"弄",@"么",@"来",@"看",@"家",@"人",];
    self.suoYinSectionArr = [self createSuoYin:arr];

    //
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenW, self.frame.size.height)];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.dataSource = self;
    self.tableview.delegate  = self;
    self.tableview.sectionIndexColor = RGB(73, 104, 136);
    self.tableview.tableHeaderView = [self createTableViewHeaderView];
    [self addSubview:self.tableview];

}

- (UIView *)createTableViewHeaderView{
    //
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 500 + 10)];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *searchArray = [ud objectForKey:@"SpAddressSearchText"];
    if (searchArray.count){
        self.historyCityArr = [NSMutableArray arrayWithArray:searchArray];
    }
    
    self.hotCityArr = [NSMutableArray arrayWithObjects:@"北京",@"上海",@"杭州",@"成都",@"厦门",nil];
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0,self.frame.size.width - 40,500) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [_headerView addSubview:self.collectionView];
    
    //这种是自定义cell不带xib的注册
    [self.collectionView registerClass:[STShoppingAddressCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    //这是头部与脚部的注册
    [_collectionView registerClass:[STAddressHeaderCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
#pragma mark // 调用这个地方在获取到热门城市之后调用
    CGRect cRect = self.collectionView.frame;
    cRect.size.height = [self getHeaderCollectionHeightWithSearchArr:_historyCityArr hotArr:_hotCityArr];
    self.collectionView.frame = cRect;
    
    self.headerView.frame = CGRectMake(0, 0, ScreenW, [self getHeaderCollectionHeightWithSearchArr:_historyCityArr hotArr:_hotCityArr] + 10);

    //
    _headerLine = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.collectionView.frame), ScreenW, 10)];
    _headerLine.backgroundColor = RGBACOLOR(229, 229, 229, 1);
    [_headerView addSubview:_headerLine];

    return _headerView;
}

#pragma mark tableView delegate  ============================
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _suoYinSectionArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 22)];
    label.textColor = RGBACOLOR(153, 153, 153, 1);
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = _sectionTitles[section];
    [contentView addSubview:label];
    return contentView;
    
}
// 返回侧边的索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _sectionTitles;
}
// 右边索引的点击事件
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//
//    [self endEditing:YES];
//
//    NSString *string = self.sectionTitles[index];
//
////    [self showCenterIndexShowView:string];
//    if (index == 0 || index == 1) {
//        CGRect rect = self.tableview.frame;
//        rect.origin.y = 0;
//        self.tableview.frame = rect;
//        return -1;
//    }
//    return index;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_suoYinSectionArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_suoYinSectionArr.count > indexPath.section && [_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
        NSString *titleStr = _suoYinSectionArr[indexPath.section][indexPath.row];
        if (titleStr) {
            cell.textLabel.text = titleStr;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_suoYinSectionArr.count > indexPath.section && [_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
//        PersonInfoModel *ymodel = [[PersonInfoModel alloc] init];
//        ymodel = _suoYinSectionArr[indexPath.section][indexPath.row];
//        vc.personInfoModel = ymodel;
//        vc.contactId = ymodel.contactUserId;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.suoYinSectionArr.count > section) {
        NSArray *dataList = [self.suoYinSectionArr objectAtIndex:section];
        if ([dataList count]>0){
            return 20;
        }
    }
    return 0.0;
}

- (NSMutableArray *)createSuoYin:(NSArray*)dataArrary{
    //建立索引
    UILocalizedIndexedCollation *indexCollection = [UILocalizedIndexedCollation currentCollation];
    if (self.sectionTitles.count > 0) {
        [self.sectionTitles removeAllObjects];
    }
    
    [self.sectionTitles addObjectsFromArray:[indexCollection sectionTitles]];
//    [self.sectionTitles insertObject:@"历史" atIndex:0];
//    [self.sectionTitles insertObject:@"热门" atIndex:1];

    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    
    //tableView 会被分成27个section
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
    for (int i=0;i<dataArrary.count;i++)
    {
        NSString *cUser = dataArrary[i];
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        
        if (cUser) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:cUser];
            if (firstLetter.length>0) {
                NSInteger section = [indexCollection sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:cUser];
            }
            else{
                if (sortedArray.count>0) {
                    NSMutableArray *array = [sortedArray lastObject];
                    [array addObject:cUser];
                }
            }
        }
    }
    return sortedArray;
}


#pragma mark collectionView delegate ========================
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_historyCityArr.count > 0 && _hotCityArr.count > 0) {
        return 2;
    } else if (_historyCityArr.count >0 || _hotCityArr.count > 0){
        return 1;
    }
    return 0;
}

//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    if (_sectionGriditemArr.count > section) {
    //        if ([_sectionGriditemArr[section] count] < 4) {
    //            return [_sectionGriditemArr[section] count];
    //        }
    //        return 4;
    //    }
    if (_historyCityArr.count > 0 && _hotCityArr.count > 0) {
        if (section == 0) {
            return _historyCityArr.count;
        } else {
            return _hotCityArr.count;
        }
    } else if (_historyCityArr.count > 0){
        return _historyCityArr.count;
    } else if (_hotCityArr.count > 0){
        return _hotCityArr.count;
    }
    return 0;
}
// 刷新collection
-(void)refreshCollectionHistoryCity{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *searchArray = [ud objectForKey:@"SpAddressSearchText"];
    if (searchArray.count){
        _historyCityArr = [NSMutableArray arrayWithArray:searchArray];
    }
    [self.collectionView reloadData];
    
    CGRect cRect = self.collectionView.frame;
    cRect.size.height = [self getHeaderCollectionHeightWithSearchArr:_historyCityArr hotArr:_hotCityArr];
    self.collectionView.frame = cRect;
    
    //
    _headerLine.frame = CGRectMake(0,CGRectGetMaxY(self.collectionView.frame), ScreenW, 10);

    self.headerView.frame = CGRectMake(0, 0, ScreenW, [self getHeaderCollectionHeightWithSearchArr:_historyCityArr hotArr:_hotCityArr]  + 10);
    [_tableview reloadData];
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    STShoppingAddressCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //    cell.label.text=[NSString stringWithFormat:@"%ld",indexPath.section*100+indexPath.row];
    //    if (_sectionGriditemArr.count > indexPath.section) {
    //        NSMutableArray *indexArr = _sectionGriditemArr[indexPath.section];
    //        if (indexArr.count > indexPath.row) {
    //            VideoHomeGriditemModel *model = indexArr[indexPath.row];
    //            model.sectionIndexPath = indexPath.section;
    //            model.rowIndexPath = indexPath.row;
    //            [cell refreshViewWithModel:model];
    //        }
    //    }
//    [cell refreshCellWithModel:nil];
    if (_historyCityArr.count > 0 && _hotCityArr.count > 0) {
        if (indexPath.section == 0) {
            [cell testFefreshCellWithStr:_historyCityArr[indexPath.row]];
        } else {
            [cell testFefreshCellWithStr:_hotCityArr[indexPath.row]];
        }
    } else if (_historyCityArr.count > 0){
        [cell testFefreshCellWithStr:_historyCityArr[indexPath.row]];
    } else if (_hotCityArr.count > 0){
        [cell testFefreshCellWithStr:_hotCityArr[indexPath.row]];
    }
    
    return cell;
}

//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        STAddressHeaderCollectionView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if (_historyCityArr.count > 0 && _hotCityArr.count > 0) {
            if (indexPath.section == 0) {
                [headerView refreshHeaderViewWithText:@"历史访问城市"];
            } else {
                [headerView refreshHeaderViewWithText:@"国内热门城市"];
            }
        } else if (_historyCityArr.count > 0){
            [headerView refreshHeaderViewWithText:@"历史访问城市"];
        } else if (_hotCityArr.count > 0){
            [headerView refreshHeaderViewWithText:@"国内热门城市"];
        }
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

    return CGSizeMake(ScreenW, 40);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW - 35 - 40) / 3, 50);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(collectionViewCellSelectedWithIndexSection:indexRow:)]) {
//        [self.delegate collectionViewCellSelectedWithIndexSection:indexPath.section indexRow:indexPath.row];
//    }
}

- (CGFloat)getHeaderCollectionHeightWithSearchArr:(NSMutableArray *)searchArr hotArr:(NSMutableArray *)hotArr{
    
    if (searchArr.count > 0 && hotArr.count > 0) {
        CGFloat hotH = 0.0;
        if (hotArr.count / 3 >= 1) {
            if (hotArr.count % 3 == 0 && hotArr.count / 3 == 1) {
                hotH = 60 + 40;
            } else {
                hotH = 60 * (hotArr.count / 3 + 1) + 40;
            }
        } else {
            hotH = 60 + 40;
        }
        return hotH + 40 + 60;
    } else if (searchArr.count > 0){
        return 40 + 60;
    } else if (hotArr.count > 0){
        CGFloat hotH = 0.0;
        if (hotArr.count / 3 >= 1) {
            if (hotArr.count % 3 == 0 && hotArr.count / 3 == 1) {
                hotH = 60 + 40;
            } else {
                hotH = 60 * (hotArr.count / 3 + 1) + 40;
            }
        } else {
            hotH = 60 + 40;
        }
        return hotH;
    }
    return 0.0;
}

@end
