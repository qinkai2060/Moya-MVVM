//
//  HFLoginRegModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLoginRegModel.h"

@implementation HFLoginRegModel
- (void)getdata:(id)obj {
    self.code = [[obj valueForKey:@"code"] integerValue];
    if ([[obj valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
         self.data = [obj valueForKey:@"data"];
        
    }
    self.msg = [HFUntilTool EmptyCheckobjnil:[obj valueForKey:@"msg"]];
    self.state = [[obj valueForKey:@"state"] integerValue];
}
@end
