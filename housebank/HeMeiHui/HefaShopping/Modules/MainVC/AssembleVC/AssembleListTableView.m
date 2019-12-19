//
//  AssembleListTableView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleListTableView.h"
#import "AssembleListCell.h"
@interface AssembleListTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *HMH_tableView;
@end

@implementation AssembleListTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI
{
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 417+KBottomSafeHeight-50-67-KBottomSafeHeight) style:UITableViewStylePlain];
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    _HMH_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _HMH_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_HMH_tableView];
}
#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.openGroupList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssembleListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"AssembleListCell"];
    if (listCell == nil) {
        listCell = [[AssembleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssembleListCell"];
    }
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    OpenGroupListItem *model=[self.openGroupList objectAtIndex:indexPath.row];
    [listCell reSetSelectedData:model];
    return listCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:2000];
    UIView *listTableView = [window viewWithTag:2100];
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.35f animations:^{
        listTableView.frame= CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight);
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [listTableView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
//    self.backgroundColor=[UIColor clearColor];
    [[NSNotificationCenter defaultCenter]postNotificationName:GoToPinTuanlViewView object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row]}];
    //      SpikeGoodDetailViewController
    //    GetProductListByConditionModel *list = [[GetProductListByConditionModel alloc] init];
//    ListItemmodel *iteamModel=[self.spikeDataList.data.spikes.list objectAtIndex:indexPath.row];
//    SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
//    vc.productId = [NSString stringWithFormat:@"%ld",(long)iteamModel.productId];
//    //    促销疯抢、名品
//    vc.goodsType=PromotionGoodsDetailStyle;
//    //   秒杀切换goodsStyle为下
//    //     vc.goodsStyle=GoodsDetailStyleSpike;
//    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
