//
//  HFVipSearchCellNode.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <AsyncDisplayKit/ASCellNode.h>
@class HFHotKeyModel;
@class HFVipSearchCellNode;
NS_ASSUME_NONNULL_BEGIN
@protocol HFVipSearchCellNodeDelegate <NSObject>

- (void)cellNode:(HFVipSearchCellNode*)cellNode didSelectIndex:(HFHotKeyModel*)model;
- (void)clearHistory;

@end
@interface HFVipSearchCellNode : ASCellNode
@property(nonatomic,strong)ASTextNode *titleNode;
@property(nonatomic,strong)ASButtonNode *btnNode;
@property(nonatomic,strong)ASDisplayNode *lineNode;
@property(nonatomic,strong)HFHotKeyModel *model;
@property(nonatomic,weak)id<HFVipSearchCellNodeDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *childrenItem;
- (instancetype)initWithModel:(HFHotKeyModel*)model;
@end

NS_ASSUME_NONNULL_END
