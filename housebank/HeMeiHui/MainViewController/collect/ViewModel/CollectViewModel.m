//
//  collectViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectViewModel.h"
#import "CollectProductModel.h"
#import "CollectViewModel+loadData.h"
#import "EmptyModel.h"
#define collectDataKey @"cache.collect"
@implementation CollectViewModel
@synthesize mutableSource = _mutableSource ;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _refreshUISubject = [RACSubject new];
        [self loadData];
    }
    return self;
}

- (void)loadData {
   
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        [self loadNewWork];
    }else {
        [self loadFromCache];
    }
}

- (void)loadNewWork {

    @weakify(self);
    [[self loadRequest_collectProduct]subscribeNext:^(NSMutableArray * x) {
        @strongify(self);
        self.mutableSource = x;
        
        if (self.mutableSource.count == 0) {
            self.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }else {
            /** 添加缓存*/
            if (self.mutableSource) {
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableSource];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:collectDataKey];
            }
        }
        
    }];
}

/** 从缓存中拿取*/
- (void)loadFromCache {
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:collectDataKey];
    NSMutableArray * mutaleArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.mutableSource = mutaleArray;
}

- (void)setMutableSource:(NSMutableArray *)mutableSource {
    _mutableSource = mutableSource;
    [self.refreshUISubject sendNext:self.mutableSource];
}

- (NSInteger)jx_numberOfSections {
    return 1;
}

- (NSInteger)jx_numberOfRowsInSection:(NSInteger)section {
    return self.mutableSource.count;
}

- (id<JXModelProtocol>)jx_modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.mutableSource[indexPath.row];
}

- (CGFloat)jx_heightAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self jx_modelAtIndexPath:indexPath];
    return model.height;
}

- (NSMutableArray *)mutableSource {
    if (!_mutableSource) {
        _mutableSource = [NSMutableArray array];
    }
    return _mutableSource;
}
@end
