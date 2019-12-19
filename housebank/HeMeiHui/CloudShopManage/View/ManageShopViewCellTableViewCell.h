//
//  ManageShopViewCellTableViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXViewProtocol.h"
typedef void(^errorBlock)(BOOL isSuccess);
@protocol AddSelectActionDelegate <NSObject>
@required
- (void)canActionTheAddToWeiShopTuple:(RACTuple *)tuple error:(errorBlock)errorBlock;
@end
NS_ASSUME_NONNULL_BEGIN
@interface ManageShopViewCellTableViewCell : UITableViewCell<JXViewProtocol>
@property (nonatomic, weak) id<AddSelectActionDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
