//
//  HMHMCSelectImageView.m
//  SalesCircle
//
//  Created by chenpeng on 2016/12/23.
//  Copyright © 2016年 雷雷. All rights reserved.
//

#import "HMHMCSelectImageView.h"
#import "MCSelectImageUploadCollectionViewFlowLayout.h"

@interface HMHMCSelectImageView ()<UICollectionViewDelegate ,UICollectionViewDataSource>

@end

@implementation HMHMCSelectImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selectImageArrary = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20, frame.size.height) collectionViewLayout:[MCSelectImageUploadCollectionViewFlowLayout new]];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [self addSubview:_myCollectionView];
    }
    return self;
}

- (void)setSelectImageArrary:(NSMutableArray *)selectImageArrary{
    _selectImageArrary = selectImageArrary;
    [self.myCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_selectImageArrary.count < 9) {
        return _selectImageArrary.count + 1;
    }
    return _selectImageArrary.count;
}


- (void)deleteBtnClik:(UIButton *)sender {
    [_selectImageArrary removeObjectAtIndex:sender.tag];
    [_myCollectionView reloadData];
    if (_deleteItemIndex) {
        _deleteItemIndex(sender.tag);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectImageArrary.count < 9 && _selectImageArrary.count == indexPath.item) {//选择图片
        if (_gotoSelectImageView) {
            _gotoSelectImageView();
        }
    }
}


@end
