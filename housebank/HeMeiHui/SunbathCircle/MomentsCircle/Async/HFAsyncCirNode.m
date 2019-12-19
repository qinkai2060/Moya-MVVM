//
//  HFAsyncCirNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAsyncCirNode.h"
#import "HFTextCovertImage.h"
@interface HFAsyncCirNode ()
@property(nonatomic,strong)ASDisplayNode *bgNode;
@property(nonatomic,strong)ASNetworkImageNode *iconNode;
@property(nonatomic,strong)ASTextNode *nameNode;
@property(nonatomic,strong)ASTextNode *timeNode;
@property(nonatomic,strong)ASTextNode *detailNode;
@property(nonatomic,strong)ASButtonNode *playBtn;
@property(nonatomic,strong)NSMutableArray *subViewsArray;
@property(nonatomic,strong)ASDisplayNode *lineNode;

@property(nonatomic,strong)ASButtonNode *likeBtn;
@property(nonatomic,strong)ASButtonNode *messageBtn;
@property(nonatomic,strong)ASButtonNode *packageBtn;
@property(nonatomic,strong)ASButtonNode *forwarBtn;
@end
@implementation HFAsyncCirNode
- (instancetype)initWithObj:(id)obj {
    if (self = [super init]) {
        [self addSubnode:self.bgNode];
        [self addSubnode:self.iconNode];
        [self addSubnode:self.nameNode];
        [self addSubnode:self.timeNode];
        [self addSubnode:self.detailNode];
        CGFloat w = 0;
        NSInteger arc = (arc4random()%9)+1;
        if (arc == 1) {
            w = (kScreenWidth-50);
        }else {
            w = (kScreenWidth-50-10)/3;
        }
        for (int i = 0; i < arc; i++) {
            ASNetworkImageNode *network = [[ASNetworkImageNode alloc] init];
            network.image = [UIImage imageNamed:@"yd_meishi"];
            network.style.preferredSize = CGSizeMake(w, w);
            network.cornerRadius = 5;
            [self.subViewsArray addObject:network];
            [self addSubnode:network];
        }
        [self addSubnode:self.playBtn];
        self.playBtn.hidden = YES;
        [self addSubnode:self.lineNode];
        
        [self addSubnode:self.likeBtn];
        [self addSubnode:self.messageBtn];
        [self addSubnode:self.packageBtn];
        [self addSubnode:self.forwarBtn];
        self.nameNode.attributedText = [HFTextCovertImage nodeAttributesStringText:@"AidenGreeneAidenGreeneAidenGreeneAidenGreeneAidenGreeneAidenGreeneAidenGreene" TextColor:[UIColor colorWithHexString:@"333333"] Font:[UIFont boldSystemFontOfSize:16]];
        self.timeNode.attributedText =  [HFTextCovertImage nodeAttributesStringText:@"19小时前发布" TextColor:[UIColor colorWithHexString:@"999999"] Font:[UIFont systemFontOfSize:12]];
        self.detailNode.attributedText =  [HFTextCovertImage nodeAttributesStringText:@"高效做好重要和紧急的事情，腾出大量时间做重要不紧要的事情，尽快做好紧急不重要的事情，避免不重要不紧急的事情" TextColor:[UIColor colorWithHexString:@"333333"] Font:[UIFont systemFontOfSize:14]];
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize  {
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:3 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[self.nameNode,self.timeNode]];
    contentStack.style.flexShrink = YES;
    ASStackLayoutSpec *goodsImageContentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[self.iconNode, contentStack]];
    goodsImageContentStack.style.flexShrink = YES;
    ASStackLayoutSpec *nine = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart flexWrap:ASStackLayoutFlexWrapWrap alignContent:ASStackLayoutAlignContentStart lineSpacing:5 children:self.subViewsArray];
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.playBtn];
    ASOverlayLayoutSpec *playOver = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:nine overlay:center];
    ASStackLayoutSpec *btnContent = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:25 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[self.likeBtn,self.messageBtn,self.packageBtn]];
    ASStackLayoutSpec *btnStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:3 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[btnContent,self.forwarBtn]];
    ASStackLayoutSpec *detail = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:15 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[goodsImageContentStack,self.detailNode,playOver,self.lineNode,btnStack]];
    detail.style.flexShrink = YES;
    ASInsetLayoutSpec *top =  [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(25, 25, 25, 25) child:detail];
    ASInsetLayoutSpec *bottom = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:self.bgNode];
    ASOverlayLayoutSpec *over = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:top overlay:bottom];
    return over;
}
- (ASDisplayNode *)bgNode {
    if (!_bgNode) {
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.cornerRadius = 5;
        
    }

        return _bgNode;
}
- (ASDisplayNode *)lineNode {
        if (!_lineNode) {
            _lineNode = [[ASDisplayNode alloc] init];
            _lineNode.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            _lineNode.style.preferredSize = CGSizeMake(kScreenWidth-50, 0.5);
            
        }
        return _lineNode;
}

