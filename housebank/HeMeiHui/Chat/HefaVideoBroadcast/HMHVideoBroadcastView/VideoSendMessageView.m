//
//  VideoSendMessageView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/14.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "VideoSendMessageView.h"

@interface VideoSendMessageView ()<UITextViewDelegate>

//@property (nonatomic, strong) UIView *blackView;
//@property (nonatomic, strong) UIView *whiteView;


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UILabel *sendPlaceHolder;

@end

@implementation VideoSendMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    // blackView
//    self.backgroundColor = [UIColor clearColor];
//    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    _blackView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_blackView];
//
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [_blackView addGestureRecognizer:tap];

    //
   UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 1)];
    lineLab.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [headerView addSubview:lineLab];
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    self.titleLab.font = [UIFont systemFontOfSize:16.0];
    self.titleLab.text = self.titleStr;
    self.titleLab.text = @"回复跟帖";
    [headerView addSubview:self.titleLab];
    //
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(headerView.frame.size.width - 80,self.titleLab.frame.origin.y , 80, self.titleLab.frame.size.height);
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.sendBtn.enabled = NO;
    [self.sendBtn addTarget:self action:@selector(sendbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.sendBtn];
    
    
    _sendTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLab.frame) + 10, ScreenW - 20, 80)];
    _sendTextView.font = [UIFont systemFontOfSize:14.0];
    _sendTextView.delegate = self;
    _sendTextView.layer.masksToBounds = YES;
    _sendTextView.layer.cornerRadius = 5.0;
    _sendTextView.layer.borderWidth = 1.0;
    _sendTextView.layer.borderColor = RGBACOLOR(226, 226, 226, 1).CGColor;
    [headerView addSubview:_sendTextView];
    
    _sendPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, ScreenW - 20, 15)];
    _sendPlaceHolder.font = [UIFont systemFontOfSize:14.0];
    _sendPlaceHolder.textColor = [UIColor lightGrayColor];
//    _sendPlaceHolder.text = self.placeHolderStr;
    _sendPlaceHolder.text = @"请回复跟帖...";
    [_sendTextView addSubview:_sendPlaceHolder];

    
//    if ([[_sendTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1 && self.videoUrl.length <= 0) {

}

- (void)sendbtnClick:(UIButton *)btn{
    [_sendTextView resignFirstResponder];
    // 显示或隐藏placeHolder 发送按钮的状态
    if (_sendTextView.text.length < 1) {
        _sendPlaceHolder.hidden = NO;
        _sendBtn.enabled = NO;
        [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        _sendPlaceHolder.hidden = YES;
        _sendBtn.enabled = YES;
        [_sendBtn setTitleColor:RGBACOLOR(9, 78, 196, 1) forState:UIControlStateNormal];
    }
    
    if (self.sendMessageBlock) {
        if (_sendTextView.text.length > 0) {
            self.sendMessageBlock(_sendTextView.text);
        }
    }
    
    _sendTextView.text = @"";
}

#pragma mark --------------------------------------------
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *remarkStr = [NSString stringWithFormat:@"%@%@",_sendTextView.text,text];
    if (range.length==1) {//删除键
        if (_sendTextView.text.length>0) {
            remarkStr = [remarkStr substringWithRange:NSMakeRange(0, remarkStr.length-1)];
        }
    }
    if (remarkStr.length > 0) {
        _sendBtn.enabled = YES;
        [_sendBtn setTitleColor:RGBACOLOR(9, 78, 196, 1) forState:UIControlStateNormal];
    } else {
        _sendBtn.enabled = NO;
        [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    if (remarkStr.length > 160) {

//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"备注字数不能大于1500" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    contentStr = textView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _sendPlaceHolder.hidden = YES;
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length < 0) {
        _sendPlaceHolder.hidden = NO;
    }else{
        _sendPlaceHolder.hidden = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {//当结束编辑的时候 如果没内容 就显示placeHolder
        _sendPlaceHolder.hidden = NO;
    }
    return YES;
}

- (void)dismiss{
    [_sendTextView resignFirstResponder];
}
@end
