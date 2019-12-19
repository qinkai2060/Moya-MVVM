//
//  HMHLiveVideoHomeViewRecommendController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeViewRecommendController.h"
#import "HMLiveRecommendBannerCell.h"
#import "HMLiveRecommendShortVideoCell.h"
#import "HMLiveRecommendChannelCell.h"
#import "HMHVideoPreviewViewController.h"
#import "HMHShortVideoViewController.h"
#import "HMHAliyunTimeShiftLiveViewController.h"
#import "HMHAliYunVodPlayerViewController.h"
#import "HMHliveParamsModel.h"
#import "HMHLiveMoreHeaderModel.h"
#import "HMHLiveAttentionModel.h"
#import "HMHVideoListNewModel.h"
#import "HMLiveRecommendNewInformationCell.h"
#import "HMLiveRecommendEditCell.h"
#import "HFShouYinViewController.h"

#import "HMLiveNewTableViewCell.h"
#import "HMLiveActivityTableViewCell.h"
@interface HMHLiveVideoHomeViewRecommendController ()

@property (nonatomic,strong)NSArray<NSString *> *signArray;
@property (nonatomic,strong)NSArray<NSString *> *moreTitleArray;

@property (nonatomic,strong)HMHLiveModel *currentModel;

@property (nonatomic,strong)HMHLiveMoreHeaderModel *currentMoreModel;

@property (nonatomic,strong)NSMutableArray *tempArray;

@property (nonatomic,strong)NSMutableArray *classArray;

@end

@implementation HMHLiveVideoHomeViewRecommendController

- (NSMutableArray *)tempArray {
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (NSMutableArray *)classArray {
    if (_classArray == nil) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}
//取数据用的
- (NSArray<NSString *> *)signArray {
    if (_signArray == nil) {
        _signArray = @[@"banner",@"modules_news",@"well_chosen",@"live_stream",@"modules_4",@"short_video",@"recommend"];
    }
    return _signArray;
}

- (NSArray<NSString *> *)moreTitleArray {
    if (_moreTitleArray == nil) {
        _moreTitleArray = @[@"live_stream_header",@"well_chosen_header",@"short_video_header",@"recommend_header"];
    }
    return _moreTitleArray;
}

- (void)viewDidLoad {
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self loadData];
}

- (void)loadData {
    [super loadData];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-info/revisionV2-index/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }

    [self requestData:[NSDictionary dictionary] withUrl:getUrlStr withRequestName:@""];
    
}

- (void)addFooterRefresh {
    
}

- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestName:(NSString *)requestName{
    
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf getPrcessdata:request.responseObject];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
        if (weakSelf.currentModel) {
            [weakSelf hideNoContentView];
        } else {
            [weakSelf showNoContentView:YES];
        }
    }];
}

