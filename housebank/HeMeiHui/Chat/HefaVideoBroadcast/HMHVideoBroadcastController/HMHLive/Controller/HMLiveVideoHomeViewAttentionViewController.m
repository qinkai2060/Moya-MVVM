//
//  HMLiveVideoHomeViewAttentionViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveVideoHomeViewAttentionViewController.h"
#import "HMHLiveVideoHomeSearchView.h"
#import "HMLiveRecommendAttentionCell.h"
#import "HMHVideoSearchViewController.h"


@interface HMLiveVideoHomeViewAttentionViewController ()

@property (nonatomic,strong)HMHLiveVideoHomeSearchView *serachView;

@property(nonatomic,strong) id model;

@property (nonatomic,weak)UIView *currentLoginView;

@property (nonatomic,strong)NSMutableArray<HMHLiveAttentionModel *>  *modelArray;

@end

@implementation HMLiveVideoHomeViewAttentionViewController

- (void)viewDidLoad {
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.currentPage = 1;
    
    self.modelArray = [NSMutableArray array];
    
    [super viewDidLoad];
    
 
    
}

- (void)setSubviews {
    [super setSubviews];
    
    if (self.isShowSearch) {
        
        HMHLiveVideoHomeSearchView *searchView = [[HMHLiveVideoHomeSearchView alloc] initWithFrame:CGRectZero];
        self.serachView = searchView;
        [self.view addSubview:searchView];
        self.serachView.radius = WScale(15);
        self.serachView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        @weakify(self)
        [[self.serachView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
            [self.nvController pushViewController:searchVC animated:YES];
            
        }];
        
        [self.serachView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(WScale(10));
            make.leading.mas_equalTo(self.view.mas_leading).mas_offset(WScale(15));
            make.trailing.mas_equalTo(self.view.mas_trailing).mas_offset(-WScale(15));
            make.height.mas_equalTo(WScale(30));
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.serachView.mas_bottom).mas_offset(WScale(15));
        }];
        
    } else {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
                
    }
    
    //注册cell
    [self.tableView registerClass:[HMLiveRecommendAttentionCell class] forCellReuseIdentifier:@"HMLiveRecommendAttentionCell"];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)reFreshUI {
    
    
        [self.tableView reloadData];
    
}

- (void)loadData {
    [super loadData];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%ld?sid=%@",getUrlStr,(long)self.currentPage,sidStr];
    }

    [self requestData:nil withUrl:getUrlStr requestType:@"get"];
    
}

// 数据请求
#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url requestType:(NSString *)requestType{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([requestType isEqualToString:@"get"]) {
            [weakSelf HMH_getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            
        }else if([requestType isEqualToString:@"delete"]) {
         //   [weakSelf getDeleteFavoriteData:request.responseObject];
        }else {
            
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
       
     
        
        if (weakSelf.modelArray.count <= 5) {
            weakSelf.tableView.mj_footer.hidden = YES;
          //  weakSelf.tableView.mj_footer.automaticallyHidden = YES;;
        } else {
            weakSelf.tableView.mj_footer.hidden = NO;
        //    weakSelf.tableView.mj_footer.automaticallyHidden = NO;;
        }
        weakSelf.noContentImageName = @"SpType_search_noContent";
        if (weakSelf.modelArray.count == 0) {
            [weakSelf showNoContentView:YES];

        }
    }];
}

- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (self.currentPage == 1) {
            [self.modelArray removeAllObjects];
        }
        NSDictionary *dataDic = resDic[@"data"];
        if ( [dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            
                NSArray *tempArray = [NSArray modelArrayWithClass:[HMHLiveAttentionModel class] json:dataDic[@"list"]];
                [self.modelArray addObjectsFromArray:tempArray];
                
                [self reFreshUI];
            
            if (self.modelArray.count > 0) {
                [self hideNoContentView];
            } else {
                self.noContentImageName = @"SpType_search_noContent";

                [self showNoContentView:YES];
            }
            
            if (self.modelArray.count <= 5) {
                //   self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
              //  self.tableView.mj_footer.automaticallyHidden = YES;
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
              //  self.tableView.mj_footer.automaticallyHidden = NO;;
            }
            
        }
    }
}

- (void)loadMoreData {
    self.currentPage ++;
    [self loadData];
}

- (void)gotoLogin{
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.pageUrlConfigArrary.count) {
        
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
            
            if([model.pageTag isEqualToString:@"fy_login"]) {
                self.HMH_loginVC = [[HMHPopAppointViewController alloc]init];
                self.HMH_loginVC.urlStr = model.url;
                
                [self.nvController pushViewController:self.HMH_loginVC animated:YES];
//                [self.view addSubview:self.HMH_loginVC.view];
//
//                [self.HMH_loginVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.mas_equalTo(self.view);
//                }];
                
            }
        }
    }
}

#pragma mark <UITableViewDelegate,UITableViewDatasource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.modelArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HMLiveRecommendAttentionCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendAttentionCell" forIndexPath:indexPath];
    cell.attentionModel = self.modelArray[indexPath.section];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 0.0;
    if (section == 0) {
        height = 0.1;
    } else {
        height = WScale(15);
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    headView.alpha = 0.02;
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [UIView new];
    footView.alpha = 0.02;
    return footView;
}





@end
