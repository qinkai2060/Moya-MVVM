//
//  WARDiaryMagicImageCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/17.
//

#import "WARFeedCell.h"

@class WARFeedImageComponent;

@protocol WARDiaryMagicImageCellDelegate <NSObject>
 
- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView ;

@end

@interface WARDiaryMagicImageCell : WARFeedCell

@property (nonatomic, weak) id<WARDiaryMagicImageCellDelegate> delegate;

@end
