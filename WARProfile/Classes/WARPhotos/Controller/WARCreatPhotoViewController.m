//
//  WARCreatPhotoViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//
//照片存储路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"PhotoImages"]

//视频存储路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

#import "WARCreatPhotoViewController.h"
#import "WARCreatEditPhotoView.h"
#import "WARFinshCreatViewController.h"
#import "WARBaseMacros.h"
#import "WARPhotoSettingAuthViewController.h"
#import "WARImagePickerController.h"
#import "WARUploadingViewController.h"
#import "WARNetwork.h"
#import "UIImage+WARCategory.h"
#import "WARMacros.h"
#import <Photos/Photos.h>
#import "WARCTranscodeTool.h"
#import "WARProfileNetWorkTool.h"
#import "UIImage+PreViewImage.h"
#import "WARPhotosUploadManger.h"
#import "WARPhotoDetailsViewController.h"
#import "TZImageManager.h"
#define kScaleFrom_iPhone5(_X_) (_X_ * (kScreenWidth/320))
@interface WARCreatPhotoViewController ()<WARImagePickerControllerDelegate>
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)WARCreatEditPhotoView *creatphotoV;
@property (nonatomic,strong)WARGroupModel *model;
@property (nonatomic,strong)NSMutableArray   *waitingArray;
@property (nonatomic,assign)BOOL   isFromeCreat;
@end

@implementation WARCreatPhotoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}
- (void)initSubViews {
    [self.view addSubview:self.customBar];
    [self.view addSubview:self.creatphotoV];
    [self.customBar.titleButton setTitle:WARLocalizedString(@"新建相册") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self initCallBack];
}
- (void)initCallBack {
    WS(weakself);
    self.creatphotoV.pushBlock = ^(WARGroupModel *model){
        weakself.model = model;
        WARImagePickerController *imagePick = [[WARImagePickerController alloc] initWithMaxImagesCount:99 delegate:weakself];
        imagePick.showHeaderView = YES;
        
        imagePick.allowPickingMultipleVideo = YES;
        imagePick.doneBtnTitleStr = WARLocalizedString(@"上传");
        [imagePick setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
            leftButton.hidden = YES;
        }];
        imagePick.imagePickerControllerDidCancelHandle = ^{
            WARFinshCreatViewController *vc = [[WARFinshCreatViewController alloc] initWithModel:model];
            
            vc.view.backgroundColor = [UIColor whiteColor];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        imagePick.view.backgroundColor = [UIColor whiteColor];
        [weakself presentViewController:imagePick animated:YES completion:nil];
    };
    self.creatphotoV.authBlock = ^(NSString *type) {
        WARPhotoSettingAuthViewController *vc = [[WARPhotoSettingAuthViewController alloc] initWith:type];
        vc.authBlock = ^(NSString *type) {
            weakself.creatphotoV.authNamelb.text = WARLocalizedString(type);
        };
        
        vc.view.backgroundColor = [UIColor whiteColor];
        [weakself.navigationController pushViewController:vc animated:YES];
    };

}
- (void)imagePickerController:(WARImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    WARGroupModel *groupModel = self.model;
    [[WARPhotosUploadManger sharedGolbalViewManager] uploadData:groupModel upImages:photos upPhaset:assets loactions:@[] isSelectOriginalPhoto:isSelectOriginalPhoto];
    
    [self.customBar.progressBtn setTitle:[NSString stringWithFormat:@"%ld",groupModel.uploadArray.count] forState:UIControlStateNormal];
    WARPhotoDetailsViewController *vc =   [[WARPhotoDetailsViewController alloc] initWithModel:self.model atAccountID:self.guyID];
    vc.isOtherEnterHome = self.isOtherEnterHome;
    vc.isFromeCreat = YES;
    NSArray *uploadArr = groupModel.uploadArray;
    vc.uploadCount = uploadArr.count;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:NO];

}

- (WARCreatEditPhotoView *)creatphotoV{
    if (!_creatphotoV) {
        _creatphotoV = [[WARCreatEditPhotoView alloc] initWithType:WARCreatEditPhotoViewTypeNewCreat];
      CGFloat navH =  WAR_IS_IPHONE_X ? 84:64;
        _creatphotoV.frame = CGRectMake(0, navH, kScreenWidth, kScreenHeight);
    }
    return _creatphotoV;
}
- (NSMutableArray *)waitingArray{
    if (!_waitingArray) {
        _waitingArray = [NSMutableArray array];
    }
    return _waitingArray;
}
@end
