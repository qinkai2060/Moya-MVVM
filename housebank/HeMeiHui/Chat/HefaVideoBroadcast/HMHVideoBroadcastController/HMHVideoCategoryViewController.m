//
//  HMHVideoCategoryViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCategoryViewController.h"
#import "HMHVideoCategoryView.h"
#import "HMHVideoAllCategoryView.h"
#import "HMHSearchHotLabView.h"
#import "HMHVideoSearchViewController.h"
#import "HMHVideoTagsModel.h"


@interface HMHVideoCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,SearchHotLabViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIView *HMH_navView;
@property (nonatomic, strong) UITextField *HMH_searchTextField;

@property (nonatomic, strong) NSMutableArray *HMH_hotTagArr;
@property (nonatomic, strong) NSMutableArray *HMH_parentArr;
@property (nonatomic, strong) NSMutableArray *HMH_allCategotyArr;
@end

@implementation HMHVideoCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    _HMH_hotTagArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_parentArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_allCategotyArr = [NSMutableArray arrayWithCapacity:1];

    // 获取热门分类
    [self HMH_requestHotTagData];
    // 获取所有分类
    [self HMH_getAllCategoryData];

    [self HMH_createNav];
    [self HMH_createTableView];
    
    [self createAlertView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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


-(void)HMH_createNav{
    self.navigationController.navigationBarHidden = YES;
    
    _HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit, ScreenW, 44)];
    _HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_navView];
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 7, ScreenW - 40 - 60, 30)];
    bgView.backgroundColor = RGBACOLOR(233, 234, 235, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 30 / 2;
    [_HMH_navView addSubview:bgView];
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 7.5, 15, 15)];
    img.image = [UIImage imageNamed:@"VH_videoSearch"];
    [bgView addSubview:img];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 60, 44);
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backImageView.image=[UIImage imageNamed:@"VH_blackBack"];
    [backButton addSubview:backImageView];
    [_HMH_navView addSubview:backButton];
    
     _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
//    HMH_searchTextField.delegate = self;
    _HMH_searchTextField.enabled = NO;
    _HMH_searchTextField.returnKeyType = UIReturnKeySearch;
    _HMH_searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _HMH_searchTextField.text = self.searchKeyStr;
    _HMH_searchTextField.placeholder = @"请输入搜索内容";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    [bgView addSubview:_HMH_searchTextField];
    
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:searchBtn];

    //
    UIButton *rightButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton1.frame=CGRectMake(_HMH_navView.frame.size.width-54, 0, 44, 44);
    [rightButton1 setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton1 setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton1 addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_navView addSubview:rightButton1];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_navView.frame.size.height - 1, _HMH_navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [_HMH_navView addSubview:bottomLab];
}
// 返回按钮的点击事件
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
// 搜索按钮的点击事件
- (void)searchBtnClick:(UIButton *)btn{
    HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)HMH_createTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit + 44, ScreenW, ScreenH - self.HMH_statusHeghit - 44 - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _tableview.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (_HMH_hotTagArr.count > 0 && _HMH_allCategotyArr.count > 0) {
//        return 2+_HMH_parentArr.count;
//    }else if (_HMH_hotTagArr.count > 0 || _HMH_allCategotyArr.count > 0){
//        return 1+_HMH_parentArr.count;
//    }
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
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HMHVideosListViewController class]]) {
            HMHVideosListViewController *vc = (HMHVideosListViewController *)temp;
            vc.searchType = searchType;
            vc.searchValue = searchValue;
//            vc.tagOrCategoryNameStr = searchName;
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
    listVC.searchType = searchType;
    listVC.searchValue = searchValue;
//    listVC.tagOrCategoryNameStr = searchName;
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
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in resDic[@"data"]) {
                HMHVideoTagsModel *model =[[HMHVideoTagsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_HMH_hotTagArr addObject:model];
            }
        }
        [_tableview reloadData];
    }
}
// 获取所有分类
- (void)HMH_getResultAllCategoryData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in resDic[@"data"]) {
                HMHVideoCategoryParentModel *pModel = [[HMHVideoCategoryParentModel alloc] init];
                [pModel setValuesForKeysWithDictionary:dataDic];
                for (NSDictionary *cDic in pModel.children) {
                    HMHVideoCategoryChildrenModel *cModel = [[HMHVideoCategoryChildrenModel alloc] init];
                    
                    [cModel setValuesForKeysWithDictionary:cDic];
                }
                if ([pModel.topType isEqualToNumber:@1]) {
                    [_HMH_parentArr addObject:pModel];
                } else {
                    [_HMH_allCategotyArr addObject:pModel];
                }
            }
        }
        [_tableview reloadData];
    }
}

@end
