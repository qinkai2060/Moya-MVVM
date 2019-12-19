//
//  NSMutableAttributedString+MutableAttributestr.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/19.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "NSMutableAttributedString+MutableAttributestr.h"

@implementation NSMutableAttributedString (MutableAttributestr)
#pragma mark - 富文本设置部分字体颜色
//分割字段显示不容大小颜色
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color{
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
     text = text ? text : @"";
    NSMutableAttributedString*attributeStr= [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:hightlightTextRange];
        return attributeStr;
    }else {
        return [rangeText copy];
    }
    return attributeStr;
}
//设置图片文字共存
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text textColor:(UIColor *)color setImage:(UIImage *)image{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"   我纳斯达克市场部撒草卡死你查看售楼处内 按时打算打算的撒打算离开的骄傲是是大神快了解到撒开了就对啦可视对讲卢卡斯的卡洛斯的骄傲"];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"tab_suning"];
    attch.bounds = CGRectMake(0, 0, 61, 14);
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:string atIndex:0];
    //用label的attributedText属性来使用富文本
    return attri;
}
//设置文字标签富文本
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)titleText indentationText:(NSString *)singleText1 indentationText:(NSString *)singleText2
{
    NSString *spaceText1=@"";
    NSString *spaceText2=@"";
    if (singleText1.length>0||singleText2.length>0) {
       spaceText1=@" ";
       spaceText2=@" ";
    }
    
    NSString *titleString = titleText;
    //创建  NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:titleString];
    //创建一个小标签的Label
    NSString *aa = singleText1;
    CGFloat aaW = 14*aa.length;
    UILabel *aaL = [UILabel new];
    aaL.frame = CGRectMake(0, 0, aaW*4, 20*3);
    aaL.text = aa;
    aaL.font = [UIFont boldSystemFontOfSize:12*3];
    aaL.textColor = [UIColor whiteColor];
    aaL.backgroundColor =HEXCOLOR(0xF63019);
    aaL.clipsToBounds = YES;
    aaL.layer.cornerRadius = 2*3;
    aaL.textAlignment = NSTextAlignmentCenter;
    //调用方法，转化成Image
    UIImage *image = [UIImage imageWithUIView:aaL];
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -2.5, aaW, 16); //这个-2.5是为了调整下标签跟文字的位置
    attach.image = image;
    
    NSString *bb = singleText2;
    CGFloat bbW = 8*bb.length;
    UILabel *bbL = [UILabel new];
    bbL.frame = CGRectMake(0, 0, bbW*4, 20*3);
    bbL.text = bb;
    bbL.font = [UIFont boldSystemFontOfSize:12*3];
    bbL.textColor = [UIColor whiteColor];
    if ([singleText2 isEqualToString:@"I类"]) {
        bbL.backgroundColor = HEXCOLOR(0xF63019);
    }
    if ([singleText2 isEqualToString:@"II类"]) {
        bbL.backgroundColor = HEXCOLOR(0xFF9900);
    }
    if ([singleText2 isEqualToString:@"III类"]) {
        bbL.backgroundColor = HEXCOLOR(0xB4B4B4);
    }
  
    bbL.clipsToBounds = YES;
    bbL.layer.cornerRadius = 2*3;
    bbL.textAlignment = NSTextAlignmentCenter;
    //调用方法，转化成Image
    UIImage *image2 = [UIImage imageWithUIView:bbL];
    //创建Image的富文本格式
    NSTextAttachment *attach2 = [[NSTextAttachment alloc] init];
    attach2.bounds = CGRectMake(0, -2.5, bbW, 16); //这个-2.5是为了调整下标签跟文字的位置
    attach2.image = image2;
    //添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
     NSAttributedString * imageStr2 = [NSAttributedString attributedStringWithAttachment:attach2];
     spaceText1 = spaceText1 ? spaceText1 : @"";
    spaceText2 = spaceText2 ? spaceText2 : @"";
     NSAttributedString * spaceStr1 = [[NSAttributedString alloc]initWithString:spaceText1];
     NSAttributedString * spaceStr2 = [[NSAttributedString alloc]initWithString:spaceText2];
     [maTitleString insertAttributedString:spaceStr2 atIndex:0];
    [maTitleString insertAttributedString:imageStr2 atIndex:0];
    [maTitleString insertAttributedString:spaceStr1 atIndex:0];
    [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面
    
    //[maTitleString appendAttributedString:imageStr];//加入文字后面
    //[maTitleString insertAttributedString:imageStr atIndex:4];//加入文字第4的位置
    
    //注意 ：创建这个Label的时候，frame，font，cornerRadius要设置成所生成的图片的3倍，也就是说要生成一个三倍图，否则生成的图片会虚，同学们可以试一试。
    
    return maTitleString;
}
//设置g横线
+ (NSMutableAttributedString *)setupAttributeLine:(NSString *)text lineColor:(UIColor *)color {
   NSString * oldPrice = [NSString stringWithFormat:@"%@",text];
     NSUInteger length = oldPrice.length;
     oldPrice = oldPrice ? oldPrice : @"";
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attri.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, attri.length)];
   
    return attri;
}



@end
