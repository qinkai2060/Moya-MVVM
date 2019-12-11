//
//  WARPhotoGroupEditingViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoGroupEditingViewController.h"
#import "WARCreatEditPhotoView.h"
#import "WARPhotoSettingCoverViewController.h"
#import "WARBaseMacros.h"
#import "WARPhotoSettingAuthViewController.h"
#import "WARGroupModel.h"
#import "Masonry.h"
#import "WARProfileNetWorkTool.h"
#import "WARProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
@interface WARPhotoGroupEditingViewController ()
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)WARCreatEditPhotoView *creatphotoV;
@property (nonatomic,strong)WARGroupModel *model;
@property (nonatomic,strong)NSString *coverID;
@end

@implementation WARPhotoGroupEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavStyle];
    [self initCallBack];
    [self.creatphotoV editingGroupInfoModel:self.model];

}
- (void)initCallBack {
    WS(weakself);
    self.creatphotoV.authBlock = ^(NSString *type) {
        WARPhotoSettingAuthViewController *vc = [[WARPhotoSettingAuthViewController alloc] initWith:type];
        vc.authBlock = ^(NSString *type) {
            weakself.creatphotoV.authNamelb.text = WARLocalizedString(type);
        };
        vc.view.backgroundColor = [UIColor whiteColor];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    self.creatphotoV.EditingCoverBlock = ^{
        WARPhotoSettingCoverViewController *vc = [[WARPhotoSettingCoverViewController alloc] initWithModel:weakself.model];
        vc.CoverSettingBlock = ^(NSString *coverID) {
            if (coverID.length == 0) {
                return ;
            }
            weakself.coverID = coverID;
            [weakself.creatphotoV.coverIconImg sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(45 , 45),coverID) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(45 , 45))];
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.creatphotoV.deleteBlock = ^{
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    };
}
- (void)initNavStyle {
    [self.view addSubview:self.customBar];
    self.customBar.rightbutton.hidden = NO;
    [self.customBar.button setImage:[UIImage new] forState:UIControlStateNormal];
    [self.customBar.button setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"保存") forState:UIControlStateNormal];
    [self.view addSubview:self.creatphotoV];
    [self.customBar.titleButton setTitle:WARLocalizedString(@"编辑相册信息") forState:UIControlStateNormal];
    self.customBar.dl_alpha = 0;
}
- (void)leftAtction{

    self.finshVC = nil;
    self.DetailVC = nil;
    self.uploadVC = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction{
    WS(weakself);
    if (![self.creatphotoV.Editingmodel.name isEqualToString:self.creatphotoV.textField.text] || ![self.creatphotoV.Editingmodel.accessPermission isEqualToString:[self.creatphotoV  accessPermission:self.creatphotoV.authNamelb.text]] || ![self.creatphotoV.Editingmodel.type isEqualToString:self.creatphotoV.tagV.selectBtn.currentTitle]||self.coverID.length!=0){
        NSString *type = @"";
        if(!self.creatphotoV.tagV.selectBtn) {
            type = @"普通";
        }else{
            type = self.creatphotoV.tagV.selectBtn.currentTitle;
        }
        if (self.creatphotoV.textField.text.length == 0) {
            self.creatphotoV.textField.text = @"未命名";
        }
        
        NSDictionary *params = @{@"accessPermission":[self.creatphotoV accessPermission:self.creatphotoV.authNamelb.text],@"name":self.creatphotoV.textField.text,@"type":type,@"coverId":self.coverID.length==0?@"":self.coverID};
        [WARProfileNetWorkTool putEditingPhoto:self.creatphotoV.Editingmodel.albumId params:params CallBack:^(id response) {
            
            [WARProgressHUD showMessageToWindow:@"编辑成功"];
            [WARProgressHUD hideHUD];
       
                WARGroupModel *model = [[WARGroupModel alloc] init];
                model.isMine = YES;
                [model praseData:response];
       //
            if (weakself.finshVC) {
                [weakself.navigationController popToViewController:weakself.finshVC animated:YES];
                weakself.finshVC = nil;
            }
            if (weakself.DetailVC) {
                weakself.DetailVC.DetailGroupModel = model;
                [weakself.navigationController popToViewController:weakself.DetailVC animated:YES];
                weakself.DetailVC = nil;
            }
            if (weakself.uploadVC) {
                weakself.uploadVC.newloadingModel = model;
                [weakself.navigationController popToViewController:weakself.uploadVC animated:YES];
                weakself.uploadVC = nil;
            }
        } failer:^(id response) {
            [WARProgressHUD showMessageToWindow:@"编辑失败"];
            [WARProgressHUD hideHUD];
        }];
    }else{
          [self.navigationController popViewControllerAnimated:YES];
    }
}
- (WARCreatEditPhotoView *)creatphotoV{
    if (!_creatphotoV) {
        _creatphotoV = [[WARCreatEditPhotoView alloc] initWithType:WARCreatEditPhotoViewTypeEditing];
        _creatphotoV.frame = CGRectMake(0, CGRectGetMaxY(self.customBar.frame), kScreenWidth, kScreenHeight);
    }
    return _creatphotoV;
}


@end
