//
//  WARUserPrivateStateView.m
//  WARProfile
//
//  Created by Hao on 2018/6/19.
//

#import "WARUserPrivateStateView.h"
#import "Masonry.h"
#import "WARMacros.h"

@interface WARUserPrivateStateView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy)NSString *stateString;
@property (nonatomic, copy)NSString *showStateString;

@property (nonatomic, strong) UILabel *pickerTitleLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, copy)NSArray *dataArr;
@property (nonatomic, copy)NSArray *showStrArr;

@end

@implementation WARUserPrivateStateView

- (id)initWithFrame:(CGRect)frame state:(NSString *)state {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        self.dataArr = @[@"SECRECY",@"SINGLE",@"IN_LOVE",@"MARRIED"];
        self.showStrArr = @[WARLocalizedString(@"保密"),WARLocalizedString(@"单身"),WARLocalizedString(@"恋爱中"),WARLocalizedString(@"已婚")];

        [self initUI];
        
        if (state.length) {
            self.stateString = state;
            NSInteger index = [self.dataArr indexOfObject:state];
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        }else {
            self.stateString = self.dataArr[0];
        }
    }
    return self;
}

- (void)initUI{
    
    [self addSubview:self.pickerView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.pickerTitleLab];
    [self addSubview:self.sureBtn];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(180);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(15);
    }];
    
    [self.pickerTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.left.equalTo(self.pickerTitleLab.mas_right);
        make.right.mas_equalTo(-15);
    }];
    
    [self.cancelBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.sureBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.showStrArr.count;
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return self.showStrArr[row];
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40)];
    myView.font = [UIFont systemFontOfSize:18];
    myView.backgroundColor = [UIColor clearColor];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = self.showStrArr[row];
    return myView;
}

- (CGSize)rowSizeForComponent:(NSInteger)component{
    return CGSizeMake(self.frame.size.width, 41);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.showStateString = self.showStrArr[row];
    self.stateString = self.dataArr[row];
}

- (void)cancelAction:(UIButton *)button{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)sureAction:(UIButton *)button{
    if (self.confirmBlock) {
        self.confirmBlock(self.stateString);
    }
}

#pragma mark - Setter And Getter
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
        _pickerTitleLab.font = kFont(17);
        _pickerTitleLab.textColor = TextColor;
        _pickerTitleLab.text = WARLocalizedString(@"情感状态");
        _pickerTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _pickerTitleLab;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:WARLocalizedString(@"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:DisabledTextColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont(16);
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:WARLocalizedString(@"确定") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kFont(16);
        [_sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
