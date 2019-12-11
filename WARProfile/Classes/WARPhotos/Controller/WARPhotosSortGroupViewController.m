//
//  WARPhotosSortGroupViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/3.
//

#import "WARPhotosSortGroupViewController.h"
#import "WARPhotosGroupSortTableView.h"
#import "WARMacros.h"
#import "WARGroupModel.h"
#import "WARPhotosGroupSortCell.h"
#import "WARProfileNetWorkTool.h"
#import "WARNavgationCutsomBar.h"

@interface WARPhotosSortGroupViewController () <WARPhotosGroupSortTableViewDataSource,WARPhotosGroupSortTableViewDelegate>
@property (nonatomic,strong) WARPhotosGroupSortTableView *tableView;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WARNavgationCutsomBar *customBar;

@end

@implementation WARPhotosSortGroupViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.title = WARLocalizedString(@"相册排序");
    [self.view addSubview:self.customBar];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
}
- (void)setSortArray:(NSMutableArray *)sortArray {
    _sortArray = sortArray;
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sortArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57*kScale_iphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARPhotosGroupSortCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortCellID"];
    if (!cell) {
        cell = [[WARPhotosGroupSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SortCellID"];
    }
    WARGroupModel *model = self.sortArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (NSArray *)dataSourceArrayInTableView:(WARPhotosGroupSortTableView *)tableView{
    return self.sortArray;
}

- (void)tableView:(WARPhotosGroupSortTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (WARGroupModel *model in newDataSourceArray) {
        [array addObject:model.albumId];
    }
    
    [WARProfileNetWorkTool putSortGroupPhoto:array params:nil CallBack:^(id response) {
        
    } failer:^(id response) {
        
    }];
    self.sortArray = newDataSourceArray.mutableCopy;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSMutableArray *sourceArr = [NSMutableArray arrayWithArray:self.sortArray];
    
    [self.sortArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];

    //self.sortArray = sourceArr;


    

}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (WARPhotosGroupSortTableView *)tableView {
    if (!_tableView) {
        CGFloat navH =   WAR_IS_IPHONE_X ? 84:64;
        _tableView = [[WARPhotosGroupSortTableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//- (UITableView *)tableView {
//    if (!_tableView) {
//        CGFloat navH =   WAR_IS_IPHONE_X ? 84:64;
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH) style:UITableViewStylePlain];
//        [_tableView setEditing:YES];
//
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    return _tableView;
//}


- (WARNavgationCutsomBar *)customBar{
    if (!_customBar) {
        WS(weakself);
        _customBar = [[WARNavgationCutsomBar alloc] initWithTile:@"相册排序" rightTitle:@"" alpha:0 backgroundColor:[UIColor whiteColor] rightHandler:^{
            [weakself rightAction];
        } leftHandler:^{
            [weakself leftAtction];
        }];
        CGFloat height =    WAR_IS_IPHONE_X ? 84:64;
        _customBar.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _customBar;
}
- (void)rightAction{
    
}
- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
