//
//  HFVideoView.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFPlayerControl;
/*
 * The scroll direction of scrollView.
 */
typedef NS_ENUM(NSUInteger, ZFPlayerScrollDirection) {
    ZFPlayerScrollDirectionNone,
    ZFPlayerScrollDirectionUp,         // Scroll up
    ZFPlayerScrollDirectionDown,       // Scroll Down
    ZFPlayerScrollDirectionLeft,       // Scroll left
    ZFPlayerScrollDirectionRight       // Scroll right
};



@interface HFVideoView : UITableView

@property(nonatomic,strong) ZFPlayerControl * playeControl;


/// The block invoked When the player appearing.
@property (nonatomic, copy, nullable) void(^zf_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/// The block invoked When the player disappearing.
@property (nonatomic, copy, nullable) void(^zf_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/// The block invoked When the player will appeared.
@property (nonatomic, copy, nullable) void(^zf_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did appeared.
@property (nonatomic, copy, nullable) void(^zf_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player will disappear.
@property (nonatomic, copy, nullable) void(^zf_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did disappeared.
@property (nonatomic, copy, nullable) void(^zf_playerDidDisappearInScrollView)(NSIndexPath *indexPath);
/// The block invoked When the player did stop scroll.
@property (nonatomic, copy, nullable) void(^zf_scrollViewDidStopScrollCallback)(NSIndexPath *indexPath);

/// The block invoked When the player should play.
@property (nonatomic, copy, nullable) void(^zf_shouldPlayIndexPathCallback)(NSIndexPath *indexPath);

@property (nonatomic, assign) ZFPlayerScrollDirection zf_scrollDirection;

@property (nonatomic, assign) BOOL pauseWhenAppResignActive;

/// You can custom the AVAudioSession,
/// default is NO.
@property (nonatomic, assign) BOOL customAudioSession;

/// The current player controller is disappear, not dealloc
@property (nonatomic, getter=isViewControllerDisappear) BOOL viewControllerDisappear;

@property (nonatomic, getter=isPauseByEvent) BOOL pauseByEvent;

- (void)zf_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler;

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath;
@end