- (ASNetworkImageNode *)iconNode {
    if (!_iconNode) {
        _iconNode = [[ASNetworkImageNode alloc] init];
        _iconNode.image = [UIImage imageNamed:@"ascircle_icon"];
        _iconNode.style.preferredSize = CGSizeMake(45, 45);
    }
    return _iconNode;
}
- (ASButtonNode *)playBtn {
    if (!_playBtn) {
        _playBtn = [[ASButtonNode alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"circleplay"] forState:UIControlStateNormal]; ;
        _playBtn.style.preferredSize =CGSizeMake(65, 65);
    }
    return _playBtn;
}

- (ASButtonNode *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[ASButtonNode alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"circle_nolike"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"circle_liked"] forState:UIControlStateSelected];
        [_likeBtn setTitle:@"26" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _likeBtn.contentSpacing = 3;
    }
    return _likeBtn;
}
- (ASButtonNode *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[ASButtonNode alloc] init];
        [_messageBtn setImage:[UIImage imageNamed:@"circle_message"] forState:UIControlStateNormal];
        [_messageBtn setTitle:@"26" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _messageBtn.contentSpacing = 3;
    }
    return _messageBtn;
}
- (ASButtonNode *)packageBtn {
    if (!_packageBtn) {
        _packageBtn = [[ASButtonNode alloc] init];
        [_packageBtn setImage:[UIImage imageNamed:@"circle_package"] forState:UIControlStateNormal];
        [_packageBtn setTitle:@"26" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
         _packageBtn.contentSpacing = 3;
    }
    return _packageBtn;
}
- (ASButtonNode *)forwarBtn {
    if (!_forwarBtn) {
        _forwarBtn = [[ASButtonNode alloc] init];
        [_forwarBtn setImage:[UIImage imageNamed:@"circle_foward"] forState:UIControlStateNormal];
        [_forwarBtn setTitle:@"26" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _forwarBtn.contentSpacing = 3;
    }
    return _forwarBtn;
}
- (ASTextNode *)nameNode {
    if (!_nameNode) {
        _nameNode  = [[ASTextNode alloc] init];
        _nameNode.style.flexShrink = YES;
        _nameNode.maximumNumberOfLines = 1;
    }
    return _nameNode;
}
- (ASTextNode *)timeNode {
    if (!_timeNode) {
        _timeNode  = [[ASTextNode alloc] init];
        _timeNode.maximumNumberOfLines = 1;
        
    }
    return _timeNode;
}
- (ASTextNode *)detailNode {
    if (!_detailNode) {
        _detailNode  = [[ASTextNode alloc] init];
   
    }
    return _detailNode;
}
- (NSMutableArray *)subViewsArray {
    if (!_subViewsArray) {
        _subViewsArray = [[NSMutableArray alloc] init];
    }
    return _subViewsArray;
}
@end
