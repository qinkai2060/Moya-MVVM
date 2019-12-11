//
//  WARProfileDataCenterViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import "WARProfileDataCenterViewController.h"
#import "WARMacros.h"
#import "WARProfilePersonalCell.h"
#import "WARProfileTagCell.h"
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#define nameKey @"name"
#define infoKey @"info"//map_attention_no
@interface WARProfileDataCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** datasource */
@property (nonatomic, strong) NSArray *dataSource;
/** datasource */
@property (nonatomic, strong) UIImageView *defaultView;
/** datasource */
@property (nonatomic, strong) UILabel *tiplb;
@end

@implementation WARProfileDataCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"个人资料");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tiplb];
    [self.view addSubview:self.defaultView];
    [self.tiplb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-100);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@17);
    }];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tiplb.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(@100);
    }];
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataSource[section];
    
    return sectionArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArr = self.dataSource[indexPath.section];
    WARProfileUserMasksModel *model = sectionArr[indexPath.row];
    return model.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    view.backgroundColor = BackgroundDefaultColor;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 33)];
    lab.textColor = DisabledTextColor;
    lab.font = kFont(14);
    NSArray *sectionArr = self.dataSource[section];
    view.hidden = !sectionArr.count;
    [view addSubview:lab];
    if (section == 0) {
        lab.text = WARLocalizedString(@"个人信息");
    }else {
        lab.text = WARLocalizedString(@"兴趣标签");
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataSource[section];
    return  sectionArr.count == 0 ? 0:33;
  
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    view.backgroundColor = UIColorWhite;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        NSArray *sectionArr = self.dataSource[section];
        return  sectionArr.count == 0 ? 0:25;
    }else {
        return 0;
    }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArr = self.dataSource[indexPath.section];
    WARProfileUserMasksModel *model = sectionArr[indexPath.row];
    if (indexPath.section == 0) {
        WARProfilePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        WARProfileTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
}
- (void)setMaskModel:(WARProfileMasksModel *)maskModel {
    _maskModel = maskModel;
 
    NSMutableArray *dataSource = [NSMutableArray array];
    if ([self personalData:maskModel].count == 0 &&[self tagsData:maskModel].count == 0) {
        
    }else{
        [dataSource addObject:[self personalData:maskModel]];
        [dataSource addObject:[self tagsData:maskModel]];
    }

    self.dataSource = dataSource.copy;
   
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.tableView.hidden = !dataSource.count;
    [self.tableView reloadData];
}
- (NSArray*)tagsData:(WARProfileMasksModel*)maskModel {
    NSMutableArray *tagarrayM = [NSMutableArray array];
    if (maskModel.delicacies.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"美食") tags:maskModel.delicacies]];
    }
    if (maskModel.sports.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"运动") tags:maskModel.sports]];
    }
    if (maskModel.tourisms.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"旅游") tags:maskModel.tourisms]];
    }
    if (maskModel.books.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"书籍") tags:maskModel.books]];
    }
    if (maskModel.films.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"电影") tags:maskModel.films]];
    }
    if (maskModel.musics.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"音乐") tags:maskModel.musics]];
    }
    if (maskModel.games.count != 0) {
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"游戏") tags:maskModel.games]];
    }
    if (maskModel.others.count != 0) {
        
        [tagarrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"其他") tags:maskModel.others]];
    }

    return tagarrayM;
}
- (NSArray*)personalData:(WARProfileMasksModel*)maskModel {
    NSMutableArray *arrayM = [NSMutableArray array];
    if (!kStringIsEmpty(maskModel.city) ||!kStringIsEmpty(maskModel.province)) {
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"家乡") content:[NSString stringWithFormat:@"%@%@",(maskModel.province.length == 0 ?@"":maskModel.province),(maskModel.city.length == 0 ?@"":maskModel.city)]]];
    }
    if (!kStringIsEmpty(maskModel.industry)) {
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"行业") content: [NSString stringWithFormat:@"%@",(maskModel.industry.length == 0 ?@"":maskModel.industry)]]];
    }
    if (!kStringIsEmpty(maskModel.job)) {
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"职业") content:[NSString stringWithFormat:@"%@",(maskModel.job.length == 0 ?@"":maskModel.job)]]];
    }
    if (!kStringIsEmpty(maskModel.affectiiveState)) {
        
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"情感状态") content:[NSString stringWithFormat:@"%@",[WARProfileMasksModel affectiveState:maskModel.affectiiveState]]]];
    }
    if (!kStringIsEmpty(maskModel.school)) {
        
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"学校") content:[NSString stringWithFormat:@"%@",maskModel.school]]];
    }
    if (!kStringIsEmpty(maskModel.signature)) {
        
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"个性签名") content:[NSString stringWithFormat:@"%@",maskModel.signature]]];
    }
    if (!kStringIsEmpty(maskModel.company)) {
        [arrayM addObject:[WARProfileUserMasksModel name:WARLocalizedString(@"公司") content:[NSString stringWithFormat:@"%@",maskModel.company]]];
    }
    
    return arrayM.copy;
}
- (UITableView *)tableView {
    if (!_tableView) {
     
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WARProfilePersonalCell class] forCellReuseIdentifier:@"PersonalCell"];
        [_tableView registerClass:[WARProfileTagCell class] forCellReuseIdentifier:@"TagCell"];
        
    }
    return _tableView;
}
- (UIImageView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"map_attention_no" curClass:[self class] curBundle:@"WARMainMap.bundle"]];
    }
    return _defaultView;
}
- (UILabel *)tiplb {
    if (!_tiplb) {
        _tiplb = [[UILabel alloc] init];
        _tiplb.font = kFont(16);
        _tiplb.textColor = DisabledTextColor;
        _tiplb.text = WARLocalizedString(@"未填写个人信息~");
        _tiplb.textAlignment = NSTextAlignmentCenter;
    }
    return _tiplb;
}
@end
