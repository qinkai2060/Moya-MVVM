//
//  WARBrowserMoudleView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import "WARBrowserMoudleView.h"
#import "WARMacros.h"
//#import "UIColor+WARCategory.h"
#import "WARPhotoDetailCell.h"
#import "WARBaseMacros.h"
#import "WARGroupModel.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARConfigurationMacros.h"
#import "WARBrowserMoudleCollectionCell.h"
#import "WARPhotoListLayout.h"
#import "WARBrowserMoudleCell.h"
#import "MJRefresh.h"
#import "WARProfileNetWorkTool.h"
@interface WARBrowserMoudleView ()<UITableViewDelegate,UITableViewDataSource,WARPhotoDetailCellDelegate,WARBrowserMoudleCellDelegate>

@property(nonatomic,strong)UIView *tbHeaderV;
@property(nonatomic,strong)UIView *tbFooterV;
@property(nonatomic,strong)UIButton *UploadPhotoBtn;
@property(nonatomic,strong)UIButton *UploadPhotoFooterBtn;
@property(nonatomic,assign)WARPhotoDetailViewType type;
@property(nonatomic,strong)WARPhotoDetailCell *cell;
@property(nonatomic,strong)NSMutableDictionary *dicH;
@end
@implementation WARBrowserMoudleView
- (instancetype)initWithFrame:(CGRect)frame atAcountID:(NSString*)accountId{
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.accountID = accountId;
        [self initUI];
        [self initHeaderV];
        WS(weakSelf);
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadFooterData];
        }];
        //  self.tableView.mj_footer.hidden =YES;
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self;
}
- (void)loadFooterData {
    
    if (self.detailmodel.lastFindId.length != 0) {
        self.tableView.mj_footer.hidden =NO;
        WS(weakSelf);
        [WARProfileNetWorkTool postPhotoDetailId:self.groupPModel.albumId   params:@{@"friendId":self.accountID,@"lastShootTime":self.detailmodel.lastShootTime,@"lastSort":self.detailmodel.lastSort,@"lastFindId":self.detailmodel.lastFindId}CallBack:^(id response)
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
                 [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
                 //  self.tableView.mj_footer.hidden =YES;
             }{
                 [self.tableView.mj_footer endRefreshing];
                 self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                 //  self.tableView.mj_footer.hidden =YES;
             }
             
             
         } failer:^(id response) {
             [weakSelf.tableView.mj_footer endRefreshing];
         }];
        
    }else {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    
}
- (NSMutableDictionary *)dicH {
    if(_dicH == nil) {
        _dicH = [[NSMutableDictionary alloc] init];
    }
    return _dicH;
}
- (void)initHeaderV{


    [self.tableView addSubview:self.headerView];
         [self.tbHeaderV addSubview:self.UploadPhotoBtn];
    [self.tbFooterV addSubview:self.UploadPhotoFooterBtn];
    self.tableView.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -190);
    [self.tableView setTableHeaderView: self.tbHeaderV];
    self.tableView.tableFooterView = self.tbFooterV;
}
- (void)initUI{
    [self addSubview:self.tableView];
    
}
- (void)setDetailmodel:(WARDetailModel *)detailmodel{
    _detailmodel = detailmodel;
    
    [self.tableView reloadData];
    
}
- (void)setGroupModel:(WARGroupModel *)model{
    self.headerView.titlelb.text = WARLocalizedString(model.name);
    self.headerView.phototypelb.text = WARLocalizedString(model.type);
    if (model.isMine) {
        self.UploadPhotoBtn.hidden = NO;
        self.tbHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 58);
    }else{
        self.UploadPhotoBtn.hidden = YES;
        self.tbHeaderV.frame = CGRectMake(0, 0, kScreenWidth, 0);
        
    }
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self.headerView sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(kScreenWidth ,190),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth ,190))];
    }else{
        [self.headerView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth , 190),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth ,190))];
    }

    self.groupPModel = model;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
        line = (detailModel.arrPictures.count/4) == 0 ? 1: ((detailModel.arrPictures.count/4)+1); /// 这要变
    }else{
        line = (detailModel.arrPictures.count/4) == 0 ? 1: (detailModel.arrPictures.count/4);
    }
    if (self.dicH[indexPath]) {
        NSNumber *num = self.dicH[indexPath];
        return [num floatValue];
    }else{
        return 80;
    }
    

}
-(void)uodataTableViewCellHight:(WARBrowserMoudleCell *)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.dicH[indexPath] isEqualToNumber: @(hight)]) {
        self.dicH[indexPath] = @(hight);
        [self.tableView reloadData];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARDetailPicturesModel *model =  self.detailmodel.arrPictures[indexPath.section];
    model.sectionIndex = indexPath.section;
    WARDetailDateDataModel*detailModel =   model.arrDateData[indexPath.row];
    detailModel.dateSection = model.sectionIndex;
    detailModel.dateRowIndex = indexPath.row;
    WARBrowserMoudleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (!cell) {
        cell = [[WARBrowserMoudleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"]; // 换cell
        
    }
    cell.accountId = self.accountID;
    cell.groupModel = self.groupPModel;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = detailModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    if ([self.delegate respondsToSelector:@selector(WARBrowserMoudleView:alpha:)]) {
        [self.delegate WARBrowserMoudleView:self alpha:alpha];
    }
}
- (UIView *)tbHeaderV{
    if (!_tbHeaderV) {
         _tbHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
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
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
- (WARPhotoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WARPhotoHeaderView alloc] initWithType:WARPhotoHeaderViewTypeCustom];
        _headerView.frame = CGRectMake(0, -190, [UIScreen mainScreen].bounds.size.width, 190);
        _headerView.tag =101;
    }
    return _headerView;
}
- (UIButton *)UploadPhotoBtn{
    if (!_UploadPhotoBtn) {
        _UploadPhotoBtn = [[UIButton alloc] init];
        _UploadPhotoBtn.backgroundColor = ThemeColor;
        [_UploadPhotoBtn setTitle:WARLocalizedString(@"上传照片/视频") forState:UIControlStateNormal];
        [_UploadPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _UploadPhotoBtn.titleLabel.font = kFont(16);
        _UploadPhotoBtn.frame = CGRectMake(101, CGRectGetMaxY(self.headerView.frame)+20, kScreenWidth-202, 32);
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
