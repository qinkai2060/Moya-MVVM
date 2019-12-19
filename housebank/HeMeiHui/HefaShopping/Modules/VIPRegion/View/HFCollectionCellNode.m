//
//  HFCollectionCellNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCollectionCellNode.h"
#import "HFBrowserModel.h"
@interface HFCollectionCellNode ()
@property(nonatomic,strong)HFNetworkImageNode *imageNode;
@end
@implementation HFCollectionCellNode
- (instancetype)initWithUrl:(HFBrowserModel*)browserModel {
    if (self = [super init]) {
        [self addSubnode:self.imageNode];
        self.imageNode.URL = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",browserModel.imgUrl]];
    }
    return self;
}
- (void)hh_setupViews {
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASWrapperLayoutSpec *layout =[ASWrapperLayoutSpec wrapperWithLayoutElement:self.imageNode];
    return layout;
}
- (HFNetworkImageNode *)imageNode {
    if (!_imageNode) {
        HFNetworkImageNode *netWorkNode = [[HFNetworkImageNode alloc] init];
        netWorkNode.defaultImage = [UIImage imageNamed:@"SpTypes_default_image"];
         _imageNode = netWorkNode;
        _imageNode.contentMode = UIViewContentModeScaleAspectFill;
        _imageNode.clipsToBounds = YES;
        _imageNode.style.preferredSize = CGSizeMake(ScreenW, 150);
        
    }
    return _imageNode;
}
@end
