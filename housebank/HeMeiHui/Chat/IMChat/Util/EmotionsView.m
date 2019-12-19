//
//  EmotionsView.m
//  MCF2
//
//  Created by QianDeng on 16/5/12.
//  Copyright © 2016年 ac. All rights reserved.
//

#import "EmotionsView.h"
#import "ChatUtil.h"


#define PageEmotionCount 20
#define EmotionViewHeight 216
#define EmotionScrollViewHeight 176
#define PageAnimationEmotionCount  8

#define EmoWidth 30.0
#define RowCount 7
#define SpaceH 18.0

@implementation EmotionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0f];
        self.emotions = [[ChatUtil emotionsDict] allKeys];
        
        self.scrollEmoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, EmotionScrollViewHeight)];
        int emoCount = (int)[self.emotions count];
        CGFloat spaceW = (frame.size.width - (EmoWidth * RowCount))/(RowCount + 1);
        for(int i=0;i<emoCount;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            int page = i/PageEmotionCount;
            //int col = i%8;
            //int row = i/8;
            int col = (i - page*PageEmotionCount)%RowCount;
            int row = (i - page*PageEmotionCount)/RowCount;
            [btn setFrame:CGRectMake((EmoWidth + spaceW)*col+spaceW+page*frame.size.width, (EmoWidth + SpaceH)*row+SpaceH, EmoWidth, EmoWidth)];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.emotions objectAtIndex:i]]] forState:UIControlStateNormal];
            [btn setTag:i];
            [btn addTarget:self action:@selector(emoClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollEmoView addSubview:btn];
        }
        [self.scrollEmoView setPagingEnabled:YES];
        [self.scrollEmoView setDelegate:self];
        [self.scrollEmoView setShowsHorizontalScrollIndicator:NO];
        [self.scrollEmoView setShowsVerticalScrollIndicator:NO];
        int pageCount = (emoCount%PageEmotionCount == 0)?(emoCount/PageEmotionCount):(emoCount/PageEmotionCount)+1;
        
        for(int j=0;j<pageCount;j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake((EmoWidth + spaceW)*(RowCount-1)+spaceW+j*frame.size.width, (EmoWidth + SpaceH)*2+SpaceH+3, 30, 24)];
            [btn setImage:[UIImage imageNamed:@"delete_expression"] forState:UIControlStateNormal];
            [btn addTarget:self
                    action:@selector(emoDelete:)
          forControlEvents:UIControlEventTouchUpInside];
            
            if (j==pageCount-1) {
                int col = (emoCount - j*PageEmotionCount)%RowCount;
                int row = (emoCount - j*PageEmotionCount)/RowCount;
                [btn setFrame:CGRectMake((EmoWidth + spaceW)*col+spaceW+j*frame.size.width, (EmoWidth + SpaceH)*row+SpaceH+3, 30, 24)];
            }
            
            [self.scrollEmoView addSubview:btn];
        }
        [self.scrollEmoView setContentSize:CGSizeMake(pageCount*frame.size.width, EmotionScrollViewHeight)];
        [self.scrollEmoView setContentOffset:CGPointMake(frame.size.width, 0)];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, EmotionScrollViewHeight-14, frame.size.width, 14)];
        [self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
        [self.pageControl setNumberOfPages:pageCount];
        [self.pageControl setCurrentPage:0];
        
        [self addSubview:self.scrollEmoView];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

#pragma mark------------------
#pragma mark - ScrollView Delegate

-(void) pageChanged
{
    int page = (int)self.pageControl.currentPage;
    [self.scrollEmoView setContentOffset:CGPointMake(page*self.scrollEmoView.frame.size.width, 0)];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = scrollView.contentOffset.x/pageWidth;
        [self.pageControl setCurrentPage:page];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x/pageWidth;
    [self.pageControl setCurrentPage:page];
}

#pragma mark------------------

-(void) emoClick:(UIButton *)button
{
    if (self.emotions.count>button.tag) {
        NSString *string = [self.emotions objectAtIndex:[button tag]];
        NSString *valueStr = [[ChatUtil emotionsDict] objectForKey:string];
        if(self.delegate && valueStr)
        {
            if([self.delegate respondsToSelector:@selector(emotionsView:didClickEmotion:)])
            {
                [self.delegate emotionsView:self didClickEmotion:valueStr];
            }
        }
        
    }
}

-(void) emoDelete:(UIButton *)button
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(emotionsViewDidDeleteEmotion:)])
        {
            [self.delegate emotionsViewDidDeleteEmotion:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
