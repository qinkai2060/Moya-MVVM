//
//  HFDescoveAsyncLayout.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFDescoveAsyncLayout;
@protocol HFDescoveAsyncLayouttDelegate <NSObject>

@required
//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)waterfallLayout:(HFDescoveAsyncLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HFDescoveAsyncLayout : UICollectionViewFlowLayout
//代理，用来计算item的高度
@property (nonatomic, weak) id<HFDescoveAsyncLayouttDelegate> delegate;
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;

@end

NS_ASSUME_NONNULL_END
