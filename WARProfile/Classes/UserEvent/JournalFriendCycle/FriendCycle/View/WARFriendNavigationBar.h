//
//  WARFriendNavigationBar.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/31.
//

#import <UIKit/UIKit.h>
 
typedef void(^WARFriendNavigationBarleftBlock)(void);
typedef void(^WARFriendNavigationBarRightBlock)(void);
typedef void(^WARFriendNavigationBarDidBlock)(void);

@interface WARFriendNavigationBar : UIView

@property(nonatomic,copy)WARFriendNavigationBarleftBlock leftHandler;
@property(nonatomic,copy)WARFriendNavigationBarRightBlock rightHandler;
@property(nonatomic,copy)WARFriendNavigationBarDidBlock didBarHandler;
@property(nonatomic,copy)WARFriendNavigationBarDidBlock titleHandler;

- (void)scrollWithOffsetY:(CGFloat)offsetY ; 
- (void)scrollWithScale:(CGFloat)scale fontScale:(CGFloat)fontScale changeAlpha:(BOOL)changeAlpha;

@end
