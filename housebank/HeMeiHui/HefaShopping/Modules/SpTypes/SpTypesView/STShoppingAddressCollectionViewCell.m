//
//  STShoppingAddressCollectionViewCell.m
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STShoppingAddressCollectionViewCell.h"

@interface STShoppingAddressCollectionViewCell ()

@property (nonatomic, strong) UILabel *cityLab;

@end

@implementation STShoppingAddressCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.cityLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
    self.cityLab.layer.masksToBounds = YES;
    self.cityLab.layer.cornerRadius = 2.0;
    self.cityLab.layer.borderWidth = 0.5;
    self.cityLab.layer.borderColor = RGBACOLOR(221, 221, 221, 1).CGColor;
    self.cityLab.textAlignment = NSTextAlignmentCenter;
    self.cityLab.font = [UIFont systemFontOfSize:14.0];
    self.cityLab.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:self.cityLab];
}

- (void)refreshCellWithModel:(id)model{
    self.cityLab.text = @"上海";
}
-(void)testFefreshCellWithStr:(NSString *)str{
    self.cityLab.text = str;
}

@end
