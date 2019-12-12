//
//  WARCreatGroupViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/13.
//

#import "WARCreatGroupViewController.h"
#import "WARCreatMaskCell.h"
#import "WARCreatGroupCell.h"
#import "WARGroupView.h"
#import "UIColor+WARCategory.h"

#import "WARNetwork.h"

#import "WARDBUserManager.h"
#import "YYModel.h"

@interface WARCreatGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *creatGroupArr;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)WARGroupView *footerV;

@property (nonatomic, copy)NSString *categoryName;
@end

@implementation WARCreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"新建分组");
    [self initData];
    [self.view addSubview:self.tableview];
    self.tableview.tableFooterView = self.footerV;
    self.view.backgroundColor = [UIColor whiteColor];
     self.tableview.backgroundColor = [UIColor whiteColor];
    [self.tableview registerClass:[WARCreatMaskCell class] forCellReuseIdentifier:@"maskCell"];
    [self.tableview registerClass:[WARCreatGroupCell class] forCellReuseIdentifier:@"groupCell"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    
}

- (void)initData{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:WARLocalizedString(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
}

- (void)saveClick{
    if (self.categoryName.length) {
        NSString* url = [NSString stringWithFormat:@"%@/contact-app/category",kDomainNetworkUrl];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.categoryName forKey:@"name"];

        [WARNetwork postDataFromURI:url params:dic completion:^(id responseObj, NSError *err) {
            if (!err) {
            
                WARContactCategoryModel *item = [WARContactCategoryModel yy_modelWithJSON:responseObj];
                [WARDBUserManager updateOrCreateContactCategoryWithCategoryModel:item];
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"创建成功")];

            }else{
                [WARProgressHUD showAutoMessage:WARLocalizedString(responseObj[@"state"])];
            }
        }];
    }else{
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"请填写分组名称")];
    }

}


- (void)pushCreatVC:(UITapGestureRecognizer*)tap{
    
}


#pragma mark - tableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WARCreatGroupCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        [Cell.groupView.textfield becomeFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputCategoryName) name:UITextFieldTextDidChangeNotification object:nil];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }else{
        WARCreatMaskCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"maskCell" forIndexPath:indexPath];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, kScreenWidth-15, 12)];
    l.font = [UIFont systemFontOfSize:12];
    l.textColor = [UIColor colorWithHexString:@"999999"];
    [v addSubview:l];
    if(section==0){
        l.text = WARLocalizedString(@"分组名称");
    }else{
        l.text = WARLocalizedString(@"选中新分组的面具");
    }
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (void)inputCategoryName{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    WARCreatGroupCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    self.categoryName = cell.groupView.textfield.text;
}


#pragma mark - getther methods
- (NSMutableArray *)creatGroupArr{
    if (!_creatGroupArr) {
        _creatGroupArr = [NSMutableArray array];
    }
    return _creatGroupArr;
}
- (UITableView *)tableview{
    if (!_tableview){
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (WARGroupView *)footerV{
    if (!_footerV) {
        _footerV = [[WARGroupView alloc] initWithType:WARGroupViewTypeNewCreat];
        _footerV.groupNamelb.text = WARLocalizedString(@"新建面具");
        _footerV.groupNamelb.textColor = [UIColor colorWithHexString:@"999999"];
        _footerV.frame = CGRectMake(0, 0, kScreenWidth, 45);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushCreatVC:)];
        [_footerV addGestureRecognizer:tap];
    }
    return _footerV;
}
@end
