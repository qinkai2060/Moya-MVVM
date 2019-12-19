//
//  HFAsyncCircleNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAsyncCircleNode.h"
#import "HFAsyncCirNode.h"
@interface HFAsyncCircleNode ()<ASTableDelegate,ASTableDataSource>
@property(nonatomic,strong)NSMutableArray *datasource;
@end
@implementation HFAsyncCircleNode
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.leadingScreensForBatching = 1;
        ASRangeTuningParameters preloadTuning;
        preloadTuning.leadingBufferScreenfuls = 2;
        preloadTuning.trailingBufferScreenfuls = 1;
        [self setTuningParameters:preloadTuning forRangeType:ASLayoutRangeTypePreload];
        
        ASRangeTuningParameters displayTuning;
        displayTuning.leadingBufferScreenfuls = 1;
        displayTuning.trailingBufferScreenfuls = 0.5;
        [self setTuningParameters:displayTuning forRangeType:ASLayoutRangeTypeDisplay];
        

        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        HFAsyncCirNode* cell = [[HFAsyncCirNode alloc] initWithObj:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([tableNode.js_reloadIndexPaths containsObject:indexPath]) {
            cell.neverShowPlaceholders = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cell.neverShowPlaceholders = NO;
            });
        } else {
            cell.neverShowPlaceholders = NO;
        }
        return cell;
    };
    return cellNodeBlock;
}
- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    
    return YES;
}
- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    NSInteger integer = 1;
    integer++;
    [self insertNewRowsInTableView:@[]];
    [context completeBatchFetching:YES];

    
}

- (void)insertNewRowsInTableView:(NSArray *)newAnimals {
        NSInteger oldCount = self.datasource.count;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.datasource];
        [array addObjectsFromArray:newAnimals];
        self.datasource = array;
        [self insertRowWithStart:oldCount NewCount:self.datasource.count];
}
- (void)insertRowWithStart:(NSInteger)start NewCount:(NSInteger)count{
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger row = start; row < count; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
        
    }
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
