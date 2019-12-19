//
//  HFShowFilterModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger  {
    HFShowFilterModelTypeStar = 1000,
    HFShowFilterModelTypeLocation,
    HFShowFilterModelTypeBedFilter,
    HFShowFilterModelTypeSort
}HFShowFilterModelType;
NS_ASSUME_NONNULL_BEGIN

@interface HFShowFilterModel : NSObject
@property(nonatomic,assign)HFShowFilterModelType type;
@property(nonatomic,assign)CGFloat viewHight;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *codeTile;
@property(nonatomic,strong)NSArray<HFShowFilterModel*> *dataSource;
+ (void)registerRenderCell:(Class)cellClass messageType:(HFShowFilterModelType)mtype;
+ (Class)getRenderClassByMessageType:(HFShowFilterModelType)mtype ;
@end

NS_ASSUME_NONNULL_END
