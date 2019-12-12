//
//  WARPhotoVideoAndPhotoImgView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import "WARPhotoVideoAndPhotoImgView.h"
#import "WARMacros.h"
#import "WARPhotoCategoryCell.h"
#import "WARPhotoViewController.h"
#import "WARPhotoCategoryCollectionCell.h"
#import "UIView+Frame.h"
@interface WARPhotoVideoAndPhotoImgView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation WARPhotoVideoAndPhotoImgView

- (instancetype)initWithFrame:(CGRect)frame atType:(WARPhotoVideoAndPhotoImgViewType)type{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self addSubview:self.collectionView];
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, kScreenWidth,55)];
//        footer.backgroundColor = UIColorClear;
//        [self addSubview:footer];
    }
    return self;
}
- (void)setPhotoModel:(WARPhotoListModel *)photoModel{
    _photoModel = photoModel;
    [self.collectionView reloadData];
}
- (void)setVideoModel:(WARPhotoVideoListModel *)videoModel {
    _videoModel = videoModel;
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    WARPhotoViewController *vc = [self currentVC:self];
    if (!vc.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
        vc.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
    
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

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((kScreenWidth-25)/4,(kScreenWidth-25)/4);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
         flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 34);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_collectionView registerClass:[WARPhotoCategoryCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WARPhotoViewController *vc = [self currentVC:self];

    if (self.type == WARPhotoCategoryCellTypePhoto) {
        WARPhotoPictureModel *photoModel = self.photoModel.pictures[indexPath.section];
         WARDetailDateDataModel *albumModel= photoModel.dateData[indexPath.item];
        if (vc.tempBrowserBlock) {
            vc.tempBrowserBlock(photoModel.dateData, indexPath.item);
        }
    }else {
        WARPhotoVideoModel *video = self.videoModel.videos[indexPath.section];
        WARPictureModel *videoModel = video.dateData[indexPath.item];
        if (vc.tempBrowserBlock) {
            vc.tempBrowserBlock(video.dateData, indexPath.item);
        }
    }
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel *headerlb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 15)];
           headerlb.frame = CGRectMake(10, 0, kScreenWidth-15, 34);
        if (self.type == WARPhotoVideoAndPhotoImgViewTypePhoto) {
            WARPhotoPictureModel *model = self.photoModel.pictures[indexPath.section];
             headerlb.text = WARLocalizedString(model.date);
        }else{
            WARPhotoVideoModel *model = self.videoModel.videos[indexPath.section];
            headerlb.text = WARLocalizedString(model.date);
        }
        headerlb.textColor = SubTextColor;
        headerlb.font = kFont(14);

        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        [headerView addSubview:headerlb];
        return headerView;
    }else{
        return nil;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.type == WARPhotoVideoAndPhotoImgViewTypePhoto) {
        return self.photoModel.pictures.count;
    }else{
        return self.videoModel.videos.count;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == WARPhotoVideoAndPhotoImgViewTypePhoto) {
   
        WARPhotoPictureModel *photoModel = self.photoModel.pictures[section];
        return photoModel.dateData.count;
    }else{
        WARPhotoVideoModel *video = self.videoModel.videos[section];
         return  video.dateData.count;
    }

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARPhotoCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.type == WARPhotoCategoryCellTypePhoto) {
        WARPhotoPictureModel *photoModel = self.photoModel.pictures[indexPath.section];
        cell.albumModel = photoModel.dateData[indexPath.item];
    }else {
         WARPhotoVideoModel *video = self.videoModel.videos[indexPath.section];
        cell.videoModel = video.dateData[indexPath.item];
    }
    return cell;
}
@end
