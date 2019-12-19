//
//  SpeakTextField.m
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import "SpeakTextField.h"
@interface SpeakTextField ()<UITextFieldDelegate>
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGRect TextFieldFrame;
@end
@implementation SpeakTextField

- (instancetype)initWithFrame:(CGRect)frame canAddVoice:(BOOL)canAddVoice {
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeySearch;
        self.delegate = self;
        if (canAddVoice == YES) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
            
            self.inputAccessoryView = self.speakPopView;
            @weakify(self);
            self.speakPopView.missBlock = ^{
                @strongify(self);
                [self resignFirstResponder];
                [self makeUpdatePopUIWithShow:NO];
                self.speakPopView.topLabel.text = @"";
            };
            
            self.speakPopView.endBlock = ^{
                @strongify(self);
                [self makeUpdatePopUIWithShow:NO];
            };
            
            self.speakPopView.begainBlock = ^{
                @strongify(self);
                [self makeUpdatePopUIWithShow:YES];
            };
        }
    }
    return self;
}

- (void)makeUpdatePopUIWithShow:(BOOL)show {
    
    if (show == YES) {
     self.speakPopView.frame = CGRectMake(0,0, kWidth, kHeight-self.rowHeight-STATUSBAR_NAVBAR_HEIGHT);
     self.TextFieldFrame = CGRectMake(0,0, kWidth, kHeight-self.rowHeight-STATUSBAR_NAVBAR_HEIGHT);
    }else {
     self.speakPopView.frame = CGRectMake(0,0, kWidth, 50);
     self.TextFieldFrame = CGRectMake(0,0, kWidth, 50);
    }
}

- (void)clearPopView {
    [self.speakPopView clearPopView];
}

- (void)keyboardAction:(NSNotification*)sender{
    
    [self clearPopView];
    @weakify(self);
    NSDictionary *useInfo = [sender userInfo];;
    CGSize kbSize= [[useInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat height = kbSize.height;
    self.rowHeight = height;
    self.speakPopView.frame = self.TextFieldFrame;
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
            [UIView animateWithDuration:0.35 animations:^{
                @strongify(self);
                [self makeUpdatePopUIWithShow:NO];
            } completion:^(BOOL finished) {
             
            }];
    }else {
            [UIView animateWithDuration:0.35 animations:^{
                @strongify(self);
                [self makeUpdatePopUIWithShow:YES];
            } completion:^(BOOL finished) {
            }];

    }
}

#pragma mark -- lazy load
- (SpeakPopView *)speakPopView {
    if (!_speakPopView) {
        _speakPopView = [[SpeakPopView alloc]init];
        _speakPopView.frame = CGRectMake(0,0, kWidth, 50);
        _speakPopView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    }
    return _speakPopView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];}
@end
