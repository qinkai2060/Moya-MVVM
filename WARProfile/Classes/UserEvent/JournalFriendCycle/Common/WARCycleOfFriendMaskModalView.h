//
//  WARContactsFriendManageModalView.h
//  WARContacts
//
//  Created by Hao on 2018/4/24.
//

#import <UIKit/UIKit.h>

typedef void (^WARCycleOfFriendMaskModalViewDidClickCloseBlock) (void);
typedef void (^WARCycleOfFriendMaskModalViewDidClickConfirmBlock) (NSArray *maskIdLists);

@class WARDBCycleOfFriendMaskModel;
@interface WARCycleOfFriendMaskModalView : UIView

@property (nonatomic, strong) NSArray <WARDBCycleOfFriendMaskModel *>*faceArray;

@property (nonatomic, copy) WARCycleOfFriendMaskModalViewDidClickCloseBlock closeBlock;
@property (nonatomic, copy) WARCycleOfFriendMaskModalViewDidClickConfirmBlock confirmBlock;

@end
