//
//  WARPhotoViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import "WARPhotoViewController.h"
#import "WARPhotoCell.h"
#import "WARCreatPhotosCell.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARActionSheet.h"
#import "WARGroupModel.h"
#import "WARProfileNetWorkTool.h"
#import "WARBaseMacros.h"
#import "WARNetwork.h"
#import "WARProfileNetWorkTool.h"
#import "UIImage+PreViewImage.h"
#import "UIImage+WARCategory.h"
#import "TZImageManager.h"
#import "WARPhotosUploadManger.h"
#import "WARDBContactModel.h"
#import "WARDBContactManager.h"
#import "WARDBUserManager.h"
#import "WARPhotosCatorgrayView.h"
#import "WARPhotoVideoAndPhotoImgView.h"
#import "WARPhotosUploadManger.h"
#import "WARPhotoVideoListModel.h"
#import "WARPhotoListModel.h"
#import "MJRefresh.h"
#import "UIScrollView+WARRefresh.h"
#import "WARDBUploadPhotoManger.h"
#import "WARProgressHUD.h"
#import "WARDownPhotoManger.h"
#import "YYModel.h"
#define kScaleFrom_iPhone5(_X_) (_X_ * (kScreenWidth/320))
@interface WARPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WARPhotosCatorgrayViewDelegate>
@property (nonatomic,strong)UIButton *uploadPhotoBtn;
@property (nonatomic,assign)NSInteger selectRow;
/**ACCountID*/
@property (nonatomic,copy) NSString *accountID;
/**scrollerview*/
@property (nonatomic,strong) UIScrollView  *scrollerView;

/** 分类view*/
@property (nonatomic,strong) WARPhotosCatorgrayView *categoryView;
/**照片*/
@property (nonatomic,strong) WARPhotoVideoAndPhotoImgView *albumView;
/**视频*/
@property (nonatomic,strong) WARPhotoVideoAndPhotoImgView *videoView;

/**视频*/
@property (nonatomic,strong) WARPhotoListModel *photoListModel;
@property (nonatomic,strong) WARPhotoVideoListModel *photoVideoListModel;
@end

