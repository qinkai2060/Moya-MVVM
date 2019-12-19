//
//  HFLoginRegModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFLoginRegModel : NSObject
@property(nonatomic,assign)NSInteger code;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,assign)NSInteger state;
- (void)getdata:(id)obj;
@end

NS_ASSUME_NONNULL_END
