//
//  GrayPageControl.m
//  HuangPuShoping
//
//  Created by Victor on 13-8-13.
//  Copyright (c) 2013年 @mwz. All rights reserved.
//
#import "GrayPageControl.h"
@implementation GrayPageControl

@synthesize inactiveImage;
@synthesize activeImage;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
	{
		self.activeImage = nil;
		self.inactiveImage = nil;
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
//		self.activeImage = nil;
//		self.inactiveImage = nil;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
	int i;
	for(i=0;i<self.numberOfPages;i++) {
		
		UIImageView *pageIcon = [self.subviews objectAtIndex:i];
		
		/* check for class type, in case of upcomming OS changes */
		if([pageIcon isKindOfClass:[UIImageView class]]) {
			if(i==self.currentPage) {
				/* use the active image */
                pageIcon.image = self.activeImage;//[UIImage imageNamed: @"Home_PagePointBtn_Select.png"];
			}
			else {
				/* use the inactive image */
                pageIcon.image = self.inactiveImage;//[UIImage imageNamed: @"Home_PagePointBtn_Nor.png"];
			}
		}
	}
}

-(void) updateDots
{
	if(!activeImage || !inactiveImage)
		return;
   
    else {
        for (int i = 0; i < [self.subviews count]; i++)
        {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            if (i == self.currentPage) [dot setBackgroundColor:[UIColor colorWithPatternImage:activeImage]];
            else [dot setBackgroundColor:[UIColor colorWithPatternImage:inactiveImage]];
        }
    }
    
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end


