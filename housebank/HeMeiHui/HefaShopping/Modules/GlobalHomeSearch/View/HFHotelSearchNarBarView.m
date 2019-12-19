//
//  HFHotelSearchNarBarView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHotelSearchNarBarView.h"
#import "HFGlobalFamilyViewModel.h"

@interface HFHotelSearchNarBarView()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView *searchImagV;

@property(nonatomic,strong)UIButton *clearBtn;
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@end
@implementation HFHotelSearchNarBarView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFGlobalFamilyViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)setUpKeyWord:(NSString *)keyWord {
    self.textFiled.text = keyWord;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    [self addSubview:self.searchImagV];
    [self addSubview:self.textFiled];
    [self addSubview:self.clearBtn];
    self.clearBtn.hidden = YES;
    self.searchImagV.frame = CGRectMake(10, 7, 15, 15);
    self.textFiled.frame = CGRectMake(self.searchImagV.right+10, 0, self.width-self.searchImagV.right-10-35-10, self.height);
    self.clearBtn.frame = CGRectMake(self.width-15-5, 0, 15, self.height);
    [self becomeVIPFirstResponse];
    @weakify(self)
    [[[self.textFiled rac_textSignal] throttle:0.5] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length > 0) {
            self.clearBtn.hidden = NO;
        }else {
            self.clearBtn.hidden = YES;
        }
        
    }];
    self.textFiled.speakPopView.callBackBlock = ^(NSString * _Nonnull string) {
        @strongify(self)
        self.textFiled.text = string;
        if (self.textFiled.text.length >0) {
            if ([self.delegate respondsToSelector:@selector(hotelSearchNarBarView:keyWord:)]) {
                [self.delegate hotelSearchNarBarView:self keyWord:self.textFiled.text];
            }
        }
    };
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.setKeyWordSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.textFiled.text = x;
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length >0) {
        if ([self.delegate respondsToSelector:@selector(hotelSearchNarBarView:keyWord:)]) {
            [self.delegate hotelSearchNarBarView:self keyWord:self.textFiled.text];
        }
    }
//    [self.viewModel.getKeyWordSubjc sendNext:textField.text];

   
    return YES;
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
   
}
- (void)clearTextFClick {
    self.textFiled.text = @"";
    self.clearBtn.hidden = YES;
}
- (void)becomeVIPFirstResponse {

    [self.textFiled becomeFirstResponder];
}
//- (BOOL)becomeFirstResponder {
//    
//    return [self.textFiled becomeFirstResponder];
//}
- (void)loseFirstRespone {
    [self endEditing:YES];
}
- (UIImageView *)searchImagV {
    if (!_searchImagV) {
        _searchImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_light"]];
    }
    return _searchImagV;
}
- (SpeakTextField *)textFiled {
    if (!_textFiled) {
        _textFiled = [[SpeakTextField alloc]initWithFrame:CGRectZero canAddVoice:YES];
        _textFiled.textColor = [UIColor colorWithHexString:@"333333"];
        _textFiled.font = [UIFont systemFontOfSize:14];
        _textFiled.placeholder = @"请输入搜索关键字";
        [_textFiled.speakPopView.voiceView.voiceBtn setTitle:@"按住说出你要找的酒店" forState:UIControlStateNormal];
        _textFiled.returnKeyType = UIReturnKeySearch;
        _textFiled.delegate = self;
//        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
  
    }
    return _textFiled;
}
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setImage:[UIImage imageNamed:@"hotel_clear"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearTextFClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}
@end
