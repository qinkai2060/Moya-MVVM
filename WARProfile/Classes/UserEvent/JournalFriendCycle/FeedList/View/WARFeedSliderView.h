//
//  WARFeedSliderView.h
//  WARControl
//
//  Created by helaf on 2018/4/27.
//

#import <UIKit/UIKit.h>


@protocol WARFeedSliderViewDelegate <NSObject>

@optional

- (void)feedSliderChangeIndex:(NSInteger)currentIndex;

@end


@interface WARFeedSliderView : UIControl


//刷新视图
- (void)reloadData:(CGFloat)value;


- (void)updateSliderCurrentPage:(NSInteger)currentPage pageCount:(NSInteger)pageCount;


@property (nonatomic,weak,nullable) id<WARFeedSliderViewDelegate> delegate;

@end
