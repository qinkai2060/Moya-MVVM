//
//  HFViewModelProtocol.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JXViewModelProtocol <NSObject>
- (NSInteger)jx_numberOfSections;
- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath;
- (void)loadData;
@optional
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSMutableArray *mutableSource;
@required
- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
