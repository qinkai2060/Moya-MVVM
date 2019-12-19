/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame option:(DXChatBarMoreItemOption)option
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews:option];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame option:DXChatBarMoreViewTypeAll];
}

- (void)setupSubviews:(DXChatBarMoreItemOption)option {
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    frame.size.height = 215;
    self.frame = frame;
    
    if (!_chatMoreBgScrollerView) {
        _chatMoreBgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 210)];
        _chatMoreBgScrollerView.showsHorizontalScrollIndicator = NO;
        _chatMoreBgScrollerView.pagingEnabled = YES;
        _chatMoreBgScrollerView.delegate = self;
        [self addSubview:_chatMoreBgScrollerView];
    }
    else {
        [_chatMoreBgScrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (!_pageControl) {
        _pageControl = [[GrayPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 20)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.inactiveImage = [UIImage imageNamed:@"chat_bg_page"];
        _pageControl.activeImage = [UIImage imageNamed:@"chat_bg_page_selected"];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:116.0/255 green:115.0/255 blue:115.0/255 alpha:1];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    
    // 计算页数
    NSUInteger count = 0;
    for (NSUInteger i=0; i<31; i++) {/*共32位，最高位是0b，忽略*/
        if (option&(1<<i)) {
            count ++;
        }
    }
    NSInteger pageNum = count/8 + (count%8 ? 1:0);
    _pageControl.numberOfPages = pageNum;
    _pageControl.hidden = pageNum < 2;
    _chatMoreBgScrollerView.contentSize = CGSizeMake(self.frame.size.width * pageNum, 210);
    
    
    NSMutableArray *buttonInfos = [NSMutableArray array];
    
    if (option & DXChatBarMoreItemTypePhoto) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_chooseAlbum", @"type": @(DXChatBarMoreItemTypePhoto)}];
    }
    
    if (option & DXChatBarMoreItemTypeTakePic) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_TakePhoto", @"type": @(DXChatBarMoreItemTypeTakePic)}];
    }
    
    if (option & DXChatBarMoreItemTypeVideo) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendVidio", @"type": @(DXChatBarMoreItemTypeVideo)}];
    }
    
    if (option & DXChatBarMoreItemTypeLocation) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendLocation", @"type": @(DXChatBarMoreItemTypeLocation)}];
    }
    
    if (option & DXChatBarMoreItemTypeGoods) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendGoods", @"type": @(DXChatBarMoreItemTypeGoods)}];
    }
    
    if (option & DXChatBarMoreItemTypeRedPaper) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendRedPaper", @"type": @(DXChatBarMoreItemTypeRedPaper)}];
    }
    
    if (option & DXChatBarMoreItemTypeCoupon) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendGoupon", @"type": @(DXChatBarMoreItemTypeCoupon)}];
        
    }
    
    if (option & DXChatBarMoreItemTypeWeiTui) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendWeiTui", @"type": @(DXChatBarMoreItemTypeWeiTui)}];
    }
    
    if (option & DXChatBarMoreItemTypeSpeakSkill) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendSpeakSkill", @"type": @(DXChatBarMoreItemTypeSpeakSkill)}];
    }
    
    if (option & DXChatBarMoreItemTypeReceipt) {
        [buttonInfos addObject:@{@"img": @"ImgChat_chatBar_SendReceipt", @"type": @(DXChatBarMoreItemTypeReceipt)}];
    }
    
    for (int p = 0; p < 2; p ++) { // 共2页
        for (int i = 0; i < 2; i ++) { // 共2行
            
            for (int  j = 0; j < 4; j ++) { // 每行共4个
                
                NSUInteger index = p * 8 + i*4 +j;
                if (index == 9) {
                    
                }
                if (buttonInfos.count > index) {
                    
                    NSDictionary *info = buttonInfos[index];
                    
                    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake( insets + (insets + CHAT_BUTTON_SIZE)*j + p * (frame.size.width), (13  + 77)* i + 13, CHAT_BUTTON_SIZE , 77)];
                    
                    NSString *imageName = info[@"img"];
                    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_high"]] forState:UIControlStateHighlighted];
                    [btn addTarget:self action:@selector(imageChatChatBaraction:) forControlEvents:UIControlEventTouchUpInside];
                    [_chatMoreBgScrollerView addSubview:btn];
                    
                    DXChatBarMoreItemOption type = [info[@"type"] integerValue];
                    btn.tag = type;
                }
                else {
                    break;
                }
            }
        }
    }
}

- (void)imageChatChatBaraction:(UIButton*)sender
{
    DXChatBarMoreItemOption type = sender.tag;
    switch (type) {
            
        case DXChatBarMoreItemTypePhoto:
            [self photoAction];
            break;
        case DXChatBarMoreItemTypeTakePic:
            [self takePicAction];
            break;
        case DXChatBarMoreItemTypeGoods:
            [self takeImgChatGoodsAction];
            break;
        case DXChatBarMoreItemTypeRedPaper:
            [self takeRedPaperAction];
            break;
        case DXChatBarMoreItemTypeCoupon:
            [self takeCouponAction];
            break;
        case DXChatBarMoreItemTypeWeiTui:
            [self VeiTuiAction];
            break;
        case DXChatBarMoreItemTypeSpeakSkill:
            [self takeSpeakSkillAction];
            break;
        case DXChatBarMoreItemTypeLocation:
            [self locationAction];
            break;
        case DXChatBarMoreItemTypeVideo:
            [self takeVideoAction];
            break;
        case DXChatBarMoreItemTypeReceipt:
            [self receiptAction];
            break;
        default:
            break;
    }
    
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

-(void)takeImgChatGoodsAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewCollectionAction:)]) {
        [_delegate moreViewCollectionAction:self];
    }
}

-(void)takeCouponsAction
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeRedPaperAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewRedPaperAction:)]) {
        [_delegate moreViewRedPaperAction:self];
    }
}

- (void)takeCouponAction
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewCouponsAction:)]) {
        [_delegate moreViewCouponsAction:self];
    }
}


- (void)takeSpeakSkillAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSpeakSkillAction:)]) {
        [_delegate moreViewSpeakSkillAction:self];
    }
}

- (void)VeiTuiAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSpreadAction:)]) {
        [_delegate moreViewSpreadAction:self];
    }
    
}

- (void)receiptAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewReceiptAction:)]) {
        [_delegate moreViewReceiptAction:self];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}
@end
