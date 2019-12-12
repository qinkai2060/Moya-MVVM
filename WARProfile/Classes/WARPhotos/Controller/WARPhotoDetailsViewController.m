//
//  WARPhotoDetailsViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoDetailsViewController.h"
#import "WARPhotoDetailView.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
#import "WARGroupModel.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotoDetailEditingView.h"
#import "WARPhotoGroupEditingViewController.h"
#import "WARPhotoGroupMangerViewController.h"
#import "WARImagePickerController.h"
#import "WARNetwork.h"
#import "UIImage+WARCategory.h"
#import "WARPhotoBroswerViewController.h"
#import "WARPhotoDetailCollectionCell.h"
#import "WARPhotosUploadManger.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "WARPhotoQuickManger.h"
#import "WARUserCenterViewController.h"
#import "WARBrowserMoudleView.h"
#import "WARActionSheet.h"
#import "WARPopOverMenu.h"
#import "WARUploadingViewController.h"
#import "WARDBUploadPhotoManger.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARDownPhotoManger.h"
#import "SDWebImageManager.h"
#import "TZImageManager.h"
#import "WARUploadManager.h"
#define kScaleFrom_iPhone5(_X_) (_X_ * (kScreenWidth/320))
@interface WARPhotoDetailsViewController ()<WARPhotoDetailViewDelegate,WARPhotoDetailEditingViewDelegate,WARImagePickerControllerDelegate,WARBrowserMoudleViewDelegate>
@property(nonatomic,strong)WARPhotoDetailView *detailV;
@property(nonatomic,strong)WARBrowserMoudleView *browserMoudle;
@property(nonatomic,strong)WARGroupModel *model;
@property(nonatomic,strong)WARPhotoDetailEditingView *photoEditView;
@property(nonatomic,strong)WARDetailModel *detailmodel;
@property(nonatomic,strong)NSString *otherAccountID;
@property (nonatomic,assign) NSInteger downCount;
@end
// userhub-app/album/{albumId}/picture/list
@implementation WARPhotoDetailsViewController

