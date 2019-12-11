//
//  WARMoveGroupViewController.m
//  Pods
//
//  Created by 秦恺 on 2018/3/14.
//

#import "WARMoveGroupViewController.h"
#import "WARMoveGroupCell.h"
#import "UIColor+WARCategory.h"
#import "WARGroupView.h"
#import "WARCreatGroupViewController.h"

#import "WARDBUserManager.h"

#import "WARNetwork.h"

@interface WARMoveGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *grouparr;
@property (nonatomic,strong)WARMoveGroupViewHeaderV *headerV;
@property (nonatomic,assign)NSInteger selectRow;

@property (nonatomic, copy)NSArray *categories;
@end

@implementation WARMoveGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"移动分组");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.tableview];
    self.tableview.tableHeaderView = self.headerV;
    
    
    self.categories = [WARDBUserManager allContactCategories];
    
    for (int i = 0; i < self.categories.count; i++) {
        WARContactCategoryModel *item = self.categories[i];
        if ([item.categoryId isEqualToString:self.currentCategoryId]) {
            self.selectRow = i;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categories.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARMoveGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WARMoveGroupCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    WARContactCategoryModel *item = self.categories[indexPath.row];
    cell.groupView.groupNamelb.text = item.defaultCategoryShowName;
    
    if (self.selectRow == indexPath.row) {
        cell.groupView.selectGroupImg .hidden = NO;
    }else{
        cell.groupView.selectGroupImg .hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WARContactCategoryModel *item = self.categories[indexPath.row];
    [self selectCategoryWithCategoryId:item.categoryId index:indexPath.row];
}



- (void)selectCategoryWithCategoryId:(NSString *)categoryId index:(NSInteger)index{
    NSString* url = [NSString stringWithFormat:@"%@/contact-app/friend/category/move",kDomainNetworkUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (categoryId) {
        [dic setObject:categoryId forKey:@"currentCategoryId"];
    }
    
    if (self.accountId) {
        [dic setObject:self.accountId forKey:@"friendId"];
    }
    
    if (self.currentCategoryId) {
        [dic setObject:self.currentCategoryId forKey:@"originCategoryId"];
    }
    
    WS(weakSelf);
    [WARNetwork putDataFromURI:url params:dic completion:^(id responseObj, NSError *err) {
        if (!err) {
            
            weakSelf.selectRow = index;
            [weakSelf.tableview reloadData];
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"移动成功")];

        }else{
            [WARProgressHUD showAutoMessage:WARLocalizedString(responseObj[@"state"])];
        }
    }];
    
    
}



- (void)pushCreatVC:(UITapGestureRecognizer*)tap{
    WARCreatGroupViewController *creatVC = [[WARCreatGroupViewController alloc] init];
    [self.navigationController pushViewController:creatVC animated:YES];
}

#pragma mark - getter methods
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableview;
}


- (WARMoveGroupViewHeaderV *)headerV{
    if (!_headerV) {
        _headerV = [[WARMoveGroupViewHeaderV alloc] init];
        _headerV.frame = CGRectMake(0, 0, kScreenWidth, 60);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushCreatVC:)];
        [_headerV addGestureRecognizer:tap];
    }
    return _headerV;
}

- (NSArray *)categories{
    if (!_categories) {
        _categories = [NSArray array];
    }
    return _categories;
}

@end

@implementation WARMoveGroupViewHeaderV
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self addSubview:self.groupView];
        self.groupView.frame = CGRectMake(0, 0, kScreenWidth, 45);
    }
    return self;
}

- (WARGroupView *)groupView{
    if (!_groupView) {
        _groupView = [[WARGroupView alloc] initWithType:WARGroupViewTypeNewCreat];
    }
    return _groupView;
}
@end
