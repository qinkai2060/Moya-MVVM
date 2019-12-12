//
//  WARPhotoSettingAuthViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoSettingAuthViewController.h"
#import "WARMacros.h"
#import "WARPhotoSettingAuthCell.h"
@interface WARPhotoSettingAuthViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,assign)NSInteger selectRow;
@property(nonatomic,strong)UITableView *tbView;
@end

@implementation WARPhotoSettingAuthViewController
- (void)initData {

   
}
- (instancetype)initWith:(NSString *)authType {
    if (self = [super init]) {
        self.array = @[@"所有人",@"好友",@"仅自己可见"];
        for (int i= 0; i<self.array.count; i++) {
            if ([authType isEqualToString:self.array[i]]) {
                self.selectRow = i;
                break;
            }
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.customBar];
    self.customBar.rightbutton.hidden = NO;
    [self.customBar.titleButton setTitle:WARLocalizedString(@"权限设置") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tbView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kScale_iphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARPhotoSettingAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authCell"];
    if (cell == nil) {
        cell = [[WARPhotoSettingAuthCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"authCell"];
    }
    if (self.selectRow == indexPath.row) {
        cell.imageGouV.hidden = NO;
    }else{
        cell.imageGouV.hidden = YES;
    }
    cell.authNamelb.text = WARLocalizedString(self.array[indexPath.row]);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
    if (self.authBlock) {
        self.authBlock(self.array[indexPath.row]);
    }
    [tableView reloadData];
}

-(UITableView *)tbView {
    if (!_tbView) {
        CGFloat navH =   WAR_IS_IPHONE_X?84:64;
        _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight-navH) style:UITableViewStylePlain];
        _tbView.backgroundColor = [UIColor whiteColor];
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.dataSource = self;
        _tbView.delegate =self;
        
    }
    return _tbView;
}


@end