- (void)getPrcessdata:(id)data {
    NSLog(@"-----------%@", data);
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    
    if ([resDic[@"data"] isKindOfClass:[NSNull class]] || !resDic) {
        self.noContentImageName = @"SpType_search_noContent";
        [self showNoContentView:YES];
        return;
    }
    
    if (state == 1) {
        
        NSDictionary *dataDic = resDic[@"data"];
        NSArray *cardsArr = dataDic[@"cards"];
        
        NSMutableDictionary *endDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *moreEndDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < cardsArr.count; i++) {
            
            NSDictionary *dict = cardsArr[i];
            
            for (int j = 0; j < self.signArray.count; j++) {
                
                if ([self.signArray[j] isEqualToString:dict[@"name"]]&& [self.signArray[j] isEqualToString:@"modules_news"]) {
                    //快讯
                    NSDictionary *dicnews = dict[@"cells"];
                                        
                    [endDict setValue:dicnews forKey:self.signArray[j]];
                    
                    break;
                } else if ([self.signArray[j] isEqualToString:dict[@"name"]] && [self.signArray[j] isEqualToString:@"modules_4"]){
                    //活动精选
                    NSDictionary *dicnews = dict[@"cells"];

                    [endDict setValue:dicnews forKey:self.signArray[j]];
                    break;

                } else if ([self.signArray[j] isEqualToString:dict[@"name"]]) {
                    //这里需要把数据取出来
                    NSLog(@"=========%@",self.signArray[j]);
                    NSMutableArray *dictArray = [NSMutableArray array];
                    NSArray *mArray = dict[@"cells"];
                    for (int m = 0; m < mArray.count ; m++) {
                        NSDictionary *mDict = mArray[m];
                        [dictArray addObject:mDict[@"data"]];
                    }
                    //这里还得存储数据
                    [endDict setValue:dictArray forKey:self.signArray[j]];
                    
                    break;
                }
                
                
            }
            
            
            for (int j = 0; j < self.moreTitleArray.count; j++) {
                
                if ([self.moreTitleArray[j] isEqualToString:dict[@"name"]]) {
                    
                    //这里需要把数据取出来
                    NSMutableArray *dictArray = [NSMutableArray array];
                    NSArray *mArray = dict[@"cells"];
                    for (int m = 0; m < mArray.count ; m++) {
                        NSDictionary *mDict = mArray[m];
                        [dictArray addObject:mDict[@"data"]];
                    }
                    //这里还得存储数据
                    [moreEndDict setValue:dictArray forKey:self.moreTitleArray[j]];
                    
                    break;
                }
                
                
            }
            
        }
        
        
        
        self.currentModel = [HMHLiveModel modelWithJSON:endDict];
        self.currentMoreModel = [HMHLiveMoreHeaderModel modelWithJSON:moreEndDict];
        
        //        NSLog(@"%@",self.currentModel);
        //        NSLog(@"%@",self.currentModel);
        
        [self dearData];
        if (self.currentModel) {
            [self hideNoContentView];
        } else {
            self.noContentImageName = @"SpType_search_noContent";
            [self showNoContentView:YES];
        }
        
        [self.tableView reloadData];
        
        
    }
    
}

/**
 数据源处理
 */
- (void)dearData {
    //"banner",@"live_stream",@"well_chosen",@"short_video",@"recommend"
    
    NSMutableArray *hhTempArray = [NSMutableArray array];
    NSMutableArray *hhClassArray = [NSMutableArray array];
    if (self.currentModel.banner.count > 0) {
        [hhTempArray addObject:self.currentModel.banner];
        [hhClassArray addObject:@"HMLiveRecommendBannerCell"];
    }
    //快讯
    if ([self.currentModel.modules_news firstObject].isModuleShow) {
        [hhTempArray addObject:self.currentModel.modules_news];
        [hhClassArray addObject:@"HMLiveNewTableViewCell"];
    }
    
    if (self.currentModel.live_stream.count > 0) {
        [hhTempArray addObject:self.currentModel.live_stream];
        [hhClassArray addObject:@"HMLiveRecommendChannelCell"];
    }
    //活动资讯
//    if ([self.currentModel.modules_4 firstObject].isModuleShow && [self.currentModel.modules_4 firstObject].items.count > 0 &&
//        self.currentModel.modules_4.count > 0) {
//        [hhTempArray addObject:self.currentModel.modules_4];
//        [hhClassArray addObject:@"HMLiveActivityTableViewCell"];
//    }
    
    if (self.currentModel.well_chosen.count > 0) {
        [hhTempArray addObject:self.currentModel.well_chosen];
        [hhClassArray addObject:@"HMLiveRecommendNewInformationCell"];
    }
    
    if (self.currentModel.short_video.count > 0) {
        [hhTempArray addObject:self.currentModel.short_video];
        [hhClassArray addObject:@"HMLiveRecommendShortVideoCell"];
    }
    
    if (self.currentModel.recommend.count > 0) {
        [hhTempArray addObject:self.currentModel.recommend];
        [hhClassArray addObject:@"HMLiveRecommendEditCell"];
    }
    
    self.tempArray = hhTempArray;
    self.classArray = hhClassArray;
    
}


- (void)initNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionHMHliveMoreNotification:) name:HMHliveMoreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionHMHliveCellTapNotification:) name:HMHliveCellTapNotification object:nil];
    
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMHliveMoreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMHliveCellTapNotification object:nil];
}

