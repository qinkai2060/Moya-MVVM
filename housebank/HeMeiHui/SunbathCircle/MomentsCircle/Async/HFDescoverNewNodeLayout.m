//
//  HFDescoverNewNodeLayout.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDescoverNewNodeLayout.h"
#import <AsyncDisplayKit/ASCellNode.h>
#import <AsyncDisplayKit/ASCollectionElement.h>
@interface HFDescoverNewNodeInfo:NSObject
@property(nonatomic,assign,readonly)NSInteger columnCount;
@property(nonatomic,assign,readonly)CGFloat columnSpacing;
@property(nonatomic,assign,readonly)CGFloat interItemSpace;
@property(nonatomic,assign,readonly)UIEdgeInsets sectionInset;
@end
@implementation HFDescoverNewNodeInfo
- (instancetype)initWithNumbers:(NSInteger)columnCount columnSpacing:(CGFloat)columnSpacing interItemSpace:(CGFloat)interItemSpace sectionInset:(UIEdgeInsets)sectionInset {
    if (self = [super init]) {
        _columnCount = columnCount;
        _interItemSpace = interItemSpace;
        _columnSpacing = columnSpacing;
        _sectionInset = sectionInset;
    }
    return self;
}
- (BOOL)isEqualToInfo:(HFDescoverNewNodeInfo*)info {
    if (!info) {
        return NO;
    }
    return  _columnCount == info.columnCount
           &&_interItemSpace == info.interItemSpace
           &&_columnSpacing == info.columnSpacing
           &&UIEdgeInsetsEqualToEdgeInsets(_sectionInset, info.sectionInset);
}
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[HFDescoverNewNodeInfo class]]) {
        return NO;
    }
    return  [self isEqualToInfo:object];
}
- (NSUInteger)hash {
    struct {
       NSInteger columnCount;
       CGFloat columnSpacing;
       CGFloat interItemSpace;
       UIEdgeInsets sectionInset;
    } data = {
        _columnCount,
        _interItemSpace ,
        _columnSpacing ,
        _sectionInset
    };
    return ASHashBytes(&data, sizeof(data));
}
@end

@interface HFDescoverNewNodeLayout ()
@end
@implementation HFDescoverNewNodeLayout{
    HFDescoverNewNodeInfo *_info;
    ASScrollDirection _direction;
}
- (instancetype)initWithNumbers:(NSInteger)columnCount columnSpacing:(CGFloat)columnSpacing interItemSpace:(CGFloat)interItemSpace sectionInset:(UIEdgeInsets)sectionInset direction:(ASScrollDirection)direction  {
    if (self = [super init]) {
        _direction = direction;
        _info = [[HFDescoverNewNodeInfo alloc] initWithNumbers:columnCount columnSpacing:columnSpacing interItemSpace:interItemSpace sectionInset:sectionInset];
    }
    return self;
}
- (ASScrollDirection)scrollableDirections {
    ASDisplayNodeAssertMainThread();
    return _direction;

}
- (id)additionalInfoForLayoutWithElements:(ASElementMap *)elements {
    ASDisplayNodeAssertMainThread();
    return _info;
}
+ (ASCollectionLayoutState *)calculateLayoutWithContext:(ASCollectionLayoutContext *)context{
    CGFloat layoutWidth = context.viewportSize.width;
    ASElementMap *elements = context.elements;
    CGFloat top = 0;
    HFDescoverNewNodeInfo *info = (HFDescoverNewNodeInfo *)context.additionalInfo;
    
    NSMapTable<ASCollectionElement *, UICollectionViewLayoutAttributes *> *attrsMap = [NSMapTable elementToLayoutAttributesTable];
    NSMutableArray *columnHeights = [NSMutableArray array];
    // 获取多少组
    NSInteger numberOfSections = [elements numberOfSections];
    
    // 遍历section- >>每组
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        // 每组节点个数
        NSInteger numberOfItems = [elements numberOfItemsInSection:section];
        // 获取第一个顶部
        top += info.sectionInset.top;
        
        // 实例空化数组 多维数组
        [columnHeights addObject:[NSMutableArray array]];
        for (NSUInteger idx = 0; idx < info.columnCount; idx++) {
            [columnHeights[section] addObject:@(top)];
        }
        //节点宽度
        CGFloat columnWidth = [self _columnWidthForSection:section withLayoutWidth:layoutWidth info:info];
        // 遍历当前组的节点
        for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
            // 获取当前组最高的
            NSUInteger columnIndex = [self _shortestColumnIndexInSection:section withColumnHeights:columnHeights];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            ASSizeRange sizeRange = [self _sizeRangeForItem:element.node atIndexPath:indexPath withLayoutWidth:layoutWidth info:info];
//            CGSize size = [element.node layoutThatFits:sizeRange].size;
            NSInteger arc = arc4random() % 2;
             CGSize size = CGSizeMake(columnWidth, arc?235:297);

            CGPoint position = CGPointMake(info.sectionInset.left + (columnWidth + info.columnSpacing) * columnIndex,
                                           [columnHeights[section][columnIndex] floatValue]);
            CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
            
            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:element];
            
            columnHeights[section][columnIndex] = @(CGRectGetMaxY(frame) + info.interItemSpace);
        }
        
        NSUInteger columnIndex = [self _tallestColumnIndexInSection:section withColumnHeights:columnHeights];
        top = [columnHeights[section][columnIndex] floatValue] - info.interItemSpace + info.sectionInset.bottom;
    
        
        //
        for (NSUInteger idx = 0; idx < [columnHeights[section] count]; idx++) {
            columnHeights[section][idx] = @(top);
        }
    }

    CGFloat contentHeight = [[[columnHeights lastObject] firstObject] floatValue];
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight);
    return [[ASCollectionLayoutState alloc] initWithContext:context contentSize:contentSize elementToLayoutAttributesTable:attrsMap];
}



+ (CGFloat)_columnWidthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(HFDescoverNewNodeInfo *)info{
    return ([self _widthForSection:section withLayoutWidth:layoutWidth info:info] - ((info.columnCount - 1) * info.columnSpacing)) / info.columnCount;
}

+ (CGFloat)_widthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(HFDescoverNewNodeInfo *)info{
    return layoutWidth - info.sectionInset.left - info.sectionInset.right;
}

+ (NSUInteger)_shortestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue < shortestHeight) {
            index = idx;
            shortestHeight = height.floatValue;
        }
    }];
    return index;
}

+ (ASSizeRange)_sizeRangeForItem:(ASCellNode *)item atIndexPath:(NSIndexPath *)indexPath withLayoutWidth:(CGFloat)layoutWidth info:(HFDescoverNewNodeInfo *)info {
    CGFloat itemWidth = [self _columnWidthForSection:indexPath.section withLayoutWidth:layoutWidth info:info];
    return ASSizeRangeMake(CGSizeMake(itemWidth, 0), CGSizeMake(itemWidth, CGFLOAT_MAX));
}

+ (NSUInteger)_tallestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights{
    __block NSUInteger index = 0;
    __block CGFloat tallestHeight = 0;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue > tallestHeight) {
            index = idx;
            tallestHeight = height.floatValue;
        }
    }];
    return index;
}

@end




