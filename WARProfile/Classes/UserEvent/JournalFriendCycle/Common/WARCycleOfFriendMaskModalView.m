//
//  WARContactsFriendManageModalView.m
//  WARContacts
//
//  Created by Hao on 2018/4/24.
//

#import "WARCycleOfFriendMaskModalView.h"

#import "Masonry.h"
#import "WARConfigurationMacros.h"
#import "WARUIHelper.h"
#import "WARMacros.h"

#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"

#import "WARCycleOfFriendMaskCell.h"

@interface WARCycleOfFriendMaskModalView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *selectMaskId;
/** 选中的面具数组 */
@property (nonatomic, strong) NSMutableArray <WARDBCycleOfFriendMaskModel *>*selectedMaskList;
@end

@implementation WARCycleOfFriendMaskModalView

#pragma mark - System

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor  = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.tableView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.right.mas_equalTo(self);
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
            make.width.height.mas_equalTo(20);
        }];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.right.mas_equalTo(-14);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-17);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(47);
            make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(-20);
            make.left.right.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setFaceArray:(NSArray *)faceArray {
    _faceArray = faceArray;
    [self.tableView reloadData];
}

#pragma mark - Event Response

- (void)closeButtonClick {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)confirmButtonClick {
    if (self.confirmBlock && self.selectedMaskList.count > 0) {
        NSMutableArray *maskIds = [NSMutableArray array];
        for (WARDBCycleOfFriendMaskModel *mask in self.selectedMaskList) {
            [maskIds addObject:mask.maskId];
        } 
        self.confirmBlock(maskIds);
    } else {
        [self closeButtonClick];
    }
}

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARCycleOfFriendMaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WARCycleOfFriendMaskCell"];
    WARDBCycleOfFriendMaskModel *model = self.faceArray[indexPath.row];
    cell.maskModel = model;
    
    if (model.hasSelected) {
        cell.selectImageView.image = [[UIImage war_imageName:@"friendset_select" curClass:self.class curBundle:@"WARProfile.bundle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        cell.selectImageView.image = [UIImage war_imageName:@"friendset_unselect" curClass:self.class curBundle:@"WARProfile.bundle"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        WARDBCycleOfFriendMaskModel *allMask = self.faceArray.firstObject;
        BOOL allSelected = allMask.hasSelected;
        [self.faceArray enumerateObjectsUsingBlock:^(WARDBCycleOfFriendMaskModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (allSelected) {//已经选中， 取消全部选中
                model.hasSelected = NO;
                [self.selectedMaskList removeObject:model];
            } else {//未全部选中，全选中
                model.hasSelected = YES;
                [self.selectedMaskList addObject:model];
            }
        }];
    } else {
        WARDBCycleOfFriendMaskModel *model = self.faceArray[indexPath.row];
        WARDBCycleOfFriendMaskModel *allMask = self.faceArray.firstObject;
        if (model.hasSelected) {
            [self.selectedMaskList removeObject:model];
        } else {
            [self.selectedMaskList addObject:model];
        }
        model.hasSelected = !model.hasSelected;
        
        //处理全部好友选项
        __block BOOL tempAllSelected = YES;
        [self.faceArray enumerateObjectsUsingBlock:^(WARDBCycleOfFriendMaskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) {
                if (!obj.hasSelected) {
                    allMask.hasSelected = NO;
                    tempAllSelected = NO;
                    *stop = YES;
                }
            }
        }];
        allMask.hasSelected = tempAllSelected;
    }
    
    [tableView reloadData];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = WARLocalizedString(@"动态分组筛选");
        _titleLabel.textColor = TextColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage war_imageName:@"friendset_close" curClass:self.class curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.borderWidth = 0.5;
        _confirmButton.layer.borderColor = [ThemeColor CGColor];
        [_confirmButton setTitle:WARLocalizedString(@"确定") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:ButtonBackgroundColor];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[WARCycleOfFriendMaskCell class] forCellReuseIdentifier:@"WARCycleOfFriendMaskCell"];
    }
    return _tableView;
}

- (NSMutableArray <WARDBCycleOfFriendMaskModel *>*)selectedMaskList {
    if (!_selectedMaskList) {
        _selectedMaskList = [NSMutableArray<WARDBCycleOfFriendMaskModel *> array];
    }
    return _selectedMaskList;
}

@end