#pragma mark <MoreView  点击事件>
- (void)actionHMHliveMoreNotification:(NSNotification *)sender {
    
    self.nvController = [HMHLiveCommendClassTools shareManager].nvController;
    
    HMHLiveMoreModel *model = sender.object;
    
    
//    if ([model.text isEqualToString:@"活动精选"]) {
//        NSLog(@"活动精选");
//
//    } else {
        HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
        listVC.searchType = @"scene";
        listVC.searchValue = model.tag;
        
        if ([model.tag isEqualToString:@"live"]) {
            listVC.searchType = @"module";
        }
        [self.nvController pushViewController:listVC animated:YES];
//    }
}

#pragma mark Cell 的点击事件

- (void)actionHMHliveCellTapNotification:(NSNotification *)sender {
    
    self.nvController = [HMHLiveCommendClassTools shareManager].nvController;
    
    id   tempModel = sender.object;
    
    if ([tempModel isKindOfClass:[HMHLivereCommendModel class]]) {
        
        HMHLivereCommendModel *model = tempModel;
        
        if (model.params) {
            
            if ([model.tag isEqualToNumber:@1]) { // 浏览器
                HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
                pvc.urlStr = model.target;
                pvc.isPushFromVideoWeb = YES;
                pvc.hidesBottomBarWhenPushed = YES;
                [self.nvController pushViewController:pvc animated:NO];
                return;
            }
            if ([model.params.sceneType.description isEqualToString:@"1"]) { // 短视频
                HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
                shortVC.videoNo = model.wd_id;
                [self.nvController pushViewController:shortVC         animated:YES];
            } else {  // 普通视频
                // 视频播放状态（1预告、2直播中、3已结束、4:回放）
                if ([model.params.videoStatus.description isEqualToString:@"1"]) { // 预告
                    HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
                    preview.videoNum = model.wd_id;
                    preview.indexSelected = @0;
                    [self.nvController pushViewController:preview animated:YES];
                    
                }  else if ([model.params.videoStatus.description isEqualToString:@"2"]){ // 直播中
                    HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.wd_id;
                    [self.nvController pushViewController:liveVC animated:YES];
                }  else if ([model.params.videoStatus.description isEqualToString:@"3"] || [model.params.videoStatus.description isEqualToString:@"4"]){ // 回放 已结束
                    HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.wd_id;
                    [self.nvController pushViewController:liveVC animated:YES];
                }
            }
            
        } else {
            
            if ([model.sceneType isEqualToNumber:@1]) { // 短视频
                HMHShortVideoViewController *vc = [[HMHShortVideoViewController alloc] init];
                vc.videoNo = model.wd_id;
                [self.nvController pushViewController:vc animated:YES];
                
            } else { // 普通视频
                // 视频播放状态（1预告、2直播中、3回放 4:已结束、）
                if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                    HMHVideoPreviewViewController *previewVC = [[HMHVideoPreviewViewController alloc] init];
                    previewVC.indexSelected = @0;
                    previewVC.videoNum = model.wd_id;
                    [self.nvController pushViewController:previewVC animated:YES];
                    
                } else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                    HMHAliyunTimeShiftLiveViewController *timeVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                    timeVC.videoNum = model.wd_id;
                    timeVC.indexSelected = @0;
                    [self.nvController pushViewController:timeVC animated:YES];
                    
                } else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                    HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.wd_id; // 此时的id为视频的id
                    
                    [self.nvController pushViewController:liveVC animated:YES];
                } else { // 已结束
                }
            }
            
            
        }
        
    }
    if ([tempModel isKindOfClass:[HMHLiveAttentionModel class]]) {
        
        HMHLiveAttentionModel *model = tempModel;
        
        if ([model.sceneType isEqualToNumber:@1]) { // 短视频
            HMHShortVideoViewController *vc = [[HMHShortVideoViewController alloc] init];
            // vc.videoNo = model.wd_id;
            vc.videoNo = model.vno;
            [self.nvController pushViewController:vc animated:YES];
            
        } else { // 普通视频
            // 视频播放状态（1预告、2直播中、3回放 4:已结束、）
            if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                HMHVideoPreviewViewController *previewVC = [[HMHVideoPreviewViewController alloc] init];
                previewVC.indexSelected = @0;
                // previewVC.videoNum = model.wd_id;
                previewVC.videoNum = model.vno;
                [self.nvController pushViewController:previewVC animated:YES];
                
            } else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                HMHAliyunTimeShiftLiveViewController *timeVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                //                    timeVC.videoNum = model.wd_id;
                timeVC.videoNum = model.vno;
                timeVC.indexSelected = @0;
                [self.nvController pushViewController:timeVC animated:YES];
                
            } else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                liveVC.indexSelected = @0;
                //                    liveVC.videoNum = model.wd_id; // 此时的id为视频的id
                liveVC.videoNum = model.vno;
                
                [self.nvController pushViewController:liveVC animated:YES];
            } else { // 已结束
            }
        }
        
        
        
    }
    if ([tempModel isKindOfClass:[HMHVideoListNewModel class]]) {
        HMHVideoListNewModel *model = tempModel;
        
        if ([model.sceneType isEqualToNumber:@1]) { // 短视频
            HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
            shortVC.videoNo = model.vno;
            [self.nvController pushViewController:shortVC         animated:YES];
        } else {  // 普通视频
            // 视频播放状态（1预告、2直播中、3已结束、 4:回放）
            if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                // 如果预告中 当前剩余时间小于0 就跳转直播 反之 跳转预告
                if ([model.liveLeftTime longLongValue] < 0) { // 直播
                    HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.vno;
                    [self.nvController pushViewController:liveVC animated:YES];
                } else { // 预告
                    HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
                    preview.videoNum = model.vno;
                    preview.indexSelected = @0;
                    [self.nvController pushViewController:preview animated:YES];
                }
            }  else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.navigationController pushViewController:liveVC animated:YES];
            }  else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.nvController pushViewController:liveVC animated:YES];
            } else { // 已结束
                
            }
        }
        
        
    }
    
    
    NSLog(@"这里是cell 的点击事件");
    
    
}

