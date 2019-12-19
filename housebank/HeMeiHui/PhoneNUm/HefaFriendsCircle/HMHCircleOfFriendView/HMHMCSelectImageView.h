//
//  HMHMCSelectImageView.h
//  SalesCircle
//
//  Created by chenpeng on 2016/12/23.
//  Copyright © 2016年 雷雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHMCSelectImageView : UIView

@property (nonatomic ,strong) NSMutableArray *selectImageArrary;
@property (nonatomic ,strong) UICollectionView *myCollectionView;

@property (nonatomic ,copy) void(^deleteItemIndex)(NSInteger);
@property (nonatomic ,copy) void(^gotoSelectImageView)();


@end
