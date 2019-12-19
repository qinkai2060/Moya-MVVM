//
//  HMHHomepageVideoCollectionViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoHomeGriditemModel.h"
#import "HMHVideoListModel.h"

@interface HMHHomepageVideoCollectionViewCell : UICollectionViewCell

- (void)refreshViewWithModel:(HMHVideoHomeGriditemModel *)model;

- (void)moreWonderfullWithModel:(HMHVideoListModel *)model;

@end
