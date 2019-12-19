//
//  HFVipSearchCellNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVipSearchCellNode.h"
#import "HFVIPModel.h"
#import "HFTextCovertImage.h"
@implementation HFVipSearchCellNode
- (instancetype)initWithModel:(HFHotKeyModel *)model {
    if (self = [super init]) {
        [self addSubnode:self.titleNode];
        [self addSubnode:self.btnNode];
        [self addSubnode:self.lineNode];
        self.titleNode.attributedText = [HFTextCovertImage nodeAttributesStringText:model.type TextColor:[UIColor blackColor] Font:[UIFont boldSystemFontOfSize:15]];
        [self.btnNode setImage:[UIImage imageNamed:@"SpTypes_search_delete"] forState:UIControlStateNormal];
        self.model = model;
        NSArray *array = @[@"凉鞋",@"小米K20Pro",@"水果",@"短裤男",@"AirForce1低帮",@"AirForce1低帮",@"AirForce1低帮"];
        NSInteger i = 0;
        for (HFHotKeyModel *privatmodel  in model.dataSource) {
            ASButtonNode *btn = [[ASButtonNode alloc] init];
            btn.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
            [btn setTitle:privatmodel.mainTitle withFont:[UIFont systemFontOfSize:12] withColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.style.flexShrink = YES;
            btn.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            btn.cornerRadius = 13;
            btn.view.tag = i;
            btn.titleNode.maximumNumberOfLines = 1;
            [btn addTarget:self action:@selector(didSelect:) forControlEvents:ASControlNodeEventTouchUpInside];
            [self addSubnode:btn];
            i++;
            [self.childrenItem addObject:btn];
        }
    }
    return self;
}
- (void)didSelect:(ASButtonNode*)btn {
    if (self.model.dataSource.count>0) {
        if ([self.delegate respondsToSelector:@selector(cellNode:didSelectIndex:)]) {
            [self.delegate cellNode:self didSelectIndex:self.model.dataSource[btn.view.tag]];
        }
    }
}
- (void)clearHistory{
    if ([self.delegate respondsToSelector:@selector(clearHistory)]) {
        [self.delegate clearHistory];
    }
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart flexWrap:ASStackLayoutFlexWrapWrap alignContent:ASStackLayoutAlignContentStart  lineSpacing:10  children:self.childrenItem];
    stack.style.flexShrink = YES;
    
    ASStackLayoutSpec *imagetext = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[]];
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:15 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[]];
         imagetext.children = @[self.titleNode];
    if ([self.model.type isEqualToString:@"搜索历史"]) {
        self.btnNode.hidden = NO;
        contentStack.children = @[imagetext,stack];
    }else{
         self.btnNode.hidden = YES;
        contentStack.children = @[imagetext,stack,self.lineNode];
    }
    ASRelativeLayoutSpec *restack = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:self.btnNode];
    ASOverlayLayoutSpec *over = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:contentStack overlay:restack];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10,15 , 15, 15) child:over];
}
- (NSMutableArray *)childrenItem {
    if (!_childrenItem) {
        _childrenItem = [NSMutableArray array];
    }
    return _childrenItem;
}
- (ASTextNode *)titleNode {
    if (!_titleNode) {
        _titleNode = [[ASTextNode alloc] init];
        
    }
    return _titleNode;
}
-  (ASButtonNode *)btnNode {
    if (!_btnNode) {
        _btnNode = [[ASButtonNode alloc] init];
        _btnNode.style.preferredSize = CGSizeMake(44, 44);
        _btnNode.contentHorizontalAlignment =  ASHorizontalAlignmentRight;
        _btnNode.contentVerticalAlignment =  ASVerticalAlignmentTop;
        [_btnNode addTarget:self action:@selector(clearHistory) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _btnNode;
}
- (ASDisplayNode *)lineNode {
    if (!_lineNode) {
        _lineNode =[[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        _lineNode.style.maxHeight = ASDimensionMakeWithPoints(1);
    }
    return _lineNode;
}
@end
