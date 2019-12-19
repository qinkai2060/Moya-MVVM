//
//  VideoCommentBarView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/4/23.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "VideoCommentToolBarView.h"
#import "ChatUtil.h"
#import "UIButton+setTitle_Image.h"
#import "UIView+NTES.h"

@interface VideoCommentToolBarView()<UITextViewDelegate, DXFaceDelegate>{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *faceButton;

@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIImageView *penImage;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *totalBgView;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@end

@implementation VideoCommentToolBarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    
    self.backgroundColor = RGBACOLOR(242, 242, 242, 1);

    if (self) {
        // Initialization code
        [self setupConfigure];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction{
    
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self.backgroundColor = RGBACOLOR(242, 242, 242, 1);

    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    return _toolbarView;
}

#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)])
    {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        if (self.isFromDetail) {
            if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
                [self.delegate didSendText:textView.text];
//                self.inputTextView.text = @"";
                [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
            }
        } else {
            [textView resignFirstResponder];
        }
        return NO;
    }
    if (range.length==1) {
        NSString *chatText = textView.text;
        if (chatText.length >= 2)
        {
            NSString *lastStr= [chatText substringFromIndex:chatText.length-1];
            if ([lastStr isEqualToString:@"]"]) {
                NSString *subStr=nil;
                NSRange subRange;
                for (int i = chatText.length - 2; i >=0 ; i --) {
                    unichar ch = [chatText characterAtIndex:i];
                    NSString *chStr = [NSString stringWithFormat:@"%c", ch];
                    if([chStr isEqualToString:@"["])
                    {
                        subRange = NSMakeRange(i, chatText.length-i);
                        subStr = [chatText substringWithRange:subRange];
                        break;
                    }
                }
                if (subStr && [ChatUtil stringIsFace:subStr]) {
                    self.inputTextView.text = [chatText substringToIndex:subRange.location];
                    [self textViewDidChange:self.inputTextView];
                    return NO;
                }
            }
        }
    }
    
    NSString *remarkStr = [NSString stringWithFormat:@"%@%@",textView.text,text];
    if (remarkStr.length > 160) {
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"字数不能大于160" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
    
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.inputTextView.text;
    
    if (!isDelete && str.length > 0) {
        self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *lastStr= [chatText substringFromIndex:chatText.length-1];
            if ([lastStr isEqualToString:@"]"]) {
                NSString *subStr=nil;
                NSRange subRange;
                for (int i = chatText.length - 2; i >=0 ; i --) {
                    unichar ch = [chatText characterAtIndex:i];
                    NSString *chStr = [NSString stringWithFormat:@"%c", ch];
                    if([chStr isEqualToString:@"["])
                    {
                        subRange = NSMakeRange(i, chatText.length-i);
                        subStr = [chatText substringWithRange:subRange];
                        break;
                    }
                }
                if (subStr && [ChatUtil stringIsFace:subStr]) {
                    self.inputTextView.text = [chatText substringToIndex:subRange.location];
                    [self textViewDidChange:self.inputTextView];
                    return;
                }
            }
        }
        
        if (chatText.length > 0) {
            self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
    [self textViewDidChange:self.inputTextView];
}
- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
//    if (self.isFromGenTie) {
//        [self.toolbarView setBackgroundColor:[UIColor whiteColor]];
//    } else {
//        [self.toolbarView.layer setBorderWidth:1.0];
//        [self.toolbarView.layer setBorderColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f].CGColor];
//        [self.toolbarView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
//    }
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews{
    // 更改背景颜色
    if (self.isFromGenTie) {
        [self.toolbarView setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self.toolbarView.layer setBorderWidth:1.0];
        [self.toolbarView.layer setBorderColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f].CGColor];
        [self.toolbarView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
    }

    CGFloat textViewLeftMargin = 6.0;
    // 输入框的宽度
    CGFloat inputWidth = 0.0;
    if (_isFromGenTie) {
        inputWidth = CGRectGetWidth(self.bounds) - 20;
    } else {
        for (int i = 0;i < 1 ; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            if (i == 0) {
//                btn.frame = CGRectMake(ScreenW - 80 + 35 * i, kVerticalPadding, 35, kInputTextViewMinHeight);
//                [btn setImage:[UIImage imageNamed:@"VL_commentImage@3x"] forState:UIControlStateNormal];
//            } else {
                btn.frame = CGRectMake(ScreenW - 60, kVerticalPadding + 3, 45 + 5, kInputTextViewMinHeight - 6);
                [btn setTitle:@"发送" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = RGBACOLOR(53, 158, 224, 1);
                btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5.0;
//            }
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            [self.toolbarView addSubview:btn];
        }
        inputWidth = CGRectGetWidth(self.bounds) - 10 - 70;
    }
    
    _totalBgView = [[UIView alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, inputWidth + 10, kInputTextViewMinHeight)];
    _totalBgView.backgroundColor = [UIColor whiteColor];
    _totalBgView.layer.masksToBounds = YES;
    _totalBgView.layer.cornerRadius = kInputTextViewMinHeight / 2.0;
    _totalBgView.layer.borderWidth = 1;
    _totalBgView.layer.borderColor = RGBACOLOR(242, 242, 242, 1).CGColor;
    [self.toolbarView addSubview:_totalBgView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, inputWidth, kInputTextViewMinHeight)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    _penImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,kInputTextViewMinHeight / 2 - 8.5, 17, 17)];
    _penImage.image = [UIImage imageNamed:@"VL_commentPen"];
    
    [_totalBgView addSubview:_backView];
    //        [self.toolbarView addSubview:_backView];
    
    // 初始化输入框
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin + 16, 0, inputWidth - 16, kInputTextViewMinHeight)];
    
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.inputTextView.contentMode = UIViewContentModeCenter;
    self.inputTextView.scrollEnabled = YES;
    if (self.isFromDetail) {
        _inputTextView.returnKeyType = UIReturnKeyDone;
    } else {
        _inputTextView.returnKeyType = UIReturnKeyDefault;
    }
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    if (self.isFromGenTie) {
        _inputTextView.placeHolder =@"写跟帖";
    } else {
        _inputTextView.placeHolder =@"我来说两句";
    }
    _inputTextView.font = [UIFont systemFontOfSize:14.0];
    _inputTextView.delegate = self;
    //    _inputTextView.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    _inputTextView.backgroundColor = [UIColor whiteColor];
    
    
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
    [_totalBgView addSubview:self.inputTextView];
    //    [self.toolbarView addSubview:self.inputTextView];
    
    [_backView addSubview:_penImage];
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    //    if (![self.activityButtomView isEqual:bottomView]) {
    //        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
    //        [self willShowBottomHeight:bottomHeight];
    //
    //        if (bottomView) {
    //            CGRect rect = bottomView.frame;
    //            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
    //            bottomView.frame = rect;
    //            [self addSubview:bottomView];
    //        }
    //
    //        if (self.activityButtomView)
    //        {
    //            [self.activityButtomView removeFromSuperview];
    //        }
    //        self.activityButtomView = bottomView;
    //    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView)
        {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    } else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        [self willShowBottomHeight:0];
    } else {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight){
        return;
    }else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        //        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        } else {
            //            [self.inputTextView setContentOffset:CGPointZero animated:YES];
            //            [self.inputTextView scrollRangeToVisible:textView.selectedRange];
            
