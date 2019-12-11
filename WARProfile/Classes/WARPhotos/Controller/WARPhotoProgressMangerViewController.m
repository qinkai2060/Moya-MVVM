//
//  WARPhotoProgressMangerViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import "WARPhotoProgressMangerViewController.h"
#import "WARGroupModel.h"
#import "WARMacros.h"

@interface WARPhotoProgressMangerViewController () <UITableViewDelegate,UITableViewDataSource>
/**model*/
@property (nonatomic,strong) WARGroupModel *model;

/**tableview*/
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WARPhotoProgressMangerViewController
- (instancetype)initWithModel:(WARGroupModel *)model{
    if (self = [super initWithModel:model]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self.view addSubview:self.tableView];
}
- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customBar];
    self.customBar.backgroundColor = [UIColor clearColor];
    self.customBar.lineButton.hidden = YES;
    self.customBar.rightbutton.hidden = NO;
    self.customBar.progressBtn.hidden = YES;
    [self.customBar.titleButton setTitle:WARLocalizedString(@"上传列表") forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"全部取消") forState:UIControlStateNormal];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 这个值是以单例的值为准
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat navH = WAR_IS_IPHONE_X ? 64:84;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-navH) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    }
    return _tableView;
}

@end
