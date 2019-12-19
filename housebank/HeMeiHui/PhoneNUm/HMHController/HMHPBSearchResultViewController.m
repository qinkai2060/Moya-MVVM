//
//  HMHPBSearchResultViewController.m
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/9/5.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import "HMHPBSearchResultViewController.h"
#import "HMHPhoneBookTableViewCell.h"
#import "ChineseToPinyin.h"


@interface HMHPBSearchResultViewController ()

@property (nonatomic, strong) NSMutableArray *HMH_results;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSString *HMH_sendMessageMobile;


@end

@implementation HMHPBSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.HMH_results = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self HMH_createTableview];
    
}

- (void)HMH_createTableview{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableview];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.HMH_results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHPhoneBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHPhoneBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;

    if (self.HMH_results.count > indexPath.row) {
        HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
        [cell refreshTableViewCellWithInfoModel:model];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.clickBtnBlock = ^(HMHPhoneBookTableViewCell *cell) {
        
        [weakSelf cellStateBtnClickWithIndexPath:cell.indexPath];
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.HMH_results.count > indexPath.row) {
        HMHPersonInfoModel *ymodel = [[HMHPersonInfoModel alloc] init];
        ymodel = self.HMH_results[indexPath.row];
        
        [self HMH_telWithPhoneNum:ymodel.mobilePhone];
    }
}

#pragma mark 打电话事件
- (void)HMH_telWithPhoneNum:(NSString *)phoneNum{
    
    NSString *phone =[NSString string]; ;
    NSArray *arr = [phoneNum componentsSeparatedByString:@" "];
    if (arr.count) {
        for (NSString*str in arr) {
            phone =  [phone stringByAppendingString:str];
        }
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.HMH_results.count > 0) {
        [self.HMH_results removeAllObjects];
    }
    for (HMHPersonInfoModel *model in self.datas) {
        
        NSString *nameStr = model.contactName;
        NSString *phoneNumStr = model.mobilePhone;
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:nameStr];
        
        if ([nameStr.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound || [phoneNumStr.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound ||[firstLetter.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [self.HMH_results addObject:model];
        }
    }
    
    [self.tableview reloadData];
}

#pragma mark // cell 上按钮的点击事件
- (void)cellStateBtnClickWithIndexPath:(NSIndexPath *)indexPath{
    
    HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
    
    if ([model.inviteRole isEqualToString:@"1"]) { // 会员
        //        http://mall-api.fybanks.cn/broker/contacts/sendInviteMemberMsg
        
        if (self.HMH_results.count > indexPath.row) {
            
            HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
            _HMH_sendMessageMobile = model.mobilePhone;
        }
        
        if (self.sendMessageClickBlock) {
            self.sendMessageClickBlock(model,YES,NO);
        }
        
    }
//    else if ([model.inviteRole isEqualToString:@"2"]){ // 门店     
//         HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
//        NSString *str = [NSString stringWithString:model.mobilePhone];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgColor" object:str userInfo:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//       // [self.navigationController popViewControllerAnimated:YES];
////        if (self.HMH_results.count > indexPath.row) {
////
//        
////            HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
////            if (self.HMH_results.count > indexPath.row) {
////                
////                HMHPersonInfoModel *model = self.HMH_results[indexPath.row];
////                _HMH_sendMessageMobile = model.mobilePhone;
////            }
////            
////            if (self.sendMessageClickBlock) {
////                self.sendMessageClickBlock(model,YES,YES);
////            }
////
////        }
//       
//    }
}

- (void)dealloc{

    NSLog(@"HMHPBSearchResultViewController");


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
