//
//  UpLoadImageTool.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadImageTool : NSObject

+(UpLoadImageTool *)shareInstance;

- (RACSignal *)uploadImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
