//
//  HMLiveVideoHomeClassifyViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveVideoHomeClassifyViewController.h"
#import "HMHVideoCategoryView.h"
#import "HMHVideoAllCategoryView.h"
#import "HMHSearchHotLabView.h"
#import "HMHVideoTagsModel.h"
#import "WRNavigationBar.h"



@interface HMLiveVideoHomeClassifyViewController ()

@property (nonatomic, strong) NSMutableArray *HMH_hotTagArr;
@property (nonatomic, strong) NSMutableArray *HMH_parentArr;
@property (nonatomic, strong) NSMutableArray *HMH_allCategotyArr;

@property (nonatomic,assign) BOOL firstBool;
@property (nonatomic,assign) BOOL secoundBool;

@end

@implementation HMLiveVideoHomeClassifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    self.title = @"分类";
    
    self.navigationController.navigationBar.translucent = NO;
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setImage:[UIImage imageNamed:@"HMH_back_light"] forState:UIControlStateNormal];
    lButton.frame = CGRectMake(0, 0, 44, 44);
    lButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [lButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _HMH_hotTagArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_parentArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_allCategotyArr = [NSMutableArray arrayWithCapacity:1];
    
    // 获取热门分类
    [self HMH_requestHotTagData];
    // 获取所有分类
    [self HMH_getAllCategoryData];
    
//    [self HMH_createNav];
//    [self HMH_createTableView];
    
    [self createAlertView];
    
    self.tableView.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(2);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData {
    [super loadData];
//    [_HMH_hotTagArr removeAllObjects] ;
//    [_HMH_parentArr removeAllObjects] ;
//    [_HMH_allCategotyArr removeAllObjects] ;
 
    // 获取热门分类
    [self HMH_requestHotTagData];
    // 获取所有分类
    [self HMH_getAllCategoryData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
// 获取所有类别请求
- (void)HMH_getAllCategoryData{
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-category/category-all/get"];
    if (getUrlStr) {
        [self requestData:nil withUrl:getUrlStr requestType:@"get" requestName:@"allCategory"];
    }
}

// 热门标签数据请求
- (void)HMH_requestHotTagData{
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-tag/tag-hot/get"];
    if (getUrlStr) {
        [self requestData:nil withUrl:getUrlStr requestType:@"get" requestName:@"allTag"];
    }
}


- (void)createAlertView{
    //    VideoDownLoadAlertView *alert = [[VideoDownLoadAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) centerTitle:@"是否取消下载" cancelBtnTitle:@"取消下载" pauseBtnTitle:@"暂停下载"];
    //    [alert show];
}

//-(void)HMH_createTableView{
//    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit + 44, ScreenW, ScreenH - self.HMH_statusHeghit - 44 - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
//    _tableview.backgroundColor = RGBACOLOR(240, 241, 242, 1);
//    _tableview.dataSource = self;
//    _tableview.delegate = self;
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_tableview];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+_HMH_parentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == (2+_HMH_parentArr.count)-1) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    bgView.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    /**
     此页面的布局方式 为分区布局
     _HMH_parentArr.count 是指由两级的显示
     2是指 最后的 全部分类 和 热门标签
     总共分区个数是 (2+_HMH_parentArr.count)
     */
    
    if (indexPath.section == (2+_HMH_parentArr.count) - 2) { // 所有分类
        
        CGFloat viewH = [HMHVideoAllCategoryView getCategoryViewHeightWithArr:_HMH_allCategotyArr];
        
        HMHVideoAllCategoryView *allView = [[HMHVideoAllCategoryView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, viewH) withDataSource:_HMH_allCategotyArr];
        __weak typeof(self) weakSelf = self;
        allView.allcategoryBlock = ^(NSInteger selectTag) {
            [weakSelf videolLabSelectWithCellIndexPathSection:indexPath.section andLabTag:selectTag andParent:@""];
        };
        [cell.contentView addSubview:allView];
    } else if (indexPath.section == (2+_HMH_parentArr.count) - 1){ // 热门标签
        
        HMHSearchHotLabView *searchV = [[HMHSearchHotLabView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200) withDataSource:_HMH_hotTagArr];
        searchV.delegate = self;
        CGFloat H = [HMHSearchHotLabView getLabsHeightWithModel:_HMH_hotTagArr];
        searchV.frame = CGRectMake(0, 0, ScreenW, H);
        [cell.contentView addSubview:searchV];
    } else { //
        if (_HMH_parentArr.count > indexPath.section) {
            HMHVideoCategoryParentModel *pModel = _HMH_parentArr[indexPath.section];
            pModel.indexSection = indexPath.section;
            HMHVideoCategoryView *hefaView = [[HMHVideoCategoryView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120) withSection:indexPath.section parentModel:pModel];
            
            __weak typeof(self) weakSelf = self;
            hefaView.categoryBlock = ^(NSInteger selectTag) {
                [weakSelf videolLabSelectWithCellIndexPathSection:indexPath.section andLabTag:selectTag andParent:@""];
            };
            hefaView.parentBlock = ^(NSString *parent) {
                [weakSelf videolLabSelectWithCellIndexPathSection:indexPath.section andLabTag:0 andParent:parent];
            };
            [cell.contentView addSubview:hefaView];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark 每个分类标签的点击事件
- (void)videolLabSelectWithCellIndexPathSection:(NSInteger)cellIndexSection andLabTag:(NSInteger)labTag andParent:(NSString *)parent{
    if (cellIndexSection == (2+_HMH_parentArr.count) - 2) {
        if (_HMH_allCategotyArr.count > labTag) {
            HMHVideoCategoryParentModel *allModel = _HMH_allCategotyArr[labTag];
            NSString *idStr = [NSString stringWithFormat:@"%@",allModel.id];
            [self searchRequestDataWithSearchType:@"category" searchValue:idStr searchName:allModel.name];
        }
    } else {
        if (_HMH_parentArr.count > cellIndexSection) {
            HMHVideoCategoryParentModel *pModel = _HMH_parentArr[cellIndexSection];
            
            if (parent.length > 0) {
                NSString *idStr = [NSString stringWithFormat:@"%@",pModel.id];
                [self searchRequestDataWithSearchType:@"category" searchValue:idStr searchName:pModel.name];
            } else {
                NSLog(@"cellIndexSection = %ld  labTag = %ld",cellIndexSection,labTag);
                
                if (pModel.children.count > labTag) {
                    NSDictionary *childDic = pModel.children[labTag];
                    NSString *idStr = [NSString stringWithFormat:@"%@",childDic[@"id"]];
                    [self searchRequestDataWithSearchType:@"category" searchValue:idStr searchName:childDic[@"name"]];
                }
            }
        }
    }
}
#pragma mark 底部标签的点击事件
- (void)hotLabClickWithLabIndex:(NSInteger)labIndex{
    // searchValue为 视频标签id
    if (_HMH_hotTagArr.count > labIndex) {
        HMHVideoTagsModel *model = _HMH_hotTagArr[labIndex];
        NSString *tagIDStr = [NSString stringWithFormat:@"%@",model.id];
        [self searchRequestDataWithSearchType:@"tag" searchValue:tagIDStr searchName:model.tagName];
    }
}
// 跳转到列表页
- (void)searchRequestDataWithSearchType:(NSString *)searchType searchValue:(NSString *)searchValue searchName:(NSString *)searchName{
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[HMHVideosListViewController class]]) {
//            HMHVideosListViewController *vc = (HMHVideosListViewController *)temp;
//            vc.searchType = searchType;
//            vc.searchValue = searchValue;
//            //            vc.tagOrCategoryNameStr = searchName;
//            [self.navigationController popToViewController:temp animated:YES];
//            return;
//        }
//    }
    
    HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
    listVC.searchType = searchType;
    listVC.searchValue = searchValue;
    //    listVC.tagOrCategoryNameStr = searchName;
 //   [self.navigationController pushViewController:listVC animated:YES];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == (2+_HMH_parentArr.count) - 2) { // 全部分类
        if (_HMH_allCategotyArr.count > 0) {
            return [HMHVideoAllCategoryView getCategoryViewHeightWithArr:_HMH_allCategotyArr];
        } else {
            return 0.0;
        }
    } else if (indexPath.section == (2+_HMH_parentArr.count) - 1){ // 热门标签
        if (_HMH_hotTagArr.count > 0) {
            return [HMHSearchHotLabView getLabsHeightWithModel:_HMH_hotTagArr];
        } else {
            return 0.0;
        }
    }
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == (2+_HMH_parentArr.count) - 1) {
        return 0.0;
    }
    return 10.0;
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 数据请求
#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url requestType:(NSString *)requestType requestName:(NSString *)requestName{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestMethod;
    if ([requestType isEqualToString:@"get"]) {
        requestMethod = YTKRequestMethodGET;
    }else if ([requestType isEqualToString:@"put"]) {
        requestMethod = YTKRequestMethodPUT;
    }else {
        requestMethod = YTKRequestMethodPOST;
    }
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.requestMethod == YTKRequestMethodGET ) {
            if ([requestName isEqualToString:@"allTag"]) { // 热门标签
                [weakSelf HMH_getPrcessdata:request.responseObject];
                
            } else if ([requestName isEqualToString:@"allCategory"]){ //所有分类
                [self HMH_getResultAllCategoryData:request.responseObject];
            }
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}
// 获取热门标签数据返回
- (void)HMH_getPrcessdata:(id)data{
    
    self.firstBool = YES;
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in resDic[@"data"]) {
                HMHVideoTagsModel *model =[[HMHVideoTagsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
               // [_HMH_hotTagArr addObject:model];
                [tempArray addObject:model];
            }
            _HMH_hotTagArr = tempArray;
        }
        if (self.secoundBool) {
             [self.tableView reloadData];
        }
       
    }
}
// 获取所有分类
- (void)HMH_getResultAllCategoryData:(id)data{
    
    self.secoundBool = YES;
    
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
              NSMutableArray *tempArray1 = [NSMutableArray array];
              NSMutableArray *tempArray2 = [NSMutableArray array];
            for (NSDictionary *dataDic in resDic[@"data"]) {
                HMHVideoCategoryParentModel *pModel = [[HMHVideoCategoryParentModel alloc] init];
                [pModel setValuesForKeysWithDictionary:dataDic];
                for (NSDictionary *cDic in pModel.children) {
                    HMHVideoCategoryChildrenModel *cModel = [[HMHVideoCategoryChildrenModel alloc] init];
                    
                    [cModel setValuesForKeysWithDictionary:cDic];
                }
                if ([pModel.topType isEqualToNumber:@1]) {
//                    [_HMH_parentArr addObject:pModel];
                    [tempArray1 addObject:pModel];

                } else {
//                    [_HMH_allCategotyArr addObject:pModel];
                    [_HMH_allCategotyArr addObject:pModel];
                    [tempArray2 addObject:pModel];
                }
            }
            _HMH_parentArr =  tempArray1;
            _HMH_allCategotyArr = tempArray2;
        }
        if (self.firstBool) {
            [self.tableView reloadData];
        }
        
    }
}

- (void)addFooterRefresh {
    
}

@end
