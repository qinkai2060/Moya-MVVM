//
//  WARContactsCategoryViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARContactsCategoryViewController.h"

#import "WARImagePickerController.h"
#import "WARCameraViewController.h"

#import "WARFaceMaskView.h"
#import "WARSelecFaceMaskView.h"

#import "WARFaceMaskTableViewCell.h"
#import "WARCategoryMemberTableViewCell.h"


#import "WARCategoryViewModel.h"
#import "WARDBUserManager.h"

#define kNormalHeaderSectionHeight 50


#define kMemberKey @"kMemberKey"
#define kSelectKey @"kSelectKey"


#define kWARFaceMaskTableViewCellID @"kWARFaceMaskTableViewCellID"
#define kWARNoFaceMaskTableViewCellID @"kWARNoFaceMaskTableViewCellID"
#define kWARCategoryMemberTableViewCellID @"kWARCategoryMemberTableViewCellID"


@interface WARContactsCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) WARFaceMaskView *faceV;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *allCategories;
@property (nonatomic, strong) WARFaceMaskModel *currentFaceModel;
@property (nonatomic, strong) WARContactCategoryModel *currentCategoryModel;
@property (nonatomic, strong) WARCategoryViewModel *categoryViewModel;

// 监听分组数据库变化
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (nonatomic, assign) BOOL  isFirst;

//成员变化
@property (nonatomic, copy) NSArray *addArr;
@property (nonatomic, copy) NSArray *removeArr;


@end

@implementation WARContactsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColor(whiteColor);
    self.title = WARLocalizedString(@"分组管理");
    self.rightButtonText = WARLocalizedString(@"保存");
    
    
    [self bindViewModel];
    [self.categoryViewModel.getContactsForCategoryCommand execute:nil];
    
    self.isFirst = YES;
    WS(weakSelf);
    self.notification = [[WARDBUserManager allContactCategoriesResults] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
        if (error) {
            NDLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        if (weakSelf.isFirst) {
            weakSelf.allCategories = [WARDBUserManager canSelectCategories];
            weakSelf.faceV.dataArr = weakSelf.allCategories;
            [weakSelf scrollFaceWithIndex:0];
        }
        
        if (changes.insertions.count) {
            weakSelf.allCategories = [WARDBUserManager canSelectCategories];
            weakSelf.faceV.dataArr = weakSelf.allCategories;
            NSInteger index = weakSelf.allCategories.count-1;
            [weakSelf.faceV autoScrollToIndex:index];
            [weakSelf scrollFaceWithIndex:index];
        }
        
        if (changes.deletions.count){
            weakSelf.allCategories = [WARDBUserManager canSelectCategories];
            weakSelf.faceV.dataArr = weakSelf.allCategories;
            NSInteger index = weakSelf.allCategories.count-1;
            [weakSelf.faceV autoScrollToIndex:index];
            [weakSelf scrollFaceWithIndex:index];
        }
        
        if (changes.modifications.count) {
            weakSelf.allCategories = [WARDBUserManager canSelectCategories];
            weakSelf.faceV.dataArr = weakSelf.allCategories;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.isFirst = NO;

    }];
    
//    self.allCategories = [WARDBUserManager canSelectCategories];
//    self.faceV.dataArr = self.allCategories;
//    self.currentCategoryModel = self.allCategories.firstObject;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.valueChanged = NO;
}

- (void)bindViewModel{
    @weakify(self)
    [RACObserve(self, categoryViewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
    }];


    [self.categoryViewModel.getContactsForCategoryCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
            
                [self scrollFaceWithIndex:0];
                [self.tableView reloadData];
            }else{
                
            }
        }];
    }];
    
    
    [self.categoryViewModel.updateCategoryCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
            }else{
                
            }
        }];
    }];
    
    
    [self.categoryViewModel.updateCategoryNameCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"修改成功")];
            }else{
                
            }
        }];
    }];
    
    [self.categoryViewModel.createCategoryCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {

            }else{
                
            }
        }];
    }];
    
    
    
    [self.categoryViewModel.deleteCategoryCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(NSError *error) {
            @strongify(self);
            if (!error) {
                
            }else{
                
            }
        }];
    }];
    
    
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    CGFloat headerHeight = [self.faceV systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect headerFrame = self.faceV.frame;
    headerFrame.size.height = headerHeight;
    self.faceV.frame = headerFrame;
    
    self.tableView.tableHeaderView = self.faceV;
    
    WS(weakSelf);
    self.faceV.didClickAddNewFaceBlock = ^{
        [weakSelf addNewFace];
    };
    
    
    self.faceV.didScrollItemBlock = ^(NSInteger itemIndex) {
        [weakSelf scrollFaceWithIndex:itemIndex];
    };
    
    self.faceV.didLongPreCellBlcok = ^(NSIndexPath *indexPath) {
        [weakSelf deleteFaceWithIndex:indexPath.row];
    };
    
    self.faceV.didClickEditFaceBlock = ^{
        [weakSelf editCategoryName];
    };
    
}

