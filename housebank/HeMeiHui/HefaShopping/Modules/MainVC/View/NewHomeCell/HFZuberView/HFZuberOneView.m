//
//  HFZuberOneView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFZuberOneView.h"
#import <UIImageView+YYWebImage.h>
@implementation HFZuberOneView
- (void)hh_setupViews {
    [self addSubview:self.imageView];
}
- (void)doMessageRendering {
    //    HFZuberViewModel *viewmodel = (HFZuberViewModel*)self.viewmodel;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.fourModuleModel.imgUrl] placeholder:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
    // self.imageView.image = [UIImage imageNamed:viewmodel.model.imgUrl];
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.masksToBounds = 1;
    
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}

@end
