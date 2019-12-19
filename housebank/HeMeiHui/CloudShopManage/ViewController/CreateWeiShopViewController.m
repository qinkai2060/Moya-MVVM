//
//  CreateWeiShopViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CreateWeiShopViewController.h"
#import "CloudManageMainController.h"
#import "CloudManageBtn.h"
#import "CodeWinTextField.h"
#import "cloudWeiLabel.h"
#import "CloudTypicalView.h"
#import "HFCitySelectorView.h"
#import "HFAddressListViewModel.h"
#import "CloudCreatWeiShop.h"
#import "NSString+Person.h"
#import "UpLoadImageTool.h"
#import "MyJumpHTML5ViewController.h"
#import "HFUntilTool.h"
#import "MBProgressHUD+QYExtension.h"
#import "HFLoginH5WebViewController.h"
@interface CreateWeiShopViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView * scrollMainView ;
@property (nonatomic, strong) CloudManageBtn   * defineBtn;
@property (nonatomic, strong) CodeWinTextField * shopNameTF ;   // 店铺名称
@property (nonatomic, strong) CodeWinTextField * shopLocation;  // 店铺地址
@property (nonatomic, strong) CodeWinTextField * houseNumberTF; // 门牌号
@property (nonatomic, strong) CodeWinTextField * personTF ;     // 联系人
@property (nonatomic, strong) CodeWinTextField * phoneNumberTF ; // 联系电话
@property (nonatomic, strong) UIImageView      * selectLogImage;
@property (nonatomic, strong) UIImageView      * selectSignImage;
@property (nonatomic, strong) UIButton * imageBtn1 ;
@property (nonatomic, strong) UIButton * imageBtn2 ;
@property (nonatomic, strong) UIButton * selectBtn ;
@property (nonatomic, strong) CloudTypicalView * typicalView;
@property (nonatomic, assign) BOOL select;         // 是否选中
@property (nonatomic, strong) HFCitySelectorView *citySelectoryView;
@property (nonatomic, strong) HFAddressListViewModel *viewModel;
@property (nonatomic, strong) UIButton * showCityBtn;
@property (nonatomic, strong) UIView * firstView;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy)   NSString *  selectString;
@property (nonatomic, strong) CloudCreatWeiShop * createViewModel;
@property (nonatomic, strong) HFAddressModel *addressModel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark * address;
@property (nonatomic, copy)   NSString * shopImageUrl;
@property (nonatomic, copy)   NSString * logoImageUrl;
@property (nonatomic, strong) UIView * fourthView;
@property (nonatomic, strong) UIView * fifthView;
@property (nonatomic, strong) UILabel * bottomLabel;
@property (nonatomic, copy) NSString * firstImage;
@property (nonatomic, copy) NSString * lastImage;

@end

@implementation CreateWeiShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllUI];
    
    [self bindRAC];
}

- (void)bindRAC {
    
    @weakify(self);
    [[self.createViewModel getShop_LogoImage]subscribeNext:^(RACTuple * x) {
        @strongify(self);
        self.firstImage  = x.last;
        [self.selectLogImage sd_setImageWithURL:[self.firstImage get_Image]];
     }];
     
    [[self.createViewModel getShop_LogoImage]subscribeNext:^(RACTuple * x) {
      @strongify(self);
      self.lastImage = x.first;
      [self.selectSignImage sd_setImageWithURL:[self.lastImage get_Image]];
    }];
    
//    [[self.imageBtn1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        [self.typicalView showImageString:[firstImage get_Image] withWidth:CGSizeMake(210, 210)];
//    }];
    
    [[self.imageBtn2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.typicalView showImageString:[self.lastImage get_Image] withWidth:CGSizeMake(kWidth, 120)];
        [self.typicalView showLabelText:objectOrEmptyStr(self.shopNameTF.text)];
    }];
    
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.select = !self.select;
        [self setSelected];
    }];
    
    [[self.showCityBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self showCityView];
    }];
    
    [self.viewModel.editingSetSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            self.addressModel = (HFAddressModel*)x;
            self.shopLocation.text =[NSString stringWithFormat:@"%@ %@ %@ %@",self.addressModel.cityName,self.addressModel.regionName,self.addressModel.blockName,self.addressModel.townName];
            /** 换算经纬度*/
            @weakify(self);
            [[self.createViewModel getSelectAddress:self.shopLocation.text]subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                if (x) {
                    self.address = (CLPlacemark *)x;
                    NSLog(@"Longitude = %f", self.address.location.coordinate.longitude);
                    NSLog(@"Latitude = %f", self.address.location.coordinate.latitude);
                }else {
                    [SVProgressHUD showErrorWithStatus:@"地址选择获取出了点意外"];
                }
            }];
        }
    }];
    
    [[self.shopNameTF rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (self.shopNameTF.text.length > 0) {
            [self.typicalView showLabelText:objectOrEmptyStr(self.shopNameTF.text)];
        }else {
            [self.typicalView showLabelText:objectOrEmptyStr(@"店铺名称")];
        }
    }];
    