- (instancetype)initWithModel:(WARGroupModel*)model atAccountID:(NSString*)accountID {
    if (self = [super initWithModel:model]) {
        
        self.otherAccountID = accountID;
        self.model = model;
    }
    return self;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   [self loadNetWorkData];
    [[WARDownPhotoManger sharedDownManager] start];
    [[WARPhotosUploadManger sharedGolbalViewManager] start];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initSubViews];
    self.detailV.groupMModel = self.model;
    self.detailV.accountId = self.otherAccountID;
    [self.browserMoudle setGroupModel:self.model];
    [self initCallback];
    [self notiFication];
}
- (void)initCallback {
    WS(weakself);
    self.detailV.pickerBlock = ^{
        WARImagePickerController *imagePick = [[WARImagePickerController alloc] initWithMaxImagesCount:999 delegate:weakself];
        imagePick.showHeaderView = YES;
        imagePick.allowPickingMultipleVideo = YES;
        imagePick.doneBtnTitleStr = WARLocalizedString(@"上传");
        [imagePick setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
            leftButton.hidden = YES;
            
        }];
        imagePick.imagePickerControllerDidCancelHandle = ^{
            
        };
        
        imagePick.view.backgroundColor = [UIColor whiteColor];
        [weakself presentViewController:imagePick animated:YES completion:nil];
    };
    
    self.browserMoudle.pickerBlock = ^{
        WARImagePickerController *imagePick = [[WARImagePickerController alloc] initWithMaxImagesCount:999 delegate:weakself];
        imagePick.showHeaderView = YES;
        imagePick.allowPickingMultipleVideo = YES;
        imagePick.doneBtnTitleStr = WARLocalizedString(@"上传");
        [imagePick setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
            leftButton.hidden = YES;
        }];
        imagePick.imagePickerControllerDidCancelHandle = ^{
            
        };
        imagePick.view.backgroundColor = [UIColor whiteColor];
        [weakself presentViewController:imagePick animated:YES completion:nil];
    };
    
    [WARPhotosUploadManger sharedGolbalViewManager].finshBlock = ^(NSArray *completArray){
        WARGroupModel *model = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
        
        if ([weakself.model.albumId isEqualToString:model.albumId]) {
            weakself.model.pictureCount = [NSString stringWithFormat:@"%ld",[weakself.model.pictureCount integerValue]+completArray.count];
            
            weakself.detailV.groupMModel = weakself.model;
            [weakself.detailV.tableView reloadData];
        }
        
        
        
        if (weakself.model.albumId) {
            [WARProfileNetWorkTool postPhotoDetailId:weakself.model.albumId params:@{@"friendId":weakself.otherAccountID}CallBack:^(id response) {
                
                WARDetailModel *model = [[WARDetailModel alloc] init];
                [model praseData:response];
                weakself.detailV.detailmodel = model;
                
                
            } failer:^(id response) {
                
            }];
        }
        
    };
}
- (void)loadNetWorkData {
    WS(weakself);
    [WARProfileNetWorkTool postPhotoDetailId:weakself.model.albumId params:@{@"friendId":self.otherAccountID} CallBack:^(id response) {
        
        WARDetailModel *model = [[WARDetailModel alloc] init];
        model.isMine = weakself.model.isMine;
        [model praseData:response];
        weakself.detailV.detailmodel = model;
        weakself.detailmodel  = model;
    } failer:^(id response) {
        
    }];

}
- (void)initNavStyle {
    self.customBar.button.layer.cornerRadius = 13;
    self.customBar.button.layer.masksToBounds = YES;
    [self.customBar.button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    self.customBar.rightbutton.layer.cornerRadius = 13;
    self.customBar.rightbutton.layer.masksToBounds = YES;
    [self.customBar.rightbutton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    self.customBar.progressBtn.layer.cornerRadius = 13;
    self.customBar.progressBtn.layer.masksToBounds = YES;
    [self.customBar.progressBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    self.customBar.backgroundColor = [UIColor clearColor];
    self.customBar.lineButton.hidden = YES;
    if (self.model.isMine) {
        self.customBar.rightbutton.hidden = NO;
    } else {
        self.customBar.rightbutton.hidden = YES;
        self.customBar.progressBtn.hidden = YES;
    }
    [self.customBar.rightbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@26);
    }];
    self.customBar.dl_alpha = 0;
    [self.customBar.rightbutton setImage:[UIImage war_imageName:@"personal_photo_more" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    [self.customBar.progressBtn setImage:[UIImage war_imageName:@"shangchuan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    [self.customBar.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customBar).offset(12);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
    [self.customBar.rightbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customBar).offset(-12);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
    [self.customBar.progressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
}

- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailV];
    [self.view addSubview:self.browserMoudle];
    [self.view addSubview:self.customBar];
    [self initNavStyle];
    self.uploadCount = self.model.uploadArray.count;
    self.downCount = self.model.downArray.count;
    [self updateProgressBtn];
    [self.customBar.progressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.progressBtn  addTarget:self action:@selector(enterProgressClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.customBar.rightbutton  addTarget:self action:@selector(mangerClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)notiFication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBroswer:) name:@"upCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downCount:) name:@"downCount" object:nil];

}
- (void)enterProgressClick:(UIButton*)btn {
    WARUploadingViewController *vc = [[WARUploadingViewController alloc] initWithModel:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mangerClick:(UIButton*)btn {
    NSArray *titles = @[WARLocalizedString(@"编辑相册"),WARLocalizedString(@"批量管理"),WARLocalizedString(@"分享相册"),WARLocalizedString(@"浏览模式")];
    NSArray *images = @[];

    WARPopOverMenuConfiguration *config = [WARPopOverMenuConfiguration defaultConfiguration];
    config.needArrow = NO;
    config.textAlignment = NSTextAlignmentCenter;
    WS(weakself);
    [WARPopOverMenu showFromSenderFrame:CGRectMake(self.view.frame.size.width - 40, 40, 0, 0 ) withMenuArray:titles  doneBlock:^(NSInteger selectedIndex) {
        
        switch (selectedIndex) {
            case 0: {
        
                WARPhotoGroupEditingViewController *photoeditingVC = [[WARPhotoGroupEditingViewController alloc] initWithModel:weakself.model];
                photoeditingVC.DetailVC = weakself;
                [weakself.navigationController pushViewController:photoeditingVC animated:YES];
                
                break;
            }
            case 1: {
                WARPhotoGroupMangerViewController *groupmanger = [[WARPhotoGroupMangerViewController alloc] initWithModel:weakself.model];
                groupmanger.block = ^(WARGroupModel *model) {
                    weakself.model = model;
                    weakself.downCount = weakself.model.downArray.count;
                    [weakself genaralMethod];
                };
                [weakself.navigationController pushViewController:groupmanger animated:YES];
                break;
            }
                
            case 2:
                break;
    
            case 3: {
                [self loadBigWithSmallImage];
                break;
            }
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}
- (void)loadBigWithSmallImage {
        WS(weakself);
    [WARActionSheet actionSheetWithButtonTitles:@[@"大图",@"小图"] cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if (index == 0) {
            weakself.browserMoudle.hidden = NO;
            weakself.browserMoudle.detailmodel = weakself.detailmodel;
        }else{
            weakself.browserMoudle.hidden = YES;
        }
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } completionHandler:^{
        
    }];
}


- (void)EnterBroswer:(NSNotification*)noti{
    WARGroupModel *model = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
    __block NSInteger idIndex = 0;
    if (model != nil){
        if ([model.albumId isEqualToString:self.model.albumId]) {
            self.model.uploadArray  = model.uploadArray;
        }
    }
    self.uploadCount =  self.model.uploadArray.count;
    [self genaralMethod];
}
- (void)downCount:(NSNotification*)noti {
    
    WARGroupModel *model = [[[WARDownPhotoManger sharedDownManager] aryTasker] firstObject];
    __block NSInteger idIndex = 0;
    if (model != nil){
        if ([model.albumId isEqualToString:self.model.albumId]) {
            self.model.downArray  = model.downArray;
        }
    }
    self.downCount =  self.model.downArray.count;
    [self genaralMethod];
}
- (void)genaralMethod {

    if (self.uploadCount != 0 && self.downCount != 0) {
        self.customBar.progressBtn.hidden = NO;
        self.customBar.countLb.hidden = YES;
        [self.customBar.progressBtn setImage:[UIImage war_imageName:@"xiazaishangchuan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    } else  if (self.uploadCount == 0 && self.downCount!=0) {
        self.customBar.progressBtn.hidden = NO;
        self.customBar.countLb.hidden = NO;
        [self.customBar.progressBtn setImage:[UIImage war_imageName:@"xiazai" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        if (self.downCount>99) {
            [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@25);
            }];
            self.customBar.countLb.text = [NSString stringWithFormat:@"99+"];
        }else{
            [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@15);
            }];
            self.customBar.countLb.text = [NSString stringWithFormat:@"%ld",self.downCount];
            
        }
    } else if (self.uploadCount != 0 && self.downCount==0) {
        self.customBar.progressBtn.hidden = NO;
        self.customBar.countLb.hidden = NO;
        [self.customBar.progressBtn setImage:[UIImage war_imageName:@"shangchuan" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        if (self.uploadCount>99) {
            [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@25);
            }];
            self.customBar.countLb.text = [NSString stringWithFormat:@"99+"];
        }else{
            [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@15);
            }];
            self.customBar.countLb.text = [NSString stringWithFormat:@"%ld",self.uploadCount];
            
        }
    }else {
        self.customBar.progressBtn.hidden = YES;
        self.customBar.countLb.hidden = YES;
    }
  
}
- (void)updateProgressBtn {
    [self genaralMethod];
    if (self.uploadCount>99) {
        [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
        }];
        self.customBar.countLb.text = [NSString stringWithFormat:@"99+"];

    }else{
        [self.customBar.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@15);
        }];
        self.customBar.countLb.text = [NSString stringWithFormat:@"%ld",self.uploadCount];
    }
}

- (void)setDetailGroupModel:(WARGroupModel *)DetailGroupModel{
    _DetailGroupModel = DetailGroupModel;
    self.model = DetailGroupModel;
    [self.detailV setGroupModel:DetailGroupModel];
     [self.browserMoudle setGroupModel:DetailGroupModel];
}
- (void)WARPhotoDetailView:(WARPhotoDetailView *)detailV alpha:(CGFloat)alpha{
  
    self.customBar.dl_alpha = alpha;
}
- (void)WARBrowserMoudleView:(WARBrowserMoudleView *)detailV alpha:(CGFloat)alpha {
    self.customBar.dl_alpha = alpha;
}

- (void)WARPhotoDetailView:(WARPhotoDetailView *)detailV atMondel:(WARPictureModel *)model atCell:(WARPhotoDetailCollectionCell *)cell atPictureArray:(NSArray *)pictureArray {

    WARPhotoBroswerViewController *newvc = [[WARPhotoBroswerViewController alloc] initWithModel:self.model currentimgev:   [cell.superview viewWithTag:cell.tag-1000] currentindex:cell.tag-1000 pictureDescrtionModel:model atImagePictureArray:pictureArray atSuperView:cell.superview atAccountID:self.otherAccountID];
    [self.navigationController pushViewController:newvc animated:YES];
}

- (void)imagePickerController:(WARImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    WARGroupModel *groupModel = self.model;
    [[WARPhotosUploadManger sharedGolbalViewManager] uploadData:groupModel upImages:photos upPhaset:assets loactions:@"" isSelectOriginalPhoto:isSelectOriginalPhoto];

    self.uploadCount = groupModel.uploadArray.count;

    [self updateProgressBtn];
  
}


- (void)leftAtction{
    if (self.model.isMine && !self.isOtherEnterHome){
         [self.navigationController popToRootViewControllerAnimated:YES];
    
    }else if (self.isFromeCreat){
       
        UIViewController *vc  =   [self.navigationController.viewControllers objectAtIndex:2];
        [self.navigationController popToViewController:vc animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
  
}

- (void)photoDetailEditingView:(WARPhotoDetailEditingView *)photoDetailEditingView WithTagindex:(NSInteger)tagindex{
    switch (tagindex) {
        case 0: {
            
            WARPhotoGroupEditingViewController *photoeditingVC = [[WARPhotoGroupEditingViewController alloc] initWithModel:self.model];
            photoeditingVC.DetailVC = self;
            [self.navigationController pushViewController:photoeditingVC animated:YES];
            break;
        }
      
        case 1: {
            WARPhotoGroupMangerViewController *groupmanger = [[WARPhotoGroupMangerViewController alloc] initWithModel:self.model];
              [self.navigationController pushViewController:groupmanger animated:YES];
            break;
        }
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
- (WARPhotoDetailView *)detailV{
    if (!_detailV) {
      
        _detailV = [[WARPhotoDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight) type:WARPhotoDetailViewTypeCustom atAccounId:self.otherAccountID atModel:self.model] ;
        _detailV.delegate = self;
    }
    return _detailV;
}
- (WARBrowserMoudleView *)browserMoudle{
    if (!_browserMoudle) {
      
        _browserMoudle = [[WARBrowserMoudleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight) atAcountID:self.otherAccountID];
        _browserMoudle.hidden = YES;
        _browserMoudle.delegate = self;
    }
    return _browserMoudle;
}
- (WARPhotoDetailEditingView *)photoEditView{
    if (!_photoEditView) {
     CGFloat tabH =   WAR_IS_IPHONE_X?83:49;
        _photoEditView = [[WARPhotoDetailEditingView alloc] initWithFrame:CGRectMake(0, kScreenHeight-tabH, kScreenWidth, tabH) array:@[@"编辑相册",@"批量管理",@"分享相册",@"浏览模式"]];
        _photoEditView.backgroundColor = [UIColor whiteColor];
        _photoEditView.delegate = self;
    }
   
    return _photoEditView;
}

@end
