//
//  HFVIpClassCategoryNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIpClassCategoryNewCell.h"
#import "HFVIPModel.h"
//#import "HFContentTbNode.h"
#import "HFVIPViewModel.h"
#import "HFSectionModel.h"
#import "HFVIPProductCell.h"
@interface HFVIpClassCategoryNewCell() <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *noContentView;
@property(nonatomic,strong)UILabel *noContentLb;

@end
@implementation HFVIpClassCategoryNewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"加载了吗");
        
        [self.contentView addSubview:self.tableView];
        [self.contentView addSubview:self.noContentLb];
        [self.contentView addSubview:self.noContentView];
        self.noContentLb.hidden = YES;
        self.noContentView.hidden = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        @weakify(self)
        self.tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSInteger integer = self.model.pageNo;
            integer++;
            [self.tableView.mj_footer endRefreshing];
            [HFVIPViewModel loadCategoryDataPageNo:integer keyWord:self.model.name classId:self.model.channelId success:^(YTKBaseRequest * _Nonnull request) {
              
                if ([[request.responseObject valueForKey:@"data"] isKindOfClass:[NSArray class]] &&[[request.responseObject valueForKey:@"state"] integerValue] == 1) {
                    NSArray *array =  [request.responseObject valueForKey:@"data"];
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDict in array) {
                        HFVIPModel *model = [[HFVIPModel alloc] init];
                        [model getData:dataDict];
                        [tempArray addObject:model];
                    }
                    if (tempArray.count >0) {
                        self.model.pageNo = integer;
                        NSMutableArray *tempArraySource = [NSMutableArray arrayWithArray:self.dataSource];
                        [tempArraySource insertObjects:tempArray atIndex:tempArraySource.count];
                        self.dataSource = [tempArraySource copy];
                        [self.tableView reloadData];
                        
                    }
                }else {
                    
                }
            } error:^(YTKBaseRequest * _Nonnull request) {
                
            }];
        }];
    }
    return self;
}
- (void)setModel:(HFSegementModel *)model {
    _model = model;
    CGFloat h = ScreenH- 45 - (isIPhoneX()?88:64)-50;
    self.tableView.frame = CGRectMake(0, 0, ScreenW, h);
    self.dataSource = model.dataSource;
    [self.tableView reloadData];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.noContentLb.frame = CGRectMake(0,self.centerY+10, ScreenW, 30);
    self.noContentView.frame = CGRectMake((ScreenW-300)*0.5, self.centerY-200-10, 300, 200);
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;

}
- (void)setBottomCanscroll:(BOOL)bottomCanscroll {
    _bottomCanscroll = bottomCanscroll;
    if (!bottomCanscroll) {
        self.tableView.contentOffset = CGPointZero;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFVIPProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    HFVIPModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell doSommthingData];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFVIPModel *model = self.dataSource[indexPath.row];
    if (self.didGoodsBlock) {
        self.didGoodsBlock(model);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (!self.bottomCanscroll) {
            self.tableView.contentOffset = CGPointZero;
        }
        if (self.tableView.contentOffset.y <= 0) {
            self.bottomCanscroll = NO;
            self.tableView.contentOffset = CGPointZero;
            
            //到顶通知父视图改变状态
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
        }
    }
    
}
- (void)setErrorImage:(NSString *)imageStr text:(NSString*)textStr {
    self.noContentView.image = [UIImage imageNamed:@"SpType_search_noContent"];
    self.noContentLb.text = @"抱歉,这个星球暂时找不到";
    self.noContentLb.hidden = NO;
    self.noContentView.hidden = NO;
}
- (void)haveData {
    self.noContentLb.hidden = YES;
    self.noContentView.hidden = YES;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
   
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[HFVIPProductCell class] forCellReuseIdentifier:@"productCell"];
        
    }
    return _tableView;
}
- (UIImageView *)noContentView {
    if (!_noContentView) {
        _noContentView = [[UIImageView alloc] init];
        _noContentView.image = [UIImage imageNamed:@"SpType_search_noContent"];
        _noContentView.hidden = YES;
        _noContentView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noContentView;
}
- (UILabel *)noContentLb {
    if (!_noContentLb) {
        _noContentLb = [[UILabel alloc] init];
        _noContentLb.textAlignment = NSTextAlignmentCenter;
        _noContentLb.textColor = [UIColor colorWithHexString:@"999999"];
        _noContentLb.font = [UIFont systemFontOfSize:16];
        _noContentLb.hidden = YES;
        _noContentLb.text = @"抱歉,这个星球暂时找不到";
    }
    return _noContentLb;
}
@end