//    UITapGestureRecognizer *logTap = [[UITapGestureRecognizer alloc]init];
//    [self.selectLogImage addGestureRecognizer:logTap];
//    [[logTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//        @strongify(self);
//        self.selectString = @"LOGO";
//        [self selectPhotoPicture:self.selectLogImage];
//    }];
//
//    UITapGestureRecognizer * signTap = [[UITapGestureRecognizer alloc]init];
//    [self.selectSignImage addGestureRecognizer:signTap];
//    [[signTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//        @strongify(self);
//        self.selectString = @"招牌";
//        [self selectPhotoPicture:self.selectSignImage];
//    }];
    
    //判断按钮是不是可以点
    self.defineBtn.rac_command = [[RACCommand alloc]initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.shopLocation, text),RACObserve(self.shopNameTF, text),RACObserve(self, select),RACObserve(self, canEdit)] reduce:^id _Nonnull{
        @strongify(self);
        return @(self.shopLocation.text.length > 0 && self.shopNameTF.text.length > 0  && (self.select == YES) && (self.canEdit == YES));
    }] signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
    
    [self.defineBtn addTarget:self action:@selector(addNew:) forControlEvents:UIControlEventTouchUpInside];
    
    [RACObserve(self, bottomString)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL show = (self.bottomString.length > 0 && self.showBottom == YES)?YES : NO;
        if(show == YES){self.select = YES;}
        
        self.fourthView.hidden = show;
        self.fifthView.hidden = !show;
    }];
}
- (void)setSelected {
    if (self.select) {
        [self.selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else {
        [self.selectBtn setImage:[UIImage imageNamed:@"cloude_NoSelect"] forState:UIControlStateNormal];
    }
}
// 防止保存按钮多次点击
- (void)addNew:(UIButton *)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(registWeiShop:) object:sender];
    [self performSelector:@selector(registWeiShop:) withObject:sender afterDelay:0.4f];
}

