//
//  WARCategoriesForFaceViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import "WARCategoriesForFaceViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "UIImageView+WebCache.h"
#import "WARProgressHUD.h"
#import "WARActionSheet.h"

#import "WARNetwork.h"

#import "WARCategoriesForFaceCell.h"


#import "WARContactCategoryModel.h"

#define kNormalHeaderSectionHeight 50

#define kWARNoCategoriesForFaceCellID @"kWARNoCategoriesForFaceCellID"
#define kWARNormalCategoriesForFaceCellID @"kWARNormalCategoriesForFaceCellID"
#define kWARDifferentStateCategoriesForFaceCellID @"kWARDifferentStateCategoriesForFaceCellID"

@interface WARCategoriesForFaceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//已选择分组
@property (nonatomic, strong) NSMutableArray *selecedArr;
//可选择分组
@property (nonatomic, strong) NSMutableArray *canSeleArr;

@end

@implementation WARCategoriesForFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.view.backgroundColor = kColor(whiteColor);
    self.title = WARLocalizedString(@"分组");
    
    self.rightButtonText = WARLocalizedString(@"保存");
    

    for (WARContactCategoryModel*item in self.categories) {
        if ([item.faceId isEqualToString:self.faceModel.faceId]) {
            item.isSelected = YES;
            [self.selecedArr addObject:item];
        }
        else {
            item.isSelected = NO;
            [self.canSeleArr addObject:item];
        }
    }
    
    
    [self initUI];
    [self.tableView reloadData];
}

//本地临时保存
- (void)rightButtonAction {
    if (self.didSaveBlock) {
        self.didSaveBlock(self.selecedArr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (!self.selecedArr.count) {
            return 0;
        }
        return 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            WARCategoriesForFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARNormalCategoriesForFaceCellID];
            if (!cell) {
                cell = [[WARCategoriesForFaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARNormalCategoriesForFaceCellID];
            }
            cell.cellType = WARCategoriesForFaceCellTypeOfNormal;
            [cell configureCategories:self.selecedArr];
            
            
            WS(weakSelf);
            cell.normalDidSelectBlock = ^(NSInteger index) {
                
                if (!weakSelf.faceModel.defaults) {
                    weakSelf.valueChanged = YES;
                    
                    WARContactCategoryModel*item =weakSelf.selecedArr[index];
                    [weakSelf.selecedArr removeObjectAtIndex:index];
                    
                    item.isSelected = NO;
                    [weakSelf.canSeleArr addObject:item];
                    
                    [weakSelf.tableView reloadData];
                }else{
                    [WARProgressHUD showAutoMessage:WARLocalizedString(@"默认面具不能删除分组")];
                }

            };
            
            return cell;

    }else{
        WARCategoriesForFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARDifferentStateCategoriesForFaceCellID];
        if (!cell) {
            cell = [[WARCategoriesForFaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARDifferentStateCategoriesForFaceCellID];
        }
        cell.cellType = WARCategoriesForFaceCellTypeOfDifferentState;
        [cell configureCategories:self.canSeleArr];
        
        WS(weakSelf);
        cell.differentStateDidSelectBlock = ^(NSInteger index) {
            weakSelf.valueChanged = YES;
            WARContactCategoryModel*item =weakSelf.canSeleArr[index];
            item.isSelected = YES;
            
            item.faceId = weakSelf.faceModel.faceId;
            [weakSelf.selecedArr addObject:item];
            [weakSelf.canSeleArr removeObject:item];
            
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kNormalHeaderSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNormalHeaderSectionHeight)];
    headerV.backgroundColor = kColor(whiteColor);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, kScreenWidth, kNormalHeaderSectionHeight)];
    titleLabel.font = kFont(17);
    titleLabel.textColor = RGB(51, 51, 51);
    
    if (section == 0) {
        titleLabel.text = WARLocalizedString(@"已选择分组");
        [headerV addSubview: titleLabel];
        return headerV;
    }else{
        titleLabel.text = WARLocalizedString(@"可选择分组");
        [headerV addSubview: titleLabel];
        return headerV;
    }
    
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - getter methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _tableView.backgroundColor = kColor(whiteColor);
    }
    return _tableView;
}

- (NSMutableArray *)selecedArr{
    if (!_selecedArr) {
        _selecedArr = [NSMutableArray array];
    }
    return _selecedArr;
}

- (NSMutableArray *)canSeleArr{
    if (!_canSeleArr) {
        _canSeleArr = [NSMutableArray array];
    }
    return _canSeleArr;
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
