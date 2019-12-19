//
//  PropertyCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "PropertyCell.h"

@implementation PropertyCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.propertyL = [[UILabel alloc] init];
    self.propertyL.frame=CGRectMake(0, 0, self.width, self.height);
    self.propertyL.backgroundColor=[UIColor whiteColor];
    self.propertyL.font = PFR14Font;
    self.propertyL.textColor=HEXCOLOR(0x666666);
    self.propertyL.textAlignment=NSTextAlignmentCenter;
    self.propertyL.text = @"物流快";
    self.propertyL.layer.masksToBounds = YES;
    self.propertyL.layer.cornerRadius = self.propertyL.height/2;
    self.propertyL.layer.borderWidth = 1;
    
    [self addSubview:self.propertyL];
}
//- (void)reset:(NSString *)type
//{
//    if ([type isEqualToString:@"不可选"]) {
//                self.propertyL.backgroundColor=[UIColor whiteColor];
//                self.propertyL.layer.borderColor =HEXCOLOR(0xFFFFFF).CGColor;
//                self.propertyL.textColor=HEXCOLOR(0xCCCCCC);
//            }else if([type isEqualToString:@"选中"]) {
//                    self.propertyL.layer.borderColor =HEXCOLOR(0xE31436).CGColor;
//                    self.propertyL.textColor=HEXCOLOR(0xFFFFFF);
//                    [self.propertyL addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
//                }else{
//        //            可选
//                        self.propertyL.backgroundColor=[UIColor whiteColor];
//                        self.propertyL.layer.borderColor =HEXCOLOR(0x999999).CGColor;
//                        self.propertyL.textColor=HEXCOLOR(0x666666);
//                    }
//}
- (void)setTintStyleColor:(UIColor *)color type:(NSString *)type {
//    
    if ([type isEqualToString:@"不可选"]) {
        self.layer.borderColor =HEXCOLOR(0xE31436).CGColor;
//         [self.propertyL addGradualLayerWithColores:@[(id)HEXCOLOR(0xFFFFFF).CGColor,(id)HEXCOLOR(0xFFFFFF).CGColor]];
        self.propertyL.backgroundColor=[UIColor whiteColor];
        self.propertyL.textColor=HEXCOLOR(0xCCCCCC);
        self.propertyL.layer.borderColor =HEXCOLOR(0xE5E5E5).CGColor;
         self.propertyL.layer.borderWidth = 1;
        self.userInteractionEnabled=NO;
    }else if([type isEqualToString:@"选中"]) {
            self.layer.borderColor =HEXCOLOR(0xE31436).CGColor;
//         [self.propertyL addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
            self.propertyL.backgroundColor=[UIColor redColor];
            self.propertyL.textColor=HEXCOLOR(0xFFFFFF);
            self.propertyL.layer.borderColor =HEXCOLOR(0xFFFFFF).CGColor;
            self.propertyL.layer.borderWidth = 0;
            self.userInteractionEnabled=YES;
        }else if([type isEqualToString:@"可选"]) {
//            可选
                self.layer.borderColor =HEXCOLOR(0xE31436).CGColor;
//              [self.propertyL addGradualLayerWithColores:@[(id)HEXCOLOR(0xFFFFFF).CGColor,(id)HEXCOLOR(0xFFFFFF).CGColor]];
                self.propertyL.backgroundColor=HEXCOLOR(0xF2F2F2);
                self.propertyL.textColor=HEXCOLOR(0x666666);
                self.propertyL.layer.borderColor =HEXCOLOR(0x999999).CGColor;
             self.propertyL.layer.borderWidth = 0;
            self.userInteractionEnabled=YES;
           
            }


   
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self.propertyL mas_makeConstraints:^(MASConstraintMaker *make) {
////        [make.left.mas_equalTo(self)setOffset:DCMargin];
//        [make.top.mas_equalTo(self)setOffset:0];
//        [make.bottom.mas_equalTo(self)setOffset:0];
//        make.size.mas_equalTo(CGSizeMake(self.width, self.height));
//    }];
//}
@end
