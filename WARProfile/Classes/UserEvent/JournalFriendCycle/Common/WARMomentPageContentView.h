//
//  WARMomentPageContentView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <UIKit/UIKit.h>

@class WARFeedPageLayout,WARFeedImageComponent,WARFeedLinkComponent,WARMomentPageContentView,WARFeedGame;
@protocol WARMomentPageContentViewDelegate <NSObject>
@optional
/** 点击图片 */ 
- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView ;
/** 点击普通链接 */
- (void)pageContentView:(WARMomentPageContentView *)pageContentView didLink:(WARFeedLinkComponent *)link;
/** 点击游戏链接 */
- (void)pageContentView:(WARMomentPageContentView *)pageContentView didGameLink:(WARFeedLinkComponent *)didGameLink;
/** 点击游戏所有排行 */
- (void)pageContentViewDidAllRank:(WARMomentPageContentView *)pageContentView game:(WARFeedGame *)game;
@end

@interface WARMomentPageContentView : UIView
/** delegate */
@property (nonatomic, weak) id<WARMomentPageContentViewDelegate> delegate;
/** 页的布局对象 数组 */
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* pageLayoutArray;

/** componentHasExtraHeight */
@property (nonatomic, assign) BOOL componentHasExtraHeight;
@end
