//
//  WARProfileFaceView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/16.
//

#import "WARProfileFaceView.h"
#import "WARProfileCoverLayout.h"
#import "WARMacros.h"
#import "WARProfileFaceCell.h"
#import "WARProfileUserModel.h"
@interface WARProfileFaceView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView*collectionView;
@property (nonatomic, strong) WARProfileCoverLayout *faceLayout;
@property (nonatomic,assign) NSInteger currentItem;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *showArray;
@end
@implementation WARProfileFaceView

-(instancetype)initWithFrame:(CGRect)frame{
       frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    if (self = [super initWithFrame:frame]) {
        self.faceLayout =[[WARProfileCoverLayout alloc]init];
        _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:self.faceLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _collectionView.alpha = 1;
        _collectionView.tag = 100002;
        _collectionView.clipsToBounds = NO;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[WARProfileFaceCell class] forCellWithReuseIdentifier:@"faceCell"];
        self.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        [self.faceLayout setScrollDidBlock:^(NSInteger index) {
            weakSelf.currentItem = index;
      
        }];

    }
    return self;
    
}
#define ITEM_COUNT    9 //条目数
#define REPEAT_TIMES  60
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
-(NSMutableArray *)showArray{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}

- (void)scrollToIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WARProfileFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCell" forIndexPath:indexPath];
    WARProfileMasksModel *maskModel = self.dataSource[indexPath.row];
    cell.maskModel = maskModel;
    WS(weakSelf);
    cell.longPressBlock = ^{
        if (weakSelf.longPressBlock) {
            weakSelf.longPressBlock(indexPath.row);
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    [self.timer invalidate];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    

    NSIndexPath *index = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
    if ([self.delegate respondsToSelector:@selector(faceView:didShowItemAtIndex:)]) {
        [self.delegate faceView:self didShowItemAtIndex:index.item];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(jumpToTargetItem) userInfo:index repeats:NO];
}
-(void)jumpToTargetItem{
    [self.collectionView scrollToItemAtIndexPath:self.timer.userInfo atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.timer invalidate];
    self.timer = nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    NSIndexPath *index = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
    if ([self.delegate respondsToSelector:@selector(faceView:didShowItemAtIndex:)]) {
        [self.delegate faceView:self didShowItemAtIndex:index.item];
    }
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
@end
