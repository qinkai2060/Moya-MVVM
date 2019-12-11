//
//  WARPhotosMoveViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARPhotosMoveViewController.h"
#import "WARMacros.h"
#import "WARPhotoMoveCell.h"
#import "WARProfileNetWorkTool.h"
#import "WARGroupModel.h"
#import "WARProgressHUD.h"
#import "WARDBContactModel.h"
#import "WARDBContactManager.h"
#import "WARDBUserManager.h"
#import "YYModel.h"
@interface WARPhotosMoveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)WARGroupModel *model;
@property(nonatomic,strong)WARPhotoMoveCell *cell;
@property(nonatomic,copy)NSString  *modelID;
@property(nonatomic,assign)NSInteger  selectRow;
/**ACCountID*/
@property (nonatomic,copy) NSString *accountID;
@end

@implementation WARPhotosMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    WARDBContactModel *model = [WARDBContactManager contactWithUserModel:[WARDBUserManager userModel]];
    self.accountID = model.accountId;
    WS(weakself);
    [WARProfileNetWorkTool getphotoGroupArray:@"" photoID: self.accountID callback:^(id response) {
        NSMutableArray *arrayM = [NSMutableArray array];
        if (arrayM.count == 0) {
            [arrayM removeAllObjects];
        }
        NSArray *dataArr = (NSArray*)response;
        for (NSDictionary *dict in dataArr) {
            WARGroupModel *model = [WARGroupModel yy_modelWithDictionary:dict];
            if (![weakself.model.albumId isEqualToString:model.albumId]) {
                    [arrayM addObject:model];
            }
      
        }
        
        weakself.dataArray = [arrayM copy];
        [weakself.tableview reloadData];
    } failer:^(id response) {
        
    }];
      self.selectRow = -1;
}
- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self.view addSubview:self.customBar];
    self.customBar.backgroundColor = [UIColor whiteColor];
    self.customBar.lineButton.hidden = NO;
    self.customBar.rightbutton.hidden = NO;
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"完成") forState:UIControlStateNormal];
    [self.customBar.button setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitle:WARLocalizedString(@"选择相册") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.button setImage:[UIImage new] forState:UIControlStateNormal];
    [self.view addSubview:self.tableview];
}
- (void)setArray:(NSArray *)array{
    _array = array;
}
- (void)leftAtction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightAction{
    
    if (self.selectRow == -1) {
        return;
    }
    NSMutableArray *picturesID = [NSMutableArray array];

    for (WARPictureModel *model in self.array) {
        [picturesID addObject:model.pictureId];
    }
        WARGroupModel *gModel =  self.dataArray[self.selectRow];

        [WARProfileNetWorkTool putMovePhotoGroup:self.model.albumId photos:picturesID newAlbumID:gModel.albumId CallBack:^(id response) {
            
            [WARProgressHUD showAutoMessage:@"移动成功"];
        
            [self dismissViewControllerAnimated:YES completion:nil];
        } failer:^(id response) {
            [WARProgressHUD showAutoMessage:@"移动失败"];
        
        }];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARPhotoMoveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movecell"];
    if (!cell) {
        cell = [[WARPhotoMoveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movecell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WARGroupModel *model = self.dataArray[indexPath.row];
    cell.model = model;
//    WS(weakself);
//    cell.block = ^(NSString *moveID) {
//
//        weakself.modelID = moveID;
//        [weakself.tableview reloadData];
//    };
    if (self.selectRow == indexPath.row) {
        
        cell.selectImgBtn.selected = YES;
    }else{
        
        cell.selectImgBtn.selected = NO;
    }
    self.cell = cell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    [tableView reloadData];
}
- (UITableView *)tableview{
    if (!_tableview) {
        CGFloat navH = WAR_IS_IPHONE_X?84:64;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
      
    }
    return _tableview;
}
@end
