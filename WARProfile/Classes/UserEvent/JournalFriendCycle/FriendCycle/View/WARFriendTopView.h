//
//  WARFriendBaseCellTopView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//



/**
 弹框类型

 - WARFriendTopPopTypeAd: 广告弹框
 - WARFriendTopPopTypeMore: 普通操作弹框
 */
typedef NS_ENUM(NSUInteger, WARFriendTopPopType) {
    WARFriendTopPopTypeAd = 1,
    WARFriendTopPopTypeNormal,
};

#import <UIKit/UIKit.h>
@class WARMoment,WARFriendTopView,WARDBContactModel;

@protocol WARFriendTopViewDelegate <NSObject> 
-(void)friendTopViewShowPop:(WARFriendTopView *)topView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame popType:(WARFriendTopPopType)popType;
-(void)friendTopViewDidUserHeader:(WARFriendTopView *)topView indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model;
@end


@interface WARFriendTopView : UIView

@property (nonatomic, weak) id<WARFriendTopViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WARMoment *moment;

- (void)showExtendView:(BOOL)show;

@end
