//
//  BaseModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetBaseModel : NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * msg;

@end


NS_ASSUME_NONNULL_END
