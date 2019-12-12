//
//  WARFaceMaskView.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import "WARFaceMaskView.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

#import "WARHorizontalFlowLayout.h"
#import "WARFaceMaskCollectionViewCell.h"
#import "WARCategoryCollectionViewCell.h"


#import "WARFaceMaskModel.h"
#import "WARContactCategoryModel.h"

#define kItemSize CGSizeMake(100, 100)

#define kWARFaceMaskCollectionViewCellID @"kWARFaceMaskCollectionViewCellID"
#define kWARCategoryCollectionViewCellID @"kWARCategoryCollectionViewCellID"


@interface WARFaceMaskView()<UICollectionViewDelegate,UICollectionViewDataSource,WARHorizontalFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation WARFaceMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    
        [self addSubview:self.titleLab];
        [self addSubview:self.addBtn];
        [self addSubview:self.editBtn];
        [self addSubview:self.collectionV];
        
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(28);
            make.left.right.mas_equalTo(0);
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.centerY.equalTo(self.titleLab);
        }];
        
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addBtn.mas_left).offset(-20);
            make.centerY.equalTo(self.titleLab);
        }];
        
        [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
            make.top.equalTo(self.titleLab.mas_bottom).offset(36);
            make.height.mas_equalTo(150);
        }];
    
        
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionV reloadData];
}

- (void)setType:(WARFaceMaskViewType)type{
    _type = type;
    switch (type) {
        case WARFaceMaskViewTypeOfFaceMask:{
            self.editBtn.hidden = YES;
            self.addBtn.hidden = NO;
            self.titleLab.text = WARLocalizedString(@"滑动选择不同形象编辑");

        }
            break;
        case WARFaceMaskViewTypeOfContactCategory:{
            self.editBtn.hidden = NO;
            self.addBtn.hidden = NO;
            self.titleLab.text = WARLocalizedString(@"滑动选择不同分组");
        }
            break;
        default:
            break;
    }
    
    
}


- (void)reloadFaces{
    [self.collectionV reloadData];
}


- (void)editBtnAction{
    if (self.didClickEditFaceBlock) {
        self.didClickEditFaceBlock();
    }
}

- (void)addBtnAction{
    if (self.didClickAddNewFaceBlock) {
        self.didClickAddNewFaceBlock();
    }
}



- (void)autoScrollToIndex:(NSInteger)index{
    if (index < self.dataArr.count) {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - collectionView delegate && datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == WARFaceMaskViewTypeOfFaceMask) {
        WARFaceMaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARFaceMaskCollectionViewCellID forIndexPath:indexPath];
        cell.faceLab.text = [NSString stringWithFormat:WARLocalizedString(@"形象%ld"),indexPath.row+1];
        WARFaceMaskModel *model = self.dataArr[indexPath.row];
        
        
        [cell.faceImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(150, 150), model.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        WS(weakSelf);
        cell.didLongPreBlock = ^{
            if (weakSelf.didLongPreCellBlcok) {
                weakSelf.didLongPreCellBlcok(indexPath);
            }
        };
        return cell;
    }else{
        WARCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARCategoryCollectionViewCellID forIndexPath:indexPath];
        WARContactCategoryModel *model = self.dataArr[indexPath.row];
        
        [cell configureCategoryModel:model];
        WS(weakSelf);
        cell.didLongPreBlock = ^{
            if (weakSelf.didLongPreCellBlcok) {
                weakSelf.didLongPreCellBlcok(indexPath);
            }
        };
        return cell;
    }

}


- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return CGSizeMake(50, collectionView.bounds.size.height);
    return kItemSize;
}

- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
}


#pragma mark - WARHorizontalFlowLayoutDelegate
- (void)scrolledToTheCurrentItemAtIndex:(NSInteger)itemIndex{
    if (self.didScrollItemBlock) {
        self.didScrollItemBlock(itemIndex);
    }
}



#pragma mark - getter methods
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = kFont(11);
        _titleLab.textColor = RGB(153, 153, 153);
    }
    return _titleLab;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage war_imageName:@"list_tianjia" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage war_imageName:@"list_edit" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UICollectionView *)collectionV{
    if (!_collectionV) {
        WARHorizontalFlowLayout *layout = [[WARHorizontalFlowLayout alloc] init];
        layout.layoutDelegate = self;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) collectionViewLayout:layout];
        _collectionV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.decelerationRate = UIScrollViewDecelerationRateNormal;
        [_collectionV registerClass:[WARFaceMaskCollectionViewCell class] forCellWithReuseIdentifier:kWARFaceMaskCollectionViewCellID];
        [_collectionV registerClass:[WARCategoryCollectionViewCell class] forCellWithReuseIdentifier:kWARCategoryCollectionViewCellID];

        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.backgroundColor = kColor(whiteColor);
    }
    return _collectionV;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
