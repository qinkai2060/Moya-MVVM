//
//  WARFriendCommentMediaView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentMediaView.h"
#import "Masonry.h"
#import "WARFriendCommentMediaCCell.h"
#import "WARMacros.h"
#import "ReactiveObjC.h"
#import "WARFriendComment.h"

@interface WARFriendCommentMediaView ()< UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView; // 配图
@end


@implementation WARFriendCommentMediaView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setLayout:(WARFriendCommentLayout *)layout{
    
    _layout = layout;
    
    if (!kArrayIsEmpty(_layout.comment.medias) && layout.isMessageListUsed) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 5;
        
        WARMomentMedia *media = [_layout.comment.medias objectAtIndex:0];
        flowLayout.itemSize = CGSizeMake([media.imgW integerValue], [media.imgH integerValue]);
        self.collectionView.collectionViewLayout = flowLayout;
    } 
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.layout.comment.medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WARFriendCommentMediaCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WARFriendCommentMediaCCellID forIndexPath:indexPath];
    if (!kArrayIsEmpty(self.layout.comment.medias) && (indexPath.row < self.layout.comment.medias.count)) {
        WARMomentMedia* media = self.layout.comment.medias[indexPath.row];
        cell.media = media;
        
        @weakify(self)
        [[cell.playVideoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.playVideo) {
                self.playVideo(media);
            }
        }];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
#warning 点击评论图片
    NSMutableArray* tempArr = [NSMutableArray array];
    if (!kArrayIsEmpty(self.layout.comment.medias)) {
        for (WARMomentMedia* media in self.layout.comment.medias) {
            [tempArr addObject:media.originalImgURL];
        }
    }
    if (self.showPhotoBrower) {
        self.showPhotoBrower(tempArr, indexPath.row);
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kCommentCollectionCellWH, kCommentCollectionCellWH);
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        [_collectionView setBackgroundView:nil];
        //        [_collectionView setBackgroundColor:HEXCOLOR(0xF4F4F6)];
                [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WARFriendCommentMediaCCell class] forCellWithReuseIdentifier:WARFriendCommentMediaCCellID];
    }
    return _collectionView;
}


//UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
//layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//layout.itemSize = CGSizeMake(kCommentCollectionCellWH, kCommentCollectionCellWH);
//layout.minimumLineSpacing = 5;

@end