- (void)setSubviews {
    [super setSubviews];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    //注册CELL
    [self.tableView registerClass:[HMLiveRecommendBannerCell  class] forCellReuseIdentifier:@"HMLiveRecommendBannerCell"];
    [self.tableView registerClass:[HMLiveNewTableViewCell  class] forCellReuseIdentifier:@"HMLiveNewTableViewCell"];
    [self.tableView registerClass:[HMLiveRecommendShortVideoCell  class] forCellReuseIdentifier:@"HMLiveRecommendShortVideoCell"];
    [self.tableView registerClass:[HMLiveActivityTableViewCell  class] forCellReuseIdentifier:@"HMLiveActivityTableViewCell"];
    [self.tableView registerClass:[HMLiveRecommendChannelCell class] forCellReuseIdentifier:@"HMLiveRecommendChannelCell"];
    [self.tableView registerClass:[HMLiveRecommendNewInformationCell  class] forCellReuseIdentifier:@"HMLiveRecommendNewInformationCell"];
    [self.tableView registerClass:[HMLiveRecommendEditCell class] forCellReuseIdentifier:@"HMLiveRecommendEditCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}





#pragma mark <UITableViewDelegate,UITableViewDatasource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tempArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self selectCell:indexPath.section indexPath:indexPath];
}

- (UITableViewCell *)selectCell:(NSInteger)section indexPath:(NSIndexPath *)indexPath {
    
    NSString *stringClass = self.classArray[section];
    
    UITableViewCell *cell = nil;
    if ([stringClass isEqualToString:@"HMLiveRecommendBannerCell"]) {
        if (self.currentModel.banner.count > 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendBannerCell" forIndexPath:indexPath];
            ((HMLiveRecommendBannerCell *)cell).modelArray = self.currentModel.banner;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    //快讯
    if ([stringClass isEqualToString:@"HMLiveNewTableViewCell"]) {
        if ([self.currentModel.modules_news firstObject].isModuleShow) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveNewTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HMLiveNewTableViewCell *cellone = (HMLiveNewTableViewCell *)cell;
            cellone.model = [self.currentModel.modules_news firstObject];
            [cellone doMessageRendering];
            WEAKSELF;
            cellone.newClickBlcok = ^(HMHLivieNewsItemsModel * _Nonnull model, NSInteger type) {
                [weakSelf newClickBlcok:model type:type];
            };
            return cellone;
        }
    }
    
    if ([stringClass isEqualToString:@"HMLiveRecommendChannelCell"]) {
        
        if (self.currentModel.live_stream.count > 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendChannelCell" forIndexPath:indexPath];
            ((HMLiveRecommendChannelCell *)cell).currentMoreType = HMHomeLiveMoreType_Channel;
            ((HMLiveRecommendChannelCell *)cell).modelArray = self.currentModel.live_stream;
            ((HMLiveRecommendChannelCell *)cell).moreModel = self.currentMoreModel.live_stream_header.firstObject;
            [((HMLiveRecommendChannelCell *)cell) refreshCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
//    //活动精选
//    if ([stringClass isEqualToString:@"HMLiveActivityTableViewCell"]) {
//        if ([self.currentModel.modules_4 firstObject].isModuleShow && [self.currentModel.modules_4 firstObject].items.count >=4  &&
//            self.currentModel.modules_4.count > 0) {
//
//            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveActivityTableViewCell" forIndexPath:indexPath];
//            HMLiveActivityTableViewCell *cellmodule = (HMLiveActivityTableViewCell *)cell;
//            cellmodule.model = [self.currentModel.modules_4 firstObject];
//            cellmodule.selectionStyle = UITableViewCellSelectionStyleNone;
//            WEAKSELF;
//            cellmodule.cellClick = ^(HMHLiveModules_4ItemsModel * _Nonnull model) {
//                [weakSelf activityPushDetailH5:model];
//            };
//            return cellmodule;
//        }
//    }
    if ([stringClass isEqualToString:@"HMLiveRecommendNewInformationCell"]) {
        
        if (self.currentModel.well_chosen.count > 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendNewInformationCell" forIndexPath:indexPath];
            ((HMLiveRecommendNewInformationCell *)cell).currentMoreType = HMHomeLiveMoreType_Consult;
            ((HMLiveRecommendNewInformationCell *)cell).modelArray = self.currentModel.well_chosen;
            ((HMLiveRecommendChannelCell *)cell).moreModel = self.currentMoreModel.well_chosen_header.firstObject;
            [((HMLiveRecommendNewInformationCell *)cell) refreshCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if ([stringClass isEqualToString:@"HMLiveRecommendShortVideoCell"]) {
        
        if (self.currentModel.short_video.count > 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendShortVideoCell" forIndexPath:indexPath];
            
            ((HMLiveRecommendShortVideoCell *)cell).currentMoreType = HMHomeLiveMoreType_ShortVideo;
            ((HMLiveRecommendShortVideoCell *)cell).modelArray = self.currentModel.short_video;
            ((HMLiveRecommendChannelCell *)cell).moreModel = self.currentMoreModel.short_video_header.firstObject;
            [((HMLiveRecommendShortVideoCell *)cell) refreshCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if ([stringClass isEqualToString:@"HMLiveRecommendEditCell"]) {
        
        if (self.currentModel.recommend.count > 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendEditCell" forIndexPath:indexPath];
            ((HMLiveRecommendEditCell *)cell).currentMoreType = HMHomeLiveMoreType_Recommend;
            ((HMLiveRecommendEditCell *)cell).modelArray = self.currentModel.recommend;
            ((HMLiveRecommendChannelCell *)cell).moreModel = self.currentMoreModel.recommend_header.firstObject;
            [((HMLiveRecommendEditCell *)cell) refreshCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)newClickBlcok:(HMHLivieNewsItemsModel *)model type:(NSInteger)type{
    self.nvController = [HMHLiveCommendClassTools shareManager].nvController;
    
    if (type == 0) {
        //cell点击
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
        vc.isMore = YES;
        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,model.link]];
        [self.nvController pushViewController:vc animated:YES];
    } else {
        //更多
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
        vc.isMore = YES;
        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/appstatic/appindex/news/index.html?vv=1548659194646"]];
        [self.nvController pushViewController:vc animated:YES];
        
    }
}
- (void)activityPushDetailH5:(HMHLiveModules_4ItemsModel *)model{
    self.nvController = [HMHLiveCommendClassTools shareManager].nvController;

    HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
    vc.isMore = YES;
    [vc setShareUrl:model.link];
    [self.nvController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 0.0;
    switch (section) {
        case 0:
        {
            height = 0.1;
            break;
        }
            
        case 1:
        {
            height = 0.1;
            break;
        }
            
        case 2:
        {
            height = 10;
            break;
        }
        case 3:
        {
            height = 10;
            break;
        }
        case 4:
        {
            height = 10;
            break;
        }
            
        default:
            break;
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
