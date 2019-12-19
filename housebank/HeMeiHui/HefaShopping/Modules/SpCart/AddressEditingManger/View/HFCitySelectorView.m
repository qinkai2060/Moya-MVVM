//
//  HFCitySelectorView.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCitySelectorView.h"
#import "HFAddressListViewModel.h"
#import "HFPCCSelectorView.h"
#import "HFPCCSelectorModel.h"
#import "HFConfitionIndexPath.h"
@interface HFCitySelectorView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong)UIView *cornalView;
@property (nonatomic,strong)UILabel *pleaseSelectorLb;
@property (nonatomic,strong)UIView  *indctorV;
@property (nonatomic,strong)CALayer  *linLayer;


@property (nonatomic,strong)HFAddressListViewModel *viewModel;
@property (nonatomic,strong)HFAddressListViewModel *viewModelTwo;
@property (nonatomic,strong)HFAddressListViewModel *viewModelThird;
@property (nonatomic,strong)HFAddressListViewModel *viewModelFour;

@property (nonatomic,strong)UIScrollView  *scrollView;
@property (nonatomic,strong)HFPCCSelectorView  *selectorView;
@property (nonatomic,strong)HFPCCSelectorView  *selectorViewTwo;
@property (nonatomic,strong)HFPCCSelectorView  *selectorViewThird;
@property (nonatomic,strong)HFPCCSelectorView  *selectorViewFour;

@property (nonatomic,strong)NSString  *cityId;
@property (nonatomic,strong)NSString  *regionId;
@property (nonatomic,strong)NSString  *blockId;
@property (nonatomic,strong)NSString  *townId;

@property (nonatomic,strong)UIScrollView  *btnScroll;
@property (nonatomic,strong)UIButton *provinceBtn;
@property (nonatomic,strong)UIButton *cityBtn;
@property (nonatomic,strong)UIButton *townsBtn;
@property (nonatomic,strong)UIButton *countyBtn;
@property (nonatomic,strong)NSMutableArray *datasourceArray;
@property (nonatomic,strong)HFConfitionIndexPath *selectIndePath;
@end
@implementation HFCitySelectorView

- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
//    self.viewModelTwo = viewModel;
//    self.viewModelThird = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        self.datasourceArray = [NSMutableArray array];
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.cornalView];
    [self.cornalView addSubview:self.titleLb];
    [self.cornalView addSubview:self.closeBtn];
    [self.cornalView addSubview:self.btnScroll];
    [self.btnScroll addSubview:self.pleaseSelectorLb];
    [self.btnScroll addSubview:self.indctorV];
    [self.cornalView.layer addSublayer:self.linLayer];
    [self.cornalView addSubview:self.scrollView];
    [self.scrollView addSubview:self.selectorView];
    self.btnScroll.frame = CGRectMake(0, self.titleLb.bottom, ScreenW, 45);
    if (self.viewModel.source == 0) {
        
    }else {
//        self.areaTF.text =[NSString stringWithFormat:@"%@ %@ %@ %@",model.cityName,model.regionName,model.blockName,model.townName];
//        self.detialAdrTF.text = model.detailAddress;
//        self.viewModel.model = model;
//        [self.btnScroll addSubview:self.provinceBtn];
//        [self.scrollView addSubview:self.selectorViewTwo];
//        [self.btnScroll addSubview:self.cityBtn];
//        [self.scrollView addSubview:self.selectorViewThird];
//        [self.btnScroll addSubview:self.townsBtn];
//        [self.scrollView addSubview:self.selectorViewFour];
//        [self.btnScroll addSubview:self.countyBtn];
//        CGSize size =  [HFUntilTool boundWithStr:self.viewModel.model.cityName font:16 maxSize:CGSizeMake(70, 45)];
//        [self.provinceBtn setTitle:self.viewModel.model.cityName forState:UIControlStateNormal];
//        self.provinceBtn.frame = CGRectMake(0, 0, size.width+30, 45);
//        
//        CGSize size2 =  [HFUntilTool boundWithStr:self.viewModel.model.regionName font:16 maxSize:CGSizeMake(70, 45)];
//        [self.cityBtn setTitle:self.viewModel.model.regionName forState:UIControlStateNormal];
//        self.cityBtn.frame = CGRectMake(self.provinceBtn.right, 0, size2.width+30, 45);
//        
//        CGSize size3 =  [HFUntilTool boundWithStr:self.viewModel.model.blockName font:16 maxSize:CGSizeMake(70, 45)];
//        [self.townsBtn setTitle:self.viewModel.model.blockName forState:UIControlStateNormal];
//        self.townsBtn.frame = CGRectMake(self.cityBtn.right, 0, size3.width+30, 45);
//        
//        CGSize size4 =  [HFUntilTool boundWithStr:self.viewModel.model.townName font:16 maxSize:CGSizeMake(70, 45)];
//        self.countyBtn.frame = CGRectMake(self.townsBtn.right, 0, size4.width+30, 45);
//        [self.countyBtn setTitle:self.viewModel.model.townName forState:UIControlStateNormal];
//        
//        self.pleaseSelectorLb.frame = CGRectMake(self.countyBtn.right,0, 70, 45);
//        self.indctorV.centerX = self.countyBtn.centerX;
//        self.pleaseSelectorLb.hidden = YES;
//        [self domessageSomthing];
    }
    
}

