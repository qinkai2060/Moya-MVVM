//
//  WARFriendBaseCellBottomView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import <UIKit/UIKit.h>
@class WARMoment,WARFriendBottomView,WARRewordView;

@protocol WARFriendBottomViewDelegate <NSObject>
-(void)friendBottomViewShowPop:(WARFriendBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;
-(void)friendBottomViewDidPriase:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)friendBottomViewDidComment:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)friendBottomViewDidNoInterest:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)friendBottomViewDidAllContext:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;

-(void)friendBottomViewDidDelete:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment;
-(void)friendBottomViewDidEdit:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment;
-(void)friendBottomViewDidLock:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment lock:(BOOL)lock;
@end


@interface WARFriendBottomView : UIView

@property (nonatomic, weak) id<WARFriendBottomViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WARMoment *moment;

@property (nonatomic, strong) WARRewordView *rewordView;
 
- (void)showSeparatorView:(BOOL)show;

@end
 
