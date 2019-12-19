//
//  MyIdcardView.m
//  gcd
//
//  Created by 张磊 on 2019/4/26.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "MyIdcardView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+addGradientLayer.h"
#import "QRCodeImage.h"
#define FitiPhone6Scale(x) ((x) * ScreenW / 375.0f)

@interface MyIdcardView()
{
   
}
@property (nonatomic, strong) UILabel *nameLabel;//姓名
@property (nonatomic, strong)UILabel *positionLabel;//职位
@property (nonatomic, strong)UILabel *companyLabel;//公司
@property (nonatomic, strong)UILabel *phoneLabel;//电话
@property (nonatomic, strong)UILabel *emailLabel;//邮箱
@property (nonatomic, strong)UILabel *webLabel;//网址
@property (nonatomic, strong)UILabel *addressLabel;//地址
@property (nonatomic, strong)UIImageView *imgQrcode;//个人二维码
//@property (nonatomic, strong)UIImageView *imgHeader;//个人头像

@property (nonatomic, strong)UIImageView *imgFrontcard;//正面名片
@property (nonatomic, strong)UIImageView *imgBackcard;//背面名片
@end

@implementation MyIdcardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    

    self.imgFrontcard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cardPositive.jpg"]];
    [self addSubview:self.imgFrontcard];
    [self.imgFrontcard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FitiPhone6Scale(15));
        make.left.equalTo(self).offset(FitiPhone6Scale(20));
        make.height.mas_equalTo(FitiPhone6Scale(200));
        make.right.equalTo(self).offset(-FitiPhone6Scale(20));
    }];
    
    UILabel *labelZ  = [[UILabel alloc] init];
    labelZ.text = @"正面";
    labelZ.font = [UIFont systemFontOfSize:FitiPhone6Scale(17)];
    labelZ.textColor = HEXCOLOR(0x666666);
    [self addSubview:labelZ];
    [labelZ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imgFrontcard.mas_bottom).offset(FitiPhone6Scale(0));
        make.height.mas_equalTo(FitiPhone6Scale(44));
    }];
    
    UIImageView * imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_card"]];
    [self.imgFrontcard addSubview:imgLogo];
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgFrontcard).offset(FitiPhone6Scale(20));
        make.left.equalTo(self.imgFrontcard).offset(FitiPhone6Scale(20));
        make.height.mas_equalTo(FitiPhone6Scale(20));
        make.width.mas_equalTo(FitiPhone6Scale(101));

    }];
    
    
    self.imgBackcard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cardOther.jpg"]];
    [self addSubview:self.imgBackcard];
    [self.imgBackcard mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgFrontcard.mas_bottom).offset(FitiPhone6Scale(44));
        make.left.equalTo(self).offset(FitiPhone6Scale(20));
        make.height.mas_equalTo(FitiPhone6Scale(200));
        make.right.equalTo(self).offset(-FitiPhone6Scale(20));
        
    }];
    UILabel *labelf  = [[UILabel alloc] init];
    labelf.text = @"反面";
    labelf.font = [UIFont systemFontOfSize:FitiPhone6Scale(17)];
    labelf.textColor = HEXCOLOR(0x666666);
    [self addSubview:labelf];
    [labelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imgBackcard.mas_bottom).offset(FitiPhone6Scale(0));
        make.height.mas_equalTo(FitiPhone6Scale(44));
    }];
    
    self.nameLabel  = [[UILabel alloc] init];
//    self.nameLabel.text = @"在于";
    self.nameLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(17)];
    self.nameLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgFrontcard).offset((FitiPhone6Scale(20)));
        make.top.equalTo(self.imgFrontcard).offset(FitiPhone6Scale(55));
        make.height.mas_equalTo(FitiPhone6Scale(20));
    }];
    
    self.positionLabel  = [[UILabel alloc] init];
//    self.positionLabel.text = @"运营中心负责人";
    self.positionLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(11)];
    self.positionLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset((FitiPhone6Scale(10)));
        make.bottom.equalTo(self.nameLabel);
        make.height.mas_equalTo(FitiPhone6Scale(12));
    }];
    
    self.companyLabel  = [[UILabel alloc] init];
//    self.companyLabel.text = @"合发淮安市运营中心";
    self.companyLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(11)];
    self.companyLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(FitiPhone6Scale(10));
        make.height.mas_equalTo(FitiPhone6Scale(12));
    }];
    
    UIImageView * imgtel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel_card"]];
    [self.imgFrontcard addSubview:imgtel];
    [imgtel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.companyLabel.mas_bottom).offset(FitiPhone6Scale(15));
        make.left.equalTo(self.imgFrontcard).offset(FitiPhone6Scale(20));
        make.height.mas_equalTo(FitiPhone6Scale(11));
        make.width.mas_equalTo(FitiPhone6Scale(11));
        
    }];
    
    self.phoneLabel  = [[UILabel alloc] init];
