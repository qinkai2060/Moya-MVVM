//
//  WARGroupMangerViewController.m
//  Pods
//
//  Created by 秦恺 on 2018/3/14.
//

#import "WARGroupMangerViewController.h"
#import "WARTableView.h"
#import "WARGroupMangerCell.h"
#import "WARDBUserManager.h"
#import "WARContactCategoryModel.h"
#import "UIColor+WARCategory.h"
#import "WARMacros.h"
#import "WARRequestCareGroupModel.h"
#import "WARNetwork.h"
#import "WARCreatGroupViewController.h"
@interface WARGroupMangerViewController ()<WARTableViewDelegate,WARTableViewDataSource,WARGroupMangerCellDelegate>
@property(nonatomic,strong)WARTableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *orginDataSource;
@property(nonatomic,strong)NSMutableArray *deleteDataSource;
@property(nonatomic,assign)NSInteger selectRow;
@property(nonatomic,assign)BOOL isOriginal;
@end

@implementation WARGroupMangerViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.orginDataSource.count != [WARDBUserManager allContactCategories].count ) {
        
        [self.orginDataSource addObjectsFromArray:self.deleteDataSource];
    }
    NSString* url = [NSString stringWithFormat:@"%@/contact-app/category",kDomainNetworkUrl];
    
 
    [WARNetwork putDataFromURI:url params:@{@"orginDataSource":self.orginDataSource} completion:^(id responseObj, NSError *err) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"分组管理");
    self.dataSource = [WARDBUserManager allContactCategories];
    [self.orginDataSource addObjectsFromArray: [WARRequestCareGroupModel prase:self.dataSource]];
    self.selectRow = -1;
    [self.view addSubview:self.tableview];

}
- (NSMutableArray *)orginDataSource{
    if (!_orginDataSource) {
        _orginDataSource = [[NSMutableArray alloc] init];
    }
    return _orginDataSource;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)deleteDataSource{
    if (!_deleteDataSource) {
        _deleteDataSource = [[NSMutableArray alloc] init];
    }
    return _deleteDataSource;
}
- (WARTableView *)tableview{
    if (!_tableview) {
        _tableview = [[WARTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WARContactCategoryModel *model = self.dataSource[indexPath.row];
    WARGroupMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];

    if (!cell) {
        cell = [[WARGroupMangerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model];

    return cell;
}
- (NSArray *)dataSourceArrayInTableView:(WARTableView *)tableView{
    return self.dataSource;
}
- (void)tableView:(WARTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray
{
    self.orginDataSource = [WARRequestCareGroupModel prase:newDataSourceArray.mutableCopy];
    self.dataSource = newDataSourceArray.mutableCopy;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WARGroupView *groupView = [[WARGroupView alloc] initWithType:WARGroupViewTypeNewCreat];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushCreatVC:)];
    [groupView addGestureRecognizer:tap];
    return groupView;
}
- (void)pushCreatVC:(UITapGestureRecognizer*)tap{
    WARCreatGroupViewController *creatVC = [[WARCreatGroupViewController alloc] init];
    [self.navigationController pushViewController:creatVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    NSMutableDictionary    *reqmodel = self.orginDataSource[indexPath.row];
    [reqmodel setObject:@"DELETE" forKey:@"operateType"];
    [self.orginDataSource replaceObjectAtIndex:indexPath.row withObject:reqmodel];
    [self.deleteDataSource addObject:reqmodel];
    [self.dataSource removeObjectAtIndex:indexPath.row];

    [self.tableview reloadData];
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (void)saveEditingGroupMangerCell:(WARGroupMangerCell *)cell withModel:(WARContactCategoryModel *)model withOriginal:(BOOL)isOriginal{
    NSIndexPath *index =[self.tableview indexPathForCell:cell];
    [self.dataSource replaceObjectAtIndex:index.row withObject:model];
    if (!isOriginal) {
        NSMutableDictionary    *reqmodel =  self.orginDataSource[index.row];
        [reqmodel setObject:@"MODIFY" forKey:@"operateType"];
    }
    self.isOriginal = isOriginal;
    [self.tableview reloadData];
    
}
@end
