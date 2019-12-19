//
//  AssembleSearchListMainView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleSearchListMainView.h"
#import "AssembleCollectionViewCell.h"
#import "SpTypesSearchListTwoCollectionViewCell.h"


@interface AssembleSearchListMainView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isListView;

@end
@implementation AssembleSearchListMainView
- (instancetype)initWithFrame:(CGRect)frame withSearchStr:(NSString *)searchStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.isListView = YES;
        [self createViewWithSearchStr:searchStr];
    }
    return self;
}

- (void)createViewWithSearchStr:(NSString *)searchStr{
    //
    self.searchView = [[AssembleSearchView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44) isAddOneBtn:YES addBtnImageName:@"spTypes_search_collection" addBtnTitle:@"" searchKeyStr:searchStr canEidt:NO placeholderStr:@"" isHaveBack:YES isHaveBottomLine:NO];
    __weak typeof(self)weakSelf = self;
    self.searchView.searchRightBtnClickBlock = ^(UIButton * _Nonnull btn) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            weakSelf.isListView = NO;
            [btn setImage:[UIImage imageNamed:@"spTypes_search_list"] forState:UIControlStateNormal];
        } else {
            weakSelf.isListView = YES;
            [btn setImage:[UIImage imageNamed:@"spTypes_search_collection"] forState:UIControlStateNormal];
        }
        [weakSelf.collectionView reloadData];
    };
    [self addSubview:self.searchView];
    
    //
    self.topView = [[SpTypesSearchTopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.frame.size.width, 50)];
    [self addSubview:self.topView];
    
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 4;
    //最小两行之间的间距
    layout.minimumLineSpacing = 4;
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.topView.frame)) collectionViewLayout:layout];
    _collectionView.backgroundColor= [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self addSubview:_collectionView];
    
    //这种是自定义cell不带xib的注册
    [_collectionView registerClass:[AssembleCollectionViewCell class] forCellWithReuseIdentifier:@"OneCollectionCell"];
    [_collectionView registerClass:[SpTypesSearchListTwoCollectionViewCell class] forCellWithReuseIdentifier:@"TwoCollectionCell"];
}

// 刷新数据
- (void)refreshViewWithData:(NSMutableArray *)dataSource{
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.dataSource = dataSource;
    [self.collectionView reloadData];
}

#pragma mark collectionView delegate
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isListView) {
        _collectionView.backgroundColor= [UIColor whiteColor];
        AssembleCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OneCollectionCell" forIndexPath:indexPath];
        
        if (self.dataSource.count > indexPath.row) {
            SearchListModel *model = self.dataSource[indexPath.row];
//            model.cellIndexRow = indexPath.row;
            [cell refreshCellWithModel:model];
            
            // 进店
            __weak typeof( self)weakSelf=self;
            cell.toShopBtnClickBlock = ^(AssembleCollectionViewCell * _Nonnull cell, NSInteger cellIndexRow) {
                if (weakSelf.dataSource.count > cellIndexRow) {
                    SearchListModel *model = weakSelf.dataSource[cellIndexRow];
                    if ([weakSelf.delegate respondsToSelector:@selector(searchListToShopBtnClickWithModel:)]) {
                        [weakSelf.delegate searchListToShopBtnClickWithModel:model];
                    }
                }
            };
        }
        return cell;
    } else {
        _collectionView.backgroundColor=RGBACOLOR(242, 242, 242, 1);
        SpTypesSearchListTwoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TwoCollectionCell" forIndexPath:indexPath];
        
        if (self.dataSource.count > indexPath.row) {
            SearchListModel *model = self.dataSource[indexPath.row];
//            model.cellIndexRow = indexPath.row;
            [cell refreshCellWithModel:model];
            
            // 进店
            __weak typeof( self)weakSelf=self;
            cell.toShopBtnClickBlock = ^(SpTypesSearchListTwoCollectionViewCell * _Nonnull cell, NSInteger cellIndexRow) {
                if (weakSelf.dataSource.count > cellIndexRow) {
                    SearchListModel *model = weakSelf.dataSource[cellIndexRow];
                    if ([weakSelf.delegate respondsToSelector:@selector(searchListToShopBtnClickWithModel:)]) {
                        [weakSelf.delegate searchListToShopBtnClickWithModel:model];
                    }
                }
            };
        }
        return cell;
    }
}
//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.isListView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 4, 0, 4);
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isListView) {
        return CGSizeMake(ScreenW, 140);
    } else {
        return CGSizeMake((ScreenW - 12) / 2, (ScreenW - 12) / 2 + 120);
    }
}
//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count > indexPath.row) {
        SearchListModel *model = self.dataSource[indexPath.row];
       
        if ([self.delegate respondsToSelector:@selector(searchListCellDidSelectRowAtIndexWithModel:)]) {
            [self.delegate searchListCellDidSelectRowAtIndexWithModel:model];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
