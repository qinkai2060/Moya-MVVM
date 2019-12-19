//
//  HFVipClassCategoryCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVipClassCategoryCell.h"
#import "HFVIPModel.h"
#import "HFContentTbNode.h"
#import "HFVIPViewModel.h"
#import "HFSectionModel.h"
@implementation HFVipClassCategoryCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"加载了吗");
        
        [self.contentView addSubnode:self.tableView];
    }
    return self;
}

- (void)setModel:(HFSegementModel *)model {
    _model = model;
    [self.tableView reloadData];
}
- (void)setBottomCanscroll:(BOOL)bottomCanscroll {
    _bottomCanscroll = bottomCanscroll;
    if (!bottomCanscroll) {
        self.tableView.contentOffset = CGPointZero;
    }
}
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return self.model.dataSource.count;
}
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HFVIPModel *model = self.model.dataSource[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        HFContentTbNode *cellNode =   [[HFContentTbNode alloc] initWithModel:model];
        if ([tableNode.js_reloadIndexPaths containsObject:indexPath]) {
            cellNode.neverShowPlaceholders = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cellNode.neverShowPlaceholders = NO;
            });
        } else {
            cellNode.neverShowPlaceholders = NO;
        }
        return cellNode;
    };
    
    return cellNodeBlock;
}
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFVIPModel *model = self.model.dataSource[indexPath.row];
    if (self.didGoodsBlock) {
        self.didGoodsBlock(model);
    }
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASAbsoluteLayoutSpec *ab = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingDefault children:@[self.tableView]];
    
    return ab;
}
- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    
    return self.model.dataSource.count;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    NSInteger integer = self.model.pageNo;
    integer++;
    NSLog(@"小浣熊🐼小浣熊🐼小浣熊🐼小浣熊🐼---- %ld---%@",integer,self.model.name);
    @weakify(self)
    [HFVIPViewModel loadCategoryDataPageNo:integer keyWord:self.model.name classId:self.model.channelId success:^(YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        if ([[request.responseObject valueForKey:@"data"] isKindOfClass:[NSArray class]] &&[[request.responseObject valueForKey:@"state"] integerValue] == 1) {
            NSArray *array =  [request.responseObject valueForKey:@"data"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dataDict in array) {
                HFVIPModel *model = [[HFVIPModel alloc] init];
                [model getData:dataDict];
                [tempArray addObject:model];
            }
            if (tempArray.count >0) {
                self.model.pageNo = integer;
                [self insertNewRowsInTableView:tempArray];
                 [context completeBatchFetching:YES];
               
            }
        }else {
            
        }
    } error:^(YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

- (void)insertNewRowsInTableView:(NSArray *)newAnimals {
        NSInteger oldCount = self.model.dataSource.count;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.dataSource];
        [array addObjectsFromArray:newAnimals];
        self.model.dataSource = array;
        [self insertRowWithStart:oldCount NewCount:self.model.dataSource.count];
}
- (void)insertRowWithStart:(NSInteger)start NewCount:(NSInteger)count{
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger row = start; row < count; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
        
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView.view) {
        if (!self.bottomCanscroll) {
            self.tableView.contentOffset = CGPointZero;
        }
        if (self.tableView.contentOffset.y <= 0) {
            self.bottomCanscroll = NO;
            self.tableView.contentOffset = CGPointZero;
            
            //到顶通知父视图改变状态
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
        }
    }
    
}

- (ASTableNode *)tableView {
    if (!_tableView) {
        _tableView = [[ASTableNode alloc] init];
        CGFloat h = ScreenH- 45 - (isIPhoneX()?88:64);
        _tableView.frame = CGRectMake(0, 0, ScreenW, h);
        _tableView.style.preferredSize = CGSizeMake(ScreenW, h);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.view.showsVerticalScrollIndicator = NO;
        _tableView.view.showsHorizontalScrollIndicator = NO;
         _tableView.leadingScreensForBatching = 1.0;
        
    }
    return _tableView;
}
@end
