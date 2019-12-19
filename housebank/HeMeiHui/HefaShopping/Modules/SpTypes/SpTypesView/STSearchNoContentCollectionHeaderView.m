//
//  STSearchNoContentCollectionHeaderView.m
//  housebank
//
//  Created by liqianhong on 2018/10/31.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STSearchNoContentCollectionHeaderView.h"
#import "SpTypeSearchListNoContentView.h"

@interface STSearchNoContentCollectionHeaderView ()

@property (nonatomic, strong) SpTypeSearchListNoContentView *noContentView;

@end

@implementation STSearchNoContentCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.noContentView = [[SpTypeSearchListNoContentView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 130)];
    [self addSubview:self.noContentView];
    
    //
    UIImageView *likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 172.5, CGRectGetMaxY(self.noContentView.frame) + 50, 345, 20)];
    likeImage.image = [UIImage imageNamed:@"SpTypes_search_list_like"];
    [self addSubview:likeImage];

}

@end
