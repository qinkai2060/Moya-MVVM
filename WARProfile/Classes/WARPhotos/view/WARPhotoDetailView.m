//
//  WARPhotoDetailView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoDetailView.h"

#import "WARMacros.h"
//#import "UIColor+WARCategory.h"
#import "WARPhotoDetailCell.h"
#import "WARBaseMacros.h"
#import "WARGroupModel.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARPhotoDetailCollectionCell.h"
#import "WARPhotoListLayout.h"
#import "MJRefresh.h"
#import "WARProfileNetWorkTool.h"
#import "WARConfigurationMacros.h"
#import "WARPhotosUploadManger.h"
@interface WARPhotoDetailView ()<UITableViewDelegate,UITableViewDataSource,WARPhotoDetailCellDelegate>

@property(nonatomic,strong)UIView *tbHeaderV;
@property(nonatomic,strong)UIView *tbFooterV;
@property(nonatomic,strong)UIButton *UploadPhotoBtn;
@property(nonatomic,strong)UIButton *UploadPhotoFooterBtn;
@property(nonatomic,assign)WARPhotoDetailViewType type;
@property(nonatomic,strong)WARPhotoDetailCell *cell;
@property(nonatomic,assign)CGFloat headerHeight;
@property(nonatomic,assign)CGFloat scale;
@end
@implementation WARPhotoDetailView
- (instancetype)initWithFrame:(CGRect)frame type:(WARPhotoDetailViewType)type atAccounId:(NSString *)accoutId atModel:(WARGroupModel*)model{
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.accountId = accoutId;
        _type = type;
        [self initUI];
        if (type == WARPhotoDetailViewTypeCustom) {
            [self initHeaderV];
        }else if(type == WARPhotoDetailViewTypeDefualt){
            CGFloat y = WAR_IS_IPHONE_X?84:64;
            CGFloat tabH = WAR_IS_IPHONE_X?83:49;
            self.tableView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight-y-tabH);
        }else if(type == WARPhotoDetailViewTypeCover){
            CGFloat y = WAR_IS_IPHONE_X?84:64;
            CGFloat tabH = WAR_IS_IPHONE_X?83:49;
            self.tableView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight-y-tabH);
        }
        else{
            [self initHeaderV];
            
        }
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShuju) name:@"upCount" object:nil];
        WS(weakSelf);
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadFooterData];
        }];
        //  self.tableView.mj_footer.hidden =YES;
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self;
}
- (void)reloadShuju {
//    WS(weakself);
//    WARGroupModel *model = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
//    __block NSInteger idIndex = 0;
//    if (model != nil){
//        if ([model.albumId isEqualToString:self.groupMModel.albumId]) {
//            self.groupMModel = model;
//
//            [self.tableView reloadData];
//
//        }
//
//    }
//
}
- (void)loadFooterData {
  
    if (self.detailmodel.lastFindId.length != 0) {
         self.tableView.mj_footer.hidden =NO;
        WS(weakSelf);
        [WARProfileNetWorkTool postPhotoDetailId:self.groupMModel.albumId   params:@{@"friendId":self.accountId,@"lastShootTime":self.detailmodel.lastShootTime,@"lastSort":self.detailmodel.lastSort,@"lastFindId":self.detailmodel.lastFindId}CallBack:^(id response)
         {
             
                NSDictionary *dict = (NSDictionary*)response;
             NSArray *arrayData = dict[@"pictures"];
             if (arrayData.count > 0) {
                 NSMutableArray *pArray = [NSMutableArray array];
                 for (NSDictionary *dictData in arrayData) {
                     WARPictureModel *samllModel = [[WARPictureModel alloc] init];
                     [samllModel praseDataOther:dictData];
                     [pArray addObject:samllModel];
                     
                 }
                 
                 
                 WARDetailModel *model = [[WARDetailModel alloc] init];
                 [model praseData:response];
                 self.detailmodel.lastFindId =  model.lastFindId;
                 self.detailmodel.lastShootTime =  model.lastShootTime;
                 self.detailmodel.lastSort =  model.lastSort;
                 
                 [pArray enumerateObjectsUsingBlock:^(WARPictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     WARDetailPicturesModel *tempmodel =  [self.detailmodel.arrPictures lastObject] ;
                     WARDetailDateDataModel *addressmodel = [tempmodel.arrDateData lastObject];
                     WARPictureModel *pmodel = [addressmodel.arrPictures lastObject];
                     
                     if(![obj.sortTime isEqualToString:pmodel.sortTime]) {
                         WARPictureModel *newCreatModel = [[WARPictureModel alloc] init];
                         newCreatModel = obj;
                         
                         WARDetailDateDataModel *newDateDataModel = [[WARDetailDateDataModel alloc] init];
                         newDateDataModel.address = newCreatModel.address;
                         [newDateDataModel.arrPictures addObject:newCreatModel];
                         
                         WARDetailPicturesModel *detailPictureModel =  [[WARDetailPicturesModel alloc] init];
                         detailPictureModel.date = newCreatModel.sortTime;
                         [detailPictureModel.arrDateData addObject:newDateDataModel];
                         
                         [self.detailmodel.arrPictures addObject:detailPictureModel];
                     }else {
                         if ([obj.address isEqualToString:pmodel.address]) {
                             
                             [addressmodel.arrPictures addObject:obj];
                             
                      
                         }else {
                             WARPictureModel *newCreatModel = [[WARPictureModel alloc] init];
                             newCreatModel = obj;
                             
                             WARDetailDateDataModel *tempAddressModel = [[WARDetailDateDataModel alloc] init];
                             tempAddressModel.address = newCreatModel.address;
                             [tempAddressModel.arrPictures addObject:newCreatModel];
                             
                             [tempmodel.arrDateData addObject:tempAddressModel];
                         }
                     }
                 }];
                 
                 [self.tableView reloadData];
                 [self.tableView.mj_footer endRefreshing];
                 self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                 if (arrayData.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                 }

         
             }else {
                 [self.tableView.mj_footer endRefreshing];
                 self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                 if (arrayData.count == 0) {
                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                 }
             }
        
             
         } failer:^(id response) {
             [weakSelf.tableView.mj_footer endRefreshing];
         }];
   
        }else {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
         

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isEndDecelerating = NO;
//    [SDWebImageManager.sharedManager cancelAll];
//    [SDWebImageManager.sharedManager.imageCache clearMemory];
 //    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    self.isEndDecelerating = YES;
//    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//    for (NSIndexPath *indexPath in visiblePaths) {
//        WARPhotoDetailCell * cell = (WARPhotoDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        [cell.collectionView reloadData];
//   
//    }
//}

- (void)setDetailmodel:(WARDetailModel *)detailmodel{
    _detailmodel = detailmodel;
        WS(weakSelf);
   
    [self.tableView reloadData];
}

- (void)setGroupMModel:(WARGroupModel *)groupMModel {
    _groupMModel = groupMModel;


    self.headerView.titlelb.text = WARLocalizedString(groupMModel.name);
    self.headerView.phototypelb.text = WARLocalizedString(groupMModel.type);
    self.headerView.countlb.text = [NSString stringWithFormat:@"%@ 张",groupMModel.pictureCount];
    
    //
    if (groupMModel.isMine) {
        self.UploadPhotoBtn.hidden = NO;
        self.tbHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 58);
    }else{
        self.UploadPhotoBtn.hidden = YES;
        self.tbHeaderV.frame = CGRectMake(0,0, kScreenWidth, 0);
        
    }
    if ([groupMModel.coverType isEqualToString:@"VIDEO"]) {
        [self.headerView sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(kScreenWidth ,190),groupMModel.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth ,190))];
    }else{
        [self.headerView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth , 190),groupMModel.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth ,190))];
    }
    
    
}
- (void)setGroupModel:(WARGroupModel *)model{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.tableView.mj_footer.hidden = !self.detailmodel.arrPictures.count;
    return self.detailmodel.arrPictures.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WARDetailPicturesModel *model =  self.detailmodel.arrPictures[section];
    return model.arrDateData.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        WARDetailPicturesModel *model =  self.detailmodel.arrPictures[section];

    UIView *sectionHeader = [[UIView alloc] init];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] init];
    if (self.type == WARPhotoDetailViewTypeDefualt) {
        lable.frame = CGRectMake(10, 0, kScreenWidth-15, 34);
     
        
    }else{
        lable.frame = CGRectMake(0, 0, kScreenWidth, 34);
          lable.textAlignment = NSTextAlignmentCenter;
  
    }
    lable.textColor = TextColor;
    lable.text = WARLocalizedString(model.date);

  
    lable.font = kFont(14);
    [sectionHeader addSubview:lable];
    return sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARDetailPicturesModel *model =  self.detailmodel.arrPictures[indexPath.section];
    WARDetailDateDataModel*detailModel =   model.arrDateData[indexPath.row];
    NSInteger line = 0;
    if (detailModel.arrPictures.count%4 !=0) {
        line = (detailModel.arrPictures.count/4) == 0 ? 1: ((detailModel.arrPictures.count/4)+1);
    }else{
        line = (detailModel.arrPictures.count/4) == 0 ? 1: (detailModel.arrPictures.count/4);
    }
    
    
    return 21+((kScreenWidth-3)/4 + 5)*line+11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARDetailPicturesModel *model =  self.detailmodel.arrPictures[indexPath.section];
    model.sectionIndex = indexPath.section;
    WARDetailDateDataModel*detailModel =   model.arrDateData[indexPath.row];
    detailModel.dateSection = model.sectionIndex;
    detailModel.dateRowIndex = indexPath.row;
    WARPhotoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (!cell) {
        cell = [[WARPhotoDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    }
    [cell setCSSStyle:self.type];
    cell.delegate = self;
   cell.model = detailModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)photoDetailCell:(WARPhotoDetailCell *)cell atMondel:(WARPictureModel *)model atIndextPath:(NSIndexPath *)indexPath atCell:(WARPhotoDetailCollectionCell *)cell atPictureArr:(NSArray *)pictureArray{
    
    if ([self.delegate respondsToSelector:@selector(WARPhotoDetailView:atMondel:atCell:atPictureArray:)]) {
        [self.delegate WARPhotoDetailView:self atMondel:model atCell:cell atPictureArray:pictureArray];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
    CGFloat navbarH = WAR_IS_IPHONE_X? (64+24):64;
    //计算导航栏的透明度
    CGFloat minAlphaOffset = -190;
    CGFloat maxAlphaOffset = -60;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    CGPoint point = scrollView.contentOffset;
    if (point.y < -190) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
    if ([self.delegate respondsToSelector:@selector(WARPhotoDetailView:alpha:)]) {
        [self.delegate WARPhotoDetailView:self alpha:alpha];
    }
}
- (UIButton *)UploadPhotoFooterBtn{
    if (!_UploadPhotoFooterBtn) {
        _UploadPhotoFooterBtn = [[UIButton alloc] init];
        _UploadPhotoFooterBtn.backgroundColor = ThemeColor;
        [_UploadPhotoFooterBtn setTitle:WARLocalizedString(@"继续添加") forState:UIControlStateNormal];
        [_UploadPhotoFooterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_UploadPhotoFooterBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        _UploadPhotoFooterBtn.titleLabel.font = kFont(16);
        _UploadPhotoFooterBtn.frame = CGRectMake(0, 0, kScreenWidth-214, 32);
        CGPoint center =    _UploadPhotoFooterBtn.center;
        center.x = kScreenWidth*0.5;
        _UploadPhotoFooterBtn.center = center;
        _UploadPhotoFooterBtn.layer.cornerRadius = 3;
        _UploadPhotoFooterBtn.layer.masksToBounds = YES;
        
    }
    return _UploadPhotoFooterBtn;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"upCount" object:nil];
}
- (void)initHeaderV{
    [self.tableView addSubview:self.headerView];
    if (self.type== WARPhotoDetailViewTypeCustom) {
        [self.tbHeaderV addSubview:self.UploadPhotoBtn];
    }else if(self.type== WARPhotoDetailViewTypeManger){
        [self.tbFooterV addSubview:self.UploadPhotoFooterBtn];
    }
    self.tableView.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -190);
    [self.tableView setTableHeaderView: self.tbHeaderV];
    self.tableView.tableFooterView = self.tbFooterV;
}
- (void)initUI{
    [self addSubview:self.tableView];
    
}
- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}
- (UIView *)tbHeaderV{
    if (!_tbHeaderV) {
        _tbHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, -0, kScreenWidth, 58)];
        _tbHeaderV .backgroundColor = [UIColor whiteColor];
    }
    return _tbHeaderV;
}
- (UIView *)tbFooterV{
    if (!_tbFooterV) {
        _tbFooterV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    }
    return _tbFooterV;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame)) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
