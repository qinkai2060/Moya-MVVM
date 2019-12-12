//
//  WARCreatEditPhotoView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import "WARCreatEditPhotoView.h"
#import "Masonry.h"
#import "WARTagView.h"
#import "WARMacros.h"
//#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARProfileNetWorkTool.h"
#import "WARProgressHUD.h"
#import "WARGroupModel.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARProgressHUD.h"
#import "WARConfigurationMacros.h"
#define KScreeW [UIScreen mainScreen].bounds.size.width
@implementation WARCreatEditPhotoView

- (instancetype)initWithType:(WARCreatEditPhotoViewType)type{
    if (self = [super init]) {
        self.type = type;
        [self setUi];
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (void)textFieldDidChange:(UITextField *)textField
{
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
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
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
- (void)setUi{
    [self addSubview:self.textField];
    [self addSubview:self.lineFirtV];
    [self addSubview:self.authlb];
    [self addSubview:self.lineSedV];
    [self addSubview:self.phototypelb];
    [self addSubview:self.lineThirdV];
    [self addSubview:self.arrowsimgV];
    [self addSubview:self.authNamelb];
    [self addSubview:self.pushAuthBtn];
    [self addSubview:self.unloadBtn];
    [self addSubview:self.finshBtn];
    [self addSubview:self.deletPhotoBtn];
    [self addSubview:self.coverLb];
    [self addSubview:self.coverIconImg];
    [self addSubview:self.arrowsimgVTwo];
    [self addSubview:self.lineFourV];
    [self addSubview:self.tagV];
    [self addSubview:self.settingCoverBtn];
    
    self.textField.frame = CGRectMake(10, 0, KScreeW- 20, 60);
    self.lineFirtV.frame = CGRectMake(10, CGRectGetMaxY(self.textField.frame), KScreeW- 20, 1);
    self.authlb.frame  = CGRectMake(10, CGRectGetMaxY(self.lineFirtV.frame), 70,  60);
    self.arrowsimgV.frame = CGRectMake(KScreeW-10-8, CGRectGetMaxY(self.lineFirtV.frame)+22, 8, 17);
    self.authNamelb.frame = CGRectMake(CGRectGetMinX(self.arrowsimgV.frame)-11-100, CGRectGetMaxY(self.lineFirtV.frame), 100, 60);
    self.lineSedV.frame = CGRectMake(10, CGRectGetMaxY(self.authlb.frame), KScreeW- 20, 1);
    self.pushAuthBtn.frame  = CGRectMake(0, CGRectGetMaxY(self.lineFirtV.frame), KScreeW,  60);


    if (self.type == WARCreatEditPhotoViewTypeEditing) {
        self.coverLb.frame = CGRectMake(10, CGRectGetMaxY(self.lineSedV.frame), KScreeW- 80,  60);
        self.coverIconImg.frame = CGRectMake(CGRectGetMaxX(self.coverLb.frame)+5, CGRectGetMaxY(self.lineSedV.frame)+13, 34, 34);
        self.arrowsimgVTwo.frame = CGRectMake(KScreeW-10-8, CGRectGetMaxY(self.lineSedV.frame)+22, 8, 17);
        self.lineFourV.frame  = CGRectMake(10, CGRectGetMaxY(self.coverLb.frame), KScreeW- 20, 1);
        self.phototypelb.frame = CGRectMake(10, CGRectGetMaxY(self.lineFourV.frame), KScreeW- 20,  60);
        self.lineThirdV.frame  = CGRectMake(10, CGRectGetMaxY(self.phototypelb.frame), KScreeW- 20, 1);
        self.tagV.frame =  CGRectMake(15, CGRectGetMaxY(self.lineThirdV.frame), KScreeW-30, 80);
        self.settingCoverBtn.frame  = CGRectMake(0, CGRectGetMaxY(self.lineSedV.frame), KScreeW,  60);

    }else{
        self.arrowsimgVTwo.frame = CGRectZero;
        self.settingCoverBtn.frame  = CGRectZero;
        self.phototypelb.frame = CGRectMake(10, CGRectGetMaxY(self.lineSedV.frame), KScreeW- 20,  60);
        self.lineThirdV.frame  = CGRectMake(10, CGRectGetMaxY(self.phototypelb.frame), KScreeW- 20, 1);
        self.tagV.frame =  CGRectMake(15, CGRectGetMaxY(self.lineThirdV.frame), KScreeW-30, 80);
    }
    self.lineThirdV.hidden = YES;
    self.unloadBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tagV.frame), 45, 20);
    self.unloadBtn.hidden = YES;
    CGPoint center = self.unloadBtn.center;
    center.x = KScreeW*0.5;
    self.unloadBtn.center = center;
    self.finshBtn.frame = CGRectMake(10, CGRectGetMaxY(self.unloadBtn.frame)+20, KScreeW-20, 40);
    CGFloat btnW =  kScreenWidth- 70-40;
    self.deletPhotoBtn.frame = CGRectMake(10, CGRectGetMaxY(self.unloadBtn.frame)+20, KScreeW-20, 40);

    if (self.type == WARCreatEditPhotoViewTypeEditing) {
     
         self.deletPhotoBtn.hidden = NO;
         self.finshBtn.hidden = YES;
    }else{

        self.deletPhotoBtn.hidden = YES;
        self.finshBtn.hidden = NO;
    }
}
- (void)moreClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        
        self.tagV.frame = CGRectMake(15, CGRectGetMaxY(self.lineThirdV.frame), KScreeW-30, 74.5);
        
    }else{ 
        self.tagV.frame = CGRectMake(15, CGRectGetMaxY(self.lineThirdV.frame), KScreeW-30, 80);
    }
    for (UIButton *btn in self.tagV.subviews) {
        if (btn.tag>100 && btn.frame.origin.y >30) {
            btn.hidden = !btn.hidden;
        }
    }
    self.unloadBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tagV.frame), 45, 20);
    CGPoint center = self.unloadBtn.center;
    center.x = KScreeW*0.5;
    self.unloadBtn.center = center;
    self.finshBtn.frame = CGRectMake(10, CGRectGetMaxY(self.unloadBtn.frame)+40, KScreeW-20, 40);
    CGFloat btnW =  kScreenWidth- 70-40;
    self.deletPhotoBtn.frame = CGRectMake(10, CGRectGetMaxY(self.unloadBtn.frame)+40,  KScreeW-20, 40);

}
- (void)editingGroupInfoModel:(WARGroupModel *)model{
    self.Editingmodel = model;
    self.textField.text = model.name;
    self.authNamelb.text =[self showAccessName: model.accessPermission];
    [self.tagV settingTagStr:model.type];
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self.coverIconImg sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(34 , 34),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(34 , 34))];
    }else{
        [self.coverIconImg sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(34 , 34),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(34 , 34))];
    }

}
- (void)finshCreatClick:(UIButton*)btn{
    NSString *type = @"";
    if(!self.tagV.selectBtn) {
        type = @"普通";
    }else{
        type = self.tagV.selectBtn.currentTitle;
    }
    btn.userInteractionEnabled = NO;
    if (self.textField.text.length == 0) {
        self.textField.text = @"未命名";
    }
    WS(weakself);
    NSDictionary *params = @{@"accessPermission":[self accessPermission:self.authNamelb.text],@"name":self.textField.text,@"type":type};
    [WARProfileNetWorkTool postCreatPhoto:params CallBack:^(id response) {
        
        NSString *coverid = response[@"albumId"];
        WARGroupModel *model = [[WARGroupModel alloc] init];
        model.isMine = YES;
        [model praseData:response];
//        if (coverid.length == 0) {
//            return ;
//        }
        if (weakself.pushBlock) {
            weakself.pushBlock(model);
        }
    } failer:^(id response) {
              [WARProgressHUD showAutoMessage:@"创建失败"];
    }];
   
    
}
- (NSString*)showAccessName:(NSString*)accessPermission{
    if ([accessPermission isEqualToString:@"ALL"]) {
        return @"所有人";
    }else if ([accessPermission isEqualToString:@"RELATIVE"]){
        return @"好友";
    }else{
        return @"仅自己可见";
    }
}
// ALL, // 所有人 RELATIVE, // 好友 ONLY_SELF, // 仅自己 @[@"所有人",@"好友",@"仅自己可见"]
- (NSString*)accessPermission:(NSString*)accessPermission{
    if ([accessPermission isEqualToString:@"所有人"]) {
        return @"ALL";
    }else if ([accessPermission isEqualToString:@"好友"]){
        return @"RELATIVE";
    }else{
        return @"ONLY_SELF";
    }
}
- (void)deletClick:(UIButton*)btn{
    // 删除接口
    WS(weakself);
    [WARProfileNetWorkTool deletPhotoGroupId:self.Editingmodel.albumId CallBack:^(id response) {
        [WARProgressHUD showMessageToWindow:@"删除成功"];
         [WARProgressHUD hideHUD];
        if (weakself.deleteBlock) {
            weakself.deleteBlock();
        }
    } failer:^(id response) {
           [WARProgressHUD showMessageToWindow:@"删除失败"];
         [WARProgressHUD hideHUD];
    }];
}
- (void)sureClick:(UIButton*)btn{
 
}
- (void)pushClick:(UIButton*)btn{
    if (self.authBlock) {
        self.authBlock(self.authNamelb.text);
    }
}
- (void)settingCoverClick:(UIButton*)btn{

    if (self.EditingCoverBlock) {
        self.EditingCoverBlock();
    }
 
}
- (UIImageView *)arrowsimgVTwo{
    if (!_arrowsimgVTwo) {
        _arrowsimgVTwo = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"accessory" curClass:self curBundle:@"WARControl.bundle"]];
    }
    return _arrowsimgVTwo;
}
- (UILabel *)coverLb{
    if(!_coverLb){
        _coverLb = [[UILabel alloc] init];
        _coverLb.text = WARLocalizedString(@"更换封面");
        _coverLb.textColor = TextColor;
        _coverLb.font = [UIFont systemFontOfSize:15];
    }
    return _coverLb;
}
- (UIImageView *)coverIconImg{
    if (!_coverIconImg) {
        _coverIconImg = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"initial_background_f" curClass:[self class] curBundle:@"WARGeneral.bundle"]];
        _coverIconImg.contentMode =  UIViewContentModeScaleAspectFill;
        _coverIconImg.clipsToBounds = YES;
        _coverIconImg.layer.cornerRadius = 3;
        _coverIconImg.layer.masksToBounds = YES;
        
    }
    return _coverIconImg;
}
- (UIView *)lineFourV{
    if (!_lineFourV) {
        _lineFourV = [[UIView alloc] init];
        _lineFourV.backgroundColor = SeparatorColor;
    }
    return _lineFourV;
}
- (UIButton *)settingCoverBtn{
    if (!_settingCoverBtn){
        _settingCoverBtn = [[UIButton alloc] init];
        _settingCoverBtn.backgroundColor = [UIColor clearColor];
        [_settingCoverBtn addTarget:self action:@selector(settingCoverClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingCoverBtn;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = TextColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      //  _textField.placeholder =WARLocalizedString(@"填写相册名称");
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:WARLocalizedString(@"填写相册名称") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _textField.attributedPlaceholder = string;
    }
    return _textField;
}
- (UIView *)lineFirtV{
    if (!_lineFirtV) {
        _lineFirtV = [[UIView alloc] init];
        _lineFirtV.backgroundColor = SeparatorColor;
    }
    return _lineFirtV;
}
- (UILabel *)authlb{
    if(!_authlb){
        _authlb = [[UILabel alloc] init];
        _authlb.text = WARLocalizedString(@"权限设置");
        _authlb.textColor = TextColor;
        _authlb.font = [UIFont systemFontOfSize:15];
    }
    return _authlb;
}
- (UIImageView *)arrowsimgV{
    if (!_arrowsimgV) {
        _arrowsimgV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"accessory" curClass:self curBundle:@"WARControl.bundle"]];
    }
    return _arrowsimgV;
}
- (UILabel *)authNamelb{
    if(!_authNamelb){
        _authNamelb = [[UILabel alloc] init];
        _authNamelb.text = WARLocalizedString(@"所有人");
        _authNamelb.textColor = SubTextColor;
        _authNamelb.font = [UIFont systemFontOfSize:15];
        _authNamelb.textAlignment = NSTextAlignmentRight;
    }
    return _authNamelb;
}
- (UIButton *)pushAuthBtn{
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
- (UILabel *)phototypelb{
    if(!_phototypelb){
        _phototypelb = [[UILabel alloc] init];
        _phototypelb.text = WARLocalizedString(@"相册类型");
        _phototypelb.textColor = TextColor;
        _phototypelb.font = [UIFont systemFontOfSize:15];
    }
    return _phototypelb;
}
- (UIView *)lineThirdV{
    if (!_lineThirdV) {
        _lineThirdV = [[UIView alloc] init];
        _lineThirdV.backgroundColor = SeparatorColor;
    }
    return _lineThirdV;
}

- (WARTagView *)tagV{
    if (!_tagV) {
        _tagV = [[WARTagView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lineThirdV.frame), KScreeW-30, 80) dataArr:@[@"普通",@"亲子",@"旅游",@"情侣"] atType:WARTagViewViewTypeDefualt];
        _tagV.backgroundColor = [UIColor whiteColor];
    }
    return _tagV;
}
- (UIButton *)unloadBtn{
    if (!_unloadBtn) {
        _unloadBtn = [[UIButton alloc] init];
        [_unloadBtn setImage:[UIImage war_imageName:@"rankinglist_more" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_unloadBtn setImage:[UIImage war_imageName:@"rankinglist_up" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
        [_unloadBtn addTarget: self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unloadBtn;
}
- (UIButton *)finshBtn{
    if (!_finshBtn) {
        _finshBtn = [[UIButton alloc] init];
        [_finshBtn setTitle:WARLocalizedString(@"完成创建") forState:UIControlStateNormal];
        [_finshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finshBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _finshBtn.backgroundColor = ThemeColor;
        [_finshBtn addTarget:self action:@selector(finshCreatClick:) forControlEvents:UIControlEventTouchUpInside];
        _finshBtn.layer.cornerRadius = 3;
        _finshBtn.layer.masksToBounds = YES;
        
    }
    return _finshBtn;
}

- (UIButton *)deletPhotoBtn{
    if (!_deletPhotoBtn) {
        _deletPhotoBtn = [[UIButton alloc] init];
        [_deletPhotoBtn setTitle:WARLocalizedString(@"删除相册") forState:UIControlStateNormal];
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