//    self.phoneLabel.text = @"13836888888      13888888888";
    self.phoneLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(10)];
    self.phoneLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgtel.mas_right).offset((FitiPhone6Scale(10)));
        make.centerY.equalTo(imgtel);
    }];
    
    UIImageView * imgeml = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mail_card"]];
    [self.imgFrontcard addSubview:imgeml];
    [imgeml mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgtel.mas_bottom).offset(FitiPhone6Scale(8));
        make.left.equalTo(imgtel);
        make.height.mas_equalTo(FitiPhone6Scale(11));
        make.width.mas_equalTo(FitiPhone6Scale(11));
        
    }];
    
    self.emailLabel  = [[UILabel alloc] init];
//    self.emailLabel.text = @"pppp";
    self.emailLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(10)];
    self.emailLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.emailLabel];
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgeml.mas_right).offset((FitiPhone6Scale(10)));
        make.centerY.equalTo(imgeml);
    }];
    
    
    UIImageView * imgglobal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_global_card"]];
    [self.imgFrontcard addSubview:imgglobal];
    [imgglobal mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgeml.mas_bottom).offset(FitiPhone6Scale(8));
        make.left.equalTo(imgeml);
        make.height.mas_equalTo(FitiPhone6Scale(11));
        make.width.mas_equalTo(FitiPhone6Scale(11));
        
    }];
    
    self.webLabel  = [[UILabel alloc] init];
//    self.webLabel.text = @"www.baidu.com";
    self.webLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(10)];
    self.webLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.webLabel];
    [self.webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgglobal.mas_right).offset((FitiPhone6Scale(10)));
        make.centerY.equalTo(imgglobal);
    }];
    
    
    UIImageView * imgmap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_map_card"]];
    [self.imgFrontcard addSubview:imgmap];
    [imgmap mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgglobal.mas_bottom).offset(FitiPhone6Scale(8));
        make.left.equalTo(imgglobal);
        make.height.mas_equalTo(FitiPhone6Scale(11));
        make.width.mas_equalTo(FitiPhone6Scale(11));
        
    }];
    
    self.addressLabel  = [[UILabel alloc] init];
//    self.addressLabel.text = @"在乎的时候";
    self.addressLabel.font = [UIFont systemFontOfSize:FitiPhone6Scale(10)];
    self.addressLabel.textColor = HEXCOLOR(0x223039);
    [self.imgFrontcard addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgmap.mas_right).offset((FitiPhone6Scale(10)));
        make.centerY.equalTo(imgmap);
    }];
    
    self.imgQrcode = [[UIImageView alloc] init];
    [self.imgBackcard addSubview:self.imgQrcode];
    [self.imgQrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgBackcard).offset(FitiPhone6Scale(62));
        make.centerX.equalTo(self.imgBackcard);
        make.size.mas_equalTo(CGSizeMake(FitiPhone6Scale(55), FitiPhone6Scale(55)));
        
    }];
//    self.imgHeader  = [[UIImageView alloc] init];
//    [self.imgQrcode addSubview:self.imgHeader];
//    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.imgQrcode);
//        make.size.mas_equalTo(CGSizeMake(FitiPhone6Scale(15), FitiPhone6Scale(15)));
//
//    }];
    
    UIButton *btnSave = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSave setTitle:@"保存到手机" forState:(UIControlStateNormal)];
    btnSave.titleLabel.font = PFR16Font;
    [btnSave setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSave.layer.cornerRadius = 5;
    btnSave.layer.masksToBounds = YES;
    btnSave.backgroundColor = HEXCOLOR(0xFF2E5D);
    [btnSave addTarget:self action:@selector(btnSaveImgAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnSave];
    [btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-FitiPhone6Scale(21));
        make.left.equalTo(self).offset(FitiPhone6Scale(20));
        make.right.equalTo(self).offset(-FitiPhone6Scale(20));
        make.height.mas_equalTo(FitiPhone6Scale(50));
        
    }];
    [self layoutIfNeeded];
    [btnSave addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSave bringSubviewToFront:btnSave.titleLabel];
    
