//
//  HFAsyncTableView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAsyncTableView.h"
@interface HFAsyncTableView ()<UITableViewDelegate, UITableViewDataSource>
@end
@implementation HFAsyncTableView
{
    NSMutableArray *datas;
    NSMutableArray *needLoadArr;
    BOOL scrollToToping;
}

-(id)initWithFrame:(CGRect)frame  WithViewModel:(id<HFViewModelProtocol>)viewModel
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self hh_setupViews];
        [self hh_bindViewModel];
        datas = [[NSMutableArray alloc] init];
        needLoadArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}
- (void)hh_bindViewModel {
}

- (void)hh_setupViews {
}


@end
