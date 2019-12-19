//
//  HFNavBarTitleView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNavBarTitleView.h"
#import "HFGlobalFamilyViewModel.h"
@interface HFNavBarTitleView()
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@end
@implementation HFNavBarTitleView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.cityBtn];
    [self.layer addSublayer:self.lineLayer1];
    [self addSubview:self.datelb];
    [self addSubview:self.dateBtn];
    [self.layer addSublayer:self.lineLayer2];
    [self addSubview:self.imageView];
    [self addSubview:self.keyLb];
    [self addSubview:self.searchBtn];
    [self addSubview:self.clearBtn];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.getKeyWordSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSString class]]) {
            NSString *str = (NSString*)x;
            if (str.length > 0) {
                self.clearBtn.hidden = NO;
                self.imageView.hidden = YES;
                self.keyLb.text = x;
                self.keyLb.textColor = [UIColor colorWithHexString:@"333333"];
                self.keyLb.frame = CGRectMake(CGRectGetMaxX(self.lineLayer2.frame)+10, 0, self.width-CGRectGetMaxX(self.lineLayer2.frame)-10, 30);
            }
            
        }
      
    }];
    [self.cityBtn setTitle:@"上海" forState:UIControlStateNormal];
    self.datelb.text = @"住10-25\n离10-26";
    self.cityBtn.frame = CGRectMake(0, 0, 60, 30);
    self.lineLayer1.frame = CGRectMake(self.cityBtn.right, (30-13)*0.5, 1, 13);
    self.datelb.frame = CGRectMake(CGRectGetMaxX(self.lineLayer1.frame)+10, 0, 40, 30);
    self.dateBtn.frame = self.datelb.frame;
    self.lineLayer2.frame = CGRectMake(self.datelb.right+10, (30-13)*0.5, 1, 13);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.lineLayer2.frame)+10,9, 12, 12);
    self.keyLb.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+5, 0, self.width-CGRectGetMaxX(self.lineLayer2.frame)-10-5-12, 30);
    self.searchBtn.frame = CGRectMake(CGRectGetMaxX(self.lineLayer2.frame)+10, 0, self.width-CGRectGetMaxX(self.lineLayer2.frame)-10, 30);
    self.clearBtn.frame = CGRectMake(self.searchBtn.right-5-15-5, 0, 15, 30);
    
}
- (void)cityName:(NSString*)cityName date:(NSString*)date keyWord:(NSString*)keyWord {
    if(cityName.length != 0) {
       [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
    }
    if (date.length != 0) {
        self.datelb.text = date;
    }
    if (keyWord.length != 0) {
        CGSize size =[keyWord boundingRectWithSize:CGSizeMake(self.searchBtn.width-15, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        self.searchBtn.titleEdgeInsets = (UIEdgeInsets){
            .top    = 0,
            .left   = 0,
            .bottom = 0,
            .right  = self.searchBtn.width-size.width,
        };
        self.clearBtn.hidden = NO;
        self.imageView.hidden = YES;
        self.keyLb.text = keyWord;
        self.keyLb.textColor = [UIColor colorWithHexString:@"333333"];
        self.keyLb.frame = CGRectMake(CGRectGetMaxX(self.lineLayer2.frame)+10, 0, self.width-CGRectGetMaxX(self.lineLayer2.frame)-10, 30);
    }
}
- (void)getSearchClick {

  [self.viewModel.getSearchSubjc sendNext:nil];
}
- (void)getDateClick {
  [self.viewModel.getDateSubjc sendNext:nil];
}
- (void)getCityClick {
   [self.viewModel.getCitySubjc sendNext:nil];
}
- (void)clearClick {
    self.clearBtn.hidden = YES;
    self.keyLb.text = @"请输入搜索内容";
    self.keyLb.textColor = [UIColor colorWithHexString:@"999999"];
    self.imageView.hidden = NO;
    self.keyLb.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+5, 0, self.width-CGRectGetMaxX(self.lineLayer2.frame)-10-5-12, 30);
    [self.viewModel.getKeyWordSubjc sendNext:@""];
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];

        [_searchBtn addTarget:self action:@selector(getSearchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UILabel *)keyLb {
    if (!_keyLb) {
        _keyLb = [[UILabel alloc] init];
        _keyLb.textColor = [UIColor colorWithHexString:@"999999"];
        _keyLb.text = @"请输入搜索内容";
        _keyLb.font = [UIFont systemFontOfSize:14];
    }
    return _keyLb;
}
- (UIButton *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = [[UIButton alloc] init];
        _dateBtn.backgroundColor = [UIColor clearColor];
        [_dateBtn addTarget:self action:@selector(getDateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateBtn;
}
- (UILabel *)datelb {
    if (!_datelb) {
        _datelb = [[UILabel alloc] init];
        _datelb.font = [UIFont systemFontOfSize:9];
        _datelb.textColor = [UIColor colorWithHexString:@"333333"];
        _datelb.numberOfLines = 2;
    }
    return _datelb;
}
-(CALayer *)lineLayer1{
    if (!_lineLayer1) {
        _lineLayer1 = [CALayer layer];
        _lineLayer1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    }
    return _lineLayer1;
}
-(CALayer *)lineLayer2{
    if (!_lineLayer2) {
        _lineLayer2 = [CALayer layer];
        _lineLayer2.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    }
    return _lineLayer2;
}
- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [[UIButton alloc] init];
        [_cityBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
          [_cityBtn addTarget:self action:@selector(getCityClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityBtn;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_light"]];
        
    }
    return _imageView;
}
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setImage:[UIImage imageNamed:@"hotel_clear"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.hidden = YES;
    }
    return _clearBtn;
}
@end
