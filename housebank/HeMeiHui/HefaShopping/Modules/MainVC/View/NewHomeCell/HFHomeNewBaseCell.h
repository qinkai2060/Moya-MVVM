//
//  HFHomeNewBaseCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "HFHomeBaseModel.h"
@class HFCollectionBaseCell;
@class HFGlobalInterfaceModel;
@class HFHomeBaseModel;
@class HFTimeLimitSmallModel;
typedef void(^didBrowserBlock)(HFHomeBaseModel*) ;
typedef void(^didGlobalBlock)(HFHomeBaseModel*) ;
typedef void(^didTimeKillBlock)(HFTimeLimitSmallModel*) ;
typedef void(^didSpecialPBlock)(HFHomeBaseModel*) ;
typedef void(^didFashionPBlock)(HFHomeBaseModel*) ;
typedef void(^didZuberBlock)(HFHomeBaseModel*) ;
typedef void(^didModuleFourBlock)(HFHomeBaseModel*);
typedef void(^didModuleFiveBlock)(HFHomeBaseModel*) ;
typedef void(^didModuleSixBlock)(HFHomeBaseModel*) ;
typedef void(^didNewsBlock)(HFHomeBaseModel*) ;
typedef void(^didNewsMoreBlock)() ;
typedef void(^didQuickCellBlock)(HFHomeBaseModel*) ;
@interface HFHomeNewBaseCell : UITableViewCell
@property(nonatomic,copy)didBrowserBlock didBrowserBlock;
@property(nonatomic,copy)didGlobalBlock didGloabalBlock;
@property(nonatomic,copy)didTimeKillBlock didTimeKillBlock;
@property(nonatomic,copy)didSpecialPBlock didSpecialPBlock;
@property(nonatomic,copy)didFashionPBlock didFashionBlock;
@property(nonatomic,copy)didZuberBlock didZuberBlock;
@property(nonatomic,copy)didModuleFourBlock didModuleFourBlock;
@property(nonatomic,copy)didModuleFiveBlock didModuleFiveBlock;
@property(nonatomic,copy)didModuleSixBlock didModuleSixBlock;
@property(nonatomic,copy)didQuickCellBlock didQuickCellBlock;
@property(nonatomic,copy)didNewsBlock didNewsBlock;
@property(nonatomic,copy)didNewsMoreBlock didNewsMoreBlock;
@property(nonatomic,strong)HFHomeBaseModel *model;
+ (void)registerRenderCell:(Class)cellClass messageType:(HHFHomeBaseModelType)mtype;
- (void)doMessageRendering;
+ (Class)getRenderClassByMessageType:(HHFHomeBaseModelType)msgType;
- (void)hh_setupSubviews;
@end

