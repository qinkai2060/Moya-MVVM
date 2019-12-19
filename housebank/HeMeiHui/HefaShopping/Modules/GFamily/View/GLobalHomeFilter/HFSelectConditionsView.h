//
//  HFSelectConditionsView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFShowFilterModel.h"
@class HFSelectConditionsView;
typedef enum : NSUInteger  {
    HFSelectConditionsViewTypeStar = 1000,
    HFSelectConditionsViewTypeLocation,
    HFSelectConditionsViewTypeFilter,
    HFSelectConditionsViewTypeSort
}HFSelectConditionsViewType;
@protocol HFSelectConditionsViewDelegate<NSObject>
- (void)selectConditionView:(HFSelectConditionsView*)conditionView didSelectBtnType:(HFShowFilterModelType)didType;
- (void)selectConditionView:(HFSelectConditionsView*)conditionView didDismissBtnType:(HFSelectConditionsViewType)didType;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HFSelectConditionsView : HFView
@property(nonatomic,weak)id<HFSelectConditionsViewDelegate> delegate;
@property(nonatomic,assign)HFSelectConditionsViewType didType;
- (void)clearBtnState;
@end

NS_ASSUME_NONNULL_END
