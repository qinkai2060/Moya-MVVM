//
//  WARFriendLikeView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/5.
//

#import <UIKit/UIKit.h>

@class WARMoment,WARFriendLikeView;

@protocol WARFriendLikeViewDelegate <NSObject>
-(void)likeView:(WARFriendLikeView *)likeView  didThumber:(NSString *)accountId;
-(void)likeView:(WARFriendLikeView *)likeView  didOpen:(BOOL)open;
@end

@interface WARFriendLikeView : UIView

/** delegate */
@property (nonatomic, weak) id<WARFriendLikeViewDelegate> delegate;

@property (nonatomic, strong) WARMoment *moment;

@property (nonatomic, copy) void (^didClickLikeUserBlock)(NSString *accountId, CGRect rectInWindow);

@end