// 注册接口
- (void)registWeiShop:(UIButton *)sender {
    
    if (![HFUntilTool isValidateByRegex:self.phoneNumberTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    if(self.createType == CreateNewShop) {
        if (self.address == nil) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的地理位置"];
            return;
        }
        
//        if (![self.logoImageUrl isNotNil] || ![self.shopImageUrl isNotNil]) {
//            [SVProgressHUD showInfoWithStatus:@"店铺上传照片尚未成功，请稍等!"];
//            return;
//        }
    }
    [SVProgressHUD show];
    
    NSString *longitude = [NSString stringWithFormat:@"%.2f",self.address.location.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.2f",self.address.location.coordinate.latitude];
    NSDictionary * params = [[NSDictionary alloc]init];
    NSString * provinceId = self.addressModel.cityId?self.addressModel.cityId :objectOrEmptyStr(self.itemModel.provinceId);
    NSString * cityId = self.addressModel.regionId?self.addressModel.regionId:objectOrEmptyStr(self.itemModel.cityId);
    NSString * regionId = self.addressModel.blockId?self.addressModel.blockId:objectOrEmptyStr(self.itemModel.regionId);
    NSString * townId = self.addressModel.townId?self.addressModel.townId:objectOrEmptyStr(self.itemModel.townId);
    NSString * address = self.houseNumberTF.text?self.houseNumberTF.text:objectOrEmptyStr(self.itemModel.address);
    if (self.createType == ChangeShop) {
        params = @{
                   @"id":objectOrEmptyStr(self.itemModel.shopId),
                   @"shopsName":objectOrEmptyStr(self.shopNameTF.text),
                   @"provinceId":objectOrEmptyStr(provinceId),
                   @"cityId":objectOrEmptyStr(cityId),
                   @"regionId":objectOrEmptyStr(regionId),
                   @"townId":objectOrEmptyStr(townId),
                   @"address":objectOrEmptyStr(address),
                   @"pointLng":longitude?longitude:objectOrEmptyStr(self.itemModel.pointLng),
                   @"pointLat":latitude?latitude:objectOrEmptyStr(self.itemModel.pointLat),
//                   @"shopImgUrls":(self.shopImageUrl?self.shopImageUrl:objectOrEmptyStr(self.itemModel.shopImg)),
//                   @"logoImgUrls":(self.logoImageUrl?self.logoImageUrl:objectOrEmptyStr(self.itemModel.logoImg)),
                   @"shopImgUrls":objectOrEmptyStr(self.lastImage),
                   @"logoImgUrls":objectOrEmptyStr(self.firstImage),
                   @"logoImgId":objectOrEmptyStr(self.itemModel.logoImgId),
                   @"shopImgId":objectOrEmptyStr(self.itemModel.shopImgId),
                   @"contact":objectOrEmptyStr(self.personTF.text),
                   @"mobile":objectOrEmptyStr(self.phoneNumberTF.text),
                   @"channel":@6,
                   };
    }else {
        params = @{
                   @"shopsName":objectOrEmptyStr(self.shopNameTF.text),
                   @"provinceId":objectOrEmptyStr(self.addressModel.cityId),
                   @"cityId":objectOrEmptyStr(self.addressModel.regionId),
                   @"regionId":objectOrEmptyStr(self.addressModel.blockId),
                   @"townId":objectOrEmptyStr(self.addressModel.townId),
                   @"address":objectOrEmptyStr(self.houseNumberTF.text),
                   @"pointLng":objectOrEmptyStr(longitude),
                   @"pointLat":objectOrEmptyStr(latitude),
//                   @"shopImgUrls":self.shopImageUrl,
//                   @"logoImgUrls":self.logoImageUrl,
                   @"shopImgUrls":objectOrEmptyStr(self.lastImage),
                   @"logoImgUrls":objectOrEmptyStr(self.firstImage),
                   @"logoImgId":@"0",
                   @"shopImgId":@"0",
                   @"contact":objectOrEmptyStr(self.personTF.text),
                   @"mobile":objectOrEmptyStr(self.phoneNumberTF.text),
                   @"isReadNote":@1,
                   @"channel":@6
                   };
    }
    
    [params.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![params.allValues[idx] isKindOfClass:[NSNumber class]]) {
            if ([params.allValues[idx] isEqual:[NSNull null]] || [params.allValues[idx] isEqualToString:@""] ||params.allValues[idx] == nil) {
                [SVProgressHUD showErrorWithStatus:@"请填写完整的信息"];
                return;
            }
        }
    }];
    
    @weakify(self);
    if (self.createType == ChangeShop) {
        //  编辑微店
        [[self.createViewModel change_WeiShopWithDetailInfo:params]subscribeNext:^(id  _Nullable x) {
            @strongify(self);
             [self judgeManageShopWithDic:x Change:YES];
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showErrorWithStatus:@"编辑微店失败！"];
        }];
        
    }else {
        // 注册微店
        [[self.createViewModel creat_WeiShopWithDetailInfo:params]subscribeNext:^(NSDictionary * x) {
            @strongify(self);
            [self judgeManageShopWithDic:x Change:NO];
        }error:^(NSError * _Nullable error) {
            [SVProgressHUD showErrorWithStatus:@"创建微店失败！"];
        }];
    }
}

