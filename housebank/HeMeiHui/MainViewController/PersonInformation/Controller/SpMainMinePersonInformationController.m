//
//  SpMainMinePersonInformationController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpMainMinePersonInformationController.h"
#import "PersonInformationFirstUnitView.h"
#import "PersonInformationSecoundUnitView.h"
#import "PersonInformationThirdUnitView.h"
#import "SpMainMinePersonInformationModfiyController.h"
#import "PersonInformationSelectView.h"
#import "PersonSignalViewModel.h"
#import "PersonInfoModel.h"
#import "PersonBaseInfoModel.h"
#import "MyJumpHTML5ViewController.h"
#import "IdentityPassViewController.h"
@interface SpMainMinePersonInformationController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSMutableArray<UIView *> *unitViewArray;
@property (nonatomic,strong)PersonInformationSelectView *selectView;
@property (nonatomic,strong)UIImagePickerController *pickerController;
@property (nonatomic,weak)PersonInformationBaseView *currentClickView;
@property (nonatomic,strong)NSArray<NSString *> *defaultValueArray;
@property (nonatomic, strong) PersonSignalViewModel * viewModel;
@property (nonatomic, strong) PersonInfoModel * infoModel;
@property (nonatomic, strong) PersonBaseInfoModel * baseInfoModel;
@property (nonatomic, strong) PersonInformationFirstUnitView *firstView;
@property (nonatomic, strong) PersonInformationThirdUnitView *thirdView;
@property (nonatomic, copy) NSString * selectString;
@end

@implementation SpMainMinePersonInformationController {
    
}

- (NSArray<NSString *> *)defaultValueArray {
    if (!_defaultValueArray) {
        
        _defaultValueArray = @[
                               objectOrEmptyStr(self.baseInfoModel.head_url),
                               objectOrEmptyStr(self.baseInfoModel.nickname),
                               [NSString stringWithFormat:@"%@%@",objectOrEmptyStr(self.baseInfoModel.name),[self getFromUserName]],
                               [self.baseInfoModel.gender isEqual: @2] ? @"女":@"男",
                               objectOrEmptyStr(self.baseInfoModel.mobilephone),
                               objectOrEmptyStr(self.baseInfoModel.telphone),
                               objectOrEmptyStr(self.baseInfoModel.email),
                               objectOrEmptyStr(self.baseInfoModel.selfAdress),
                               objectOrEmptyStr(self.baseInfoModel.identity),
                               objectOrEmptyStr(self.baseInfoModel.identityFrontUrl),
                               objectOrEmptyStr(self.baseInfoModel.cardNo)
                               ];
    }
    return _defaultValueArray;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        
        _pickerController = [UIImagePickerController new];
    }
    return _pickerController;
}

- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[
                        @"头像:",
                        @"昵称:",
                        @"姓名:",
                        @"性别:",
                        @"联系电话:",
                        @"备用电话:",
                        @"电子邮箱:",
                        @"通讯地址:",
                        @"证件号码:",
                        @"证件图片:",
                        @"银行卡号码:"];
    }
    return _titleArray;
}

- (NSMutableArray<UIView *> *)unitViewArray {
    if (_unitViewArray == nil) {
        NSMutableArray *tempArray = [NSMutableArray array];
    
        for (int i = 0; i < self.titleArray.count; i++) {
            if (i == 0) {
                //第一种View
                [tempArray addObject:self.firstView];
                self.firstView.currentType = (PersonInformationType)(i+1);
                self.firstView.urlString= objectOrEmptyStr(self.baseInfoModel.head_url);
                continue;
            }
            if (i == 9) {
                
                self.thirdView.title = self.titleArray[i];
                self.thirdView.currentType = (PersonInformationType)(i+1);
                self.thirdView.content = self.defaultValueArray[i];
                [tempArray addObject:self.thirdView];
                continue;
            }
            PersonInformationSecoundUnitView *secoundView = [PersonInformationSecoundUnitView new];
            secoundView.title = self.titleArray[i];
            secoundView.currentType = (PersonInformationType)(i+1);
            secoundView.content = self.defaultValueArray[i];
            [tempArray addObject:secoundView];
        }

        _unitViewArray = tempArray;
    }
    
    return _unitViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    dispatch_group_t group = dispatch_group_create();
    @weakify(self);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [[self.viewModel getRequestPersonInfo]subscribeNext:^(RACTuple * x) {
            @strongify(self)
            self.infoModel = x.first;
            self.baseInfoModel = x.last;
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                @strongify(self);
                //添加子控件
                if (self.defaultValueArray.count > 1) {
                    [self createContentView];
                }
            });
        }];
    });
}

- (void)initNotification {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPersonInformationBaseViewNotification:) name:PersonInformationBaseViewNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PersonInformationBaseViewNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotification];
}

- (void)actionPersonInformationBaseViewNotification:(NSNotification *)sender {
    
    PersonInformationBaseView *currentView = sender.object;
    self.currentClickView = currentView;
    [self selectType:currentView.currentType];
  
}

- (void)setSubView {
    [super setSubView];
}

