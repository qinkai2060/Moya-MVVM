//
//  SpTypesSearchMainView.m
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchMainView.h"

@interface SpTypesSearchMainView ()<UITableViewDelegate,UITableViewDataSource,searchFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) NSMutableArray *searchDataSourceArr;

@property (nonatomic, assign) BOOL isLanXiangSearch;

@end

@implementation SpTypesSearchMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isLanXiangSearch = NO;
        self.dataSourceArr = [NSMutableArray arrayWithCapacity:1];
        self.searchDataSourceArr = [NSMutableArray arrayWithCapacity:1];
        [self createView];
    }
    return self;
}
-(void)createView{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *searchArray = [ud objectForKey:@"SpTypesSearchText"];
    if (searchArray.count){
        self.dataSourceArr = [NSMutableArray arrayWithArray:searchArray];
    }
    
    //
    self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44) isAddOneBtn:YES addBtnImageName:@"" addBtnTitle:@"取消" searchKeyStr:@"" canEidt:YES placeholderStr:@"" isHaveBack:NO isHaveBottomLine:YES];

    [self addSubview:self.searchView];
    
    __weak  typeof( self)weakSelf=self;
    self.searchView.searchRightBtnClickBlock = ^(UIButton * _Nonnull btn) {
        NSLog(@"取消按钮");
        if ([weakSelf.delegate respondsToSelector:@selector(lianXiangSearchCancelBtnClick:)]) {
            [weakSelf.delegate lianXiangSearchCancelBtnClick:btn];
        }
    };
    
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.searchView.frame)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#e5e5e5" alpha:1];

    [self addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isLanXiangSearch) {
        if (_searchDataSourceArr.count > 8) {
            return 8;
        }
        return _searchDataSourceArr.count;
    }
    if (_dataSourceArr.count > 7) {
        return 7;
    }
    return _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = RGBACOLOR(102, 102, 102, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.isLanXiangSearch) {
        if (_searchDataSourceArr.count > indexPath.row) {
            cell.textLabel.text = _searchDataSourceArr[indexPath.row];
        }
    } else {
        if (_dataSourceArr.count > indexPath.row) {
            cell.textLabel.text = _dataSourceArr[indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLanXiangSearch) {
        if (_searchDataSourceArr.count > indexPath.row) {
            if ([self.delegate respondsToSelector:@selector(tableViewDidSelectedWithIndexRow:searchText:)]) {
                [self.delegate tableViewDidSelectedWithIndexRow:indexPath.row searchText:_searchDataSourceArr[indexPath.row]];
            }
        }
    } else {
        if (_dataSourceArr.count > indexPath.row) {
            if ([self.delegate respondsToSelector:@selector(tableViewDidSelectedWithIndexRow:searchText:)]) {
                [self.delegate tableViewDidSelectedWithIndexRow:indexPath.row searchText:_dataSourceArr[indexPath.row]];
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   //
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    hView.backgroundColor = [UIColor whiteColor];
    
    //
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 500, hView.frame.size.height)];
    titleLab.font = [UIFont boldSystemFontOfSize:15.0];
    titleLab.textColor = RGBACOLOR(51, 51, 51, 1);
    titleLab.text = @"历史搜索";
    [hView addSubview:titleLab];
    
    return hView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, ScreenW - 20, 1)];
    lineLab.backgroundColor = RGBACOLOR(229, 229, 229, 1);
    [footerView addSubview:lineLab];
    
    self.footView = [[SpTypesSearchFooterView alloc] initWithFrame:CGRectMake(0, 15, footerView.frame.size.width, 40)];
    self.footView.delegate = self;
    [footerView addSubview:self.footView];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isLanXiangSearch) {
        return 0.0;
    }
    if (_dataSourceArr.count == 0) {
        return 0.0;
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isLanXiangSearch) {
        return 0.0;
    }
    if (_dataSourceArr.count == 0) {
        return 0.0;
    }
    return 70.0;
}

// 联想搜索的数据刷新
- (void)refreshTableViewWithDataSource:(NSMutableArray *)dataArr{
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }

    if (_searchDataSourceArr.count > 0) {
        [_searchDataSourceArr removeAllObjects];
    }
    self.isLanXiangSearch = YES;
    _searchDataSourceArr = dataArr;
    [_tableView reloadData];
}

// 历史搜索的数据刷新
- (void)refreshViewWithArr:(NSMutableArray *)muArr{
    if (_searchDataSourceArr.count > 0) {
        [_searchDataSourceArr removeAllObjects];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *searchArray = [ud objectForKey:@"SpTypesSearchText"];
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    self.isLanXiangSearch = NO;

    if (searchArray.count){
        self.dataSourceArr = [NSMutableArray arrayWithArray:searchArray];
    }

    [_tableView reloadData];
}

#pragma mark 清空历史搜索 delete方法
- (void)deleteSearchFooterViewWithBtn:(UIButton *)btn{
    [self.searchView.searchTextField resignFirstResponder];
    self.searchView.searchTextField.text = @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"SpTypesSearchText"];
    
    [_dataSourceArr removeAllObjects];
    [_tableView reloadData];
}
@end
