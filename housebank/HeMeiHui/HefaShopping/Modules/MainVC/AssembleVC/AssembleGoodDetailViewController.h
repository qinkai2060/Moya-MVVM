//
//  AssembleGoodDetailViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/22.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "AssembleSearchListModel.h"
#import "AssembleListModel.h"
#import "GoodsDetailModel.h"
#import "CommentListModel.h"
#import "ProductFeatureModel.h"
#import "SaveShoppingCar.h"
#import "AssembleGoodbaseViewController.h"
#import "OpenGroupList.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , AssembleGoodStyle) {
    
    //普通商品
    OrdinaryAssembleDetailStyle= 0,
    //拼团商品
    AssembleDetailStyle,
    
    
};
@interface AssembleGoodDetailViewController : SpBaseViewController
//增加类型
@property (nonatomic ,assign) AssembleGoodStyle assembleStyle;
/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

@property (nonatomic, strong) SearchListModel *listModel;
@property (nonatomic, strong)NSString * productId;

/* 商品轮播图 */
@property (copy , nonatomic)NSArray *shufflingArray;

@property (nonatomic, strong) AssembleGoodbaseViewController *goodBaseVc;
/* 通知 */
@property (weak ,nonatomic) id dcObj;
@property (nonatomic, strong) NSMutableArray *selectImageTap;
@property (nonatomic, strong) GoodsDetailModel *detailModel;
@property (nonatomic, strong) CommentListModel *commentList;
@property (nonatomic, strong)  ProductFeatureModel *featureModel;
@property (nonatomic, strong)  SaveShoppingCar *saveShoppingCar;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spacStarDateTime;
@property (strong , nonatomic)NSString *spaceTime;//当前日期距离结束日期倒计时
@property (strong , nonatomic)NSString *starSpaceTime;//当前日期距离开始时间倒计时
@property (strong , nonatomic)OpenGroupList *openGroupList;
@property (strong , nonatomic)UIButton *danduBtn;
@property (strong , nonatomic)UIButton *pintuanBtn;

- (instancetype)initWithModel:(id)model;

-(void)resetThirdNavBar:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
