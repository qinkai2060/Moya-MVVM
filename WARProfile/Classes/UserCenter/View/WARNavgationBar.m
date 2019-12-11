//
//  WARNavgationBar.m
//  Pods
//
//  Created by 秦恺 on 2018/1/30.
//

#import "WARNavgationBar.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "UIView+WARFrame.h"
#import "WARImagePickerController.h"
#import "WARConst.h"
#import "WARDBUserManager.h"
#import "WARMediator+UserEditor.h"
//#import "WARTweetTool.h"
#import "WARUserSettingsViewController.h"
#import "WARConfigurationMacros.h"
#import "WARProfileOtherViewController.h"
#import "WARMediator+Contacts.h"
#import "WARMediator+User.h"
#import "WARTestViewController.h"
#import "WARFavriteGenarlView.h"
#import "WARUIHelper.h"
#import "WARFavriteShowViewController.h"
#define TweetProfileGetImage(name, className)  [UIImage war_imageName:name curClass:className.class curBundle:@"WARProfile.bundle"]
@interface WARNavgationBar ()

@end
@implementation WARNavgationBar

- (instancetype)init {
    if (self = [super init]) {
    
        [self setupNavUI];
    }
    return self;
}
- (void)changeOffset: (CGFloat)offset {
    [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-offset));
    }];
}
- (void)setupNavUI {
    
    [self addSubview:self.backImageView];
    self.backImageView.alpha = 0;
  
    self.maskView = [[UIImageView alloc] init];
    self.maskView.alpha = 0;
    [self addSubview:self.maskView];

    self.maskView.image = [UIImage war_imageName:@"personalinformation_shadow" curClass:self curBundle:@"WARProfile.bundle"];
    self.backImageView.image = [WARUIHelper war_placeholderBackground];
    self.scrollerView = [[UIScrollView alloc] init];
    self.scrollerView.contentSize = CGSizeMake(0, 300);
    self.loadingView = [[UIActivityIndicatorView alloc] init];
    
    [self addSubview:self.editButton];
    [self addSubview:self.qrButton];
    [self addSubview:self.loadingView];
    [self addSubview:self.leftbtn];
    [self addSubview:self.backbtn];
    [self addSubview:self.namelabel];
    [self addSubview:self.accoutlb];
    self.clipsToBounds = YES;
    [self setUplayout];
}
- (void)setUplayout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo (@(WAR_IS_IPHONE_X?344:310));
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-12);
        make.height.width.equalTo(@25);
    }];
    [self.qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editButton.mas_left).offset(-3);
        make.bottom.equalTo(self).offset(-12);
        make.height.width.equalTo(@25);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-12);
        make.height.width.equalTo(@25);
    }];
    [self.leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-12);
        make.height.width.equalTo(@25);
    }];
    
    
    [self.accoutlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftbtn.mas_right).offset(8);
        make.bottom.equalTo(self).offset(-12);
        make.height.equalTo(@25);
        make.width.equalTo(@95);
    }];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-12);
        make.height.equalTo(@25);
    }];

}
- (void)setIsMine:(BOOL)isMine {
    _isMine = isMine;
    if(isMine){
        [self.leftbtn setImage:[UIImage war_imageName:@"person_home_code" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(EnterCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [self.leftbtn setImage:[UIImage war_imageName:@"chat_back" curClass:[self class] curBundle:@"WARChat.bundle"] forState:UIControlStateNormal];
        self.leftbtn.backgroundColor = [UIColor clearColor];
        [self.leftbtn addTarget:self action:@selector(PopClick:) forControlEvents:UIControlEventTouchUpInside];
        self.qrButton.hidden = YES;
    }
}
- (void)EnterCodeClick:(UIButton*)btn {
    [[WARMediator sharedInstance] Mediator_showQRCodeModalView];
}
- (void)PopClick:(UIButton*)btn {
    UIViewController *vc  = [self currentVC:self];
    [vc.navigationController popViewControllerAnimated:YES];
}
- (void)setIsOtherFromWindow:(BOOL)isOtherFromWindow {
    _isOtherFromWindow = isOtherFromWindow;
    if (self.isOtherFromWindow) {
        self.backbtn.hidden = NO;
        [self.backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-12);
            make.height.width.equalTo(@25);
        }];
        [self.leftbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backbtn.mas_right).offset(0);
            make.bottom.equalTo(self).offset(-12);
            make.height.width.equalTo(@25);
        }];
    }else{
        self.backbtn.hidden = YES;
        [self.leftbtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-12);
            make.height.width.equalTo(@25);
        }];
    }
}
- (void)qrCodeEvent {
    UIViewController *vc  = [self currentVC:self];
    [vc.navigationController pushViewController: [[WARMediator alloc] Mediator_viewControllerForUserFaceManagerWithCurrentFaceId:nil] animated:YES];
}
- (void)popView {
    UIViewController *vc  = [self currentVC:self];
    [vc.navigationController popViewControllerAnimated:YES];
}