- (void)domessageSomthing {
    self.viewModelTwo.regionId = [self.viewModel.model.cityId integerValue];
    self.viewModelTwo.level =   2;
    [self.viewModelTwo.regionCommand execute:nil];

    self.viewModelThird.regionId = [self.viewModel.model.blockId integerValue];
    self.viewModelThird.level = 4;
    [self.viewModelThird.regionCommand execute:nil];
    
    self.viewModelFour.regionId = [self.viewModel.model.townId integerValue];
    self.viewModelFour.level = 5;
    [self.viewModelFour.regionCommand execute:nil];
    
    self.scrollView.contentSize = CGSizeMake(4*ScreenW, 0);
    [self.scrollView setContentOffset:CGPointMake(3*ScreenW, 0) animated:YES];
}
- (void)hh_bindViewModel {
    
    /**
     //    self.viewModel.model.cityId = @"13400";
     //    self.viewModel.model.regionId = @"25194";
     //    self.viewModel.model.blockId = @"25594";
     //    self.viewModel.model.townId = @"25609";
     //    self.viewModel.model.ids = @"426698";
     */
    @weakify(self);
    [self.viewModel.didSelectregionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.selectorViewThird removeFromSuperview];
        [self.selectorViewFour removeFromSuperview];
        HFPCCSelectorModel *model = (HFPCCSelectorModel*)x;
        [self.btnScroll addSubview:self.provinceBtn];
        [self.scrollView addSubview:self.selectorViewTwo];
        CGSize size =  [HFUntilTool boundWithStr:model.name font:13 maxSize:CGSizeMake(70, 45)];
        [self.provinceBtn setTitle:model.name forState:UIControlStateNormal];
        self.provinceBtn.frame = CGRectMake(0, 0, size.width+30, 45);
        self.pleaseSelectorLb.frame = CGRectMake(self.provinceBtn.right,0, 70, 45);
        self.indctorV.centerX = self.pleaseSelectorLb.centerX;
        self.selectIndePath =  [HFConfitionIndexPath pathWithFirstPath:model.indexPath.row secondPath:-1 thirdPath:-1 fourPath:-1];
        self.viewModelTwo.regionId = model.ids;
        self.viewModelTwo.level = model.level+1;
        [self.viewModelTwo.regionCommand execute:nil];
        
        if (self.cityBtn.currentTitle.length != 0 ) {
            self.pleaseSelectorLb.hidden = NO;
            [self.cityBtn setTitle:@"" forState:UIControlStateNormal];
        }
        if (self.townsBtn.currentTitle.length != 0 ) {
            self.pleaseSelectorLb.hidden = NO;
            [self.townsBtn setTitle:@"" forState:UIControlStateNormal];
        }
        if (self.countyBtn.currentTitle.length != 0 ) {
            self.pleaseSelectorLb.hidden = NO;
            [self.countyBtn setTitle:@"" forState:UIControlStateNormal];
        }
        self.cityId = [NSString stringWithFormat:@"%ld",model.ids];
    }];
    [self.viewModel.regionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        
    }];
    [self.viewModelTwo.didSelectregionsubject subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        [self.selectorViewFour removeFromSuperview];
        [self.scrollView addSubview:self.selectorViewThird];
        HFPCCSelectorModel *model = (HFPCCSelectorModel*)x;
        [self.btnScroll addSubview:self.cityBtn];
        CGSize size =  [HFUntilTool boundWithStr:model.name font:13 maxSize:CGSizeMake(70, 45)];
        [self.cityBtn setTitle:model.name forState:UIControlStateNormal];
        self.cityBtn.frame = CGRectMake(self.provinceBtn.right, 0, size.width+30, 45);
        self.pleaseSelectorLb.frame = CGRectMake(self.cityBtn.right,0, 70, 45);
        self.indctorV.centerX = self.pleaseSelectorLb.centerX;
        self.viewModelThird.regionId = model.ids;
        self.viewModelThird.level = model.level+1;
        [self.viewModelThird.regionCommand execute:nil];
        self.selectIndePath =  [HFConfitionIndexPath pathWithFirstPath:self.selectIndePath.firstPath secondPath:model.indexPath.row thirdPath:-1 fourPath:-1];
        if (self.countyBtn.currentTitle.length != 0 ) {
            self.pleaseSelectorLb.hidden = NO;
            [self.countyBtn setTitle:@"" forState:UIControlStateNormal];
        }
        if (self.townsBtn.currentTitle.length != 0 ) {
            self.pleaseSelectorLb.hidden = NO;
            [self.townsBtn setTitle:@"" forState:UIControlStateNormal];
        }
        self.regionId = [NSString stringWithFormat:@"%ld",model.ids];
  
    }];
    [self.viewModelTwo.regionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.scrollView.contentSize = CGSizeMake(2*ScreenW, 0);
        [self.scrollView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
        
    }];
    [self.viewModelThird.didSelectregionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
    
        HFPCCSelectorModel *model = (HFPCCSelectorModel*)x;
        self.blockId  = [NSString stringWithFormat:@"%ld",model.ids];
        [self.btnScroll addSubview:self.townsBtn];
        CGSize size =  [HFUntilTool boundWithStr:model.name font:13 maxSize:CGSizeMake(70, 45)];
        [self.townsBtn setTitle:model.name forState:UIControlStateNormal];
        self.townsBtn.frame = CGRectMake(self.cityBtn.right, 0, size.width+30, 45);
        self.selectIndePath =  [HFConfitionIndexPath pathWithFirstPath:self.selectIndePath.firstPath secondPath:self.selectIndePath.secondPath thirdPath:model.indexPath.row fourPath:-1];
        if ([model.name hasSuffix:@"镇"]||[HFAddressListViewModel isContain:[NSString stringWithFormat:@"%ld",model.ids]] || model.cityCode.length == 0) {
            self.viewModel.model.partAddress = [NSString stringWithFormat:@"%@ %@ %@",self.provinceBtn.currentTitle,self.cityBtn.currentTitle,self.townsBtn.currentTitle];
            self.viewModel.model.cityId = self.cityId;
            self.viewModel.model.regionId = self.regionId;
            self.viewModel.model.blockId = @"";
            self.viewModel.model.townId = self.blockId;
            self.viewModel.model.cityName = self.provinceBtn.currentTitle;
            self.viewModel.model.regionName = self.cityBtn.currentTitle;
            self.viewModel.model.blockName = self.townsBtn.currentTitle;
            self.viewModel.model.townName = @"";
            [self.viewModel.editingSetSubjc sendNext:self.viewModel.model];
            self.pleaseSelectorLb.hidden = YES;
            [self dissMissClick];
        }else{
            [self.scrollView addSubview:self.selectorViewFour];
            self.pleaseSelectorLb.frame = CGRectMake(self.townsBtn.right,0, 70, 45);
            self.indctorV.centerX = self.pleaseSelectorLb.centerX;
            self.viewModelFour.regionId = model.ids;
            self.viewModelFour.level = model.level+1;
            [self.viewModelFour.regionCommand execute:nil];
            if (self.countyBtn.currentTitle.length != 0 ) {
                self.pleaseSelectorLb.hidden = NO;
                [self.countyBtn setTitle:@"" forState:UIControlStateNormal];
            }
        }
        
    }];
    [self.viewModelThird.regionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.scrollView.contentSize = CGSizeMake(3*ScreenW, 0);
        [self.scrollView setContentOffset:CGPointMake(2*ScreenW, 0) animated:YES];
        
    }];

    [self.viewModelFour.didSelectregionsubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
        HFPCCSelectorModel *model = (HFPCCSelectorModel*)x;
        [self.btnScroll addSubview:self.countyBtn];
        CGSize size =  [HFUntilTool boundWithStr:model.name font:13 maxSize:CGSizeMake(70, 45)];
        self.countyBtn.frame = CGRectMake(self.townsBtn.right, 0, size.width+30, 45);
        [self.countyBtn setTitle:model.name forState:UIControlStateNormal];
        self.indctorV.centerX = self.countyBtn.centerX;
        self.selectIndePath =  [HFConfitionIndexPath pathWithFirstPath:self.selectIndePath.firstPath secondPath:self.selectIndePath.secondPath thirdPath:self.selectIndePath.thirdPath fourPath:model.indexPath.row];
        self.pleaseSelectorLb.hidden = YES;
        self.townId  = [NSString stringWithFormat:@"%ld",model.ids];
        self.viewModel.model.partAddress = [NSString stringWithFormat:@"%@ %@ %@ %@",self.provinceBtn.currentTitle,self.cityBtn.currentTitle,self.townsBtn.currentTitle,self.countyBtn.currentTitle];
        self.viewModel.model.cityId = self.cityId;
        self.viewModel.model.regionId = self.regionId;
        self.viewModel.model.blockId = self.blockId;
        self.viewModel.model.townId = self.townId;
        self.viewModel.model.cityName = self.provinceBtn.currentTitle;
        self.viewModel.model.regionName = self.cityBtn.currentTitle;
        self.viewModel.model.blockName = self.townsBtn.currentTitle;
        self.viewModel.model.townName = self.countyBtn.currentTitle;
        [self.viewModel.editingSetSubjc sendNext:self.viewModel.model];
        [self dissMissClick];
    }];
    [self.viewModelFour.regionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.scrollView.contentSize = CGSizeMake(4*ScreenW, 0);
        [self.scrollView setContentOffset:CGPointMake(3*ScreenW, 0) animated:YES];

        
    }];
}
- (void)dissMissClick {

    self.frame =  [UIApplication sharedApplication].keyWindow.bounds;
    self.cornalView.frame = CGRectMake(0, 115, ScreenW, ScreenH-115);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.hidden = NO;
    self.alpha = 1;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.cornalView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-115);
    }];
}
- (void)showCitySelector {
    self.frame =  [UIApplication sharedApplication].keyWindow.bounds;
    self.cornalView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-115);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.hidden = NO;
    self.alpha = 0;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
       
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.cornalView.frame = CGRectMake(0, 115, ScreenW, ScreenH-115);
    }];
}
- (void)scrollClick:(UIButton*)btn {
    self.indctorV.centerX = btn.centerX;
    [self.scrollView setContentOffset:CGPointMake(ScreenW*(btn.tag-100), 0) animated:YES ];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
      NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    for (UIView *sub in self.btnScroll.subviews) {
        if (sub.tag == 100+index) {
            self.indctorV.centerX = sub.centerX;
        }
    }
    NSLog(@"%ld",index);
}
- (UIView *)cornalView {
    if (!_cornalView) {
        _cornalView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH-115)];
        _cornalView.backgroundColor = [UIColor whiteColor];
    }
    return _cornalView;

}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-50, 0, 50, 50)];
        [_closeBtn setImage:[UIImage imageNamed:@"car_closeicon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dissMissClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _titleLb.text = @"配送至";
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)pleaseSelectorLb {
    if (!_pleaseSelectorLb) {
        _pleaseSelectorLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        _pleaseSelectorLb.text = @"请选择";
        _pleaseSelectorLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _pleaseSelectorLb.font = [UIFont systemFontOfSize:13];
        _pleaseSelectorLb.textAlignment = NSTextAlignmentCenter;
        
    }
    return _pleaseSelectorLb;
}
- (UIView *)indctorV {
    if (!_indctorV) {
        _indctorV = [[UIView alloc] initWithFrame:CGRectMake(0, self.pleaseSelectorLb.bottom, 40, 1)];
        _indctorV.centerX = self.pleaseSelectorLb.centerX;
        _indctorV.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        
    }
    return _indctorV;
}
- (CALayer *)linLayer{
    if (!_linLayer) {
        _linLayer = [CALayer layer];
        _linLayer.frame = CGRectMake(0, self.btnScroll.bottom, ScreenW, 1);
        _linLayer.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    }
    return _linLayer;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.linLayer.frame), ScreenW, self.cornalView.height-CGRectGetMaxY(self.linLayer.frame))];
      //  _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}
