//
//  HFDescoverCellNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDescoverCellNode.h"
#import "HFTextCovertImage.h"
@interface HFDescoverCellNode ()
@property(nonatomic,strong)ASDisplayNode *bgNode;
@property(nonatomic,strong)ASNetworkImageNode *netWorkImage;
@property(nonatomic,strong)ASTextNode *titleNode;
@property(nonatomic,strong)ASNetworkImageNode *iconNode;
@property(nonatomic,strong)ASTextNode *nameNode;
@property(nonatomic,strong)ASButtonNode *likeBtn;
@property(nonatomic,strong)ASImageNode *playImageNode;

@end
@implementation HFDescoverCellNode
- (instancetype)init {
    if (self = [super init]) {
        self.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubnode:self.iconNode];
        [self addSubnode:self.nameNode];
        [self addSubnode:self.likeBtn];
        [self addSubnode:self.titleNode];
        [self addSubnode:self.netWorkImage];
        [self addSubnode:self.playImageNode];
        self.nameNode.attributedText = [HFTextCovertImage nodeAttributesStringText:@"Billy LucasBillyLuaaaa" TextColor:[UIColor colorWithHexString:@"666666"] Font:[UIFont systemFontOfSize:12]];
    
        self.titleNode.attributedText = [HFTextCovertImage nodeAttributesStringText:@"上海终于可" TextColor:[UIColor colorWithHexString:@"333333"] Font:[UIFont boldSystemFontOfSize:13]];
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{

    ASStackLayoutSpec *iconWithnameStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.iconNode,self.nameNode]];
    iconWithnameStack.style.flexShrink = YES;
    ASStackLayoutSpec *bottom = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsCenter children:@[iconWithnameStack,self.likeBtn]];
    bottom.style.flexShrink = YES;
    ASStackLayoutSpec *titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:11 justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsStretch children:@[self.titleNode,bottom]];
    titleStack.style.flexShrink = YES;
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 11, 10) child:titleStack];
    ASStackLayoutSpec *imageStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsStretch children:@[self.netWorkImage,inset]];
    
    ASInsetLayoutSpec *inset2 = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 11, 10) child:self.playImageNode];
    ASRelativeLayoutSpec *titleRelativeSpec = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:inset2];
    ASOverlayLayoutSpec *titleOverlaySpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageStack overlay:titleRelativeSpec];
    return titleOverlaySpec;
}
- (ASDisplayNode *)bgNode {
    if (!_bgNode) {
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.cornerRadius = 5;
        
    }

        return _bgNode;
}
- (ASNetworkImageNode *)iconNode {
    if (!_iconNode) {
        _iconNode = [[ASNetworkImageNode alloc] init];
        _iconNode.image = [UIImage imageNamed:@"ascircle_icon"];
        _iconNode.style.preferredSize = CGSizeMake(18, 18);
    }
    return _iconNode;
}
- (ASNetworkImageNode *)netWorkImage {
    if (!_netWorkImage) {
        _netWorkImage = [[ASNetworkImageNode alloc] init];
        _netWorkImage.image = [UIImage imageNamed:@"yd_meishi"];
        
    }
    return _netWorkImage;
}
- (ASTextNode *)nameNode {
    if (!_nameNode) {
        _nameNode  = [[ASTextNode alloc] init];
        _nameNode.style.flexShrink = YES;
        _nameNode.maximumNumberOfLines = 1;
       _nameNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return _nameNode;
}
- (ASTextNode *)titleNode {
    if (!_titleNode) {
        _titleNode  = [[ASTextNode alloc] init];
        _titleNode.maximumNumberOfLines = 2;
    }
    return _titleNode;
}
- (ASImageNode *)playImageNode {
    if (!_playImageNode) {
        _playImageNode = [[ASImageNode alloc] init];
        _playImageNode.image = [UIImage imageNamed:@"circle_layout_play"];
        _playImageNode.style.preferredSize = CGSizeMake(20, 20);
    }
    return _playImageNode;
}
- (ASButtonNode *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[ASButtonNode alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"circle_nolike"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"circle_liked"] forState:UIControlStateSelected];
        [_likeBtn setTitle:@"2677" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _likeBtn.contentSpacing = 3;
        _likeBtn.selected = YES;
    }
    return _likeBtn;
}
@end