@implementation WARPhotoViewController
- (instancetype)initWithType:(BOOL)isMine atGuyID:(NSString*)guyID{
    if (self = [super init]) {
        self.isMine = isMine;
        self.accountID = guyID;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WARDownPhotoManger sharedDownManager] start];
    [[WARPhotosUploadManger sharedGolbalViewManager] start] ;
    WS(weakself);
    if (self.isMine) {
        
        [self loadLastData];
    }else{
        
        [WARProfileNetWorkTool getphotoGroupArray:@"" photoID:self.accountID callback:^(id response) {

            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray*)response;
                [weakself pareData:array];
            }

        } failer:^(id response) {

        }];
    }
    
}
- (void)loadLastData {
       WS(weakself);
    WARDBContactModel *model = [WARDBContactManager contactWithUserModel:[WARDBUserManager userModel]];
    self.accountID = model.accountId;
    
    [WARProfileNetWorkTool getphotoGroupArray:@"" photoID:self.accountID callback:^(id response) {
        
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)response;
            [weakself pareData:array];
        }
        
    } failer:^(id response) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.selectRow = -1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectRow = -1;
    [self.view addSubview:self.scrollerView];
    if (self.isMine) {
        [self.view addSubview:self.categoryView];
         self.categoryView.hidden = NO;
    }else{
        self.scrollerView.frame = CGRectMake(0, 10, kScreenWidth, kScreenHeight);
        self.categoryView.hidden = YES;
    }
 
    
    [self.scrollerView addSubview:self.collectionView];
    [self.scrollerView addSubview:self.albumView];
    [self.scrollerView addSubview:self.videoView];
   WS(weakSelf);
    self.albumView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadFooterData];
    }];
    self.videoView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadVideoFooterData];
    }];
    [WARPhotosUploadManger sharedGolbalViewManager].finshBlock = ^(NSArray* compleArray){
        [weakSelf loadLastData];
    };
    [self refreshState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShuju) name:@"upCount" object:nil];
}
- (void)loadFooterData {
      [self.albumView.collectionView.mj_footer beginRefreshing];
       WS(weakSelf);
    [WARProfileNetWorkTool postPhotoListWithAtWithLastShootTime:self.photoListModel.lastShootTime atlastFindId:self.photoListModel.lastFindId CallBack:^(id response) {
        NSDictionary *dict = (NSDictionary*)response;
        NSArray *arrayData = dict[@"pictures"];
        if (arrayData.count > 0) {
            WARPhotoListModel *photoListModel =  [[WARPhotoListModel alloc] init];
            [photoListModel prase:response];
            weakSelf.photoListModel .lastShootTime = photoListModel.lastShootTime;
            weakSelf.photoListModel .lastFindId = photoListModel.lastFindId;
            
            NSMutableArray *pArray = [NSMutableArray array];
            for (NSDictionary *dictData in arrayData) {
                WARPictureModel *model = [WARPictureModel yy_modelWithDictionary:dictData];;
                model.sortTime = [WARPhotoListModel dataStr:[WARPhotoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[dictData[@"sortTime"] integerValue]]]];
                model.type = @"PICTURE";
                [pArray addObject:model];
            }
            
            [pArray enumerateObjectsUsingBlock:^(WARPictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WARPhotoPictureModel *tempModel =     [weakSelf.albumView.photoModel.pictures lastObject];
                WARPictureModel *pictureModel = [tempModel.dateData lastObject];
                if ([pictureModel.sortTime isEqualToString:obj.sortTime]) {
                    
                    [tempModel.dateData addObject:obj];
                }else {
                    WARPhotoPictureModel *newCreatModel = [[WARPhotoPictureModel alloc] init];
                    newCreatModel.date = obj.sortTime;
                    [newCreatModel.dateData addObject:obj];
                    [weakSelf.albumView.photoModel.pictures addObject:newCreatModel];
                }
            }];
            [weakSelf.albumView.collectionView reloadData];
            [weakSelf.albumView.collectionView.mj_footer endRefreshing];
            if (arrayData.count == 0) {
                [self.albumView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            if (arrayData.count == 0) {
                [weakSelf.albumView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failer:^(id response) {
            [weakSelf.albumView.collectionView.mj_footer endRefreshing];
            [weakSelf.albumView.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];

        
        

}
- (void)loadVideoFooterData {
    [self.videoView.collectionView.mj_footer beginRefreshing];
    WS(weakSelf);
    [WARProfileNetWorkTool postVideoListWithLastShootTime:self.photoVideoListModel.lastShootTime atlastFindId:self.photoVideoListModel.lastFindId CallBack:^(id response) {
        NSDictionary *dict = (NSDictionary*)response;
        NSArray *arrayData = dict[@"videos"];
        if (arrayData.count > 0) {
            WARPhotoVideoListModel *photoListModel =  [[WARPhotoVideoListModel alloc] init];
            [photoListModel prase:response];
            weakSelf.photoVideoListModel .lastShootTime = photoListModel.lastShootTime;
            weakSelf.photoVideoListModel .lastFindId = photoListModel.lastFindId;
            
            NSMutableArray *pArray = [NSMutableArray array];
            for (NSDictionary *dictData in arrayData) {
                WARPictureModel *model = [WARPictureModel yy_modelWithDictionary:dictData];;
                model.sortTime = [WARPhotoListModel dataStr:[WARPhotoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[dictData[@"sortTime"] integerValue]]]];
                model.timelength =  [WARPhotoVideoModel getNewTimeFromDurationSecond:[[WARPhotoVideoListModel EmptyCheckobjnil:[[dictData valueForKey:@"video"] valueForKey:@"duration"]] integerValue]];
                model.videoId = [WARPhotoVideoListModel EmptyCheckobjnil:[[dictData valueForKey:@"video"] valueForKey:@"videoId"]];
                model.type = @"VIDEO";
                [pArray addObject:model];
            }
            
            [pArray enumerateObjectsUsingBlock:^(WARPictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WARPhotoVideoModel *tempModel =     [weakSelf.videoView.videoModel.videos lastObject];
                WARPictureModel *pictureModel = [tempModel.dateData lastObject];
                
                if ([pictureModel.sortTime isEqualToString:obj.sortTime]) {
                    
                    [tempModel.dateData addObject:obj];
                }else {
                    WARPhotoVideoModel *newCreatModel = [[WARPhotoVideoModel alloc] init];
                    newCreatModel.date = obj.sortTime;
                    [newCreatModel.dateData addObject:obj];
                    [weakSelf.videoView.videoModel.videos addObject:newCreatModel];
                }
            }];
            [weakSelf.videoView.collectionView reloadData];
            [weakSelf.videoView.collectionView.mj_footer endRefreshing];
            if (arrayData.count == 0) {
                [weakSelf.videoView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else {
            if (arrayData.count == 0) {
                [weakSelf.videoView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failer:^(id response) {
        [weakSelf.videoView.collectionView.mj_footer endRefreshing];
        [weakSelf.videoView.collectionView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
    
    
    
}
- (void)refreshState {
    [self.dataphotoGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARGroupModel *gmodel = (WARGroupModel*)obj;
        [WARPhotosUploadManger sharedGolbalViewManager].finshBlock = ^(NSArray *compleUrlArr) {
            WARGroupModel *uploadingmodel  = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker]  firstObject];
            if ([uploadingmodel.albumId isEqualToString:gmodel.albumId]) {
                gmodel.stateStr = @"正在上传";
            }
        };
    }];

}
- (void)reloadShuju {
    WS(weakself);
   WARGroupModel *model = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
    __block NSInteger idIndex = 0;
    if (model != nil){
        [self.dataphotoGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARGroupModel *gmodel = (WARGroupModel*)obj;
            if ([model.albumId isEqualToString:gmodel.albumId]) {
        
                idIndex = idx;
              //  gmodel.compleArray = model.compleArray;
                gmodel.stateStr = model.stateStr;
//                gmodel.uploadArray = model.uploadArray;
                gmodel.pictureCount = [NSString stringWithFormat:@"%ld",[model.pictureCount integerValue]+model.compleArray.count];
//                [gmodel.compleArray removeAllObjects];
                [weakself.collectionView reloadData];
              
            }
        }];
      
    }

}

- (NSMutableArray *)dataphotoGroupArray{
    if (!_dataphotoGroupArray) {
        _dataphotoGroupArray = [NSMutableArray array];
    }
    return _dataphotoGroupArray;
}
- (void)setPhotoGroupArray:(NSMutableArray *)photoGroupArray{
  
}
- (void)pareData:(NSArray *)dataArr{
    
    
    [self.dataphotoGroupArray removeAllObjects];
    if (self.isMine) {
           [self.dataphotoGroupArray addObject: [[WARGroupModel alloc] init]];
    }


    for (NSDictionary *dict in dataArr) {
        
        WARGroupModel *model = [WARGroupModel yy_modelWithDictionary:dict];
   
        model.isMine = self.isMine;
        model.stateStr = @"等待上传";
  
        if ([[WARPhotosUploadManger sharedGolbalViewManager] aryTasker].count > 0) {
            WARGroupModel *uploadingmodel  = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker]  firstObject];
            if ([uploadingmodel.albumId isEqualToString:model.albumId]) {
                model.stateStr = @"正在上传";
            }
            [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WARGroupModel *gmodel = (WARGroupModel*)obj;
                if ([gmodel.albumId isEqualToString:dict[@"albumId"]]){
                    model.uploadArray = gmodel.uploadArray;
                   
                }
            }];
            
        }
        if ([[WARDownPhotoManger sharedDownManager] aryTasker].count > 0) {
            [[[WARDownPhotoManger sharedDownManager] aryTasker] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WARGroupModel *gmodel = (WARGroupModel*)obj;
                if ([gmodel.albumId isEqualToString:dict[@"albumId"]]){
                    model.downArray = gmodel.downArray;
                    
                }
            }];
            
        }
     
        [self.dataphotoGroupArray addObject:model];
        
    }
    
    [self.collectionView reloadData];
}
- (void)coverpoinChange:(WARUSerCenterProfileCell *)cell drapPoint:(CGPoint)point photos:(TZAssetModel*)imagemodel{
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint: [self.collectionView convertPoint:point fromView:cell]];
    
    if(indexpath.item == 0){
     
        return;
    }
    
    self.selectRow = indexpath.item;
    [self.collectionView reloadData];
    
}

- (void)outOfRang {
    self.selectRow = -1;
    [self.collectionView reloadData];
}

- (void)coverpoin:(WARUSerCenterProfileCell *)cell drapPoint:(CGPoint)point photos:(TZAssetModel*)imagemodel {
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint: [self.collectionView convertPoint:point fromView:cell]];
    self.selectRow = -1;

    if(indexpath.item == 0){
  
        return;
    }
    
    WS(weakself);
    WARPhotoCell *photoCell =   [self.collectionView cellForItemAtIndexPath:indexpath];
    WARGroupModel *newGroupmodel = self.dataphotoGroupArray[indexpath.item];

        @autoreleasepool {
            [[WARPhotosUploadManger sharedGolbalViewManager] uploadData:newGroupmodel upImages:@[] upPhaset:@[imagemodel.asset] loactions:@[@""] isSelectOriginalPhoto:YES];

               [self.collectionView reloadData];
        }

    
 

}

# pragma mark - tableview 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataphotoGroupArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0&&self.isMine) {
        WARCreatPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"creatphotoCell" forIndexPath:indexPath];
        
        return cell;
    }else{
        WARPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processGesture:)];
        gesture.minimumPressDuration = 1;
        [cell addGestureRecognizer:gesture];
        cell.type = WARPhotoCellTypePhotoGroup;
        cell.model = self.dataphotoGroupArray[indexPath.item];
        if (self.selectRow == indexPath.item) {
            cell.maskView.hidden = NO;
        }else{
            cell.maskView.hidden = YES;
        }
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WARGroupModel *model =  self.dataphotoGroupArray[indexPath.item];
    if (self.block) {
        self.block(indexPath,model);
    }
    
}
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        self.albumView.collectionView.contentOffset = CGPointZero;
         self.videoView.collectionView.contentOffset = CGPointZero;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY<0) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
    }else{

    }
  
    
}
#pragma mark - warphotoCategoryDelegate
- (void)photosCatorgrayView:(WARPhotosCatorgrayView *)photosCatorgayView didSelectIndex:(NSInteger)index {
        [self.scrollerView setContentOffset:CGPointMake(index*kScreenWidth, 0)];
    WS(weakSelf);
    if (index == 1){
      
            [WARProfileNetWorkTool postPhotoListWithAtWithLastShootTime:@"" atlastFindId:@"" CallBack:^(id response) {
                
                WARPhotoListModel *model = [[WARPhotoListModel alloc] init];
                [model prase:response];
                weakSelf.albumView.photoModel = model;
                weakSelf.photoListModel = model;
                [weakSelf.albumView.collectionView.mj_footer endRefreshing];
            } failer:^(id response) {
                
            }];
       
    
    } else if (index == 2){
        [WARProfileNetWorkTool postVideoListWithLastShootTime:@"" atlastFindId:@"" CallBack:^(id response) {
            WARPhotoVideoListModel *model = [[WARPhotoVideoListModel alloc] init];
            [model prase:response];
            weakSelf.videoView.videoModel = model;
             weakSelf.photoVideoListModel = model;
            [weakSelf.videoView.collectionView.mj_footer endRefreshing];
        } failer:^(id response) {
            
        }];
            
    
    }else {
         [self loadLastData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurrentIndex" object:nil userInfo:@{@"index":@(index)}];

}
#pragma mark - event
- (void)processGesture:(UILongPressGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [WARActionSheet actionSheetWithButtonTitles:@[@"排序",@"删除"] cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if (index == 0) {
                
                if (self.sortBlock) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataphotoGroupArray];
                    [array removeObjectAtIndex:0];
                    self.sortBlock(array);
                }
            }else {
                CGPoint poin =  [gesture locationInView:gesture.view];
                WARPhotoCell *cell = (WARPhotoCell*)gesture.view;
                NSIndexPath *indexpath =    [self.collectionView indexPathForCell:cell];
                
                WARGroupModel *model = self.dataphotoGroupArray[indexpath.item];
         
                for (WARDownPictureModel *down in model.downArray) {
                    [WARDBUploadPhotoManger deleteDownTaskBytaskModelId:down.taskModelId];
                }
                for (WARupPictureModel *upmodel in model.uploadArray) {
                    [WARDBUploadPhotoManger deleteUoloadTaskBytaskModelId:upmodel.taskModelId];
                }
                [model.uploadArray removeAllObjects];
                [model.downArray removeAllObjects];
           
                [WARProfileNetWorkTool deletPhotoGroupId:model.albumId CallBack:^(id response) {
                    [WARProgressHUD showAutoMessage:@"删除成功"];
                    [self.dataphotoGroupArray removeObjectAtIndex:indexpath.item];
                    [self.collectionView reloadData];
                } failer:^(id response) {
                    [WARProgressHUD showAutoMessage:@"删除失败"];
                }];
            }
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } completionHandler:^{
            
        }];
        
    }
    
}