// 新增
- (void)addNewFace{
    self.valueChanged = NO;
    
    @weakify(self);
    [[[WARAlertView alloc] initWithTextFieldsAndTitle:WARLocalizedString(@"新建分组")
                                              message:nil
                                   numberOfTextFields:1
                               textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {
                                   textField.placeholder = WARLocalizedString(@"分组名称");
                               }
                                         buttonTitles:@[@"好的"]
                                    cancelButtonTitle:WARLocalizedString(@"取消")
                               destructiveButtonTitle:nil
                                        actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                            @strongify(self);
                                            UITextField *texField = [[alertView textFieldsArray] objectAtIndex:index];
                                            NSString *name = texField.text;
                                            if (name.length) {
                                                [self.categoryViewModel.createCategoryCommand execute:name];
                                            }
                                            
                                        }
                                        cancelHandler:^(LGAlertView * _Nonnull alertView) {}
                                   destructiveHandler:^(LGAlertView * _Nonnull alertView) {}]
     showAnimated:YES
     completionHandler:nil];
    
}

// 滑动面具
- (void)scrollFaceWithIndex:(NSInteger)index{
    
    if (self.valueChanged) {
        [WARAlertView showWithTitle:nil
                            Message:WARLocalizedString(@"保存本次编辑？")
                        cancelTitle:WARLocalizedString(@"不保存")
                        actionTitle:WARLocalizedString(@"保存")
                      cancelHandler:^(LGAlertView * _Nonnull alertView) {
                          [self.navigationController popViewControllerAnimated:YES];
                      } actionHandler:^(LGAlertView * _Nonnull alertView) {
                          [self rightButtonAction];

                      }];
    }else {
        if (index < self.allCategories.count) {
            
           self.currentCategoryModel = self.allCategories[index];
            
            BOOL isFound = NO;
            for (WARFaceMaskModel *item in self.faces) {
                if ([item.faceId isEqualToString:self.currentCategoryModel.faceId]) {
                    self.currentFaceModel = item;
                    isFound = YES;
                    break;
                }
            }
            
            if (!isFound) {
                self.currentFaceModel = nil;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
    
    
}

// 保存当前面具
- (void)rightButtonAction {
    if (self.currentCategoryModel.canSelect) {
        self.valueChanged = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.addArr.count) {
            [dic setObject:self.addArr forKey:@"addCategoryUsers"];
        }
        
        if (self.removeArr.count) {
            [dic setObject:self.removeArr forKey:@"defaultCategoryUsers"];
        }
        
        [dic setObject:self.currentCategoryModel.categoryId forKey:@"categoryId"];
        [dic setObject:self.currentCategoryModel.faceId forKey:@"faceId"];
        [self.categoryViewModel.updateCategoryCommand execute:dic];
    }else{
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"此分组不能修改")];
    }

}

// 删除面具
- (void)deleteFaceWithIndex:(NSInteger)index{
    if (index < self.allCategories.count) {
        WARContactCategoryModel *model = self.allCategories[index];

        if (model.defaultCategory) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"此分组不能删除")];
        }else{
            WS(weakSelf);
            [WARActionSheet actionSheetWithTitle:WARLocalizedString(@"该分组将被删除，分组下的关注将被移至[关注]分组")
                                        subTitle:nil
                                destructiveTitle:nil
                                    buttonTitles:@[WARLocalizedString(@"确认删除")]
                                     cancelTitle:WARLocalizedString(@"取消")
                              destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                                  
                              } actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                  [weakSelf.categoryViewModel.deleteCategoryCommand execute:model.categoryId];

                              } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                                  
                              } completionHandler:^{
                                  
                              }];

        }

    }
    
}

// 修改分组名称
- (void)editCategoryName{
    if (self.currentCategoryModel.canChangeName) {
        @weakify(self);
        [[[WARAlertView alloc] initWithTextFieldsAndTitle:WARLocalizedString(@"编辑分组名称")
                                                  message:nil
                                       numberOfTextFields:1
                                   textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {
                                       textField.placeholder = WARLocalizedString(@"分组名称");
                                   }
                                             buttonTitles:@[@"确定"]
                                        cancelButtonTitle:WARLocalizedString(@"取消")
                                   destructiveButtonTitle:nil
                                            actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                                @strongify(self);
                                                UITextField *texField = [[alertView textFieldsArray] objectAtIndex:index];
                                                NSString *name = texField.text;
                                                if (name.length) {
                                                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                                    [dic setObject:self.currentCategoryModel.categoryId forKey:@"categoryId"];
                                                    [dic setObject:name forKey:@"categoryName"];
                                                    [self.categoryViewModel.updateCategoryNameCommand execute:dic];
                                                }
                                                
                                            }
                                            cancelHandler:^(LGAlertView * _Nonnull alertView) {}
                                       destructiveHandler:^(LGAlertView * _Nonnull alertView) {}]
         showAnimated:YES
         completionHandler:nil];
    }else{
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"默认分组不能修改名称")];
    }
    

}


