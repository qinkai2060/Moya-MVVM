//
//  SpCommentListImagesView.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpCommentListImagesView : UIView

@property(nonatomic, strong) void (^imageTap)(NSInteger index);
@property (nonatomic, strong) NSArray<NSString *> *imageDataArray;

- (id)initWithFrame:(CGRect)frame withCircleInfo:(GetCommentListModel *)model;

+(CGFloat)getPhotosHeightWithModel:(GetCommentListModel *)model;


@end

NS_ASSUME_NONNULL_END
