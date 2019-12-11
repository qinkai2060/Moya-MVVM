//
//  WARFeedMagicImageCell.h
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedCell.h"

@class WARFeedImageComponent;
@protocol WARFeedMagicImageCellDelegate <NSObject>

- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView;

@end

@interface WARFeedMagicImageCell : WARFeedCell

@property (nonatomic, weak) id<WARFeedMagicImageCellDelegate> delegate;

@end
