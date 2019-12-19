//
//  AssembleGoodbaseViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpBaseViewController.h"
#import "CommentListModel.h"
#import "GoodsDetailModel.h"
#import "CommentListModel.h"
#import "ProductFeatureModel.h"
#import "SaveShoppingCar.h"
#import "GetProductListByConditionModel.h"
#import "OpenGroupList.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , AssembleGoodbaseStyle) {
    
    //普通商品
    OrdinaryAssembleBaseDetailStyle= 0,
    //拼团商品
    AssembleBaseDetailStyle,
    
    
};
typedef NS_ENUM(NSInteger , AssemOffSetStyle) {
    
    //商品
    AssemOffSetStyleGood = 0,
    //评价
    AssemOffSetStyleComment,
    //详情
    AssemOffSetStyledDetail,
    
    
    
};
typedef void(^AssembleGoodbaseViewControllerOffSetBlock)(AssemOffSetStyle indexStyle);

@protocol AssembleGoodbaseViewDelegate <NSObject>
-(void)resetThirdNavBar:(CGFloat)offsetY;
@end
@interface AssembleGoodbaseViewController : SpBaseViewController
@property (nonatomic, copy) AssembleGoodbaseViewControllerOffSetBlock offSetBlock;

@property(nonatomic,weak)id<AssembleGoodbaseViewDelegate> Delegate;
/** 更改标题 */
@property (nonatomic , copy) void(^changeTitleBlock)(BOOL isChange);
//增加类型
@property (nonatomic ,assign) AssembleGoodbaseStyle assembleBaseStyle;
/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

/* 商品轮播图 */
@property (copy , nonatomic)NSArray *shufflingArray;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) GoodsDetailModel *detailModel;
@property (nonatomic, strong) GetProductListByConditionModel *listModel;
@property (nonatomic, strong) CommentListModel *commentList;
@property (nonatomic, strong) ProductFeatureModel *featureModel;
@property (nonatomic, strong)OpenGroupList*openGroupList;
@property (nonatomic,strong)NSString *code;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spaceTime;//当前日期距离结束时间倒计时
@property (strong , nonatomic)NSString *starSpaceTime;//当前日期距离开始时间倒计时

@property (strong , nonatomic)UIView *TimeView;
@property (strong , nonatomic)UILabel *  lable1;
@property (strong , nonatomic)UILabel *  lable2;
@property (strong , nonatomic)UILabel *  lable3;
@property (strong , nonatomic)UILabel *  lable4;
@property (strong , nonatomic)UILabel *  lable5;
@property (strong , nonatomic)UIImageView *spikeTimerView;
@property (nonatomic, assign) NSInteger lastcontentOffset; //添加此属性的作用，根据差值，判断ScrollView是上滑还是下拉
@property (assign , nonatomic)CGFloat wkwebviewHeight;
@property (assign , nonatomic)BOOL isFirstRefrenshWeb;//web已经加载

@end

NS_ASSUME_NONNULL_END
