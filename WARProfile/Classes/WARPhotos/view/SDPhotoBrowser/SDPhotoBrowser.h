//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
- (void)photoBrowserWithKeyBordRegisnFirstResponder:(SDPhotoBrowser *)browser;
- (void)photoBrowser:(SDPhotoBrowser *)browser CurrentIndex:(NSInteger)index;
- (void)photoBrowser:(SDPhotoBrowser *)browser longGesture:(UILongPressGestureRecognizer*)gesture;
@end

typedef void (^pushBlock) ();
@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>
{
     UIScrollView *_scrollView;
}
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger scrollendIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray *showArr;
@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;
@property (nonatomic,strong)UIButton *v;
@property (nonatomic, copy) NSString *urlID;
@property (nonatomic,copy)pushBlock block;

- (void)show;
- (void)stop;
@end
