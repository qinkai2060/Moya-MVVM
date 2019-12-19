//
//  ACTextView.m
//  MCF2
//
//  Created by zhangkai on 16/4/12.
//  Copyright © 2016年 ac. All rights reserved.
//

#import "ACTextView.h"

@interface ACTextView ()<UITextViewDelegate>

@end

@implementation ACTextView
{
    UILabel *_placeHolderLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        _placeHolderColor = [UIColor lightGrayColor];
        _placeHolderFont = [UIFont systemFontOfSize:14];
        _placeHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, frame.size.width-10, frame.size.height)];
        _placeHolderLab.backgroundColor = [UIColor clearColor];
        _placeHolderLab.textColor = _placeHolderColor;
        _placeHolderLab.font = _placeHolderFont;
        [self addSubview:_placeHolderLab];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_placeHolderLab addGestureRecognizer:tap];
        self.delegate = self;
        self.textContainerInset = UIEdgeInsetsMake(-0.5, 0, 0, 0);
//        self.scrollEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)tapAction{
    [self becomeFirstResponder];
}


-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    _placeHolderColor = placeHolderColor;
    _placeHolderLab.textColor = _placeHolderColor;
}

-(void)setPlaceHolderFont:(UIFont *)placeHolderFont{
    _placeHolderFont = placeHolderFont;
    _placeHolderLab.font = _placeHolderFont;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    _placeHolderLab.text = _placeHolder;
}

-(void)setText:(NSString *)text{
    [super setText:text];
    if (!text || text.length == 0) {
        _placeHolderLab.hidden = NO;
    }
}

-(void)textDidChange{
    if (self.text.length > 0) {
        _placeHolderLab.hidden = YES;
    }else{
        _placeHolderLab.hidden = NO;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
