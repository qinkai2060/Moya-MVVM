//
//  WARUploadListView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/7.
//

#import "WARUploadListView.h"
#import "WARGroupModel.h"
#import "WARMacros.h"
#import "WARDBUploadPhotoManger.h"
#import "WARPhotosUploadManger.h"
#import "WARPhotoUpDownListCell.h"
#import "UIImage+WARBundleImage.h"
@interface WARUploadListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)WARGroupModel *model;

@end
@implementation WARUploadListView
- (instancetype)initWithFrame:(CGRect)frame atGroupModel :(WARGroupModel*)groupModel{
    if (self = [super initWithFrame:frame]) {
        self.model = groupModel;
        [self addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBroswer:) name:@"upCount" object:nil];
    }
    return self;
}
- (void)EnterBroswer:(NSNotification*)noti {
    WARGroupModel *model = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
  
    if (model != nil){
        if ([model.albumId isEqualToString:self.model.albumId]) {
            
            self.model.uploadArray  = model.uploadArray;
            self.model.compleArray = model.compleArray;
            [self.tableView reloadData];
        }
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        
        if (self.model.uploadArray.count >10 && !self.model.isOpen) {
            return 10;
        }else {
            return self.model.uploadArray.count;
        }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return @"删除";
    }else{
        return @"";
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    if (indexPath.section == 0) {
        NSMutableArray *uploadArray = [NSMutableArray arrayWithArray:self.model.uploadArray];
        WARupPictureModel *upLoadmodel = uploadArray[indexPath.row];
        [uploadArray removeObjectAtIndex:indexPath.row];
        self.model.uploadArray = uploadArray;
        
         [WARDBUploadPhotoManger deleteUoloadTaskBytaskModelId:upLoadmodel.taskModelId];
        [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WARGroupModel *model = (WARGroupModel*)obj;
            if ([model.albumId isEqualToString:self.model.albumId]) {
                
                [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker]  replaceObjectAtIndex:idx withObject:self.model];
            }
        }];
        
        
        [self.tableView reloadData];
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *sectionHeader = [[UIView alloc] init];
//    sectionHeader.backgroundColor = [UIColor whiteColor];
//    UILabel *lable = [[UILabel alloc] init];
//    lable.frame = CGRectMake(10, 0, kScreenWidth-15, 34);
//    lable.textColor = [UIColor blackColor];
//    if (section == 0) {
//        lable.text = [NSString stringWithFormat:@"上传列表 (%ld)",self.model.uploadArray.count];
//    }else{
//        lable.text = [NSString stringWithFormat:@"上传完成 (%ld)",self.model.compleArray.count];
//    }
//
//    lable.font = kFont(14);
//    [sectionHeader addSubview:lable];
//    return  sectionHeader;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//        if (self.model.uploadArray.count == 0) {
//            return 0;
//        }else{
//            return 34;
//        }
//
//
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.model.uploadArray.count > 10) {
            UIView *sectionHeader = [[UIView alloc] init];
            sectionHeader.backgroundColor = [UIColor whiteColor];
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(10, 0, kScreenWidth, 34);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.selected = self.model.isOpen;
            [btn setTitle:WARLocalizedString(@"展开全部") forState:UIControlStateNormal];
            [btn setImage:[UIImage war_imageName:@"rankinglist_more" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
            [btn setImage:[UIImage war_imageName:@"rankinglist_up" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(unwindClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = kFont(14);
            [sectionHeader addSubview:btn];
            return sectionHeader;
        }else{
            return nil;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.model.uploadArray.count <= 10) {
            return 0;
        }else {
            return 34;
        }
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55*kScale_iphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARPhotoUpDownListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpDownListCell"];
    if (!cell) {
        cell = [[WARPhotoUpDownListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UpDownListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WARupPictureModel *model;
  
        if (self.model.uploadArray.count!=0) {
            model = self.model.uploadArray[indexPath.row];
        }
        

    cell.model = model;
    return cell;
}
- (void)unwindClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    self.model.isOpen = btn.selected;
    [self.tableView reloadData];
}
- (void)cleanData {
    NSMutableArray *uploadArray  = [NSMutableArray arrayWithArray:self.model.uploadArray];
    for (WARupPictureModel *model in uploadArray) {
        [WARDBUploadPhotoManger deleteUoloadTaskBytaskModelId:model.taskModelId];
    }
    [uploadArray removeAllObjects];
    self.model.uploadArray = uploadArray;
    [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARGroupModel *model = (WARGroupModel*)obj;
        if ([model.albumId isEqualToString:self.model.albumId]) {
            
            [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker]  replaceObjectAtIndex:idx withObject:self.model];
        }
    }];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upCount" object:nil];
}
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat navH = WAR_IS_IPHONE_X ? 84:64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
