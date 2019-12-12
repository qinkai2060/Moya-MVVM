//
//  WARPhotoSettingCoverViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/14.
//

#import "WARPhotoSettingCoverViewController.h"
#import "WARPhotoDetailView.h"
#import "WARGroupModel.h"
#import "WARMacros.h"
#import "WARProfileNetWorkTool.h"
#import "WARProgressHUD.h"
@interface WARPhotoSettingCoverViewController ()<WARPhotoDetailViewDelegate>
@property(nonatomic,strong)WARPhotoDetailView *detailV;
@property(nonatomic,strong)WARGroupModel *model;
@end

@implementation WARPhotoSettingCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailV];
    [self.view addSubview:self.customBar];
    self.customBar.backgroundColor = [UIColor clearColor];
    self.customBar.lineButton.hidden = YES;
    self.customBar.rightbutton.hidden = NO;
    [self.customBar.titleButton setTitle:WARLocalizedString(@"更换封面") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.customBar.button.hidden = YES;

    WS(weakself);
    [WARProfileNetWorkTool postPhotoDetailId:self.model.albumId params:@{} CallBack:^(id response) {
        
        WARDetailModel *model = [[WARDetailModel alloc] init];
        [model praseData:response];
        weakself.detailV.detailmodel = model;
    } failer:^(id response) {
        
    }];
}
- (void)rightAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)WARPhotoDetailView:(WARPhotoDetailView*)detailV atMondel:(WARPictureModel *)model atCell:( WARPhotoDetailCollectionCell*)cell atPictureArray:(NSArray*)pictureArray{
    if (self.CoverSettingBlock) {
        self.CoverSettingBlock(model.pictureId);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    WS(weakself);
//    [WARProfileNetWorkTool putPhotoCoverWithAlbumID:self.model.albumId atPictureId:model.pictureId CallBack:^(id response) {
//        [WARProgressHUD showAutoMessage:@"设置成功"];
//
//
//
//    } failer:^(id response) {
//        [WARProgressHUD showAutoMessage:@"设置失败"];
//    }];
}
- (WARPhotoDetailView *)detailV{
    if (!_detailV) {
        _detailV = [[WARPhotoDetailView alloc] initWithFrame:self.view.bounds type:WARPhotoDetailViewTypeCover atAccounId:@"" atModel:self.model];
        _detailV.delegate = self;
    }
    return _detailV;
}
@end
