//
//  CategoryRightCollectionViewCell.m
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesRightCollectionViewCell.h"

@interface SpTypesRightCollectionViewCell ()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation SpTypesRightCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellView];
    }
    return self;
}

- (void)createCellView{
    //
    self.categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 30)];
    self.categoryImageView.userInteractionEnabled= YES;
    [self.contentView addSubview:self.categoryImageView];
    
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.categoryImageView.frame.origin.x, CGRectGetMaxY(self.categoryImageView.frame), self.categoryImageView.frame.size.width, 30)];
    self.titleLab.font = [UIFont systemFontOfSize:12.0];
    self.titleLab.textColor = RGBACOLOR(102, 102, 102, 1);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
}

- (void)refreshCellWithModel:(NSDictionary *)dic{
    
    NSString *iconStr = [dic objectForKey:@"icon"];
    
    [self.categoryImageView sd_setImageWithURL:[iconStr get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];

        
    self.titleLab.text = [dic objectForKey:@"classifyName"];
}

@end
