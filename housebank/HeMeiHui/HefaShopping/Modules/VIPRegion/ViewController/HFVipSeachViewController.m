//
//  HFVipSeachViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVipSeachViewController.h"
#import "WRNavigationBar.h"
#import "HFVipSearchCellNode.h"
#import "HFHotelSearchNarBarView.h"
#import "HFVIPModel.h"
#import "SpTypesSearchListViewController.h"
#import "HFAlertView.h"
@interface HFVipSeachViewController ()<ASTableDelegate,ASTableDataSource,HFHotelSearchNarBarViewDelegate,HFVipSearchCellNodeDelegate>
@property(nonatomic,strong)ASTableNode *tableView;
@property(nonatomic,strong)HFHotelSearchNarBarView *titleView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation HFVipSeachViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.viewModel.getHotkeyCommand execute:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupNavUI];
    @weakify(self)
    [self.viewModel.getHotkeySubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ( [x isKindOfClass:[NSArray class]]) {
            self.dataSource = x;
            [self.tableView reloadData];
   
           
        }
        
    }];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubnode:self.tableView];

    if (@available(iOS 11.0, *)) {
        self.tableView.view.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.titleView.textFiled becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleView loseFirstRespone];
    
}
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFHotKeyModel *model = self.dataSource[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        HFVipSearchCellNode *cellNode =   [[HFVipSearchCellNode alloc] initWithModel:model];
        cellNode.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([tableNode.js_reloadIndexPaths containsObject:indexPath]) {
            cellNode.neverShowPlaceholders = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cellNode.neverShowPlaceholders = NO;
            });
        } else {
            cellNode.neverShowPlaceholders = NO;
        }
        cellNode.delegate = self;
        return cellNode;
    };
    return cellNodeBlock;
}
- (void)cellNode:(HFVipSearchCellNode *)cellNode didSelectIndex:(HFHotKeyModel *)model {
    
    if (model.mainTitle.length > 0) {
        self.titleView.textFiled.text = model.mainTitle;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"]] allObjects]];
            [tempArray  addObject:model.mainTitle];
            [[NSUserDefaults standardUserDefaults] setObject: tempArray forKey:@"vip_historyKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else {
            NSMutableArray *temArray = [NSMutableArray arrayWithObject:model.mainTitle];
            [[NSUserDefaults standardUserDefaults] setObject: temArray forKey:@"vip_historyKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    SpTypesSearchListViewController *listVC = [[SpTypesSearchListViewController alloc] init];
    listVC.searchStr = model.mainTitle;
    listVC.classId = @" ";
    listVC.level = @" ";
    listVC.isFristIn = YES;
    listVC.type = SpTypesSearchListViewControllerTypeVip;
    [self.navigationController pushViewController:listVC animated:YES];
    
}
- (void)hotelSearchNarBarView:(HFHotelSearchNarBarView*)barView keyWord:(NSString*)keyWord {
    if (keyWord.length > 0) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"]] allObjects]];
            [tempArray  addObject:keyWord];
            [[NSUserDefaults standardUserDefaults] setObject: tempArray forKey:@"vip_historyKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else {
            NSMutableArray *temArray = [NSMutableArray arrayWithObject:keyWord];
            [[NSUserDefaults standardUserDefaults] setObject: temArray forKey:@"vip_historyKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    SpTypesSearchListViewController *listVC = [[SpTypesSearchListViewController alloc] init];
    listVC.searchStr = keyWord;
    listVC.classId = @" ";
    listVC.level = @" ";
    listVC.isFristIn = YES;
    listVC.type = SpTypesSearchListViewControllerTypeVip;
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)clearHistory {
    [self.titleView loseFirstRespone];
    [HFAlertView showAlertViewType:HFAlertViewTypeNone title:@"确认删除全部历史纪录？" detailString:@"" cancelTitle:@"取消" vipBlock:^(HFAlertView *view) {
        
    } sureTitle:@"确定" sureBlock:^(HFAlertView *view) {
        if (self.dataSource.count==2) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip_historyKey"] isKindOfClass:[NSArray class]]) {
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"vip_historyKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
            [array removeObjectAtIndex:self.dataSource.count-1];
            self.dataSource = array;
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];

}
- (void)setupNavUI {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor colorWithHexString:@"FF6600"]];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setNavBarShadowImageHidden:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [rightButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
//    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
//        if ([v isKindOfClass:[SpeakPopView class]]) {
//            [v removeFromSuperview];
//        }
//    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leaveTop" object:nil];
}
- (ASTableNode *)tableView {
    if (!_tableView) {
        _tableView = [[ASTableNode alloc] init];
        CGFloat h = (isIPhoneX()?88:64);
        _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight);
//        _tableView.style.preferredSize = CGSizeMake(ScreenW, h);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.view.showsVerticalScrollIndicator = NO;
        _tableView.view.showsHorizontalScrollIndicator = NO;
        
    }
    return _tableView;
}
- (HFHotelSearchNarBarView *)titleView {
    if(!_titleView) {
        _titleView = [[HFHotelSearchNarBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-35-15-15-10, 30) WithViewModel:nil];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _titleView.layer.cornerRadius = 15;
        _titleView.layer.masksToBounds = YES;
        _titleView.delegate = self;
    }
    return _titleView;
}

@end
