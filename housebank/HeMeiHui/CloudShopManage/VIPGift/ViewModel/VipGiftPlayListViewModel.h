//
//  VipGiftPlayListViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipGiftPlayListViewModel : NSObject
@property (nonatomic, strong) NSMutableArray * dataSource;
- (RACSignal *)loadVIP_PlayListRequestShow;
- (RACSignal *)loadMoreVIP_PlayListRequestShow;
- (RACSignal *)load_shareVideoRequest;
- (RACSignal *)loadVIP_PlayDetailRequestWith:(NSString *)productID;
@end

NS_ASSUME_NONNULL_END