            [self.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
        }
        _previousTextViewContentHeight = toHeight;
        self.backView.height = toHeight + 5;
        _totalBgView.height = toHeight + 5;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
//        NSLog(@"%lf",ceilf([textView sizeThatFits:textView.frame.size].height));
        
//        NSLog(@"%lf",[self getStringRectInTextView:textView.text InTextView:textView].height);
        
        //       return [self getStringRectInTextView:textView.text InTextView:textView].height;
        
        return (ceilf([textView sizeThatFits:textView.frame.size].height));
    } else {
        return textView.contentSize.height;
    }
}

- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //
    //    NSLog(@"行高  ＝ %f container = %@,xxx = %f",self.textview.font.lineHeight,self.textview.textContainer,self.textview.textContainer.lineFragmentPadding);
    //
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
}
#pragma mark - action
#pragma mark 底部按钮 图片  发送
- (void)threeBtnClick:(UIButton *)btn{
    
    [_inputTextView resignFirstResponder];
    if (self.commentBtnClick) {
        self.commentBtnClick(btn.tag,_inputTextView.text);
    }
}

#pragma mark 发送按钮的点击事件
- (void)buttonAction:(id)sender
{
    [_inputTextView resignFirstResponder];
    if (self.sendBtnClick) {
        self.sendBtnClick(_inputTextView.text);
    }
    
    [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 1://表情
        {
            //            if (button.selected) {
            //                [self.inputTextView resignFirstResponder];
            //                [self willShowBottomView:self.faceView];
            //                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //                    self.inputTextView.hidden = !button.selected;
            //                } completion:^(BOOL finished) {
            //
            //                }];
            //            } else {
            //                [self.inputTextView becomeFirstResponder];
            //            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - public

/**
 *  停止编辑
 */
//- (BOOL)endEditing:(BOOL)force
//{
//    BOOL result = [super endEditing:force];
//
////    self.faceButton.selected = NO;
////    [self willShowBottomView:nil];
////    if ([self.delegate respondsToSelector:@selector(inputEndEditing)]) {
////        [self.delegate inputEndEditing];
////    }
//
//    return result;
//}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}


@end
