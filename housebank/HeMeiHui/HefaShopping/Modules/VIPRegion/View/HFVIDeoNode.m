//
//  HFVIDeoNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIDeoNode.h"
#import "HFSectionModel.h"
#import "HFAdModel.h"
#import "HFGoodsVideoModel.h"
@interface HFVIDeoNode ()
@property(nonatomic,strong)HFNetworkImageNode *netWorkImage;
@property(nonatomic,strong)ASDisplayNode *top;
@property(nonatomic,strong)ASDisplayNode *bottom;
@property(nonatomic,strong)ASImageNode *imageNode;
@property(nonatomic,strong)ASImageNode *goodsVipImage;
@end
@implementation HFVIDeoNode
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeGoodsVideo];
}
- (instancetype)initWithModel:(HFSectionModel *)model {
    if (self = [super initWithModel:model]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubnode:self.top];
        [self addSubnode:self.netWorkImage];
        [self addSubnode:self.bottom];
        [self addSubnode:self.imageNode];
        [self addSubnode:self.goodsVipImage];
        self.admodel = (HFGoodsVideoModel*)[model.dataModelSource firstObject];
        self.admodel = [self.admodel.dataArray firstObject];
        self.netWorkImage.URL = [NSURL URLWithString:self.admodel.img];
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASRatioLayoutSpec *imageR = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:0.7 child:self.netWorkImage];
//    ASRelativeLayoutSpec *relativeImage =[ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:self.goodsVipImage];
//    ASInsetLayoutSpec *insetVip = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15, 0, 0, 0) child:imageR];
//    ASOverlayLayoutSpec *overVip = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageR overlay:insetVip];
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.imageNode];
    ASInsetLayoutSpec *indet = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 15, 0, 15) child:imageR];
    ASOverlayLayoutSpec *over = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:indet overlay:center];
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:15 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch flexWrap:ASStackLayoutFlexWrapNoWrap alignContent:ASStackLayoutAlignContentCenter lineSpacing:0 children:@[over,self.bottom]];
    return stack;
}

- (ASDisplayNode *)top {
    if (!_top) {
        _top = [[ASDisplayNode alloc] init];
        _top.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _top.style.preferredSize = CGSizeMake(ScreenW, 10);
    }
    return _top;
}
- (ASDisplayNode *) bottom {
    if (!_bottom) {
        _bottom = [[ASDisplayNode alloc] init];
        _bottom.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _bottom.style.preferredSize = CGSizeMake(ScreenW, 10);
    }
    return _bottom;
}
- (HFNetworkImageNode *)netWorkImage {
    if (!_netWorkImage) {
        _netWorkImage = [[HFNetworkImageNode alloc] init];
        _netWorkImage.defaultImage = [UIImage imageNamed:@"SpTypes_default_image"];
//        _netWorkImage.style.preferredSize = CGSizeMake(105, 85);
        _netWorkImage.contentMode = UIViewContentModeScaleAspectFill;
        _netWorkImage.cornerRadius = 10;
        
    }
    return _netWorkImage;
}
- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASImageNode alloc] init];
        _imageNode.image = [UIImage imageNamed:@"Vip_play_icon"];
        _imageNode.style.preferredSize =CGSizeMake(50, 50);
    }
    return _imageNode;
}
- (ASImageNode *)goodsVipImage {
    if (!_goodsVipImage) {
        _goodsVipImage = [[ASImageNode alloc] init];
        _goodsVipImage.image = [UIImage imageNamed:@"good_goods_vip"];
        _goodsVipImage.style.preferredSize =CGSizeMake(52, 20);
    
    }
    return _goodsVipImage;
}
@end
