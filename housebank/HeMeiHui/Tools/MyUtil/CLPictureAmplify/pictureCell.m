//
//  pictureCell.m
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "pictureCell.h"

@interface pictureCell()
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@end

@implementation pictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picView.userInteractionEnabled = YES;
    [self.picView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageForDismiss)]];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [self.picView addGestureRecognizer:longGesture];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    [self.picView addGestureRecognizer:pinchRecognizer];
    
//    UIPanGestureRecognizer *panTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTapGesture:)];
//    [self.picView addGestureRecognizer:panTap];
    
}

- (void)clickImageForDismiss
{
    self.clickCellImage();
}

// 添加长按手势
- (void)showMenu:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressImage) {
            self.longPressImage();
        }
    }
}

- (void)setPicImg:(UIImage *)picImg
{
    _picImg = picImg;
    self.picView.image = picImg;
    self.picView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark ----------- 缩放手势响应事件
- (void)didDoubleTap:(UIPinchGestureRecognizer *)pinchGes{
    if (self.doubleTap) {
        self.doubleTap(pinchGes);
    }
}

- (void)panTapGesture:(UIPanGestureRecognizer *)panGes{
    if (self.panTap) {
        self.panTap(panGes);
    }
}

@end
