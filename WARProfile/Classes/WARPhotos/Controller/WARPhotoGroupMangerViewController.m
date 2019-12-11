//
//  WARPhotoGroupMangerViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARPhotoGroupMangerViewController.h"
#import "WARPhotoDetailView.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
#import "WARGroupModel.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotoDetailEditingView.h"
#import "WARPhotoGroupEditingViewController.h"
#import "WARPhotosMoveViewController.h"
#import "WARPhotosUploadManger.h"
#import "WARProgressHUD.h"
#import "ReactiveObjC.h"
#import "WARAlertView.h"
#import "WARPhotoDetailCell.h"
#import "UIImage+WARBundleImage.h"
#import "WARActionSheet.h"
#import "WARNetwork.h"
#import "WARDownPhotoManger.h"
#import "WARDBUploadPhotoManger.h"
#import "SDWebImageManager.h"
#import "WARConfigurationMacros.h"
#import "Masonry.h"
static void * kDownloaderKVOContext = &kDownloaderKVOContext;
@interface WARPhotoGroupMangerViewController ()<WARPhotoDetailViewDelegate,WARPhotoDetailEditingViewDelegate>
@property(nonatomic,strong)WARPhotoDetailView *detailV;
@property(nonatomic,strong)WARGroupModel *model;
@property(nonatomic,strong)WARPhotoDetailEditingView *photoEditView;
@property(nonatomic,strong)NSMutableArray *imageArr;
@end

@implementation WARPhotoGroupMangerViewController
- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WS(weakself);
    [WARProfileNetWorkTool postPhotoDetailId:self.model.albumId params:@{} CallBack:^(id response) {
        
        WARDetailModel *model = [[WARDetailModel alloc] init];
        [model praseData:response];
        weakself.detailV.detailmodel = model;
        weakself.detailV.groupMModel = weakself.model;
    } failer:^(id response) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectChange:) name:@"selectCount" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//       [SDWebImageManager.sharedManager cancelAll];