- (void)getImagePicture:(NSInteger)way {
    self.pickerController.delegate = self;
    self.pickerController.allowsEditing = YES;
    
    BOOL isPicker = NO;
    
    switch (way) {
        case 1:
            isPicker = true;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                isPicker = true;
            }
            break;
            
        case 2:
            self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            isPicker = true;
            break;
            
        default:
            self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            isPicker = true;
            break;
    }
    
    if (isPicker) {
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)createContentView {
    //设置约束
    for (int i = 0 ; i < self.unitViewArray.count ; i++) {
        [self.contentView addSubview:self.unitViewArray[i]];
        [self.unitViewArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(WScale(0));
            } else if (i == 1) {
                make.top.mas_equalTo(self.unitViewArray[i - 1].mas_bottom).mas_offset(WScale(10));
            } else {
                make.top.mas_equalTo(self.unitViewArray[i - 1].mas_bottom).mas_offset(WScale(1));
            }
            
            make.leading.trailing.mas_equalTo(self.contentView);
            //  make.bottom.mas_offset(self.contentView.mas_bottom);
            
        }];
    }
}

- (void)selectType:(PersonInformationType)currentType {
    
    __weak SpMainMinePersonInformationController *weakSelf = self;
    switch (currentType) {
        case PersonInformationType_Head:
        {
            self.selectString = @"头像";
            [self selectPhotoPicture:self.firstView.iconImageV];
            break;
        }
            
        case PersonInformationType_NickName:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_NickName - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_Name:
        {
            if (self.baseInfoModel.authStatus ==  1 || self.baseInfoModel.authStatus == 4) {
                NSString *strUrl = @"/html/house/personalinformation/identityVerify_r.html";
                MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
                HtmlVC.webUrl = strUrl;
                [self.navigationController pushViewController:HtmlVC animated:YES];
                return;
            }
            
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_Name -1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_Sex:
        {
            self.selectView = [PersonInformationSelectView share];
            [self.selectView showView:@[@"男",@"女"] cancel:^{
            } sure:^(NSString * _Nonnull title) {
                
                @weakify(self);
                NSNumber * gender;
                if([title isEqualToString:@"男"]) {
                    gender = @1;
                }else {
                    gender = @2;
                 }
                NSString *sid = USERDEFAULT(@"sid")?:@"";
                [[self.viewModel changePersonIndoWithParams:@{
                                                              @"gender":gender,
                                                              @"sid":sid
                                                              }]subscribeNext:^(id  _Nullable x) {
                    @strongify(self);
                    NSNumber * code = [x objectForKey:@"code"];
                    if ([code isEqual:@0]) {
                        self.currentClickView.content = title;
                    }else {
                        NSString *error = [x objectForKey:@"msg"];
                        [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(error)];
                    }
                }];
                
            }];
            
            break;
        }
        case PersonInformationType_ContactPhone:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.passValue = objectOrEmptyStr(self.baseInfoModel.mobilephone);
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_ContactPhone - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_RefillPhone:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_RefillPhone - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_Email:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_Email - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_Address:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_Address - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_IDNumber:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_IDNumber - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PersonInformationType_IDPicture:
        {
            self.selectString = @"身份证";
            [self selectPhotoPicture:self.thirdView.iconImageV];
            break;
        }
        case PersonInformationType_BankNubmer:
        {
            SpMainMinePersonInformationModfiyController *vc = [SpMainMinePersonInformationModfiyController new];
            vc.currentType = currentType;
            vc.nvTitle = self.titleArray[(NSInteger)PersonInformationType_BankNubmer - 1];
            vc.success = ^(NSString * _Nonnull str) {
                
                weakSelf.currentClickView.content = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}


- (void)selectPhotoPicture:(UIImageView *)imageView {
    
    @weakify(self);
    UIImagePickerController *imagePickController = [[UIImagePickerController alloc]init];
    imagePickController.delegate = self;
    imagePickController.allowsEditing = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        NSLog(@"从手机相册中选择");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            imagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"直接拍照");
        @strongify(self);
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:phoneAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark-- imagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([self.selectString isEqualToString:@"头像"]) {
        self.firstView.iconImageV.image = image;
    }else if ([self.selectString isEqualToString:@"身份证"]){
        self.thirdView.iconImageV.image = image;
    }
    
    // 调用接口
    [[self.viewModel sendPostUSerHeadImage]subscribeNext:^(id  _Nullable x) {
        
    }];
    //图片存入相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    }
}

// 相机选择取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
}

- (NSString *)getFromUserName {
    if (self.baseInfoModel.authStatus == 1 || self.baseInfoModel.authStatus == 4) {
        return @"   (未验证)";
    }
    return nil;
}

#pragma mark -- lazy load
- (PersonSignalViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PersonSignalViewModel alloc]init];
    }
    return _viewModel;
}

- (PersonInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[PersonInfoModel alloc]init];
    }
    return _infoModel;
}

- (PersonBaseInfoModel *)baseInfoModel {
    if (!_baseInfoModel) {
        _baseInfoModel = [[PersonBaseInfoModel alloc]init];
    }
    return _baseInfoModel;
}

- (PersonInformationFirstUnitView *)firstView {
    if (!_firstView) {
        _firstView = [[PersonInformationFirstUnitView alloc]init];
    }
    return _firstView;
}

- (PersonInformationThirdUnitView *)thirdView {
    if (!_thirdView) {
        _thirdView = [[PersonInformationThirdUnitView alloc]init];
    }
    return _thirdView;
}
@end
