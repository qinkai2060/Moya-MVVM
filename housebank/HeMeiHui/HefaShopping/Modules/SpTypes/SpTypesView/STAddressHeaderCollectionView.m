//
//  STAddressHeaderCollectionView.m
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STAddressHeaderCollectionView.h"

@interface STAddressHeaderCollectionView ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation STAddressHeaderCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    self.titleLab.font = [UIFont systemFontOfSize:14.0];
    self.titleLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:self.titleLab];
}

- (void)refreshHeaderViewWithText:(NSString *)textStr{
    self.titleLab.text = textStr;
}

@end