- (void)judgeManageShopWithDic:(NSDictionary *)dic Change:(BOOL)change{
    NSNumber * errorCode = [dic objectForKey:@"state"];
    NSString * successMsg = (change == YES) ? @"编辑微店成功！" : @"创建微店成功!";
    NSString * errorMsg = (change == YES) ? @"编辑微店失败!" : @"创建微店失败!";
    @weakify(self);
    if ([errorCode isEqual:@1]) {
        [SVProgressHUD showSuccessWithStatus:successMsg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self popManageListVC];
        });
    }else if ([errorCode isEqual:@2]){
        if ([dic.allKeys containsObject:@"msg"] && [[dic objectForKey:@"msg"] isNotNil]) {
            errorMsg = [dic objectForKey:@"msg"];
        }
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }else {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }
}

- (void)popManageListVC {
    for (UIViewController * item in self.navigationController.viewControllers) {
        if ([item isKindOfClass:[CloudManageMainController class]]) {
            [self.navigationController popToViewController:item animated:YES];
        }
    }
}
- (void)selectPhotoPicture:(UIImageView *)imageView {
    
    @weakify(self);
    UIImagePickerController *imagePickController = [[UIImagePickerController alloc]init];
    [imagePickController.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    imagePickController.delegate = self;
    imagePickController.allowsEditing = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        NSLog(@"从手机相册中选择");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickController.navigationBar.translucent = NO;
//            imagePickController.modalPresentationStyle = UIModalPresentationFullScreen;
            imagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            imagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickController animated:YES completion:^{
                @strongify(self);
                UIViewController *contr = imagePickController.viewControllers.lastObject;
                UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
                [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                rightBtn.titleLabel.font = kFONT(16);
                [rightBtn sizeToFit];
                UIView *rightView = [[UIView alloc] initWithFrame:rightBtn.bounds];
                [rightView addSubview:rightBtn];
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
                contr.navigationItem.rightBarButtonItem = rightItem;
                [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
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
    
    [MBProgressHUD qy_showInfoWithStatus:@"图片上传中，请等待!"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([self.selectString isEqualToString:@"LOGO"]) {
        self.selectLogImage.image = image;
        @weakify(self);
        [[[UpLoadImageTool shareInstance]uploadImage:image]subscribeNext:^(NSString * x) {
            @strongify(self);
            [MBProgressHUD qy_hideProgressView];
            if ([x isEqualToString:@"失败"]) {
                [SVProgressHUD showErrorWithStatus:@"店铺LOGO图片上传失败"];
            }else {
                self.logoImageUrl = x;
                [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            }
        }];
    }else if ([self.selectString isEqualToString:@"招牌"]){
        self.selectSignImage.image = image;
        @weakify(self);
        [[[UpLoadImageTool shareInstance]uploadImage:image]subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [MBProgressHUD qy_hideProgressView];
            if ([x isEqualToString:@"失败"]) {
                [SVProgressHUD showErrorWithStatus:@"店铺招牌图片上传失败"];
            }else {
                self.shopImageUrl = x;
                [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            }
        }];
    }
    
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

/**城市列表view */
- (void)showCityView {
    [self.viewModel.regionCommand execute:nil];
    [self.citySelectoryView showCitySelector];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customNavBar.hidden = NO;
    [self.navigationController.navigationBar setHidden:YES];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
}

- (void)updateUI {
    
    self.shopNameTF.text = objectOrEmptyStr(self.itemModel.shopName);
    self.shopLocation.text = objectOrEmptyStr(self.itemModel.address);
    self.houseNumberTF.text = objectOrEmptyStr(self.itemModel.localAddress);
    self.personTF.text = objectOrEmptyStr(self.itemModel.contact);
    self.phoneNumberTF.text = objectOrEmptyStr(self.itemModel.mobile);
//    [self.selectLogImage sd_setImageWithURL:[objectOrEmptyStr(self.itemModel.logoImg)  get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
//    [self.selectSignImage sd_setImageWithURL:[objectOrEmptyStr(self.itemModel.shopImg)  get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
    self.height = [self.createViewModel rowHeight:self.reason];
    if (self.reason.length > 0) {
        self.scrollMainView.contentSize = CGSizeMake(0, 45*5+20+250+180+self.height+30+50);
    }else {
        self.scrollMainView.contentSize = CGSizeMake(0, 45*5+20+250+180+50);
        
    }
    
    if ([self.reason isNotNil]) {
        UIView * topView = [UIView new];
        topView.backgroundColor = [UIColor whiteColor];
        [self.scrollMainView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.scrollMainView);
            make.width.equalTo(self.view);
            make.height.equalTo(@(self.height + 30));
        }];
        cloudWeiLabel * reasonLabel = [[cloudWeiLabel alloc]init];
        reasonLabel.text = @"拒绝原因";
        [topView addSubview:reasonLabel];
        [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(topView).offset(15);
            make.width.equalTo(@56);
            make.height.equalTo(@15);
        }];
        
        cloudWeiLabel * reasonDetailLabel = [[cloudWeiLabel alloc]init];
        reasonDetailLabel.text = objectOrEmptyStr(self.reason);
        reasonDetailLabel.numberOfLines = 0;
        reasonDetailLabel.textColor = [UIColor colorWithHexString:@"#ED0505"];
        [topView addSubview:reasonDetailLabel];
        [reasonDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reasonLabel);
            make.left.equalTo(reasonLabel.mas_right).offset(15);
            make.right.equalTo(topView).offset(-15);
            make.height.equalTo(@(self.height));
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [topView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topView);
            make.top.equalTo(reasonDetailLabel.mas_bottom).offset(15);
            make.height.equalTo(@1);
        }];
    }
}

// 整体布局
- (void)setUpAllUI {
    
    self.select = NO;
    [self.view addSubview:self.scrollMainView];
    [self.view addSubview:self.defineBtn];
    
    self.firstView = [UIView new];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.scrollMainView addSubview:self.firstView];
    
    if(self.createType == ChangeShop) {
        self.customNavBar.title = @"编辑微店";
        [_defineBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self updateUI];
        if (self.reason.length > 0) {
            self.firstView.frame = CGRectMake(0, self.height+30, kWidth, 45*3);
        }else {
            self.firstView.frame = CGRectMake(0, 0, kWidth, 45*3);
        }
    }else {
        self.customNavBar.title = @"创建微店";
        self.firstView.frame = CGRectMake(0, 0, kWidth, 45*3);
    }
    
    CGFloat rowHeight = (self.height && self.reason.length > 0? self.height+30 : 0);
    cloudWeiLabel * shopNameLabel = [[cloudWeiLabel alloc]init];
    shopNameLabel.text = @"店铺名称";
    [self.firstView addSubview:shopNameLabel];
    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(15);
        make.top.equalTo(self.firstView).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    [self.firstView addSubview:self.shopNameTF];
    [self.shopNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(91);
        make.centerY.equalTo(shopNameLabel);
        make.right.equalTo(self.firstView).offset(-40);
        make.height.equalTo(@20);
    }];
    
    UIView * line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.firstView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.firstView);
        make.top.equalTo(self.firstView).offset(44);
        make.height.equalTo(@1);
    }];
    
    cloudWeiLabel * shopLocationLabel = [[cloudWeiLabel alloc]init];
    shopLocationLabel.text = @"店铺地址";
    [self.firstView addSubview:shopLocationLabel];
    [shopLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(15);
        make.top.equalTo(line1).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    [self.firstView addSubview:self.shopLocation];
    [self.shopLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(91);
        make.centerY.equalTo(shopLocationLabel);
        make.right.equalTo(self.firstView).offset(-40);
        make.height.equalTo(@20);
    }];
    
    [self.firstView addSubview:self.showCityBtn];
    [self.showCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shopLocation);
    }];
    
    UIImageView * right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_light666"]];
    [self.firstView addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstView).offset(-15);
        make.centerY.equalTo(shopLocationLabel);
        make.width.height.equalTo(@15);
    }];
    
    UIView * line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.firstView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.firstView);
        make.top.equalTo(line1.mas_bottom).offset(44);
        make.height.equalTo(@1);
    }];
    
    cloudWeiLabel * shopNumberLabel = [[cloudWeiLabel alloc]init];
    shopNumberLabel.text = @"门牌号";
    [self.firstView addSubview:shopNumberLabel];
    [shopNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(15);
        make.top.equalTo(line2).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    [self.firstView addSubview:self.houseNumberTF];
    [self.houseNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView).offset(91);
        make.centerY.equalTo(shopNumberLabel);
        make.right.equalTo(self.firstView).offset(-40);
        make.height.equalTo(@20);
    }];
    
    UIView * secondView = [UIView new];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.scrollMainView addSubview:secondView];
    secondView.frame = CGRectMake(0, 45*3+10+rowHeight, kWidth, 45*2);
    
    cloudWeiLabel * personLabel = [[cloudWeiLabel alloc]init];
    personLabel.text = @"联系人";
    [secondView addSubview:personLabel];
    [personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView).offset(15);
        make.top.equalTo(secondView).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    [secondView addSubview:self.personTF];
    [self.personTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView).offset(91);
        make.centerY.equalTo(personLabel);
        make.right.equalTo(secondView).offset(-40);
        make.height.equalTo(@20);
    }];
    
    UIView * line3 = [UIView new];
    line3.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [secondView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(secondView);
        make.top.equalTo(secondView).offset(44);
        make.height.equalTo(@1);
    }];
    
    cloudWeiLabel * phoneNumLabel = [[cloudWeiLabel alloc]init];
    phoneNumLabel.text = @"联系电话";
    [secondView addSubview:phoneNumLabel];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView).offset(15);
        make.top.equalTo(line3).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    [secondView addSubview:self.phoneNumberTF];
    [self.phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView).offset(91);
        make.centerY.equalTo(phoneNumLabel);
        make.right.equalTo(secondView).offset(-40);
        make.height.equalTo(@20);
    }];
    
    UIView * thirdView = [UIView new];
    thirdView.backgroundColor = [UIColor whiteColor];
    [self.scrollMainView addSubview:thirdView];
    thirdView.frame = CGRectMake(0, 45*5 +20+rowHeight, kWidth, 250);
    
    cloudWeiLabel * shopPhoto = [[cloudWeiLabel alloc]init];
    shopPhoto.text = @"店铺照片";
    [thirdView addSubview:shopPhoto];
    [shopPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdView).offset(15);
        make.top.equalTo(thirdView).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@56);
    }];
    
    cloudWeiLabel * shopLog = [[cloudWeiLabel alloc]init];
    shopLog.text = @"店铺LOGO";
    [thirdView addSubview:shopLog];
    [shopLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopPhoto.mas_right).offset(20);
        make.top.equalTo(thirdView).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@100);
    }];
    
    self.imageBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn1 setTitle:@"示例图" forState:UIControlStateNormal];
    [self.imageBtn1 setTitleColor:[UIColor colorWithHexString:@"#3897F0"] forState:UIControlStateNormal];
    self.imageBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.imageBtn1.titleLabel.font = kFONT(14);
    [thirdView addSubview:self.imageBtn1];
    [self.imageBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopLog);
        make.left.equalTo(shopLog.mas_right).offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(thirdView).offset(-30);
    }];
    self.imageBtn1.hidden = YES;
    
    [thirdView addSubview:self.selectLogImage];
    [self.selectLogImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopLog.mas_bottom).offset(10);
        make.left.equalTo(shopLog);
        make.width.height.equalTo(@75);
    }];
    
    cloudWeiLabel * shopSignLabel = [[cloudWeiLabel alloc]init];
    shopSignLabel.text = @"店铺招牌(注册店铺完成后展示的";
    [thirdView addSubview:shopSignLabel];
    [shopSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopLog);
        make.top.equalTo(self.selectLogImage.mas_bottom).offset(20);
        make.height.equalTo(@15);
    }];
    
    self.imageBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn2 setTitle:@"示例图)" forState:UIControlStateNormal];
    [self.imageBtn2 setTitleColor:[UIColor colorWithHexString:@"#3897F0"] forState:UIControlStateNormal];
    self.imageBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.imageBtn2.titleLabel.font = kFONT(14);
    [thirdView addSubview:self.imageBtn2];
    [self.imageBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopSignLabel);
        make.left.equalTo(shopSignLabel.mas_right).offset(1);
        make.height.equalTo(@30);
