//
//  RefundSelectImgCollectionViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RefundSelectImgCollectionViewCellDelegate <NSObject>
- (void)refundSelectImgCollectionViewCellCloseIndex:(NSInteger)Index;
@end
@interface RefundSelectImgCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, weak) id <RefundSelectImgCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
