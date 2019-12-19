//
//  HFCollectionCellNode.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <AsyncDisplayKit/ASCellNode.h>
@class HFBrowserModel;
NS_ASSUME_NONNULL_BEGIN

@interface HFCollectionCellNode : ASCellNode
- (instancetype)initWithUrl:(HFBrowserModel*)browserModel;
@end

NS_ASSUME_NONNULL_END
