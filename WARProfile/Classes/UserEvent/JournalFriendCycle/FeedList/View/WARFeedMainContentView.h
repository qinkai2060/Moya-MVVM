//
//  WARFeedMainContentView.h
//  Pods
//
//  Created by helaf on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "WARFeedHeader.h"
#import "WARFeedModelProtocol.h"

@class WARFeedPageLayout,WARFeedMainContentView ,WARFeedComponentContent,WARFeedImageComponent,WARFeedLinkComponent;

@protocol WARFeedMainContentViewDelegate <NSObject>

@optional
/**
 点击视图响应

 @param feedMainContentView feedMainContentView
 */
-(void)didFeedMainContentView:(WARFeedMainContentView *)feedMainContentView ;

/**
 左右滑动

 @param feedMainContentView
 @param scrollToLeft
 */
-(void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView scrollToLeft:(BOOL)scrollToLeft;

/**
 结束滑动

 @param feedMainContentView
 @param finishHorizontalScroll 
 */
-(void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView finishHorizontalScroll:(BOOL)finishHorizontalScroll;


/**
 点击链接响应
 
 @param feedMainContentView feedMainContentView
 */
-(void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didLink:(WARFeedLinkComponent *)link ;
/**
 点击游戏链接响应
 
 @param feedMainContentView feedMainContentView
 */
-(void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didGameLink:(WARFeedLinkComponent *)didGameLink;

/**
 点击图片响应
 
 @param feedMainContentView feedMainContentView
 */
-(void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView;

@end

@interface WARFeedMainContentView : UIView

/** delegate */
@property (nonatomic, weak) id<WARFeedMainContentViewDelegate> delegate;
/** 遵循的协议对象 */
@property (nonatomic, strong) id <WARFeedModelProtocol> modelProtocol;

@end