//    UIButton *btnRefrensh = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btnRefrensh setTitle:@"刷新" forState:(UIControlStateNormal)];
//    btnRefrensh.titleLabel.font = PFR16Font;
//    [btnRefrensh setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    btnRefrensh.layer.cornerRadius = 5;
//    btnRefrensh.layer.masksToBounds = YES;
//    btnRefrensh.backgroundColor = HEXCOLOR(0x404040);
//    [btnRefrensh addTarget:self action:@selector(btnRefrenshAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self addSubview:btnRefrensh];
//    [btnRefrensh mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-FitiPhone6Scale(21));
//        make.left.equalTo(self).offset(FitiPhone6Scale(20));
//        make.right.equalTo(btnSave.mas_left).offset(-FitiPhone6Scale(20));
//        make.height.mas_equalTo(FitiPhone6Scale(50));
//
//    }];
}

/**
 刷新
 */
- (void)btnRefrenshAction{
    if (self.refrenshBlock) {
        self.refrenshBlock();
    }
}

/**
 保存图片方法
 */
- (void)btnSaveImgAction{
    
    [SVProgressHUD show];
    
    UIImage *frontcard = [self makeImageWithView:self.imgFrontcard withSize:CGSizeMake(ScreenW - FitiPhone6Scale(40), FitiPhone6Scale(210))];
    
    UIImage *backcard = [self makeImageWithView:self.imgBackcard withSize:CGSizeMake(ScreenW - FitiPhone6Scale(40), FitiPhone6Scale(210))];
    
    
    
    [self writeImages:[@[frontcard,backcard] mutableCopy] completion:^(id result) {
        NSLog(@"%@", result);
        
        [SVProgressHUD showSuccessWithStatus:@"已保存到手机相册!"];
        [SVProgressHUD dismissWithDelay:1];
    }];
}
//- (void)setStrHeader:(NSString *)strHeader{
//    _strHeader = strHeader;
//    if (self.strHeader.length) {
//        [_imgHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strHeader]] placeholderImage:[UIImage imageNamed:@"defualt_user"]];
//    } else {
//        _imgHeader.image = [UIImage imageNamed:@"defualt_user"];
//    }
//}
- (void)setIdCardModel:(MyIdCardModel *)idCardModel{
    _idCardModel = idCardModel;
    self.nameLabel.text = CHECK_STRING(_idCardModel.name);//姓名
    self.positionLabel.text = CHECK_STRING(_idCardModel.position);//职位
    self.companyLabel.text = CHECK_STRING(_idCardModel.title);//公司
    self.phoneLabel.text = CHECK_STRING(([NSString stringWithFormat:@"%@          %@",_idCardModel.mobilephone,_idCardModel.phone]));//电话
    self.emailLabel.text = CHECK_STRING(_idCardModel.email);//邮箱
    self.webLabel.text = CHECK_STRING(@"https://www.hfhomes.cn");//网址
    self.addressLabel.text = CHECK_STRING(_idCardModel.selfAdress);//地址
    self.imgQrcode.image = [QRCodeImage getQrImageWithBarcode:[NSString stringWithFormat:@"%@/html/register.html?tuiId=%@&flag=1",fyMainHomeUrl, USERDEFAULT(@"uid")] Size:WScale(55)];//个人二维码

    
   
    
  
    
//     [_imgFrontcard sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SharePictureUrl,[dicSource objectForKey:@"cardPositivePath"]]] placeholderImage:[UIImage imageNamed:@"icon_cardPositive.jpg"]];//正面名片

//
//     [imgBackcard sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SharePictureUrl,[dicSource objectForKey:@"cardOtherPath"]]] placeholderImage:[UIImage imageNamed:@"icon_cardOther.jpg"]];//背面名片

}


/**
 试图转成图片
 
 @param view 要转的试图
 @param size 尺寸
 @return 转成后图片返回
 */
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}



typedef void (^completion_t)(id result);

/**
 保存多张图片到本地相册
 
 @param images 数据源数组 (存的 image)
 @param completionHandler 保存后回调
 */
- (void)writeImages:(NSMutableArray*)images
         completion:(completion_t)completionHandler {
    if ([images count] == 0) {
        if (completionHandler) {
            // Signal completion to the call-site. Use an appropriate result,
            // instead of @"finished" possibly pass an array of URLs and NSErrors
            // generated below  in "handle URL or error".
            completionHandler(@"images are all saved.");
        }
        return;
    }
    UIImage* image = [images firstObject];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                    orientation:ALAssetOrientationUp
                                completionBlock:^(NSURL *assetURL, NSError *error){
                                    // Caution: check the execution context - it may be any thread,
                                    // possibly use dispatch_async to dispatch to the main thread or
                                    // any other queue.
                                    // handle URL or error
                                    if (error) {
                                        NSLog(@"error = %@", [error localizedDescription]);
                                        //                                        isImagesSavedFailed = true;
                                        return;
                                    }
                                    [images removeObjectAtIndex:0];
                                    // next image:
                                    [self writeImages:images completion:completionHandler];
                                }];
}
@end
