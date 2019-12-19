//
//  HFAddressViewModel.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAddressViewModel.h"
#import "MJExtension.h"
#import "HFPCCSelectorModel.h"

@implementation HFAddressViewModel
- (RACSubject *)sureTagSuj {
    if (!_sureTagSuj) {
        _sureTagSuj = [[RACSubject alloc] init];
    }
    return _sureTagSuj;
}
- (RACSubject *)selectedEditingSuj {
    if (!_selectedEditingSuj) {
        _selectedEditingSuj = [[RACSubject alloc] init];
    }
    return _selectedEditingSuj;
}
- (RACSubject *)contactsSubj {
    if (!_contactsSubj) {
        _contactsSubj = [[RACSubject alloc] init];
    }
    return _contactsSubj;
}
- (RACSubject *)selectAreaSubj {
    if (!_selectAreaSubj) {
        _selectAreaSubj = [[RACSubject alloc] init];
    }
    return _selectAreaSubj;
}
- (RACSubject *)PCCSelectorSubjc {
    if (!_PCCSelectorSubjc) {
        _PCCSelectorSubjc = [[RACSubject alloc] init];
    }
    return _PCCSelectorSubjc;
}
- (RACSubject *)didSelectSubjc {
    if (!_didSelectSubjc) {
         _didSelectSubjc = [[RACSubject alloc] init];
    }
    return _didSelectSubjc;
}
- (void)loadFirstData
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    
    self.addressArr = [NSArray arrayWithContentsOfFile:path];
   
    


    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        HFPCCSelectorModel *model =  [[HFPCCSelectorModel alloc] init];
        NSString *name = dict.allKeys.firstObject;
        model.str = [dict valueForKey:@"state"];
        model.typeStr = @"省";
        model.selected = NO;
        [firstName addObject:model];
    }
    [self.PCCSelectorSubjc sendNext:firstName];

}

@end
