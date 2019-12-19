//
//  HFBrowserImageNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFBrowserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFBrowserImageNewCell : HFHomeNewBaseCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)HFBrowserModel *browserModel;
//@property(nonatomic,strong)NSArray *dataSource;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;
@end

NS_ASSUME_NONNULL_END
