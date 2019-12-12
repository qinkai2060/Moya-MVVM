//
//  WARNewCreatFavriteView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import "WARNewCreatFavriteView.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"
#import "WARAlertView.h"
#import "WARProgressHUD.h"
#import "WARActionSheet.h"
#import "WARFavriteNetWorkTool.h"
#import "UIImageView+WebCache.h"
#import "WARProgressHUD.h"
#import "YYModel.h"
#import "WARMediator+Publish.h"
#define KScreeW [UIScreen mainScreen].bounds.size.width
@implementation WARNewCreatFavriteView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUi];
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.coverID = @"";
    }
    return self;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.textField) {
        
        NSString *toBeString = textField.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 10) {
                    textField.text = [toBeString substringToIndex:10];
                    [WARProgressHUD showAutoMessage:@"超过字数限制"];
                }
            }
            else{
                
            }
            
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [WARProgressHUD showAutoMessage:@"超过字数限制"];
            }
            
        }
        
    }
    
}
- (void)setCoverID:(NSString *)coverID {
    _coverID = coverID;
    [self.coverIconImg sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(30, 30),coverID) placeholderImage:[WARUIHelper war_defaultUserIcon]];
}

- (void)setUi {
    [self initSubViews];
    self.textField.frame = CGRectMake(10, 0, KScreeW- 20, 60);
    self.lineFirtV.frame = CGRectMake(10, CGRectGetMaxY(self.textField.frame), KScreeW- 20, 1);
    self.authlb.frame  = CGRectMake(10, CGRectGetMaxY(self.lineFirtV.frame), 70, 60);
    self.arrowsimgV.frame = CGRectMake(KScreeW-10-8, CGRectGetMaxY(self.lineFirtV.frame)+22, 8, 17);
    self.authNamelb.frame = CGRectMake(CGRectGetMinX(self.arrowsimgV.frame)-11-100, CGRectGetMaxY(self.lineFirtV.frame), 100, 60);
    self.lineSedV.frame = CGRectMake(10, CGRectGetMaxY(self.authlb.frame), KScreeW- 20, 1);
    self.pushAuthBtn.frame  = CGRectMake(0, CGRectGetMaxY(self.lineFirtV.frame), KScreeW, 60);
    
    
    self.coverLb.frame = CGRectMake(10, CGRectGetMaxY(self.lineSedV.frame), KScreeW- 80, 60);
    self.coverIconImg.frame = CGRectMake(CGRectGetMaxX(self.coverLb.frame)+5, CGRectGetMaxY(self.lineSedV.frame)+13, 34, 34);
    self.arrowsimgVTwo.frame = CGRectMake(KScreeW-10-8, CGRectGetMaxY(self.lineSedV.frame)+22, 8, 17);
    self.lineFourV.frame  = CGRectMake(10, CGRectGetMaxY(self.coverLb.frame), KScreeW- 20, 1);
    self.phototypelb.frame = CGRectMake(10, CGRectGetMaxY(self.lineFourV.frame), KScreeW- 20, 50);
    self.tagV.frame =  CGRectMake(15, CGRectGetMaxY(self.phototypelb.frame), KScreeW-30, 240);
    self.settingCoverBtn.frame  = CGRectMake(0, CGRectGetMaxY(self.lineSedV.frame), KScreeW, 60);
    CGFloat tabH =  WAR_IS_IPHONE_X ? 83:49;
   
    self.deletPhotoBtn.frame = CGRectMake(18, self.frame.size.height-60-tabH-67, KScreeW-36, 40);

}
- (void)initSubViews {
    [self addSubview:self.textField];
    [self addSubview:self.lineFirtV];
    [self addSubview:self.authlb];
    [self addSubview:self.lineSedV];
    [self addSubview:self.phototypelb];
    [self addSubview:self.arrowsimgV];
    [self addSubview:self.authNamelb];
    [self addSubview:self.pushAuthBtn];
    [self addSubview:self.deletPhotoBtn];
    [self addSubview:self.coverLb];
    [self addSubview:self.coverIconImg];
    [self addSubview:self.arrowsimgVTwo];
    [self addSubview:self.lineFourV];
    [self addSubview:self.tagV];
    [self addSubview:self.settingCoverBtn];
}
- (void)settingCoverClick:(UIButton*)btn {
    WS(weakself);
    [WARActionSheet actionSheetWithButtonTitles:@[WARLocalizedString(@"从相册选择图片")] cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if (index == 0) {
            if (weakself.block) {
                weakself.block();
            }
        }
     
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } completionHandler:^{
        
    }];
}
- (void)pushClick:(UIButton*)btn {
    if (self.authBlock) {
        self.authBlock(self.authNamelb.text);
    }
}
- (void)deletClick:(UIButton*)btn {
    NSString *type = @"";
    if(!self.tagV.selectBtn) {
        type = @"普通";
    }else{
        type = self.tagV.selectBtn.currentTitle;
    }
      UIViewController *vc = [self currentVC:self];
    if (self.textField.text.length == 0) {
        self.textField.text = @"未命名";
    }
    if (self.favoriteID) {
        [self editingFavrite:type];
    }else {
        [self creatFavirite:type];
    }

}
- (void)editingFavrite:(NSString*)type {
    UIViewController *vc = [self currentVC:self];
    if(!self.tagV.selectBtn) {
        type = self.model.favoriteType;
    }
    if (![self.model.favoriteCover isEqualToString: self.coverID] ||![self.model.favoriteName isEqualToString: self.textField.text] ||![self.model.permission isEqualToString: [self accessPermission:self.authNamelb.text]]||![self.model.favoriteType isEqualToString: type]) {
        
        [WARFavriteNetWorkTool putFavriteEditingWithFavoriteId:self.favoriteID byParams:@{@"favoriteCover":self.coverID,@"favoriteName":self.textField.text,@"favoriteType":type,@"permission":[self accessPermission:self.authNamelb.text]} callback:^(id response) {
            [WARProgressHUD showSuccessMessage:@"修改成功"];
            [vc.navigationController popViewControllerAnimated:YES];
        } failer:^(id response) {
            [WARProgressHUD showErrorMessage:@"修改失败"];
        }];
    }
    
    [vc.navigationController popViewControllerAnimated:YES];
}
- (void)creatFavirite :(NSString*)type {
    UIViewController *vc = [self currentVC:self];
    [WARFavriteNetWorkTool postFavriteCreatWithParams:@{@"favoriteCover":self.coverID,@"favoriteName":self.textField.text,@"favoriteType":type,@"permission":[self accessPermission:self.authNamelb.text]} callback:^(id response) {
        //            WARFavoriteInfoModel *model = [WARFavoriteInfoModel yy_modelWithDictionary:response];
        [WARProgressHUD showSuccessMessage:@"创建成功"];
        if (self.type != 2) {
            [vc.navigationController popViewControllerAnimated:YES];
        }else{
            NSDictionary *dictID =    response  ;
            UIViewController *publishVC = [[WARMediator sharedInstance] Mediator_viewControllerForBookmarksEditBoardVC:self.url bookmarkId:dictID[@"favoriteId"]];
            
            [vc.navigationController pushViewController:publishVC animated:YES];
        }
        
    } failer:^(id response) {
        [WARProgressHUD showErrorMessage:@"创建失败"];
    }];
}
- (void)setModel:(WARFavoriteInfoModel *)model {
    _model = model;
    self.textField.text = model.favoriteName;
    self.authNamelb.text = [self accessTransefer:model.permission];
    [self.coverIconImg sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(30, 30),model.favoriteCover) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.tagV settingTagStr:model.favoriteType];
    self.favoriteID = model.favoriteId;
    self.coverID  = model.favoriteCover;
    self.originmodel = model;
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
- (NSString*)accessPermission:(NSString*)accessPermission {
    if ([accessPermission isEqualToString:@"所有人"]) {
        return @"ALL";
    }else if ([accessPermission isEqualToString:@"好友"]) {
        return @"FRIEND";
    }else{
        return @"ONLY_SELF";
    }
}
- (NSString *)accessTransefer:(NSString*)permission {
    if ([permission isEqualToString:@"ALL"]) {
        return @"所有人";
    }else if ([permission isEqualToString:@"FRIEND"]) {
        return @"好友";
    }else{
        return @"仅自己可见";
    }
}
- (UIImageView *)arrowsimgVTwo {
    if (!_arrowsimgVTwo) {
        _arrowsimgVTwo = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"accessory" curClass:[self class] curBundle:@"WARControl.bundle"]];
    }
    return _arrowsimgVTwo;
}
- (UILabel *)coverLb {
    if(!_coverLb){
        _coverLb = [[UILabel alloc] init];
        _coverLb.text = WARLocalizedString(@"封面设置");
        _coverLb.textColor = TextColor;
        _coverLb.font = [UIFont systemFontOfSize:15];
    }
    return _coverLb;
}
- (UIImageView *)coverIconImg {
    if (!_coverIconImg) {
        _coverIconImg = [[UIImageView alloc] initWithImage:[WARUIHelper war_defaultUserIcon]];
        _coverIconImg.contentMode =  UIViewContentModeScaleAspectFill;
        _coverIconImg.clipsToBounds = YES;
        _coverIconImg.layer.cornerRadius = 3;
        _coverIconImg.layer.masksToBounds = YES;
        _coverIconImg.backgroundColor = [UIColor redColor];
        
    }
    return _coverIconImg;
}
- (UIView *)lineFourV {
    if (!_lineFourV) {
        _lineFourV = [[UIView alloc] init];
        _lineFourV.backgroundColor = SeparatorColor;
    }
    return _lineFourV;
}
- (UIButton *)settingCoverBtn {
    if (!_settingCoverBtn){
        _settingCoverBtn = [[UIButton alloc] init];
        _settingCoverBtn.backgroundColor = [UIColor clearColor];
        [_settingCoverBtn addTarget:self action:@selector(settingCoverClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingCoverBtn;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = TextColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:17];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:WARLocalizedString(@"填写书册名称") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        _textField.attributedPlaceholder = string;
    }
    return _textField;
}
- (UIView *)lineFirtV {
    if (!_lineFirtV) {
        _lineFirtV = [[UIView alloc] init];
        _lineFirtV.backgroundColor = SeparatorColor;
    }
    return _lineFirtV;
}
- (UILabel *)authlb {
    if(!_authlb){
        _authlb = [[UILabel alloc] init];
        _authlb.text = WARLocalizedString(@"权限设置");
        _authlb.textColor = [UIColor blackColor];
        _authlb.font = [UIFont systemFontOfSize:15];
    }
    return _authlb;
}
- (UIImageView *)arrowsimgV {
    if (!_arrowsimgV) {
        _arrowsimgV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"accessory" curClass:[self class] curBundle:@"WARControl.bundle"]];
    }
    return _arrowsimgV;
}
- (UILabel *)authNamelb {
    if(!_authNamelb){
        _authNamelb = [[UILabel alloc] init];
        _authNamelb.text = WARLocalizedString(@"所有人");
        _authNamelb.textColor = SubTextColor;
        _authNamelb.font = [UIFont systemFontOfSize:15];
        _authNamelb.textAlignment = NSTextAlignmentRight;
    }
    return _authNamelb;
}
- (UIButton *)pushAuthBtn {
    if (!_pushAuthBtn){
        _pushAuthBtn = [[UIButton alloc] init];
        _pushAuthBtn.backgroundColor = [UIColor clearColor];
        [_pushAuthBtn addTarget:self action:@selector(pushClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushAuthBtn;
}
- (UIView *)lineSedV{
    if (!_lineSedV) {
        _lineSedV = [[UIView alloc] init];
        _lineSedV.backgroundColor = SeparatorColor;
    }
    return _lineSedV;
}
- (UILabel *)phototypelb {
    if(!_phototypelb){
        _phototypelb = [[UILabel alloc] init];
        _phototypelb.text = WARLocalizedString(@"书册类型");
        _phototypelb.textColor = [UIColor blackColor];
        _phototypelb.font = [UIFont systemFontOfSize:15];
    }
    return _phototypelb;
}


- (WARFavriteTagView *)tagV {
    if (!_tagV) {
        _tagV = [[WARFavriteTagView alloc] initWithFrame:CGRectMake(15, 0, KScreeW-30, 240) dataArr:@[@"",@"普通",@"亲子",@"旅游",@"情侣"]];
        _tagV.backgroundColor = [UIColor whiteColor];
    }
    return _tagV;
}

- (UIButton *)deletPhotoBtn{
    if (!_deletPhotoBtn) {
        _deletPhotoBtn = [[UIButton alloc] init];
        [_deletPhotoBtn setTitle:WARLocalizedString(@"完成") forState:UIControlStateNormal];
        [_deletPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deletPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _deletPhotoBtn.backgroundColor = ThemeColor;
        [_deletPhotoBtn addTarget:self action:@selector(deletClick:) forControlEvents:UIControlEventTouchUpInside];
        _deletPhotoBtn.layer.cornerRadius = 3;
        _deletPhotoBtn.layer.masksToBounds = YES;
        
    }
    return _deletPhotoBtn;
}
@end
