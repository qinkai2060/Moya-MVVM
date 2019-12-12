//
//  WARFeedPageContentViewController.h
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "WARFeedHeader.h"

@class WARFeedComponentContent,WARPageContentViewController,WARFeedImageComponent,WARFeedLinkComponent;
@protocol WARPageContentViewControllerDelegate <NSObject>
@optional
- (void)controller:(WARPageContentViewController *)controller didLink:(WARFeedLinkComponent *)link;
- (void)controller:(WARPageContentViewController *)controller didGameLink:(WARFeedLinkComponent *)didGameLink;
- (void)controller:(WARPageContentViewController *)controller didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView;
 
@end


@interface WARPageContentViewController : UIViewController

/** delegate */
@property (nonatomic, weak) id<WARPageContentViewControllerDelegate> delegate;

/** 页的布局对象 */
@property (nonatomic, strong) WARFeedPageLayout *pageLayout;

@end
