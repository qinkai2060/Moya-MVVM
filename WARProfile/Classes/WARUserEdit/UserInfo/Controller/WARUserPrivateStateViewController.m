//
//  WARUserPrivateStateViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import "WARUserPrivateStateViewController.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"

#import "WARSettingsCell.h"

#define kPrivateStateCellID @"kPrivateStateCellID"
@interface WARUserPrivateStateViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSString *stateString;
@property (nonatomic, copy)NSString *showStateString;

@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *pickerTitleLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, copy)NSArray *dataArr;
@property (nonatomic, copy)NSArray *showStrArr;

@end

@implementation WARUserPrivateStateViewController

- (instancetype)initWithStateStr:(NSString *)stateStr showStateStr:(NSString *)showStateStr{
    if (self = [super init]) {
        if (stateStr.length) {
            self.stateString = stateStr;
            self.showStateString = showStateStr;
        }
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = WARLocalizedString(@"情感状态");
    self.view.backgroundColor = kColor(whiteColor);
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.dataArr = @[@"SECRECY",@"SINGLE",@"IN_LOVE",@"MARRIED"];
    self.showStrArr = @[WARLocalizedString(@"保密"),WARLocalizedString(@"单身"),WARLocalizedString(@"恋爱中"),WARLocalizedString(@"已婚")];
    [self initUI];
    
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


#pragma mark UITableView data Source & UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrivateStateCellID];
    if (!cell) {
        cell = [[WARSettingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPrivateStateCellID];
    }
    cell.selectionStyle = NO;
    cell.showAccessoryView = YES;
    cell.descriptionText = WARLocalizedString(@"情感状态");
    cell.rightText = self.stateString.length ? self.showStateString:WARLocalizedString(@"请填写情感状态");
    cell.rightTextColor = self.stateString.length ? COLOR_WORD_GRAY_6 : COLOR_WORD_GRAY_9;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showPickerView];
}

- (void)showPickerView{
    
    [self.view addSubview:self.pickerBgView];
    [self.pickerBgView addSubview:self.containerView];
    [self.containerView addSubview:self.pickerView];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.pickerTitleLab];
    [self.containerView addSubview:self.sureBtn];
    
    [self.pickerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.pickerBgView);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(150);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.mas_top).offset(-20);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(13);
    }];
    
    [self.pickerTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.left.equalTo(self.pickerTitleLab.mas_right);
        make.right.mas_equalTo(-13);
    }];
    
    [self.cancelBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.sureBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)removeStatePicker{
    [self.cancelBtn removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.pickerTitleLab removeFromSuperview];
    
    [self.containerView removeFromSuperview];
    [self.pickerBgView removeFromSuperview];
}

#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.showStrArr.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.showStrArr[row];
}

- (CGSize)rowSizeForComponent:(NSInteger)component{
    return CGSizeMake(kScreenWidth, 20);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.showStateString = self.showStrArr[row];
    self.stateString = self.dataArr[row];
}


- (void)tapBgView{
    [self removeStatePicker];
}

- (void)cancelAction:(UIButton *)button{
    [self removeStatePicker];
}

- (void)sureAction:(UIButton *)button{
    if (self.stateString.length) {
        [self.tableView reloadData];
        if (self.didSelectStateBlock) {
            self.didSelectStateBlock(self.stateString);
        }
    }
    [self removeStatePicker];
}

#pragma mark - getther methods

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = COLOR_WORD_GRAY_E;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    }
    return _tableView;
}

- (UIView *)pickerBgView{
    if (!_pickerBgView) {
        _pickerBgView = [[UIView alloc]init];
        _pickerBgView.backgroundColor = RGBA(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
        [_pickerBgView addGestureRecognizer:tap];
    }
    return _pickerBgView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = kColor(whiteColor);
    }
    return _containerView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UILabel *)pickerTitleLab{
    if (!_pickerTitleLab) {
        _pickerTitleLab = [[UILabel alloc]init];
        _pickerTitleLab.font = kFont(16);
        _pickerTitleLab.textColor = HEXCOLOR(0x333333);
        _pickerTitleLab.text = WARLocalizedString(@"情感状态");
        _pickerTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _pickerTitleLab;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_WORD_GRAY_9 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont(14);
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:WARLocalizedString(@"确定") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x00D8B7) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kFont(14);
        [_sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
