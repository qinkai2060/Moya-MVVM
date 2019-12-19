//
//  HFCitySelectorViewModel.m
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCitySelectorViewModel.h"

@implementation HFCitySelectorViewModel
- (RACSubject *)closeSubjc {
    if (!_closeSubjc) {
        _closeSubjc = [[RACSubject alloc] init];
    }
    return _closeSubjc;
}
@end