//        make.right.equalTo(thirdView).offset(-30);
    }];
    
    [thirdView addSubview:self.selectSignImage];
    [self.selectSignImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopSignLabel.mas_bottom).offset(10);
        make.left.equalTo(shopSignLabel);
        make.width.equalTo(@120);
        make.height.equalTo(@75);
    }];
    
    UIView * line4 = [UIView new];
    line4.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [thirdView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(thirdView);
        make.top.equalTo(self.selectSignImage.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
#pragma mark -- 1.创造店铺 那么下面是协议  2.编辑店铺，下面是备注
    if (self.bottomString.length > 0 && self.showBottom == YES) {
        [self.scrollMainView addSubview:self.fifthView];
        self.fifthView.frame = CGRectMake(0, 45*5+20+rowHeight+251, kWidth, 180);
        
        [self.fifthView addSubview:self.bottomLabel];
        self.bottomLabel.text = self.bottomString;
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fifthView).offset(15);
            make.left.equalTo(self.fifthView).offset(15);
            make.right.equalTo(self.fifthView).offset(-15);
            make.bottom.equalTo(self.fifthView).offset(-10);
        }];
    }else {
        
        [self.scrollMainView addSubview:self.fourthView];
        self.fourthView.frame = CGRectMake(0, 45*5+20+rowHeight+251, kWidth, 60);
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setImage:[UIImage imageNamed:@"cloude_NoSelect"] forState:UIControlStateNormal];
        [self.fourthView addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fourthView).offset(33);
            make.height.width.equalTo(@20);
            make.top.equalTo(self.fourthView).offset(15);
        }];
        
        cloudWeiLabel * alertLabel = [[cloudWeiLabel alloc]init];
        alertLabel.text = @"我已阅读并同意";
        [self.fourthView addSubview:alertLabel];
        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectBtn);
            make.left.equalTo(self.selectBtn.mas_right).offset(10);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        
        UIButton * serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [serverBtn setTitle:@"《微店商户服务协议》" forState:UIControlStateNormal];
        serverBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        serverBtn.titleLabel.font = kFONT(14);
        [serverBtn setTitleColor:[UIColor colorWithHexString:@"#F16C6C"] forState:UIControlStateNormal];
        [self.fourthView addSubview:serverBtn];
        [serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectBtn);
            make.left.equalTo(alertLabel.mas_right);
            make.right.equalTo(self.fourthView);
            make.height.equalTo(@20);
        }];
        
        @weakify(self);
        [[serverBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSString *strUrl = [NSString stringWithFormat:@"/html/common/agreement-app3.html?hideTitle=1"];
            HFLoginH5WebViewController *vc = [[HFLoginH5WebViewController alloc] init];
            vc.title = @"微店商户服务协议";
            vc.isBottomButton = YES;
            vc.url = [NSString stringWithFormat:@"%@/%@",fyMainHomeUrl,strUrl];
            vc.view.backgroundColor = [UIColor whiteColor];
            [[vc.bottomView.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                self.select = YES;
                [self setSelected];
            }];
            
            [[vc.bottomView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                 self.select = NO;
                [self setSelected];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    
    [self.defineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
}

#pragma mark -- lazy load
- (UIScrollView *)scrollMainView {
    if (!_scrollMainView) {
        _scrollMainView = [[UIScrollView alloc]init];
        _scrollMainView.frame = CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT);
        _scrollMainView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _scrollMainView.showsHorizontalScrollIndicator = NO;
        _scrollMainView.showsVerticalScrollIndicator = NO;
        _scrollMainView.contentSize = CGSizeMake(0, 45*5+20+250+60+50);
        _scrollMainView.userInteractionEnabled = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return _scrollMainView;
}

- (CloudManageBtn *)defineBtn {
    if (!_defineBtn) {
        _defineBtn = [[CloudManageBtn alloc]init];
        [_defineBtn initWithLayerWidth:kWidth font:16 height:50];
        [_defineBtn setTitle:@"创建" forState:UIControlStateNormal];
        _defineBtn.layer.cornerRadius = 0;
        _defineBtn.titleLabel.font = kFONT_BOLD(16);
    }
    return _defineBtn;
}

- (CodeWinTextField *)shopNameTF {
    if (!_shopNameTF) {
        _shopNameTF = [[CodeWinTextField alloc]init];
        _shopNameTF.placeholder = @"请输入店铺地址";
        [_shopNameTF changePlaceHolderColor];
        _shopNameTF.delegate = self;
    }
    return _shopNameTF;
}

- (CodeWinTextField *)shopLocation {
    if (!_shopLocation) {
        _shopLocation = [[CodeWinTextField alloc]init];
        _shopLocation.placeholder = @"请输入店铺地址";
        [_shopLocation changePlaceHolderColor];
        _shopLocation.delegate = self;
    }
    return _shopLocation;
}

- (CodeWinTextField *)houseNumberTF {
    if (!_houseNumberTF) {
        _houseNumberTF = [[CodeWinTextField  alloc]init];
        _houseNumberTF.placeholder = @"请输入门牌号";
        [_houseNumberTF changePlaceHolderColor];
        _houseNumberTF.delegate = self;
    }
    return  _houseNumberTF;
}

- (CodeWinTextField *)personTF {
    if (!_personTF) {
        _personTF = [[CodeWinTextField alloc]init];
        _personTF.placeholder = @"请输入联系人真实姓名";
        [_personTF changePlaceHolderColor];
        _personTF.delegate = self;
    }
    return _personTF;
}

- (CodeWinTextField *)phoneNumberTF {
    if (!_phoneNumberTF) {
        _phoneNumberTF = [[CodeWinTextField alloc]init];
        _phoneNumberTF.placeholder = @"请输入联系人电话";
        _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneNumberTF changePlaceHolderColor];
        _phoneNumberTF.delegate = self;
    }
    return _phoneNumberTF;
}

- (CloudTypicalView *)typicalView {
    if(!_typicalView) {
        _typicalView = [[CloudTypicalView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, kHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:_typicalView];
    }
    return _typicalView;
}

- (HFCitySelectorView *)citySelectoryView {
    if (!_citySelectoryView) {
        _citySelectoryView = [[HFCitySelectorView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
        _citySelectoryView.titleLb.text = @"选择店铺地址";
        _citySelectoryView.hidden = YES;
    }
    return _citySelectoryView;
}

- (HFAddressListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFAddressListViewModel alloc]init];
    }
    return _viewModel;
}

- (UIButton *)showCityBtn {
    if (!_showCityBtn) {
        _showCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showCityBtn.backgroundColor = [UIColor clearColor];
    }
    return _showCityBtn;
}

- (CloudCreatWeiShop *)createViewModel {
    if (!_createViewModel) {
        _createViewModel = [[CloudCreatWeiShop alloc]init];
    }
    return _createViewModel;
}

- (UIImageView *)selectLogImage {
    if (!_selectLogImage) {
        _selectLogImage = [[UIImageView alloc]init];
        _selectLogImage.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _selectLogImage.image = [UIImage imageNamed:@"cloud_photo"];
        _selectLogImage.userInteractionEnabled = YES;
    }
    return _selectLogImage;
}

- (UIImageView *)selectSignImage {
    if (!_selectSignImage) {
        _selectSignImage = [[UIImageView alloc]init];
        _selectSignImage.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _selectSignImage.image = [UIImage imageNamed:@"cloud_photo"];
        _selectSignImage.userInteractionEnabled = YES;
    }
    return _selectSignImage;
}

- (UIView *)fourthView {
    if (!_fourthView) {
        _fourthView = [UIView new];
        _fourthView.backgroundColor = [UIColor whiteColor];
    }
    return _fourthView;
}

- (UIView *)fifthView {
    if(!_fifthView) {
        _fifthView = [UIView new];
        _fifthView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _fifthView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _bottomLabel.font = kFONT(13);
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}
@end
