//
//  WARProfileHeaderDetailView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/20.
//

#import "WARProfileHeaderDetailView.h"
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "WARMacros.h"
#import "WARUIHelper.h"
#import "UIColor+WARCategory.h"
#import "WARMediator+Contacts.h"
#import "WARMediator+User.h"
#import "WARMediator+UserEditor.h"
#import "WARMediator+Publish.h"
#import "WARProfileDataCenterViewController.h"
#import "WARTestViewController.h"
#import "WARPhotoBrowserModel.h"
#import "WARPhotoBrowser.h"
#import "UIView+BlockGesture.h"
@implementation WARProfileHeaderDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [WARUIHelper war_placeholderBackground];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self addSubview:self.maskView];
    [self addSubview:self.signBtn];
    [self addSubview:self.enterDataInfoBtn];
    [self addSubview:self.scoreLb];
    [self addSubview:self.homelb];
    [self addSubview:self.agelb];
    [self addSubview:self.genderBtn];
    [self addSubview:self.nickNamelb];
    [self addSubview:self.editBtn];
    [self addSubview:self.borderView];
    [self addSubview:self.publish];
    [self addSubview:self.iconView];
    [self addSubview:self.accoutlb];
    
}
- (void)setModel:(WARProfileUserModel *)model {
    _model = model;
             self.publish.hidden = NO;
             self.cameraBtn.hidden = NO;
             self.editBtn.hidden = NO;
             self.isMine = YES;
             self.accoutlb.text = model.accNum.length == 0 ?@"":[NSString stringWithFormat:@"账号:%@",model.accNum];
    for (WARProfileMasksModel *maskModel in model.masks) {
        if (maskModel.defaults) {
            self.defaultModel = maskModel;
            [self sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(self.bounds.size.width, 190), maskModel.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
            [self.iconView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(65, 65), maskModel.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];

           NSShadow *shadow = [[NSShadow alloc]init];
           shadow.shadowBlurRadius = 0.5;
           shadow.shadowOffset = CGSizeMake(1, 1);
           shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
           NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:maskModel.nickname attributes:@{NSForegroundColorAttributeName:UIColorWhite,NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSShadowAttributeName:shadow}];
            self.nickNamelb.attributedText = attributedString;
            if (maskModel.city.length != 0) {
                if ([maskModel.city isEqualToString:@"市辖区"]) {
                    self.homelb.text = WARLocalizedString(maskModel.province);
                }else{
                     self.homelb.text = WARLocalizedString(maskModel.city);
                }
                
                CGSize homeSize =  [self.homelb.text boundingRectWithSize:CGSizeMake(60, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(10)} context:nil].size;
                self.homelb.frame = CGRectMake(CGRectGetMaxX(self.scoreLb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, homeSize.width+5, 17);
                self.agelb.frame = CGRectMake(CGRectGetMaxX(self.homelb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
            }else{
                self.homelb.frame = CGRectZero;
                self.agelb.frame = CGRectMake(CGRectGetMaxX(self.scoreLb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
                
            }
    
            self.genderBtn.frame = CGRectMake(CGRectGetMaxX(self.agelb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
            self.genderBtn.image = [WARUIHelper war_constellationImgWithMonth:[maskModel.month integerValue] day:[maskModel.day integerValue] gender:maskModel.gender];
            NSString *ageStr = [WARUIHelper war_birthdayToAge:maskModel.year month:maskModel.month day:maskModel.day];
            self.agelb.text = ageStr;
            if (ageStr.length) {
                self.agelb.hidden = NO;
                self.agelb.backgroundColor = [WARUIHelper ageBgColorByGender:maskModel.gender];
            }else {
                self.agelb.hidden = YES;
            }
            self.genderBtn.hidden = self.agelb.hidden;
            self.signBtn.text = maskModel.signature;
            break;
        }
    }
    
}
- (void)setOtherModel:(WARProfileUserModel *)otherModel {
    _otherModel = otherModel;
       self.isMine = NO;
       [self sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(self.bounds.size.width, 190), otherModel.guyMask.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
       [self.iconView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(65, 65), otherModel.guyMask.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowBlurRadius = 0.5;
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    if (otherModel.guyMask.nickname) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:otherModel.guyMask.nickname attributes:@{NSForegroundColorAttributeName:UIColorWhite,NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSShadowAttributeName:shadow}];
        self.nickNamelb.attributedText = attributedString;
    }
    if (otherModel.guyMask.city.length != 0) {
        if ([otherModel.guyMask.city isEqualToString:@"市辖区"]) {
            self.homelb.text = WARLocalizedString(otherModel.guyMask.province);
        }else{
            self.homelb.text = WARLocalizedString(otherModel.guyMask.city);
        }
        CGSize homeSize =  [self.homelb.text boundingRectWithSize:CGSizeMake(60, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(10)} context:nil].size;
        self.homelb.frame = CGRectMake(CGRectGetMaxX(self.scoreLb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, homeSize.width+5, 17);
        self.agelb.frame = CGRectMake(CGRectGetMaxX(self.homelb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
    }else{
        self.homelb.frame = CGRectZero;
        self.agelb.frame = CGRectMake(CGRectGetMaxX(self.scoreLb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
        
    }
       self.genderBtn.frame = CGRectMake(CGRectGetMaxX(self.agelb.frame)+4, CGRectGetMaxY(self.nickNamelb.frame)+8, 17, 17);
       self.genderBtn.image = [WARUIHelper war_constellationImgWithMonth:[otherModel.guyMask.month integerValue] day:[otherModel.guyMask.day integerValue] gender:otherModel.guyMask.gender];
       NSString *ageStr = [WARUIHelper war_birthdayToAge:otherModel.guyMask.year month:otherModel.guyMask.month day:otherModel.guyMask.day];
       self.agelb.text = ageStr;
    if (ageStr.length) {
        self.agelb.hidden = NO;
        self.agelb.backgroundColor = [WARUIHelper ageBgColorByGender:otherModel.guyMask.gender];
    }else {
        self.agelb.hidden = YES;
    }
       self.genderBtn.hidden = self.agelb.hidden;
       self.signBtn.text = otherModel.guyMask.signature;
}
- (void)setIsOherWindow:(BOOL)isOherWindow {
    _isOherWindow = isOherWindow;
    if (isOherWindow) {
        CGFloat navH =   WAR_IS_IPHONE_X ? (36+24):36;
        self.accoutlb.frame = CGRectMake(65, navH, [self.accoutlb sizeThatFits:CGSizeMake(120, 25)].width, 25);
    }
}
- (void)enterDataInfoClick:(id)sender {
    UIViewController *vc  = [self currentVC:self];
    WARProfileDataCenterViewController *dataCenterVC = [[WARProfileDataCenterViewController alloc] init];
    if (self.isMine) {
        dataCenterVC.maskModel = self.defaultModel;
    }else{
        dataCenterVC.maskModel = self.otherModel.guyMask;
    }
    [vc.navigationController pushViewController:dataCenterVC animated:YES];
}
- (void)editBtnClick:(id)sender {
    if (self.didPushToEditVC) {
        self.didPushToEditVC();
    }
}
- (void)publishClick:(id)sender {
      UIViewController *vc  = [self currentVC:self];
      [vc.navigationController pushViewController: [[WARMediator sharedInstance] Mediator_viewControllerForProfileDiaryEditBoard] animated:YES];

}
- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}

- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        _maskView.image = [UIImage war_imageName:@"personalinformation_shadow" curClass:self curBundle:@"WARProfile.bundle"];
    }
    return _maskView;
}
- (UIImageView *)borderView {
    if (!_borderView) {
        _borderView = [[UIImageView alloc] initWithFrame:self.bounds];
        _borderView.image =   [UIImage war_imageName:@"pic_bg" curClass:self curBundle:@"WARProfile.bundle"];
        _borderView.frame = CGRectMake(10, CGRectGetMinY(self.nickNamelb.frame)-5-69, 69, 69);
    }
    return _borderView;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
         _iconView.frame = CGRectMake(12, self.borderView.frame.origin.y+2, 65, 65);
        _iconView.image = [WARUIHelper war_defaultGroupIcon];
        _iconView.userInteractionEnabled = YES;
        [_iconView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
            WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
            NSString *imageId = @"";
            for (WARProfileMasksModel *maskModel in self.model.masks) {
                if (maskModel.defaults) {
                    imageId = maskModel.faceImg;
                }
            }
            NSString *imageUrl = (self.model.masks.count == 0 ?self.otherModel.guyMask.faceImg :imageId);
            photoBrowserModel.picUrl = [kCMPRPhotoUrl(imageUrl) absoluteString];
            [tempArray addObject:photoBrowserModel];
            WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
            photoBrowser.placeholderImage = self.iconView.image;
            photoBrowser.photoArray = tempArray;
            photoBrowser.currentIndex = 0;
            [photoBrowser show];
        }];
    }
    return _iconView;
}

- (UILabel *)nickNamelb {
    if (!_nickNamelb) {
        
        _nickNamelb = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(self.scoreLb.frame)-8-17, kScale_iphone5*204, 17)];
        _nickNamelb.font = [UIFont boldSystemFontOfSize:17];
        _nickNamelb.textColor = UIColorWhite;
        _nickNamelb.text = WARLocalizedString(@"上海市");
  
    }
    return _nickNamelb;
}
- (UILabel *)scoreLb {
    if (!_scoreLb) {
        _scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(self.signBtn.frame)-8-17, 36, 17)];
        _scoreLb.textColor = UIColorWhite;
        _scoreLb.font = kFont(10);
        _scoreLb.text = WARLocalizedString(@"LV22");
        _scoreLb.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" opacity:0.4];
        _scoreLb.layer.cornerRadius = 4;
        _scoreLb.layer.masksToBounds = YES;
         _scoreLb.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLb;
}
- (UILabel *)homelb {
    if (!_homelb) {
        _homelb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scoreLb.frame)+4, CGRectGetMinY(self.signBtn.frame)-8-17, 36, 17)];
        _homelb.textColor = UIColorWhite;
        _homelb.font = kFont(10);
        _homelb.text = WARLocalizedString(@"上海市");
        _homelb.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" opacity:0.4];
        _homelb.layer.cornerRadius = 4;
        _homelb.layer.masksToBounds = YES;
        _homelb.textAlignment = NSTextAlignmentCenter;
    }
    return _homelb;
}
- (UILabel *)agelb {
    if (!_agelb) {
          _agelb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.homelb.frame)+4, CGRectGetMinY(self.signBtn.frame)-8-17, 17, 17)];
        _agelb.textColor = UIColorWhite;
        _agelb.font = kFont(10);
        _agelb.text = WARLocalizedString(@"23");
        _agelb.backgroundColor = [WARUIHelper ageBgColorByGender:@"F"];
        _agelb.layer.cornerRadius = 4;
        _agelb.layer.masksToBounds = YES;
        _agelb.textAlignment = NSTextAlignmentCenter;

    }
    return _agelb;
}
- (UIImageView *)genderBtn {
    if (!_genderBtn) {
        _genderBtn = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.agelb.frame)+4, CGRectGetMinY(self.signBtn.frame)-8-17, 17, 17)];
        _genderBtn.image =  [WARUIHelper war_constellationImgWithMonth:[@"09" integerValue] day:[@"05" integerValue] gender:@"F"];
        _genderBtn.backgroundColor = [WARUIHelper ageBgColorByGender:@"M"];
        _genderBtn.layer.cornerRadius = 4;
        _genderBtn.layer.masksToBounds = YES;
    }
    return _genderBtn;
}
- (UILabel *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UILabel alloc] initWithFrame:CGRectMake(10,  CGRectGetHeight(self.frame)-15-30-35, kScale_iphone6*235, 15)];
        _signBtn.textColor = UIColorWhite;
        _signBtn.font = kFont(14);
        _signBtn.text = WARLocalizedString(@"上海市");
        _signBtn.layer.cornerRadius = 4;
        _signBtn.layer.masksToBounds = YES;
    }
    return _signBtn;
}
- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        _cameraBtn.frame = CGRectMake(kScreenWidth-39*kScale_iphone6-35,  kStatusBarAndNavigationBarHeight+50, 35, 35);
        [_cameraBtn setImage:[UIImage war_imageName:@"homepage_carema2" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn.hidden = YES;
        CGPoint center = _cameraBtn.center;
        center.y = self.borderView.center.y;
        _cameraBtn.center = center;
    }
    return _cameraBtn;
}
- (UIButton *)publish {
    if (!_publish) {
        _publish = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-72, 0, 72, 35)];
        CGPoint center = _publish.center;
        center.y = self.borderView.center.y;
        _publish.center = center;
        [_publish setImage:[UIImage war_imageName:@"sent" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        _publish.hidden = YES;
          [_publish addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _publish;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setImage:[UIImage war_imageName:@"comment22" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        _editBtn.frame = CGRectMake(kScreenWidth-28-7, 0, 28, 28);
        CGPoint center = _editBtn.center;
        center.y = self.nickNamelb.center.y;
        _editBtn.center = center;
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.hidden = YES;
    }
    return _editBtn;
}
- (UIButton *)enterDataInfoBtn {
    if (!_enterDataInfoBtn) {
        _enterDataInfoBtn = [[UIButton alloc] init];
        [_enterDataInfoBtn setImage:[UIImage war_imageName:@"arrow_open2" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        _enterDataInfoBtn.frame = CGRectMake(kScreenWidth-28-7, 0, 28, 28);
        CGPoint center = _enterDataInfoBtn.center;
        center.y = self.signBtn.center.y;
        _enterDataInfoBtn.center = center;
        [_enterDataInfoBtn addTarget:self action:@selector(enterDataInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterDataInfoBtn;
}
- (UILabel *)accoutlb {
    if (!_accoutlb) {
        _accoutlb  = [[UILabel alloc] init];
        _accoutlb.textColor = [UIColor whiteColor];
        _accoutlb.font = [UIFont systemFontOfSize:14];
        CGFloat navH =   WAR_IS_IPHONE_X ? (36+24):36;
        _accoutlb.frame = CGRectMake(43, navH-8, 103, 25);

    }
    return _accoutlb;
}
@end
