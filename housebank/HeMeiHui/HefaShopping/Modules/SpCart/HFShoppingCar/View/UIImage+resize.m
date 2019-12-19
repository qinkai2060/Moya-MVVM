//
//  UIImage+resize.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UIImage+resize.h"

@implementation UIImage (resize)
- (UIImage *)resizeImage {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.7];
}
@end
