//
//  WARUserProvinceViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserProvinceViewController.h"


#import "WARMacros.h"
#import "Masonry.h"

#import "WARUserInfoRightImgVTableViewCell.h"


#import "WARUserProvinceModel.h"
#import "WARUserInfoLocalFileManager.h"

#import "WARUserInfoCommonListViewController.h"


#define kNormalCellHeight 44


#define kProviceCellId @"kProviceCellId"


@interface WARUserProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSArray *dataArr;
@end

@implementation WARUserProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = WARLocalizedString(@"家乡");
    
    [self initUI];
    self.dataArr = [WARUserInfoLocalFileManager allHometowns];
    [self.tableView reloadData];
}


- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARUserInfoRightImgVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProviceCellId];
    if (!cell) {
        cell = [[WARUserInfoRightImgVTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProviceCellId];
    }
    WARUserProvinceModel *provinceM = self.dataArr[indexPath.row];
    [cell configureContentStr:provinceM.provinceName];
    cell.rightMoreImgV.hidden = provinceM.citys.count ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WARUserProvinceModel *provinceM = self.dataArr[indexPath.row];
    if (provinceM.citys.count) {
        WARUserInfoCommonListViewController *vc = [[WARUserInfoCommonListViewController alloc]initWithType:UserInfoCommonListViewControllerTypeOfHometown title:provinceM.provinceName selectType:UserInfoCommonListSelectTypeOfSignal];
        vc.dataArr = provinceM.citys;
        WS(weakSelf);
        vc.didSelectCityBlock = ^(WARUserCityModel *model) {
            if (weakSelf.userHometownBlock) {
                weakSelf.userHometownBlock(provinceM, model);
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        if (self.userHometownBlock) {
            self.userHometownBlock(provinceM, nil);
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}


#pragma mark - getther methods

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = COLOR_WORD_GRAY_E;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = kNormalCellHeight;
    }
    return _tableView;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