#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (self.currentFaceModel.faceId.length) {
            WARFaceMaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARFaceMaskTableViewCellID];
            if (!cell) {
                cell = [[WARFaceMaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARFaceMaskTableViewCellID];
            }
            
            [cell configureFaceMaskModel:self.currentFaceModel];
            
            return cell;
            
        }else{
            WARNoFaceMaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARNoFaceMaskTableViewCellID];
            if (!cell) {
                cell = [[WARNoFaceMaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARNoFaceMaskTableViewCellID];
            }
            
            return cell;
        }
    }else{
        WARCategoryMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWARCategoryMemberTableViewCellID];
        if (!cell) {
            cell = [[WARCategoryMemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWARCategoryMemberTableViewCellID];
        }
        
        [cell configureMembers:self.categoryViewModel.members categoryModel:self.currentCategoryModel];
        
        WS(weakSelf);
        cell.didEditBlock = ^(NSDictionary *dic, NSArray *addArr, NSArray *removeArr) {
            if (weakSelf.currentCategoryModel.defaultCategory) {
                [WARProgressHUD showAutoMessage:WARLocalizedString(@"不能修改默认分组成员")];
            }else{
                if (addArr.count || removeArr.count) {
                    weakSelf.valueChanged = YES;
                }
                
                
                NSArray *topArr = dic[kMemberKey];
                NSArray *bottomArr = dic[kSelectKey];
                
                NSMutableArray *mArr = [NSMutableArray array];
                [mArr addObjectsFromArray:topArr];
                [mArr addObjectsFromArray:bottomArr];
                
                weakSelf.categoryViewModel.members = mArr;
                [weakSelf.tableView reloadData];
                
                weakSelf.addArr = addArr;
                weakSelf.removeArr = removeArr;
            }
            
        };

        

        cell.didFinishBlock = ^(NSArray *addArr, NSArray *removeArr) {

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (addArr.count) {
                [dic setObject:addArr forKey:@"addCategoryUsers"];
            }
            
            if (removeArr.count) {
                [dic setObject:removeArr forKey:@"defaultCategoryUsers"];
            }
            
            [dic setObject:weakSelf.currentCategoryModel.categoryId forKey:@"categoryId"];
            [dic setObject:weakSelf.currentCategoryModel.faceId forKey:@"faceId"];

            [weakSelf.categoryViewModel.updateCategoryCommand execute:dic];
            weakSelf.valueChanged = NO;
            
        };
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    
    return [self.categoryViewModel heightForMembersWithCategoryId:self.currentCategoryModel.categoryId];
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
        titleLabel.text = WARLocalizedString(@"选择分组展示的形象");
        [headerV addSubview: titleLabel];
        return headerV;
    } else {
        titleLabel.text = WARLocalizedString(@"分组成员管理");
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {

        WARSelecFaceMaskView *view = [[WARSelecFaceMaskView alloc] initWithFrame:self.view.bounds];
        view.groupArr = self.faces;
        
        for (int i = 0; i < self.faces.count; i++) {
            WARFaceMaskModel *model = self.faces[i];
            if ([self.currentCategoryModel.faceId isEqualToString:model.faceId]) {
                view.isSelectRow = YES;
                view.selectRow = i;
                break;
            }else{
                view.isSelectRow = NO;
            }
        }

        @weakify(self)
        view.sureBlock = ^(NSString *faceId) {
            @strongify(self)
            WARContactCategoryModel *model = [[WARContactCategoryModel alloc]init];
            model.categoryId = self.currentCategoryModel.categoryId;
            model.faceId = faceId;
        
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.currentCategoryModel.categoryId forKey:@"categoryId"];
            [dic setObject:faceId forKey:@"faceId"];
            [self.categoryViewModel.updateCategoryCommand execute:dic];
            
            self.currentFaceModel.faceId = faceId;

            // update View
            BOOL isFound = NO;
            for (WARFaceMaskModel *item in self.faces) {
                if ([item.faceId isEqualToString:self.currentCategoryModel.faceId]) {
                    self.currentFaceModel = item;
                    isFound = YES;
                    break;
                }
            }
            
            if (!isFound) {
                self.currentFaceModel = nil;
            }
            
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
        };

        [UIView animateWithDuration:0.5 animations:^{
            [self.view addSubview:view];
        }];
    }
}



#pragma mark - getter methods
- (WARFaceMaskView *)faceV{
    if (!_faceV) {
        _faceV = [[WARFaceMaskView alloc]init];
        _faceV.type = WARFaceMaskViewTypeOfContactCategory;
    }
    return _faceV;
}

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

- (WARCategoryViewModel *)categoryViewModel{
    if (!_categoryViewModel) {
        _categoryViewModel = [[WARCategoryViewModel alloc]init];
    }
    return _categoryViewModel;
}

- (NSArray *)addArr{
    if (!_addArr) {
        _addArr = [NSArray array];
    }
    return _addArr;
}

- (NSArray *)removeArr{
    if (!_removeArr) {
        _removeArr = [NSArray array];
    }
    return _removeArr;
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
