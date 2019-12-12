//
//  WARMemberHeaderView.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <UIKit/UIKit.h>
#import "WARCornerButtonView.h"

typedef NS_ENUM(NSInteger,WARMemberHeaderViewType) {
    WARMemberHeaderViewTypeOfMember,
    WARMemberHeaderViewTypeOfOthers,
};



typedef void(^WARMemberHeaderViewDidClickEditBlock)(BOOL isEdit);

@interface WARMemberHeaderView : UICollectionReusableView

@property (nonatomic, strong) WARCornerButtonView *cornerBtn;

@property (nonatomic, copy)WARMemberHeaderViewDidClickEditBlock didClickEditBlock;

@property (nonatomic, assign) WARMemberHeaderViewType  type;

// 是否是默认分组（默认不允许修改成员）
@property (nonatomic, assign) BOOL  isDefault;

@end
