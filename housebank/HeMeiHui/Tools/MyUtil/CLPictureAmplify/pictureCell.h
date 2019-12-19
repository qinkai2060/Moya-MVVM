//
//  pictureCell.h
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCellImageBlock)();

typedef void(^longPressCellImageBlock)();

typedef void(^doubleTapImageBlock)(UIPinchGestureRecognizer * pinchGes);

typedef void(^panTapBlock)(UIPanGestureRecognizer *panGes);

@interface pictureCell : UICollectionViewCell
@property (nonatomic,strong) UIImage *picImg;

@property (nonatomic,strong) clickCellImageBlock clickCellImage;

// 长按手势
@property (nonatomic, strong) longPressCellImageBlock longPressImage;

@property (nonatomic, strong) doubleTapImageBlock doubleTap;

@property (nonatomic, strong) panTapBlock panTap;

@end
