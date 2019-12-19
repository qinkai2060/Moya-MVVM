//
//  HMHDGYHomePhotosView.h
//  SalesCircle
//
//  Created by QianDeng on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHHeFaCircleOfFriendModel.h"
#import "GetCommentListModel.h"

@interface HMHDGYHomePhotosView : UIView

@property(nonatomic, strong) void (^imageTap)(NSInteger index);
@property (nonatomic, strong) NSArray<NSString *> *imageDataArray;

// 合友圈
- (id)initWithFrame:(CGRect)frame withCircleInfo:(HMHHeFaCircleOfFriendModel *)model;

+(CGFloat)getPhotosHeightWithModel:(HMHHeFaCircleOfFriendModel *)model;

// 合发购 评论
- (id)initWithFrame:(CGRect)frame withHeFaShoppingCommentInfo:(GetCommentListModel *)model;
//中间可变内容高度 (内容+图片)
+(CGFloat)getHeFaShoppingCommentPhotosHeightWithModel:(GetCommentListModel *)model;

@end
