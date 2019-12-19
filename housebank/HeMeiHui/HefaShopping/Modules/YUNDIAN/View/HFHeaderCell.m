//
//  HFHeaderCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHeaderCell.h"

@implementation HFHeaderCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, ScreenW-30, 185)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (void)domessageData {
    NSString *str = [NSString stringWithFormat:@"%@%@",[[[ManagerTools shareManagerTools] appInfoModel] imageServerUrl],self.model.imgUrl];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
}
@end
