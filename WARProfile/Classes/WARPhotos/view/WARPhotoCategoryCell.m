//
//  WARPhotoCategoryCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import "WARPhotoCategoryCell.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARPhotoCategoryCollectionCell.h"
#import "WARPhotoViewController.h"
@implementation WARPhotoCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier atType:(WARPhotoCategoryCellType)type{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.type = type;
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.bottom.right.equalTo(self.contentView);
            
        }];
    }
    return self;
}
- (void)setVideoModel:(WARPhotoVideoModel *)videoModel{
    _videoModel = videoModel;
    
    [self.collectionView reloadData];
}
- (void)setPhotoModel:(WARPhotoPictureModel *)photoModel{
    _photoModel = photoModel;
    
     [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == WARPhotoCategoryCellTypePhoto) {
        
           return  self.photoModel.dateData.count;
    }else {
           return  self.videoModel.dateData.count;
    }
 
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARPhotoCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.type == WARPhotoCategoryCellTypePhoto) {
        
        cell.albumModel = self.photoModel.dateData[indexPath.item];
    }else {
         cell.videoModel = self.videoModel.dateData[indexPath.item];
    }
    return cell;
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[WARPhotoCategoryCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}
@end
