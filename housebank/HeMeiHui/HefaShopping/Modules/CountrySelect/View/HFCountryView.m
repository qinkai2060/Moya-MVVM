//
//  HFCountryView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCountryView.h"
#import "HFTableViewnView.h"
#import "HFCountryCell.h"
#import "HFLoginViewModel.h"
@interface HFCountryView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton  *closeBtn;
@property(nonatomic,strong)UILabel *lb;
@property(nonatomic,strong)HFTableViewnView *tableView;

@property(nonatomic,strong)HFLoginViewModel *viewModel;
@end
@implementation HFCountryView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.closeBtn];
    [self addSubview:self.lb];
    [self addSubview:self.tableView];
    
  
    self.closeBtn.frame = CGRectMake(10, 10, 44, 44);
    self.lb.frame = CGRectMake(30, self.closeBtn.bottom+24, ScreenW-60, 30);
    self.tableView.frame = CGRectMake(0, self.lb.bottom+20, ScreenW, self.height-self.lb.bottom-20);
        for (UIView *subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
                UIView *v = subView ;
                for (UIView *indexSubView in v.subviews) {
                    indexSubView.layer.cornerRadius = 8;
                    indexSubView.layer.masksToBounds = 1;
                    indexSubView.backgroundColor = [UIColor colorWithHexString:@"446889"];
                }
                [subView setValue:[UIFont systemFontOfSize:12.0] forKey:@"font"];
            }
       
        }
}
- (void)hh_bindViewModel {
    @weakify(self)
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.countryCodeCloseSubject sendNext:self];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [HFCountryCodeModel jsonSerialization].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HFCountryCodeModel *model =    [HFCountryCodeModel jsonSerialization][section];
    return model.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, ScreenW-60, 44)];
    lb.textColor = [UIColor colorWithHexString:@"999999"];
    lb.font = [UIFont systemFontOfSize:13];
    HFCountryCodeModel *model =    [HFCountryCodeModel jsonSerialization][section];
    lb.text = model.indexKey;
    [v addSubview:lb];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HFCountryCodeModel *model =    [HFCountryCodeModel jsonSerialization][indexPath.section];
    HFCountryCodeModel *data = model.dataArray[indexPath.row];
    cell.model = data;
    [cell doMessagesomthing];
    return cell;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [[HFCountryCodeModel jsonSerialization] valueForKey:@"indexKey"];
}

// 可以相应点击的某个索引, 也可以为索引指定其对应的特定的section, 默认是 section == index
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //    [ZJProgressHUD showStatus:title andAutoHideAfterTime:0.5];
    return index;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFCountryCodeModel *model =    [HFCountryCodeModel jsonSerialization][indexPath.section];
    HFCountryCodeModel *data = model.dataArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:data.countryCode forKey:@"loginAreacode"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ (+%@)",data.countryName,data.countryCode]forKey:@"codeValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.viewModel.didSelectCountryCodeSubject sendNext:data];
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UILabel *)lb {
    if (!_lb) {
        _lb = [[UILabel alloc] init];
        _lb.text = @"选择国家/地区";
        _lb.font = [UIFont boldSystemFontOfSize:22];
        
    }
    return _lb;
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HFCountryCell  class] forCellReuseIdentifier:@"countryCell"];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = [UIColor colorWithHexString:@"446889"];
        
    }
    return _tableView;
}
@end
