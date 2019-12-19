//
//  HFCollectionFashionNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCollectionFashionNode.h"
#import "HFTextCovertImage.h"
#import "HFFashionModel.h"
@interface HFCollectionFashionNode ()
@property(nonatomic,strong)ASTextNode *titleNode;
@property(nonatomic,strong)ASTextNode *subTitleNode;
@property(nonatomic,strong)HFNetworkImageNode *imageNode;
@property(nonatomic,strong)ASDisplayNode *topNode;
@property(nonatomic,strong)ASDisplayNode *rightNode;
@property(nonatomic,strong)ASDisplayNode *bottomNode;
@end
@implementation HFCollectionFashionNode
- (instancetype)initWithModel:(HFFashionModel*)model {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubnode:self.titleNode];
        [self addSubnode:self.subTitleNode];
        [self addSubnode:self.imageNode];
        [self addSubnode:self.topNode];
        [self addSubnode:self.rightNode];
        [self addSubnode:self.bottomNode];
        self.titleNode.attributedText =  [HFTextCovertImage nodeAttributesStringText:model.title TextColor:[UIColor colorWithHexString:@"494949"] Font:[UIFont systemFontOfSize:14]];
        self.subTitleNode.attributedText =  [HFTextCovertImage nodeAttributesStringText:model.littleTitle TextColor:[UIColor colorWithHexString:@"8146EC"] Font:[UIFont systemFontOfSize:12]];
        self.imageNode.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imgUrl]];
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *titAndSubStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[self.titleNode,self.subTitleNode]];
    
    ASStackLayoutSpec *imageNode = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter
                                                        children:@[titAndSubStack,self.imageNode]];
    
    ASAbsoluteLayoutSpec *re = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.topNode]];
    ASAbsoluteLayoutSpec *right = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.rightNode]];
    ASAbsoluteLayoutSpec *bottom = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.bottomNode]];
    
    ASOverlayLayoutSpec *overlay1 = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageNode overlay:re];
    ASOverlayLayoutSpec *overlay2 = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overlay1 overlay:bottom];
    ASOverlayLayoutSpec *overlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overlay2 overlay:right];
    


    return overlay;
}
- (ASTextNode *)titleNode {
    if (!_titleNode) {
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.style.flexShrink = YES;
        
    }
    return _titleNode;
}
- (ASTextNode *)subTitleNode {
    if (!_subTitleNode) {
        _subTitleNode = [[ASTextNode alloc] init];
         _subTitleNode.style.flexShrink = YES;
     
    }
    return _subTitleNode;
}
- (HFNetworkImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[HFNetworkImageNode alloc] init];
        _imageNode.defaultImage = [UIImage imageNamed:@"SpTypes_default_image"];
        _imageNode.style.preferredSize = CGSizeMake(105, 85);
    }
    return _imageNode;
}
- (ASDisplayNode *)topNode {
    if (!_topNode) {
        _topNode = [[ASDisplayNode alloc] init];
        _topNode.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
        _topNode.style.layoutPosition = CGPointMake(0, 0);
        _topNode.style.preferredSize = CGSizeMake(ScreenW/3, 1);
    }
    return _topNode;
}
- (ASDisplayNode *)rightNode {
    if (!_rightNode) {
        _rightNode = [[ASDisplayNode alloc] init];
        _rightNode.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
        _rightNode.style.layoutPosition = CGPointMake(ScreenW/3-1, 0);
        _rightNode.style.preferredSize = CGSizeMake(1, 160);
    }
    return _rightNode;
}
- (ASDisplayNode *)bottomNode {
    if (!_bottomNode) {
        _bottomNode = [[ASDisplayNode alloc] init];
        _bottomNode.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
        _bottomNode.style.layoutPosition = CGPointMake(0, 160-1);
        _bottomNode.style.preferredSize = CGSizeMake(ScreenW/3-1, 1);
    }
    return _bottomNode;
}
@end
