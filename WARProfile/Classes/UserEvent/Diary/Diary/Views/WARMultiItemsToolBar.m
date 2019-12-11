//
//  WARMultiItemsToolBar.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/21.
//

#define BtnMargin 0
#define BtnWidth 58
#define TipViewHeight 2

#import "WARMultiItemsToolBar.h"
#import "WARMacros.h"
#import "WARNewUserDiaryMonthModel.h"

@interface WARMultiItemsToolBar()

@property (nonatomic, strong) NSMutableArray<UIButton *> *tagBtns;

@end

@implementation WARMultiItemsToolBar


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.tagBtns = [NSMutableArray<UIButton *> array];
    }
    return self;
}

- (void)setBtnTitleFont:(UIFont *)btnTitleFont {
    _btnTitleFont = btnTitleFont;
    [self.tagBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = btnTitleFont;
    }];
}

- (void)setBtnTitleSelectColor:(UIColor *)btnTitleSelectColor {
    _btnTitleSelectColor = btnTitleSelectColor;
    [self.selectedBtn setTitleColor:btnTitleSelectColor forState:UIControlStateSelected];
}

- (void)setTags:(NSArray<WARNewUserDiaryMonthModel *> *)tags {
    _tags = tags;
    
    if (self.tagBtns.count>0) {
        [self.tagBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.tagBtns removeAllObjects];
    }
    
    [tags enumerateObjectsUsingBlock:^(WARNewUserDiaryMonthModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self btnWithTitle:[NSString stringWithFormat:@"%@",obj.diaryToolBarTitle] tag:idx];
        [self addSubview:btn];
        [self.tagBtns addObject:btn];
    }];
    
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupLayoutsOne];
}

- (void)setupLayoutsOne {
    
    __block CGFloat currentWidth = BtnMargin;
    [self.tagBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btn_w = BtnWidth;//[btn.currentTitle sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width;
        btn.frame = CGRectMake(currentWidth, 0, btn_w, MultiItemsToolBarScrollViewHeight);
        currentWidth += (btn_w+BtnMargin);
    }];
    self.contentSize = CGSizeMake(currentWidth, MultiItemsToolBarScrollViewHeight);
}

- (void)setupLayoutsTwo {
    
    NSUInteger tagsCount = self.tagBtns.count;
    CGFloat self_w = CGRectGetWidth(self.bounds);
    __block CGFloat totalBtnsWidth = 0;
    NSMutableArray *btn_ws = [NSMutableArray array];
    [self.tagBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btn_w = [btn.currentTitle sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width;
        totalBtnsWidth += btn_w ;
        [btn_ws addObject:@(btn_w)];
    }];
    CGFloat needWith = totalBtnsWidth + BtnMargin * (tagsCount + 1);
    if (needWith >self_w) {
        [self setupLayoutsOne];
    }else{
        CGFloat margin = (self_w - totalBtnsWidth)/(tagsCount+1);
        __block CGFloat currentWidth = margin;
        [btn_ws enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat btn_w = [obj floatValue];
            if (idx<tagsCount) {
                UIButton *btn = self.tagBtns[idx];
                btn.frame = CGRectMake(currentWidth, 0, btn_w, MultiItemsToolBarScrollViewHeight);
                
                currentWidth += (btn_w + margin);
                
            }
        }];
    }
}

- (UIButton *)btnWithTitle:(NSString *)title tag:(NSUInteger)tag{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = tag;
    [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
//    if (self.btnTitleFont) {
//        [btn.titleLabel setFont:self.btnTitleFont];
//    }else{
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    }
//    [btn setTitleColor:HEXCOLOR(0xADB1BE) forState:UIControlStateNormal];
//    if (self.btnTitleSelectColor) {
//        [btn setTitleColor:self.btnTitleSelectColor forState:UIControlStateSelected];
//    }else{
//        [btn setTitleColor:HEXCOLOR(0x343C4F) forState:UIControlStateSelected];
//    }
    
    NSArray *titleElements = [title componentsSeparatedByString:@"月"];
    NSString *month = titleElements[0];
    NSMutableAttributedString *norAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
    if (titleElements.count > 1) {
        NSString *year = titleElements[1];
        [norAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(month.length + 1, year.length)];
    }
    [norAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, month.length + 1)];
    [norAttributeString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xADB1BE) range:NSMakeRange(0, title.length)];
    
    NSMutableAttributedString *selAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
    if (titleElements.count > 1) {
        NSString *year = titleElements[1];
        [selAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(month.length + 1, year.length)];
    }
    [selAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, month.length + 1)];
    [selAttributeString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x343C4F) range:NSMakeRange(0, title.length)];
 
    [btn setAttributedTitle:norAttributeString forState:UIControlStateNormal];
    [btn setAttributedTitle:selAttributeString forState:UIControlStateSelected];
    
    btn.adjustsImageWhenHighlighted = NO;
    
    return btn;
}

- (void)selectedAction:(UIButton *)btn{ 
    if ([self.clickDelegate respondsToSelector:@selector(toolBar:didSelectedIndex:)]) {
        [self.clickDelegate toolBar:self didSelectedIndex:btn.tag];
    }
}

- (void)selectedBtnIndex:(NSUInteger)index
                 animate:(BOOL)animate
{
    if (self.tagBtns.count<1 || index>self.tagBtns.count-1) {
        return;
    }
    
    UIButton *btn = self.tagBtns[index];
    
    NSTimeInterval duration = animate?0.25:0.0;
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat maxOffsetX = self.contentSize.width-self.frame.size.width;
        if (maxOffsetX>=0) {
            CGFloat offsetX = btn.center.x-self.frame.size.width*0.5;
            CGFloat minOffsetX = 0;
            
            if (offsetX < minOffsetX) {
                offsetX = minOffsetX;
            }else if (offsetX > maxOffsetX) {
                offsetX = maxOffsetX;
            }
            
            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
    }];
    
    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = HEXCOLOR(0xFBFBFB);
    btn.selected = YES;
    btn.backgroundColor = HEXCOLOR(0xE6F9ED);
    self.selectedBtn = btn;
}

- (void)changeTipPlaceWithSmallIndex:(NSUInteger)smallIndex
                            bigIndex:(NSUInteger)bigIndex
                            progress:(CGFloat)progress
                             animate:(BOOL)animate
{
    
    if (smallIndex>=self.tagBtns.count) {
        smallIndex = self.tagBtns.count-1;
    }
    if (bigIndex>=self.tagBtns.count) {
        bigIndex = self.tagBtns.count-1;
    }
    
    if (progress==0) {
        [self selectedBtnIndex:smallIndex animate:animate];
    }else{
        UIButton *btn1 = self.tagBtns[smallIndex];
        UIButton *btn2 = self.tagBtns[bigIndex];
        
        CGFloat btn1X = btn1.frame.origin.x;
        CGFloat btn2X = btn2.frame.origin.x;
        
        CGFloat marginX = btn2X-btn1X;
        
        if (smallIndex == self.tagBtns.count-1) {marginX = 40;} 
    }
}
@end
