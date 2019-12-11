//
//  WARDBCycleOfFriendMaskModel.h
//  WARDatabase
//
//  Created by 卧岚科技 on 2018/7/10.
//

#import "WARMaskItem.h"

@interface WARDBCycleOfFriendMaskModel : WARMaskItem
  
/** 辅助字段 */
/** 好友圈 是否已选中 */
@property (nonatomic, assign) BOOL hasSelected;
/** 全部好友 */
@property (nonatomic, assign) BOOL isAllFriends;
@end