- (WARPhotoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WARPhotoHeaderView alloc] initWithType:WARPhotoHeaderViewTypeCustom];
        _headerView.frame = CGRectMake(0,  -190, [UIScreen mainScreen].bounds.size.width, 190);
        _headerView.tag = 101;
//        _headerView.contentMode = UIViewContentModeScaleAspectFill;
//        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}
- (UIButton *)UploadPhotoBtn{
    if (!_UploadPhotoBtn) {
        _UploadPhotoBtn = [[UIButton alloc] init];
        _UploadPhotoBtn.backgroundColor = ThemeColor;
        [_UploadPhotoBtn setTitle:WARLocalizedString(@"上传照片/视频") forState:UIControlStateNormal];
        [_UploadPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _UploadPhotoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _UploadPhotoBtn.frame = CGRectMake(101, CGRectGetMaxY(self.headerView.frame)+20, kScreenWidth-202, 35);
        _UploadPhotoBtn.layer.cornerRadius = 3;
        _UploadPhotoBtn.layer.masksToBounds = YES;
        [_UploadPhotoBtn addTarget:self action:@selector(pushHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _UploadPhotoBtn;
}
- (void)pushHandler:(UIButton*)btn
{
    if (self.pickerBlock) {
        self.pickerBlock();
    }
}
@end
