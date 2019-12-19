//
//  HFFilterBoxBaseView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFShowFilterModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HFFilterBoxBaseView;
@protocol HFFilterBoxBaseViewDelegate <NSObject>

- (void)popupView:(HFFilterBoxBaseView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index isDelete:(BOOL)isDelete;

@end
@interface HFFilterBoxBaseView : HFView
@property(nonatomic,assign)CGRect sourceFrame;
@property(nonatomic,assign)BOOL isDelete;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)HFShowFilterModel *model;
@property(nonatomic,weak)id<HFFilterBoxBaseViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedArray;

+ (void)registerRenderCell:(Class)cellClass messageType:(HFShowFilterModelType)mtype;
+ (Class)getRenderClassByMessageType:(HFShowFilterModelType)mtype ;
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^)(void))completion;
- (instancetype)initWithFilter:(HFShowFilterModel*)model;
- (void)dismiss;
- (void)show;
@end

NS_ASSUME_NONNULL_END
