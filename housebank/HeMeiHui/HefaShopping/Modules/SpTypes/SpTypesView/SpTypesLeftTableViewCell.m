//
//  CategoryLeftTableViewCell.m
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesLeftTableViewCell.h"

@interface SpTypesLeftTableViewCell ()

@property (nonatomic, strong) UIButton *leftBtn;

@end

@implementation SpTypesLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{
    //
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(10, 10, ScreenW / 11 * 3 - 20, 25);
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.layer.cornerRadius = self.leftBtn.frame.size.height / 2.0;
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.leftBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.leftBtn];
}

//
- (void)refreshLeftCellWithModel:(SpTypeFirstLevelModel *)model{
    if (model.isSelected) {
        self.leftBtn.backgroundColor = RGBACOLOR(255, 0, 0, 1);
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.leftBtn.backgroundColor = [UIColor whiteColor];
        [self.leftBtn setTitleColor:RGBACOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
    }
    [self.leftBtn setTitle:model.classifyName forState:UIControlStateNormal];
}

@end