//    [SDWebImageManager.sharedManager.imageCache clearMemory];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initSubViews];
    self.photoEditView.backgroundColor = [UIColor whiteColor];
    for (UIButton *btn in self.photoEditView.subviews) {
        btn.userInteractionEnabled = NO;

    }
    [self.customBar.progressBtn setImage:[UIImage war_imageName:@"xiazaishangchuan" curClass:[self class] curBundle:@"WARProfile.bundle"]  forState:UIControlStateNormal];
    [self.customBar.progressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customBar).offset(-15);
        
    }];
    [self.detailV setGroupModel:self.model];
    self.selectArray = [NSMutableArray array];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downCount:) name:@"downCount" object:nil];
}
- (void)downCount:(NSNotification*)noti {
     WARGroupModel *model = [[[WARDownPhotoManger sharedDownManager] aryTasker] firstObject];
    if (model.downArray.count  == 0) {
        self.customBar.progressBtn.hidden = YES;
    }else{
        self.customBar.progressBtn.hidden = NO;
    }
}
- (void)selectChange:(NSNotification*)noti{
    NSArray *array = noti.object;
    if (array.count>0) {
        self.photoEditView.backgroundColor = ThemeColor;
        self.photoEditView.lineV.backgroundColor = ThemeColor;
        for (UIView *btn in self.photoEditView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                UIButton *newBtn = (UIButton*)btn;
                [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            btn.userInteractionEnabled = YES;
            
        }
    }else{
        self.photoEditView.backgroundColor = [UIColor whiteColor];
        self.photoEditView.lineV.backgroundColor = SeparatorColor;
        for (UIView *btn in self.photoEditView.subviews) {
            btn.userInteractionEnabled = NO;
            if ([btn isKindOfClass:[UIButton class]]) {
                UIButton *newBtn = (UIButton*)btn;
                [newBtn setTitleColor:TextColor forState:UIControlStateNormal];
            }
            
        }
    }
    [self.detailV.tableView reloadData];
}

- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailV];
    [self.view addSubview:self.customBar];
    self.customBar.backgroundColor = [UIColor clearColor];
    self.customBar.lineButton.hidden = YES;
    self.customBar.rightbutton.hidden = NO;
   
    self.customBar.dl_alpha = 0;
    [self.customBar.titleButton setTitle:WARLocalizedString(@"批量管理") forState:UIControlStateNormal];
    [self.view addSubview:self.photoEditView];
    [ self.customBar.button setImage:[UIImage war_imageName:@"shoucang_back" curClass:self curBundle:@"WARChat.bundle"] forState:UIControlStateNormal];
}
- (void)WARPhotoDetailView:(WARPhotoDetailView *)detailV alpha:(CGFloat)alpha{
    if (alpha < 1) {
         [ self.customBar.button setImage:[UIImage war_imageName:@"shoucang_back" curClass:self curBundle:@"WARChat.bundle"] forState:UIControlStateNormal];
                [self.customBar.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
         [ self.customBar.button setImage:[UIImage war_imageName:@"chat_back" curClass:self curBundle:@"WARChat.bundle"] forState:UIControlStateNormal];
          [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    self.customBar.dl_alpha = alpha;
}

- (void)photoDetailEditingView:(WARPhotoDetailEditingView *)photoDetailEditingView WithTagindex:(NSInteger)tagindex{
    NSMutableArray *imageArray = [NSMutableArray array];
   
    
    switch (tagindex) {
        case 0:
        {   
             WS(weakself);
                 NSArray *array = @[@"原图",@"高清图"];
            [WARActionSheet actionSheetWithButtonTitles:array cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {

                if(index == 1 ||index == 0) {
                    [[WARDownPhotoManger sharedDownManager] downDataSourceMore:self.selectArray atCurrentGroupModel:self.model];
                    if ([[WARDownPhotoManger sharedDownManager]  aryTasker] >0) {
                        [self.customBar.progressBtn setImage:[UIImage war_imageName:@"xiazaishangchuan" curClass:[self class] curBundle:@"WARProfile.bundle"]  forState:UIControlStateNormal];
                    }
                    if (self.block) {
                        self.block(self.model);
                    }
                    for (WARDetailPicturesModel *dateModel in weakself.detailV.detailmodel.arrPictures) {
                        for (WARDetailDateDataModel *dateTempModel in dateModel.arrDateData) {
                            dateTempModel.rowISAllSelect = NO;
                            for (WARPictureModel *pmodel in dateTempModel.arrPictures) {
                                
                                pmodel.isSelect = NO;
                                NDLog(@"ID ----%@",pmodel.pictureId);
                            }
                            
                        }
                    }
                    
                    [self.detailV.tableView reloadData];

                    [self.selectArray removeAllObjects];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:self.selectArray];
                    
           
                   
                }
            } cancelHandler:^(LGAlertView * _Nonnull alertView) {

            } completionHandler:^{

            }];

           
      
            
        }
            break;
        case 1:{
     
    
            if (!self.selectArray.count) {
                return ;
            }
       
            WARPhotosMoveViewController *movc = [[WARPhotosMoveViewController alloc] initWithModel:self.model];
            movc.array = self.selectArray;
            [self.selectArray removeAllObjects];
            [self presentViewController:movc animated:YES completion:nil];
         
        }
            break;
        case 2:{
            @weakify(self);;
            [WARAlertView showWithTitle:WARLocalizedString(@"提示") Message:WARLocalizedString(@"你确定要删除") cancelTitle:WARLocalizedString(@"不了") actionTitle:WARLocalizedString(@"确定") cancelHandler:nil actionHandler:^(LGAlertView * _Nonnull alertView) {
                @strongify(self);
                NSMutableArray *imageIDArray = [NSMutableArray array];
                if (!self.selectArray.count) {
                    return ;
                }
                for (WARPictureModel *pictureModel in self.selectArray) {
                    if([pictureModel.type isEqualToString:@"VIDEO"]) {
                            [imageIDArray addObject:pictureModel.videoId];
                    }else{
                         [imageIDArray addObject:pictureModel.pictureId];
                    }
                }
                
                WS(weakself);
                [WARProfileNetWorkTool deleteSelectPhotos:imageIDArray.copy photoID:self.model.albumId CallBack:^(id response) {
                    
                    
                    [WARProgressHUD showAutoMessage:@"删除成功"];
                    
                    [weakself.selectArray removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:self.selectArray];
                    [WARProfileNetWorkTool postPhotoDetailId:self.model.albumId params:@{} CallBack:^(id response) {
                        
                        WARDetailModel *model = [[WARDetailModel alloc] init];
                        [model praseData:response];
                        weakself.detailV.detailmodel = model;
                    } failer:^(id response) {
                        
                    }];
                    
                } failer:^(id response) {
                    [WARProgressHUD showAutoMessage:@"删除失败"];
                    
                }];
                
                
            }];
        }
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:self.selectArray];
}
- (BOOL)isContainKey{
    __block  BOOL isContain = NO;
    [[[WARDownPhotoManger sharedDownManager] aryTasker] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARGroupModel *gModel = (WARGroupModel*)obj;
        if ([gModel.albumId isEqualToString:self.model.albumId]) {
            isContain = YES;
        }
        
    }];
    return isContain;
}
- (WARPhotoDetailView *)detailV{
    if (!_detailV) {
        
        _detailV = [[WARPhotoDetailView alloc] initWithFrame:self.view.bounds type:WARPhotoDetailViewTypeDefualt atAccounId:@"" atModel:self.model];
        _detailV.delegate = self;
    }
    return _detailV;
}
- (WARPhotoDetailEditingView *)photoEditView{
    if (!_photoEditView) {
        CGFloat tabH =   WAR_IS_IPHONE_X?83:49;
        _photoEditView = [[WARPhotoDetailEditingView alloc] initWithFrame:CGRectMake(0, kScreenHeight-tabH, kScreenWidth, tabH) array:@[@"下载",@"移动到",@"删除"]];
        _photoEditView.backgroundColor = [UIColor whiteColor];
        _photoEditView.delegate = self;
        
    }
    
    return _photoEditView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



@end