- (void)addEvent {
    if (!self.isMine) {
        if (self.settingBlock) {
            self.settingBlock();
        }
        return ;
    }
    
    WARUserSettingsViewController *settingVC = [[WARUserSettingsViewController alloc] init];
    UIViewController *vc  = [self currentVC:self];
    
    [vc.navigationController pushViewController:settingVC animated:YES];
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
    
- (void)setDl_alpha:(CGFloat)dl_alpha {
    _dl_alpha = dl_alpha;
//    self.backImageView.alpha = dl_alpha;
    self.namelabel.hidden = !(dl_alpha >= 0.99);
}
/**
 将要刷新
 */
-(void)dl_willRefresh {
    self.editButton.hidden = YES;
    self.loadingView.hidden = NO;
}

/**
 刷新
 */
-(void)dl_refresh {
    self.editButton.hidden = YES;
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}
- (void)stopAnmation:(void(^)())block {
      [self.loadingView stopAnimating];
    if (block) {
        block();
    }
}
/**
 结束刷新
 */
-(void)dl_endRefresh {
    self.editButton.hidden = NO;
    self.loadingView.hidden = YES;
 
}
- (UIButton *)backbtn {
    if (!_backbtn) {
        _backbtn = [[UIButton alloc] init];
//        _backbtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _backbtn.layer.cornerRadius = 15;
        _backbtn.layer.masksToBounds = YES;
        _backbtn.adjustsImageWhenHighlighted = NO;
        [_backbtn setImage:[UIImage war_imageName:@"fanhui" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_backbtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backbtn;
}
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [[UIButton alloc] init];
        //_editButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _editButton.layer.cornerRadius = 15;
        _editButton.layer.masksToBounds = YES;
        _editButton.adjustsImageWhenHighlighted = NO;
       
        [_editButton setImage:TweetProfileGetImage(@"person_home_setup",self) forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
- (UIButton *)leftbtn {
    if (!_leftbtn) {
        _leftbtn = [[UIButton alloc] init];
//        _leftbtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _leftbtn.layer.cornerRadius = 15;
        _leftbtn.layer.masksToBounds = YES;
        _leftbtn.adjustsImageWhenHighlighted = NO;
        [_leftbtn setImage:TweetProfileGetImage(@"person_home_edit copy",self) forState:UIControlStateNormal];
        [_leftbtn addTarget:self action:@selector(PopClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftbtn;
}
- (UIButton *)qrButton {
    if (!_qrButton) {
        _qrButton = [[UIButton alloc] init];
        _qrButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _qrButton.layer.cornerRadius = 15;
        _qrButton.layer.masksToBounds = YES;
        _qrButton.adjustsImageWhenHighlighted = NO;
         _qrButton.hidden = YES;
        [_qrButton setImage:TweetProfileGetImage(@"person_home_setup",self) forState:UIControlStateNormal];
        [_qrButton addTarget:self action:@selector(qrCodeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrButton;
}
- (UILabel *)accoutlb {
    if (!_accoutlb) {
        _accoutlb  = [[UILabel alloc] init];
        _accoutlb.textColor = [UIColor whiteColor];
        _accoutlb.font = [UIFont systemFontOfSize:14];
        _accoutlb.hidden = YES;
    }
    return _accoutlb;
}
- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel  = [[UILabel alloc] init];
        _namelabel.textColor = [UIColor whiteColor];
        _namelabel.font = [UIFont systemFontOfSize:18];

        _namelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _namelabel;
}
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
@end
