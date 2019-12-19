//
//  HFTagView.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTagView.h"
#import "HFEditingTagView.h"
#import "HFAddressViewModel.h"
@interface HFTagView ()
@property (nonatomic,assign)CGFloat maxY;
@property (nonatomic,strong)HFEditingTagView *editTagView;
@property (nonatomic,strong) HFAddressViewModel *viewModel;
@end
@implementation HFTagView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    UIButton *recordBtn =nil;
    NSArray *array = @[@"家人",@"学校",@"公司",@"空的"];
    for (int i = 0; i < array.count; i ++) {
         NSString *name = array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"F3344A"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(180 , 15) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat BtnW = rect.size.width + 23;
        if ([name isEqualToString:@"空的" ]) {
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"round_add_light"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        CGFloat BtnH = rect.size.height + 6;
        btn.layer.borderColor = [[UIColor colorWithHexString:@"E5E5E5"] CGColor];
        btn.layer.cornerRadius =12;
        btn.layer.masksToBounds = YES;
        //设置边框宽度
        btn.layer.borderWidth = 1.0f;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (BtnW >= 180) {
            BtnW = 180;
        }
        if (i == 0) {
            
            btn.frame =CGRectMake(0, 15, BtnW, BtnH);
        }else {
            CGFloat yuWidth = 180  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (i == 3) {
                NSLog(@"😁%.f",yuWidth);
            }
            if (yuWidth >= BtnW) {
                
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                self.maxY = CGRectGetMaxY(recordBtn.frame)+10;
                btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
            }
        }
     
        [self addSubview:btn];
        
//        if (btn.frame.origin.y>30) {
//            btn.hidden= YES;
//        }
        //
        recordBtn = btn;
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.selected = YES;
            self.selectBtn = btn;
            self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"F3344A"] CGColor];
        }
    }
    [self addSubview:self.editTagView];
}
- (void)hh_bindViewModel {
    @weakify(self);
 //   [self.viewModel.sureTagSuj subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        if (self.selectBtn) {
//            self.selectBtn.selected = NO;
//            self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"E5E5E5"] CGColor];
//            self.selectBtn = nil;
//        }
//
//        if ([x isKindOfClass:[UILabel class]]) {
//            UILabel *lb = (UILabel*)x;
//            self.editTagView.frame = CGRectMake(0, self.maxY, lb.width+40, 25);
//        }else {
//            self.editTagView.frame = CGRectMake(0, self.maxY,240, 25);
//        }
//
//    }];
    [self.viewModel.selectedEditingSuj subscribeNext:^(id  _Nullable x) {
        if (self.selectBtn) {
         
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"E5E5E5"] CGColor];
            self.selectBtn = nil;
            
           
        }
         self.editTagView.selecte = !self.editTagView.selecte;
       
    }];
}
- (void)BtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.tag != 103 ) {
        if (self.selectBtn) {
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"E5E5E5"] CGColor];
            self.selectBtn = nil;
        }
        if (sender.selected) {
            self.selectBtn = sender;
            self.selectBtn.layer.borderColor = [[UIColor colorWithHexString:@"F3344A"] CGColor];
            
        }
        self.editTagView.selecte = NO;
    }else {
       
        sender.hidden = YES;
        self.editTagView.hidden = NO;
        [self.editTagView becomFirstResponder];
    }
//     [self.viewModel.selectedEditingSuj sendNext:nil];

}
- (HFEditingTagView *)editTagView {
    if (!_editTagView) {
        _editTagView = [[HFEditingTagView alloc] initWithFrame:CGRectMake(0, self.maxY, 240, 25) WithViewModel:self.viewModel];
        _editTagView.hidden = YES;
    }
    return _editTagView;
}
@end