- (HFPCCSelectorView *)selectorView {
    if (!_selectorView) {
        _selectorView = [[HFPCCSelectorView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.scrollView.height) WithViewModel:self.viewModel];
    }
    return _selectorView;
}
- (HFPCCSelectorView *)selectorViewTwo {
    if (!_selectorViewTwo) {
        _selectorViewTwo = [[HFPCCSelectorView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, self.scrollView.height) WithViewModel:self.viewModelTwo];
        _selectorViewTwo.backgroundColor = [UIColor redColor];
    }
    return _selectorViewTwo;
}
- (HFPCCSelectorView *)selectorViewThird {
    if (!_selectorViewThird) {
        _selectorViewThird = [[HFPCCSelectorView alloc] initWithFrame:CGRectMake(ScreenW*2, 0, ScreenW, self.scrollView.height) WithViewModel:self.viewModelThird];
        _selectorViewThird.backgroundColor = [UIColor redColor];
    }
    return _selectorViewThird;
}
- (HFPCCSelectorView *)selectorViewFour {
    if (!_selectorViewFour) {
        _selectorViewFour = [[HFPCCSelectorView alloc] initWithFrame:CGRectMake(ScreenW*3, 0, ScreenW, self.scrollView.height) WithViewModel:self.viewModelFour];
        _selectorViewFour.backgroundColor = [UIColor redColor];
    }
    return _selectorViewFour;
}
- (UIButton *)provinceBtn {
    if (!_provinceBtn) {
        _provinceBtn = [[UIButton alloc] init];
        _provinceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _provinceBtn.tag = 100;
        [_provinceBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _provinceBtn;
}
- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [[UIButton alloc] init];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _cityBtn.tag = 101;
        [_cityBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cityBtn;
}
- (UIButton *)townsBtn {
    if (!_townsBtn) {
        _townsBtn = [[UIButton alloc] init];
        _townsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_townsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          _townsBtn.tag = 102;
        [_townsBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _townsBtn;
}
- (UIButton *)countyBtn {
    if (!_countyBtn) {
        _countyBtn = [[UIButton alloc] init];
        _countyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_countyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          _countyBtn.tag = 103;
        [_countyBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countyBtn;
}
- (UIScrollView *)btnScroll {
    if (!_btnScroll) {
        _btnScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleLb.bottom, ScreenW, 45)];
    }
    return _btnScroll;
}
- (HFAddressListViewModel *)viewModelTwo {
    if (!_viewModelTwo) {
        _viewModelTwo = [[HFAddressListViewModel alloc] init];
    }
    return _viewModelTwo;
}
- (HFAddressListViewModel *)viewModelThird {
    if (!_viewModelThird) {
        _viewModelThird = [[HFAddressListViewModel alloc] init];
    }
    return _viewModelThird;
}
- (HFAddressListViewModel *)viewModelFour {
    if (!_viewModelFour) {
        _viewModelFour = [[HFAddressListViewModel alloc] init];
    }
    return _viewModelFour;
}
@end
