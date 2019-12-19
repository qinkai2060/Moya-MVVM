//
//  MyCacheListViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCacheListViewController.h"
#import "HMHVideoCacheListTableViewCell.h"

@interface HMHVideoCacheListViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>

@property (nonatomic, strong) UITableView *HMH_tableView;

@end

@implementation HMHVideoCacheListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"缓存区";
    self.view.backgroundColor = [UIColor whiteColor];
//
    [self showNoContentView];
    
//    [self createTableView];
}

- (void)createTableView{
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - self.HMH_statusHeghit - 44 - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    [self.view addSubview:_HMH_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHVideoCacheListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHVideoCacheListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshCellWithModel:nil];
    cell.rightButtons = [self createRightButtons:2 shieldTitles:@"取消缓存"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(NSArray *) createRightButtons: (int) number shieldTitles:(NSString*)shieldStr{
    NSMutableArray * result = [NSMutableArray array];
    
    NSArray* titles = @[@"删除",shieldStr];
    NSArray * colors = @[[UIColor redColor], [UIColor lightGrayColor]];
    for (int i = 0; i < number; ++i){
        if (titles.count>i && colors.count>i) {
            MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i]];
            CGRect btnFrame =  button.frame;
            btnFrame.size.width = 63;
            button.frame = btnFrame;
            [result addObject:button];
        }
    }
    return result;
}
#pragma mark - MGSwipeTableCellDelegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button
//        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        // 删除
        //        [self.dataSource removeObjectAtIndex:indexPath.row];
        //        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        //        [self.dataSource removeObjectAtIndex:path.row];
        //        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (direction == MGSwipeDirectionRightToLeft && index == 1){
        
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        
    }
    return YES;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
