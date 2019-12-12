//
//  WARFinshCreatViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import "WARFinshCreatViewController.h"
#import "WARPhotoHeaderView.h"
#import "WARMacros.h"
#import "WARUserCenterViewController.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
#import "WARUploadingViewController.h"
#import "WARPhotoGroupEditingViewController.h"
#import "WARGroupModel.h"
#import "WARImagePickerController.h"
#import "WARPhotosUploadManger.h"
@interface WARFinshCreatViewController ()
@property(nonatomic,strong)WARPhotoHeaderView *headerView;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *secondTipLabel;
@property(nonatomic,strong)UIButton *UploadPhotoBtn;
@property(nonatomic,strong)WARGroupModel *model;
@end

@implementation WARFinshCreatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}
- (void)initSubViews{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.customBar];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.secondTipLabel];
    [self.view addSubview:self.UploadPhotoBtn];
    self.customBar.backgroundColor = [UIColor clearColor];
    self.customBar.lineButton.hidden = YES;
    self.customBar.rightbutton.hidden = NO;
    self.customBar.dl_alpha = 0;
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"编辑") forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.UploadPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@171);
        make.top.equalTo(self.secondTipLabel.mas_bottom).offset(107);
        make.height.equalTo(@32);
    }];
    [self.headerView setCoveriD:self.coverID];
    self.headerView.maskV.hidden = NO;
    self.headerView.titlelb.hidden = NO;
    self.headerView.phototypelb.hidden = NO;
    self.headerView.lockImgV.hidden = NO;
    self.headerView.countlb.hidden = NO;
    
    [self.headerView setGroupModel:self.model];
    
}

- (void)leftAtction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightAction {
    
    WARPhotoGroupEditingViewController *photoeditingVC = [[WARPhotoGroupEditingViewController alloc] initWithModel:self.model];
    photoeditingVC.finshVC = self;
    [self.navigationController pushViewController:photoeditingVC animated:YES];
    
}
- (WARPhotoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WARPhotoHeaderView alloc] initWithType:WARPhotoHeaderViewTypeDefualt];
        _headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 178);
    }
    return _headerView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = WARLocalizedString(@"暂无任何内容");
        _tipLabel.font = kFont(14);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor colorWithHexString:@"999999" opacity:1];
        _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame)+108, kScreenWidth, 14);
    }
    return _tipLabel;
}
- (UILabel *)secondTipLabel{
    if (!_secondTipLabel) {
        _secondTipLabel = [[UILabel alloc] init];
        _secondTipLabel.text = WARLocalizedString(@"辛苦创建的,派不上用场多可惜");
        _secondTipLabel.font = kFont(14);
        _secondTipLabel.textAlignment = NSTextAlignmentCenter;
        _secondTipLabel.textColor = [UIColor colorWithHexString:@"999999" opacity:1];
        _secondTipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame)+30, kScreenWidth, 14);
    }
    return _secondTipLabel;
}
- (UIButton *)UploadPhotoBtn{
    if (!_UploadPhotoBtn) {
        _UploadPhotoBtn = [[UIButton alloc] init];
        _UploadPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"00d8b7" opacity:1];
        [_UploadPhotoBtn setTitle:WARLocalizedString(@"上传照片/视频") forState:UIControlStateNormal];
        [_UploadPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _UploadPhotoBtn.titleLabel.font = kFont(16);
        [_UploadPhotoBtn addTarget:self action:@selector(pushHandler:) forControlEvents:UIControlEventTouchUpInside];
        _UploadPhotoBtn.layer.cornerRadius = 3;
        _UploadPhotoBtn.layer.masksToBounds = YES;
    }
    return _UploadPhotoBtn;
}
- (void)pushHandler:(UIButton*)btn
{
    WARImagePickerController *imagePick = [[WARImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePick.showHeaderView = YES;
    imagePick.allowPickingMultipleVideo = YES;
    imagePick.doneBtnTitleStr = WARLocalizedString(@"上传");
    [imagePick setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
        leftButton.hidden = YES;
    }];
    imagePick.imagePickerControllerDidCancelHandle = ^{
        
    };
    imagePick.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:imagePick animated:YES completion:nil];
}
- (void)imagePickerController:(WARImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto  {
    WARPhotosUploaModel *model = [[WARPhotosUploaModel alloc] init];
    model.uploadUrlArr = photos;
    model.model = self.model;
    [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] addObject:model];
    [[WARPhotosUploadManger sharedGolbalViewManager] start];

}
@end
