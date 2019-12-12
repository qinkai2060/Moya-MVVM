//
//  WARActivateSegmentBar.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <UIKit/UIKit.h>


typedef void(^WARExploreSegmentBarDidBlock)(NSInteger didIndex);

@interface WARExploreSegmentBar : UIView
/** didBlock */
@property (nonatomic, copy) WARExploreSegmentBarDidBlock didBlock;
/** selectedIndex */
@property (nonatomic, assign) NSInteger selectedIndex;

@end

#pragma mark - WARActivateItemView

typedef void(^WARExploreItemDidBlock)(void);

@interface WARExploreItemView:UIView

/** didBlock */
@property (nonatomic, copy) WARExploreItemDidBlock didBlock;
/** eventButton */
@property (nonatomic, strong) UIButton *eventButton;

- (void)configTitle:(NSString *)title number:(NSString *)number;

@end
