//
//  HFFashionNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFashionNode.h"
#import "HFCollectionFashionNode.h"
#import "HFFashionModel.h"
#import "HFSectionModel.h"
@interface HFFashionNode()<ASCollectionDelegate,ASCollectionDataSource>
@property(nonatomic,strong)ASCollectionNode *colloectionNode;
@end
@implementation HFFashionNode
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFashionType];
}
- (instancetype)initWithModel:(HFSectionModel *)model {
    if (self = [super initWithModel:model]) {
        
        self.fashionModel = [model.dataModelSource firstObject];
        [self addSubnode:self.colloectionNode];
        
        
    }
    return self;
}
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return self.fashionModel.dataArray.count;
}
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    HFFashionModel *model = self.fashionModel.dataArray[indexPath.item];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        HFCollectionFashionNode *cellNode = [[HFCollectionFashionNode alloc] initWithModel:model];
        
        return cellNode;
    };
    return cellNodeBlock;
}
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HFFashionModel *model = self.fashionModel.dataArray[indexPath.row];
    if (self.didFashionBlock) {
        self.didFashionBlock(model);
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
   
    ASRatioLayoutSpec *wrap = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:self.fashionModel.rowheight/ScreenW child:self.colloectionNode];
    return wrap;
}
- (ASCollectionNode *)colloectionNode {
    if (!_colloectionNode) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(ScreenW/3,160);
        _colloectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        _colloectionNode.backgroundColor = [UIColor whiteColor];
        _colloectionNode.dataSource = self;
        _colloectionNode.delegate = self;
        _colloectionNode.view.pagingEnabled = YES;
        _colloectionNode.view.scrollEnabled = NO;
    }
    return _colloectionNode;
}
@end
