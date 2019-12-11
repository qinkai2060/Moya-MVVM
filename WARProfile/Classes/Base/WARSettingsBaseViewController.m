//
//  WARSettingsBaseViewController.m
//  Pods
//
//  Created by huange on 2017/8/4.
//
//

#import "WARSettingsBaseViewController.h"
#import "WARUIHelper.h"
@interface WARSettingsBaseViewController ()

@end

@implementation WARSettingsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataManager = [[WARSettingDataManager alloc] init];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//
//    self.navigationBarClear = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

#pragma mark - UI
- (void)initUI {
    
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    self.tableView.rowHeight = 80;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = BackgroundDefaultColor;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (WAR_IS_IPHONE_X) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view);
        }else {
            make.edges.equalTo(self.view);
        }
    }];
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settinsItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCellID"];
    if (!cell) {
        cell = [[WARSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCellID"];
    }
    WARSettingCellItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
    
    cell.showAccessoryView = YES;
    cell.descriptionText = item.titleString;
//    cell.imageView.image = item.image;
//    cell.textLabel.text = item.titleString;
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.textLabel.textColor = RGB(51, 51, 51);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

@end
