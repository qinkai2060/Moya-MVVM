//
//  SpFeatureItemCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpProductReviewCell.h"
#import "SpProductReviewHeaderView.h"
#import "SpProductReviewDetailCell.h"
#import "SpaceLineCell.h"
#import "SpNoHasCommentCollectionViewCell.h"

@interface SpProductReviewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const SpProductReviewDetailCellID = @"SpProductReviewDetailCell";
static NSString *const SpProductReviewHeaderViewID = @"SpProductReviewHeaderView";
static NSString *const SpaceLineCellID=@"SpaceLineCell";
static NSString *const SpNoHasCommentCollectionViewCellID=@"SpNoHasCommentCollectionViewCell";

@implementation SpProductReviewCell

#pragma mark - LoadLazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
//        layout.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        //注册
           [_collectionView registerClass:[SpProductReviewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SpProductReviewHeaderViewID];
        [_collectionView registerClass:[SpProductReviewDetailCell class] forCellWithReuseIdentifier:SpProductReviewDetailCellID];
         [_collectionView registerClass:[SpaceLineCell class] forCellWithReuseIdentifier:SpaceLineCellID];
        [_collectionView registerClass:[SpNoHasCommentCollectionViewCell class] forCellWithReuseIdentifier:SpNoHasCommentCollectionViewCellID];

    
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.commentList.data.commentList.list.count>=2) {
         return  4;
    }else if (self.commentList.data.commentList.list.count==1)
    {
        return 2;
    }else
    {
        return 2;
    }
    
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *gridcell = nil;
    if (self.commentList.data.commentList.list.count==0) {
        if (indexPath.row==0) {
        SpNoHasCommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpNoHasCommentCollectionViewCellID forIndexPath:indexPath];
        gridcell = cell;
        } else {//间隔
            SpaceLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpaceLineCellID forIndexPath:indexPath];
            cell.backgroundColor=HEXCOLOR(0xF5F5F5);
            gridcell = cell;
        }
    } else {
    if (indexPath.row==0||indexPath.row==2) {//间隔
        SpaceLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpaceLineCellID forIndexPath:indexPath];
        cell.backgroundColor=HEXCOLOR(0xF5F5F5);
        gridcell = cell;
    }else
    {
        SpProductReviewDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpProductReviewDetailCellID forIndexPath:indexPath];
        ListItem *commentItem;
        if (indexPath.row==1) {
            commentItem=[self.commentList.data.commentList.list objectAtIndex:0];
        }else
        {
            commentItem=[self.commentList.data.commentList.list objectAtIndex:1];
        }
        cell.commentList=self.commentList;
        [cell reSetVDataValue:commentItem];
        gridcell = cell;
    }
    }
    return gridcell;
}
//设置各个区的头部尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            
            SpProductReviewHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SpProductReviewHeaderViewID forIndexPath:indexPath];
            [headerView setComNum:[NSString stringWithFormat:@"%ld",(unsigned long)self.commentList.total]];
            
            
            
            reusableview = headerView;
         }
    }
    return reusableview;
    
}
#pragma mark - <UICollectionViewDelegate>
#pragma mark - item宽高   待计算动态高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.commentList.data.commentList.list.count==0) {
        if (indexPath.row== 0 ){
        return  CGSizeMake(ScreenW, 60) ;
        } else {
            return  CGSizeMake(ScreenW, 10) ;
        }
    } else {
    if (indexPath.row==0||indexPath.row==2) {
      return  CGSizeMake(ScreenW, 1) ;
    }else
    {
        ListItem *commentItem;
        if (indexPath.row==1) {
            if (self.commentList.data.commentList.list.count>0) {
                 commentItem=[self.commentList.data.commentList.list objectAtIndex:0];
            }
           
        }else
        {
            if (self.commentList.data.commentList.list.count>1) {
                 commentItem=[self.commentList.data.commentList.list objectAtIndex:1];
            }
          
        }
            if (commentItem.commentPictureList.count>0) {
                return  CGSizeMake(ScreenW, 225) ;//有图片
            }else
            {
                return CGSizeMake(ScreenW, 100);//无
            }
        
        
    }
    }
   
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return  CGSizeMake(ScreenW, 45);
}

//#pragma mark - foot宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return (section == 4) ? CGSizeMake(ScreenW, 50) : CGSizeMake(ScreenW, DCMargin);
//}

#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
      [[NSNotificationCenter defaultCenter]postNotificationName:SeaTheReviewList object:nil userInfo:nil];
}
-(void)reSetVDataValue:(CommentListModel*)productInfo
{
    self.commentList=productInfo;
}
#pragma mark - Setter Getter Methods


@end
