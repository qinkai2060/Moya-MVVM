//
//  WARUserDiaryTweetCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import <UIKit/UIKit.h>
#import "WARUserDiaryBaseTableViewCell.h"

@class WARUserDiaryEventModel;

@interface WARUserDiaryTweetCell : WARUserDiaryBaseTableViewCell

- (void)configureModel:(WARUserDiaryEventModel *)model;
@end



@interface WARUserDiaryTweetPhotoCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *photoImgV;
@end
