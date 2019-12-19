//
//  SpProductReviewDetailPicCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

@interface SpProductReviewDetailPicCell : UICollectionViewCell


/* 图片 */
@property (strong , nonatomic)UIImageView *pciImageView;
@property (strong , nonatomic)CommentPictureListItem *picItem;
-(void)reSetVDataValue:(CommentPictureListItem*)productInfo;
@end
