//
//  WARFavriteCreatEditeViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import "WARFavriteCreatEditeViewController.h"
#import "WARMacros.h"
#import "WARNewCreatFavriteView.h"
#import "WARImagePickerController.h"
#import "WARNetwork.h"
#import "WARGroupModel.h"
#import "WARPhotoSettingAuthViewController.h"
#import "WARUploadManager.h"
#import "WARProgressHUD.h"
#import "WARUploadRespData.h"
@interface WARFavriteCreatEditeViewController ()<WARImagePickerControllerDelegate>
@property (nonatomic,strong)WARNavgationCutsomBar *customBar;
@property (nonatomic,strong)WARNewCreatFavriteView *editingView;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString *url;
@end

@implementation WARFavriteCreatEditeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (instancetype)initWithType:(NSInteger)type withlinkURL:(NSString*)url{
    if (self = [super init]) {
        self.type = type;
         self.url = url;
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customBar];
    [self.view addSubview:self.editingView];
    self.editingView.type = self.type;
    self.editingView.url = self.url;
    [self.customBar.titleButton setTitle:WARLocalizedString(@"设置") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self editingVEvenBlock];
}
- (void)editingVEvenBlock {
    WS(weakself);
    self.editingView.block = ^{
        
        WARImagePickerController *imagePick = [[WARImagePickerController alloc] initWithMaxImagesCount:1 delegate:weakself];
        imagePick.showHeaderView = YES;
        imagePick.allowPickingOriginalPhoto = NO;
        imagePick.allowPickingMultipleVideo = YES;
        imagePick.doneBtnTitleStr = WARLocalizedString(@"上传");
        [imagePick setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
            leftButton.hidden = YES;
        }];

        imagePick.view.backgroundColor = [UIColor whiteColor];
        [weakself presentViewController:imagePick animated:YES completion:nil];
    };
    self.editingView.authBlock = ^(NSString *type) {
        WARPhotoSettingAuthViewController *vc = [[WARPhotoSettingAuthViewController alloc] initWith:type];
        vc.authBlock = ^(NSString *type) {
            weakself.editingView.authNamelb.text = WARLocalizedString(type);
        };
        
        vc.view.backgroundColor = [UIColor whiteColor];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
}
- (void)imagePickerController:(WARImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    WS(weakself);
    WARupPictureModel *model = [[WARupPictureModel alloc] init];

    model.filePath = [NSString stringWithFormat:@"Favrite.jpg"];
    PHAsset *asset = [assets firstObject];
    if (asset.mediaType == 1) {
        [[WARUploadManager shared] uploadPhsset:[assets firstObject] type:WARUploadManagerTypeALBUM mimeType:@"image/jpg" progressBlock:nil responseBlock:^(WARUploadRespData *respData, NSString *key) {
            weakself.editingView.coverID = respData.url;
        } errorInfo:^{
            
        }];
    }else{
        [WARProgressHUD showAutoMessage:@"请选择图片"];
    }

}
- (void)enterEditingFav:(WARFavoriteInfoModel*)model {
    self.editingView.model = model;
}
- (NSMutableArray *)toDoActImages:(WARupPictureModel *)model {
    NSMutableArray *formDataArray = [NSMutableArray array];
    
    WARFormData *formData = [[WARFormData alloc] init];
    formData.name = @"files";
    formData.mimeType = @"image/jpeg";
    formData.filename = model.filePath;
    [formDataArray addObject:formData];
    
    return formDataArray;
}
- (WARNewCreatFavriteView *)editingView {
    if (!_editingView) {
        CGFloat navH =   WAR_IS_IPHONE_X ? 88:64;
        _editingView = [[WARNewCreatFavriteView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH)];
    }
    return _editingView;
}
- (WARNavgationCutsomBar *)customBar{
    if (!_customBar) {
        WS(weakself);
        _customBar = [[WARNavgationCutsomBar alloc] initWithTile:@"" rightTitle:@"" alpha:0 backgroundColor:[UIColor whiteColor] rightHandler:^{
            [weakself rightAction];
        } leftHandler:^{
            [weakself leftAtction];
        }];
        CGFloat height =    WAR_IS_IPHONE_X ? 84:64;
        _customBar.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _customBar;
}
- (void)rightAction{
    
}
- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
