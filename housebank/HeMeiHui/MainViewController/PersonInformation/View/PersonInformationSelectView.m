//
//  PersonInformationSelectView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationSelectView.h"
#import "PersonInformationCancelSureView.h"

@interface PersonInformationSelectView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSArray<NSString *> *titleArray;

@property(nonatomic,strong)SelectViewCancelBlock cancelBlock;

@property (nonatomic,strong)SelectViewSureBlock sureBlock;

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UIPickerView *pickView;

@property (nonatomic,strong)PersonInformationCancelSureView *cancelSureView;

@property (nonatomic,strong)UIView *bottomView;

@end

@implementation PersonInformationSelectView

+ (instancetype)share {
    return [[PersonInformationSelectView alloc] init];
}

- (void)showView:(NSArray<NSString *> *)titleArray cancel:(SelectViewCancelBlock)cancelBlock sure:(SelectViewSureBlock)sureBlock {

    self.cancelBlock = cancelBlock;
    self.sureBlock = sureBlock;
    self.titleArray = titleArray;
    
    //背景View
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    UIView *backView = [UIView new];
    [keyView addSubview:backView];
    backView.frame = keyView.bounds;
    backView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    backView.alpha = 0.5;
    self.backView = backView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [backView addGestureRecognizer:tap];
    
    UIView *bottomView = [UIView new];
    self.bottomView = bottomView;
    [keyView addSubview:bottomView];
    
    
    
    //第二步,选择View
    UIPickerView *pickView = [UIPickerView new];
    self.pickView = pickView;
    [bottomView addSubview:pickView];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
  
    PersonInformationCancelSureView *cancelSureView = [PersonInformationCancelSureView new];
    self.cancelSureView = cancelSureView;
    [self.bottomView addSubview:cancelSureView];
    self.cancelSureView.leftTitle = @"取消";
    self.cancelSureView.rightTitle = @"确认";
    __weak PersonInformationSelectView *weakSelf = self;
    cancelSureView.cancelBlock = ^{
      
        [weakSelf actionTap:nil];
    };
    
    cancelSureView.sureBlock = ^{
        
        NSInteger temp = [weakSelf.pickView selectedRowInComponent:0];
        weakSelf.sureBlock(weakSelf.titleArray[temp]);
        [weakSelf actionTap:nil];
    };
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(backView);
    }];
    
    [self.cancelSureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(bottomView);
        make.height.mas_equalTo(WScale(40));
    }];
    
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(WScale(210));
        make.top.mas_equalTo(cancelSureView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(bottomView);
    }];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.pickView reloadAllComponents];
    });
    
}

- (void)actionTap:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backView.alpha = 0;
        self.bottomView.y = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        
        [self.backView removeFromSuperview];
        [self.bottomView removeFromSuperview];
    }];
}

#pragma mark <UIPickViewDatasource>
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titleArray.count;
}

#pragma mark <UIPickViewDelegate>
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titleArray[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    for (UIView *singleLine in pickerView.subviews) {
        
        if (singleLine.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithHexString:@"#E4E7ED"];
        }
    }
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleArray[row];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    return titleLabel;
    
    return nil;
   
}

@end
