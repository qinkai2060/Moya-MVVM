//
//  HFDescoverAsyncNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDescoverAsyncNode.h"
#import "HFDescoverCellNode.h"
#import "HFDescoveAsyncLayout.h"
#import <AsyncDisplayKit/ASCollectionFlowLayoutDelegate.h>
#import "HFDescoverNewNodeLayout.h"
@interface HFDescoverAsyncNode()<ASCollectionDelegate,ASCollectionDataSource,HFDescoveAsyncLayouttDelegate>
@property(nonatomic,strong)NSMutableArray *dataNetworksource;
@end
@implementation HFDescoverAsyncNode
- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate layoutFacilitator:(id<ASCollectionViewLayoutFacilitatorProtocol>)layoutFacilitator {
    HFDescoverNewNodeLayout *layoutDelegate1 = [[HFDescoverNewNodeLayout alloc] initWithNumbers:2 columnSpacing:5 interItemSpace:5 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10) direction:ASScrollDirectionVerticalDirections];
    if (self = [super initWithLayoutDelegate:layoutDelegate1 layoutFacilitator:nil]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    HFDescoveAsyncLayout *flowlayout = [[HFDescoveAsyncLayout alloc] init];
    flowlayout.delegate = self;
  
    [flowlayout setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    if (self = [super initWithCollectionViewLayout:flowlayout]) {

        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (CGFloat)waterfallLayout:(HFDescoveAsyncLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    NSInteger arc = (arc4random()%2);
    NSLog(@"%ld",arc);
    return arc ?235:297;
}
- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return 100;
}
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        HFDescoverCellNode* cell = [[HFDescoverCellNode alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if ([self.js_reloadIndexPaths containsObject:indexPath]) {
//            cell.neverShowPlaceholders = YES;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                cell.neverShowPlaceholders = NO;
//            });
//        } else {
//            cell.neverShowPlaceholders = NO;
//        }
        return cell;
    };
    return cellNodeBlock;
}
@end
