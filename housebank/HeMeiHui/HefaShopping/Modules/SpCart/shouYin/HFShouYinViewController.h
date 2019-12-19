//
//  HFShouYinViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/1/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,GlobleHomePushBlockType) {
    GlobleHomePushBlockTypeHotel,//酒店首页
    GlobleHomePushBlockTypeHotelList,//酒店列表
    GlobleHomePushBlockTypeOrderList//订单列表

};
@protocol HFShouYinViewControllerDelegate <NSObject>

- (void)backMangeAddress:(NSDictionary*)dict;
- (void)popNewVC:(NSString*)url vc:(UIViewController*)evc;

@end
typedef void(^appearBlock)(void);
typedef void(^GlobleHomePushBlock)(GlobleHomePushBlockType pushBlockType, NSDictionary *dic);
@interface HFShouYinViewController : SpBaseViewController


@property(nonatomic,weak) id <HFShouYinViewControllerDelegate> delegate;
@property(nonatomic,strong) NSString* shareUrl;
@property(nonatomic,strong) NSString* fromeSource;
@property(nonatomic,assign) BOOL isMore;

@property (nonatomic, copy) appearBlock appearblock;
@property (nonatomic, copy) GlobleHomePushBlock pushBlock;
@property (nonatomic, assign) BOOL isPushNewHF;//是否 从当前web push newweb
- (void)refrensh;
@end

NS_ASSUME_NONNULL_END
