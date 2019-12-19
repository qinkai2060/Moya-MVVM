//
//  YunDianRefundSelectImgView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YunDianRefundSelectImgViewDelegate <NSObject>

- (void)yunDianRefundSelectImgViewDelegateAtction:(NSInteger)index;

@end

@interface YunDianRefundSelectImgView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arr;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, weak) id <YunDianRefundSelectImgViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
