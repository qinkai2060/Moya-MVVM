//
//  WARUserInfoCommonListViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import "WARUserInfoCommonListViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARProgressHUD.h"

#import "WARCommonListTableViewCell.h"

#import "WARUserProvinceModel.h"

#import "WARUserInfoCreateNewTagViewController.h"

#define kNormalCellHeight 44

#define kMaxSelectCount 15

#define kCityCellId @"kCityCellId"
#define kNormalCellId @"kNormalCellId"

@interface WARUserInfoCommonListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UserInfoCommonListViewControllerType  type;
@property (nonatomic, assign) UserInfoCommonListSelectType  selectType;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation WARUserInfoCommonListViewController

- (instancetype)initWithType:(UserInfoCommonListViewControllerType)type title:(NSString *)title selectType:(UserInfoCommonListSelectType)selectType{
    if (self = [super init]) {
        self.type = type;
        self.selectType = selectType;
        
        self.title = title;
        
        [self initUI];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)initUI{
    switch (self.type) {
        case 0:
            {
    
            }
            break;
        case 1:
            {
                self.title = WARLocalizedString(@"行业");
            }
            break;
        case 2:
            {
                self.title = WARLocalizedString(@"职业");

            }
            break;
        case 3:
            {
                self.title = WARLocalizedString(@"美食");

            }
            break;
        case 4:
            {
                self.title = WARLocalizedString(@"运动");
                
            }
            break;
        case 5:
            {
                self.title = WARLocalizedString(@"旅游");

            }
            break;
        default:
            break;
    }
    
    
//    if (self.selectType == UserInfoCommonListSelectTypeOfMulti) {
//        self.rightButtonText = WARLocalizedString(@"确定");
//    }
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}


- (void)rightButtonAction{
    if (self.didSureBlock) {
        self.didSureBlock(self.selectArr);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    if (self.type != UserInfoCommonListViewControllerTypeOfHometown) {
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObjectsFromArray:dataArr];
        [mArr insertObject:@"create" atIndex:0];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == UserInfoCommonListViewControllerTypeOfHometown) {
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCityCellId];
        }

        cell.type = WARCommonListTableViewCellTypeOfNormal;
        WARUserCityModel *model = self.dataArr[indexPath.row];
        [cell configureText:model.cityName];
        
        
        return cell;
    }else if (self.type == UserInfoCommonListViewControllerTypeOfIndustry){
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNormalCellId];
        }
        if (indexPath.row == 0) {
            cell.type = WARCommonListTableViewCellTypeOfCreate;
        }else{
            cell.type = WARCommonListTableViewCellTypeOfNormal;
            [cell configureText:self.dataArr[indexPath.row - 1]];
            [cell configureSelectStateWithArray:self.selectArr isMulti:NO];
        }
        
        return cell;
        
    }else if (self.type == UserInfoCommonListViewControllerTypeOfWork){
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNormalCellId];
        }
        if (indexPath.row == 0) {
            cell.type = WARCommonListTableViewCellTypeOfCreate;
        }else{
            cell.type = WARCommonListTableViewCellTypeOfNormal;
            [cell configureText:self.dataArr[indexPath.row - 1]];
            [cell configureSelectStateWithArray:self.selectArr isMulti:NO];
        }
        
        return cell;
        
    }else if (self.type == UserInfoCommonListViewControllerTypeOfFood){
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNormalCellId];
        }
        if (indexPath.row == 0) {
            cell.type = WARCommonListTableViewCellTypeOfCreate;
        }else{
            cell.type = WARCommonListTableViewCellTypeOfNormal;
            [cell configureText:self.dataArr[indexPath.row - 1]];
            [cell configureSelectStateWithArray:self.selectArr isMulti:YES];
        }
        
        return cell;
    }else if (self.type == UserInfoCommonListViewControllerTypeOfSports){
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNormalCellId];
        }
        if (indexPath.row == 0) {
            cell.type = WARCommonListTableViewCellTypeOfCreate;
        }else{
            cell.type = WARCommonListTableViewCellTypeOfNormal;
            [cell configureText:self.dataArr[indexPath.row - 1]];
            [cell configureSelectStateWithArray:self.selectArr isMulti:YES];
        }
        
        return cell;
    }else{
        WARCommonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        if (!cell) {
            cell = [[WARCommonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNormalCellId];
        }
        if (indexPath.row == 0) {
            cell.type = WARCommonListTableViewCellTypeOfCreate;
        }else{
            cell.type = WARCommonListTableViewCellTypeOfNormal;
            [cell configureText:self.dataArr[indexPath.row - 1]];
            [cell configureSelectStateWithArray:self.selectArr isMulti:YES];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == UserInfoCommonListViewControllerTypeOfHometown) {
        return kNormalCellHeight;
    }else{
        if (indexPath.row == 0) {
            return 50;
        }
        return kNormalCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case UserInfoCommonListViewControllerTypeOfHometown:
            {
                WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.rightImgV.hidden = !cell.rightImgV.hidden;
                WARUserCityModel *model = self.dataArr[indexPath.row];
                if (self.didSelectCityBlock) {
                    self.didSelectCityBlock(model);
                    [self.navigationController popViewControllerAnimated:NO];
                }

            }
            break;
        case UserInfoCommonListViewControllerTypeOfIndustry:
            {
                if (indexPath.row == 0) {
                    WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfIndustry];
                 
                    WS(weakSelf);
                    vc.addBlock = ^(NSString *tagStr) {
                        BOOL isExist = NO;
                        for (NSString *item in weakSelf.dataArr) {
                            if ([item isEqualToString:tagStr]) {
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {
                            if (self.didSelectItemBlock) {
                                self.didSelectItemBlock(tagStr);
                            }
                        }else{
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"标签已存在")];
                        }
                        

                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.rightImgV.hidden = !cell.rightImgV.hidden;
                    
                    if (self.didSelectItemBlock) {
                        self.didSelectItemBlock(self.dataArr[indexPath.row - 1]);
                        [self.navigationController popViewControllerAnimated:YES];
                    }

                }
            }
            break;
        case UserInfoCommonListViewControllerTypeOfWork:
            {
                if (indexPath.row == 0) {
                    WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfWork];
                    
                    WS(weakSelf);
                    vc.addBlock = ^(NSString *tagStr) {
                        BOOL isExist = NO;
                        for (NSString *item in weakSelf.dataArr) {
                            if ([item isEqualToString:tagStr]) {
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {
                            if (self.didSelectItemBlock) {
                                self.didSelectItemBlock(tagStr);
                            }
                        }else{
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"标签已存在")];
                        }
                        
                        
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.rightImgV.hidden = !cell.rightImgV.hidden;
                    
                    if (self.didSelectItemBlock) {
                        self.didSelectItemBlock(self.dataArr[indexPath.row - 1]);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }
            }
            break;
        case UserInfoCommonListViewControllerTypeOfFood:
            {
                if (indexPath.row == 0) {
                    WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfFood];
                    
                    WS(weakSelf);
                    vc.addBlock = ^(NSString *tagStr) {
                        BOOL isExist = NO;
                        for (NSString *item in weakSelf.dataArr) {
                            if ([item isEqualToString:tagStr]) {
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {
                            NSMutableArray *mArr = [NSMutableArray array];
                            [mArr addObjectsFromArray:weakSelf.dataArr];
                            [mArr insertObject:tagStr atIndex:0];
                            weakSelf.dataArr = [NSArray arrayWithArray:mArr];
                            if (self.selectArr.count >= 15) {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                return;
                            }
                            [weakSelf.selectArr addObject:tagStr];
                            if (self.didSureBlock) {
                                self.didSureBlock(self.selectArr);
                            }
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }else{
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"标签已存在")];
                        }
                        
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    NSString *item = self.dataArr[indexPath.row - 1];
                    
                    if (!cell.rightImgV.hidden) {
                        if ([self.selectArr containsObject:item]) {
                            [self.selectArr removeObject:item];
                        }
                    }else{
                        if (self.selectArr.count >= 15) {
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多选择15个标签")];
                            return;
                        }
                        [self.selectArr addObject:item];
                    }
                    cell.rightImgV.hidden = !cell.rightImgV.hidden;

                    if (self.didSureBlock) {
                        self.didSureBlock(self.selectArr);
                    }
                }
            }
            break;
        case UserInfoCommonListViewControllerTypeOfSports:
            {
                if (indexPath.row == 0) {
                    WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfSports];
                    
                    WS(weakSelf);
                    vc.addBlock = ^(NSString *tagStr) {
                        BOOL isExist = NO;
                        for (NSString *item in weakSelf.dataArr) {
                            if ([item isEqualToString:tagStr]) {
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {
                            NSMutableArray *mArr = [NSMutableArray array];
                            [mArr addObjectsFromArray:weakSelf.dataArr];
                            [mArr insertObject:tagStr atIndex:0];
                            weakSelf.dataArr = [NSArray arrayWithArray:mArr];
                            if (self.selectArr.count >= 15) {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                return;
                            }
                            [weakSelf.selectArr addObject:tagStr];
                            if (self.didSureBlock) {
                                self.didSureBlock(self.selectArr);
                            }
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }else{
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"标签已存在")];
                        }
                        
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    NSString *item = self.dataArr[indexPath.row - 1];
                    
                    if (!cell.rightImgV.hidden) {
                        if ([self.selectArr containsObject:item]) {
                            [self.selectArr removeObject:item];
                        }
                    }else{
                        if (self.selectArr.count >= 15) {
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多选择15个标签")];
                            return;
                        }
                        [self.selectArr addObject:item];
                    }
                    cell.rightImgV.hidden = !cell.rightImgV.hidden;
                    
                    if (self.didSureBlock) {
                        self.didSureBlock(self.selectArr);
                    }
                }
            }
            break;
        case UserInfoCommonListViewControllerTypeOfTravel:
            {
                if (indexPath.row == 0) {
                    WARUserInfoCreateNewTagViewController *vc = [[WARUserInfoCreateNewTagViewController alloc]initWithType:UserInfoCreateNewTagViewControllerTypeOfTravel];
                    
                    WS(weakSelf);
                    vc.addBlock = ^(NSString *tagStr) {
                        BOOL isExist = NO;
                        for (NSString *item in weakSelf.dataArr) {
                            if ([item isEqualToString:tagStr]) {
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {
                            NSMutableArray *mArr = [NSMutableArray array];
                            [mArr addObjectsFromArray:weakSelf.dataArr];
                            [mArr insertObject:tagStr atIndex:0];
                            weakSelf.dataArr = [NSArray arrayWithArray:mArr];
                            if (self.selectArr.count >= 15) {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                return;
                            }
                            [weakSelf.selectArr addObject:tagStr];
                            if (self.didSureBlock) {
                                self.didSureBlock(self.selectArr);
                            }
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }else{
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"标签已存在")];
                        }
                        
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    WARCommonListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    NSString *item = self.dataArr[indexPath.row - 1];
                    
                    if (!cell.rightImgV.hidden) {
                        if ([self.selectArr containsObject:item]) {
                            [self.selectArr removeObject:item];
                        }
                    }else{
                        if (self.selectArr.count >= 15) {
                            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多选择15个标签")];
                            return;
                        }
                        [self.selectArr addObject:item];
                    }
                    cell.rightImgV.hidden = !cell.rightImgV.hidden;
                    
                    if (self.didSureBlock) {
                        self.didSureBlock(self.selectArr);
                    }
                }
            }
            break;
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray arrayWithArray:_lastSelectArray];
    }
    return _selectArr;
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
