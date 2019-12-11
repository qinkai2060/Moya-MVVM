//
//  WARPhotoDetailEditingView.m
//  WARProduct
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoDetailEditingView.h"
#import "WARMacros.h"
#import "UIColor+WARCategory.h"
#import "WARConfigurationMacros.h"
@implementation WARPhotoDetailEditingView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame]){
       self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        [self.lineV setBackgroundColor:SeparatorColor];
        [self addSubview:self.lineV];
         CGFloat width = kScreenWidth/titleArray.count;
        for(int i = 0;i < titleArray.count;i++){
            UIButton *btn = [[UIButton alloc] init];
           
            [btn setTitle:WARLocalizedString(titleArray[i]) forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            btn.frame = CGRectMake(i*width, 1, width, 49);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = 1000+i;
         
            [btn addTarget:self action:@selector(HandlerClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
    
}
- (void)HandlerClick:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(photoDetailEditingView:WithTagindex:)]) {
        [self.delegate photoDetailEditingView:self WithTagindex:btn.tag-1000];
    }
}
@end
