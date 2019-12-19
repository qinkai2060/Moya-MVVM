//
//  HFSegementCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSegementNode.h"
@interface HFSegementNode()
@property(nonatomic,strong)ASTextNode *titlenode;
@property(nonatomic,strong)ASDisplayNode *lineNode;
@property(nonnull,strong)HFSegementModel *model;
@end
@implementation HFSegementNode
- (instancetype)initWithModel:(HFSegementModel*)model {
    if (self = [super init]) {
        [self addSubnode:self.lineNode];
        [self addSubnode:self.titlenode];
        NSDictionary *attributesDic = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]};
        NSAttributedString *attributesString = [[NSAttributedString alloc] initWithString:@"全部" attributes:attributesDic];
        self.titlenode.attributedText = attributesString;
        if (!model.isSelected) {
            NSDictionary *attributesDic = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]};
            NSAttributedString *attributesString = [[NSAttributedString alloc] initWithString:model.name attributes:attributesDic];
            self.titlenode.attributedText = attributesString;
           
        }else {
            NSDictionary *attributesDic = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]};
            NSAttributedString *attributesString = [[NSAttributedString alloc] initWithString:model.name attributes:attributesDic];
            self.titlenode.attributedText = attributesString;
        }
         self.lineNode.hidden = !model.isSelected;
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASRatioLayoutSpec *title = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:self.titlenode];
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:3 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[title,self.lineNode]];
    
    ASInsetLayoutSpec *indset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 12, 10, 12) child:stack];
    
    return indset;
}
- (ASDisplayNode *)lineNode {
    if (!_lineNode) {
        _lineNode = [[ASDisplayNode alloc] initWithLayerBlock:^CALayer * _Nonnull{
            CAGradientLayer  *gradientlayer = [CAGradientLayer layer];
            gradientlayer.startPoint = CGPointMake(0, 0);
            gradientlayer.endPoint = CGPointMake(1, 0);
            gradientlayer.locations = @[@(0.0),@(1.0)];//渐变点
            
            [gradientlayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
            gradientlayer.cornerRadius = 1;
            return gradientlayer;
        }];
        _lineNode.style.preferredSize = CGSizeMake(28, 2);
        
        
    }
    return _lineNode;
}
- (ASTextNode *)titlenode {
    if (!_titlenode) {
        _titlenode = [[ASTextNode alloc] init];
    }
    return _titlenode;
}
@end