- (NSMutableArray *)toDoActImages:(NSArray *)photos{
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (UIImage* photo in photos) {
        if (photo) {
            WARFormData *formData = [[WARFormData alloc] init];
            CGSize size = photo.size;
            UIImage* scaleImage = [photo war_scaledToSize:CGSizeMake(kScaleFrom_iPhone5(size.width),kScaleFrom_iPhone5(size.height))highQuality:YES] ;
            formData.data = UIImageJPEGRepresentation(scaleImage, 0.8);
            formData.name = @"files";
            formData.mimeType = @"image/jpeg";
            formData.filename = @"activity_image.png";
            [formDataArray addObject:formData];
        }else{
            formDataArray = nil;
        }
    }
    return formDataArray;
}
- (WARPhotosCatorgrayView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[WARPhotosCatorgrayView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
    }
    return _categoryView ;
}
- (UIScrollView *)scrollerView{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth, kScreenHeight-58-34)];
        _scrollerView.scrollEnabled = NO;
        _scrollerView.contentSize = CGSizeMake(kScreenWidth*3, 0);
    }
    return _scrollerView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(CellW,CellW+15+30);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        CGFloat tabH =   WAR_IS_IPHONE_X?83:49;
                  flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 200+tabH+100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (self) {
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
        }
 
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HeaderView"];
        [_collectionView registerClass:[WARPhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
       [_collectionView registerClass:[WARCreatPhotosCell class] forCellWithReuseIdentifier:@"creatphotoCell"];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.tag = 1000;
    }
    return _collectionView;
}
- (UIButton *)uploadPhotoBtn{
    if (!_uploadPhotoBtn) {
        _uploadPhotoBtn = [[UIButton alloc] init];
        [_uploadPhotoBtn setImage:[UIImage war_imageName:@"wo_xiangce_tianjia" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
    }
    return _uploadPhotoBtn;
}
- (WARPhotoVideoAndPhotoImgView *)albumView{
    if (!_albumView) {
        _albumView = [[WARPhotoVideoAndPhotoImgView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight- (WAR_IS_IPHONE_X ?280:220)) atType:WARPhotoVideoAndPhotoImgViewTypePhoto];
   
    }
    return _albumView;
}
- (WARPhotoVideoAndPhotoImgView *)videoView{
    if (!_videoView) {
        _videoView = [[WARPhotoVideoAndPhotoImgView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-(WAR_IS_IPHONE_X ?280:220)) atType:WARPhotoVideoAndPhotoImgViewTypeVideo];
        _videoView.backgroundColor = [UIColor redColor];
    }
    return _videoView;
}
- (void)dealloc{
   

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;


}
@end
