//
//  WARSeeSBViewController.m
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import "WARSeeSBViewController.h"
#import "WARIgnoreUserListCell.h"
#import "UIImageView+WebCache.h"

#import "UIImage+WARBundleImage.h"
#import "UIImage+WARGeneralImage.h"
#import "WARAlertView.h"
#import "WARUIHelper.h"

#define WARIgnoreUserListCellId @"WARIgnoreUserListCellId"

#define rowCellHeight 70.0

@interface WARSeeSBViewController () <WARIgnoreUserListCellDelegate>

@property (nonatomic, assign) BOOL isDeleteing;
@property (nonatomic, strong) NSMutableArray *deleteUserIds;

@end

@implementation WARSeeSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    [super initData];
    
    self.settinsItemArray = [NSMutableArray new];
    self.deleteUserIds = [NSMutableArray new];
    self.isDeleteing = NO;
    
    [self getCannotSeeData];
}

- (void)initUI {
    [super initUI];
    self.tableView.rowHeight = rowCellHeight;
    [self.tableView registerClass:[WARIgnoreUserListCell class] forCellReuseIdentifier:WARIgnoreUserListCellId];
    [self createRightBarItem];
}

- (void)createRightBarItem {
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    [rightButton setTitle:WARLocalizedString(@"移除") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void)rightBarButtonAction:(id)sender {
    UIButton *rightButton = (UIButton *)sender;
    
    self.isDeleteing = !self.isDeleteing;
    
    NSArray *vissibleCell = [self.tableView visibleCells];
    for (WARIgnoreUserListCell *cell in vissibleCell) {
        [cell setEditingWidthAnimation:self.isDeleteing animation:YES];
    }
    
    if (self.isDeleteing) {
        [rightButton setTitle:WARLocalizedString(@"完成") forState:UIControlStateNormal];
    }else {
        [rightButton setTitle:WARLocalizedString(@"移除") forState:UIControlStateNormal];
        [self deleteUserfromServer];
    }
}

- (void)backAction {
    @weakify(self);
    if (self.isDeleteing) {
        [WARAlertView showWithTitle:nil
                            Message:WARLocalizedString(@"是否放弃编辑？")
                        cancelTitle:WARLocalizedString(@"取消")
                        actionTitle:WARLocalizedString(@"确定")
                      cancelHandler:^(LGAlertView * _Nonnull alertView) {
                         
                      } actionHandler:^(LGAlertView * _Nonnull alertView) {
                          @strongify(self);
                          [self.navigationController popViewControllerAnimated:YES];
                      }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableView delegtate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settinsItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARIgnoreUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:WARIgnoreUserListCellId];
    cell.ignoreListCellDelegate = self;
    
    if (indexPath.row < self.settinsItemArray.count) {
        WARSeeSBListItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = item.name;
        cell.descriptionLabel.text = item.signature;
        
        UIImage *image = [UIImage war_defaultUserIcon];
        NSURL *iconImageURL = kPhotoUrl(item.headerID);
        [cell.iconImageView sd_setImageWithURL:iconImageURL placeholderImage:image];
        
        NSInteger year = item.year;
        NSInteger month = item.month;
        NSInteger day = item.day;
        
        NSString *yearString = [[NSNumber numberWithInteger:year] stringValue];
        NSString *monthString = [[NSNumber numberWithInteger:month] stringValue];
        NSString *dayString = [[NSNumber numberWithInteger:day] stringValue];

        
        UIImage *starImage = ConstellationImage (month,day);
        if (starImage) {
             cell.solarImageView.hidden = NO;
            cell.solarImageView.image = image;
        }else {
            cell.solarImageView.hidden = YES;
        }
        
        cell.solarImageView.backgroundColor = ConstellationBgColor(item.gender);
        cell.ageLabel.backgroundColor = AgeBgColor(item.gender);
        
        cell.ageLabel.text = [WARUIHelper war_birthdayToAge:yearString month:monthString day:dayString];
        
        cell.isEditing = self.isDeleteing;
    }
    
    return cell;
}


#pragma mark - cell delegate
- (void)rightDeleteButtonAction:(NSIndexPath *)indexPath {
    if (indexPath.row < self.settinsItemArray.count) {
        WARSeeSBListItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
        
        if (item.accountId) {// delete from server
            [self.dataManager removeUserBySeeSBType:self.viewType userListArray:@[item.accountId] Success:nil failed:nil];
        }
        [self.settinsItemArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)leftDeleteButtonAction:(NSIndexPath *)indexPath {
    if (indexPath.row < self.settinsItemArray.count) {
        WARSeeSBListItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
        if (item.accountId) {
            [self.deleteUserIds addObject:item.accountId];
        }
        
        [self.settinsItemArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)deleteUserfromServer {
    if (self.deleteUserIds.count > 0) {
        [self.dataManager removeUserBySeeSBType:self.viewType userListArray:self.deleteUserIds Success:nil failed:nil];
    }
}


#pragma mark - get data

- (void)getCannotSeeData {
    [MBProgressHUD showLoad];
    
    @weakify(self);
    [self.dataManager cannotSeenSBByType:self.viewType Success:^(id successData) {
        @strongify(self);
        if (successData) {
            [self createData:successData];
        }
        [MBProgressHUD hideHUD];
    } failed:^(id failedData) {
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)createData:(NSArray*)listArray {
    [self.settinsItemArray addObjectsFromArray:listArray];
    
    [self.tableView reloadData];
}

@end
