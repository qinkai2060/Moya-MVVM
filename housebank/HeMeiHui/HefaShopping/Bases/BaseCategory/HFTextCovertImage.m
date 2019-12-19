//
//  HFTextCovertImage.m
//  housebank
//
//  Created by usermac on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTextCovertImage.h"

@implementation HFTextCovertImage
+ (NSMutableAttributedString *)exchangeCommonString:(NSString *)string withText:(NSString *)text imageSize:(CGSize )imageSize
{
    //1、创建一个可变的属性字符串
     text = text ? text : @"";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
   [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, text.length)];

    //2、匹配字符串
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的图片以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //bean_money_1@2x
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:@"tag"];
        
        //修改一下图片的位置,y为负值，表示向下移动
        textAttachment.bounds = CGRectMake(0, -2, imageSize.width, imageSize.height);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
 
    return attributeString;
    
}
+ (NSMutableAttributedString *)exchangeCommonString:(NSString *)string {
    if (string.length >0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(0, 1)];
        if ([string rangeOfString:@"."].location != NSNotFound) {
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(1, [string rangeOfString:@"."].location)];
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange([string rangeOfString:@"."].location+1,2)];
        }else {
            [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(1, string.length-1)];
        }
        
        return attributeString;
    }
    return [[NSMutableAttributedString alloc] initWithString:@""];
}
+ (NSMutableAttributedString *)exchangeFinalString:(NSString *)string {

     if (string.length >0) {
         NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
         [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, 3)];
         if ([string rangeOfString:@"¥"].location != NSNotFound) {
             
             [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(3, 1)];
         }else {
             return attributeString;
         }
         if ([string rangeOfString:@"."].location != NSNotFound) {
             [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(4, [string rangeOfString:@"."].location-1)];
             [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange([string rangeOfString:@"."].location+1,2)];
         }else {
             [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F3344A"]} range:NSMakeRange(3, string.length-1)];
         }
         return attributeString;
     }
    return [[NSMutableAttributedString alloc] initWithString:@""];
}
+(NSMutableAttributedString*)str :(NSString*)str {

        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF6600"]} range:NSMakeRange(0, 1)];
    if ([str rangeOfString:@"¥"].location != NSNotFound) {
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF6600"]} range:NSMakeRange(1, [str rangeOfString:@"起"].location-1)];
    }else {

    }
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(str.length-1,1)];
    return attributeString;
    
}
+ (NSMutableAttributedString*)attrbuteStr:(NSString*)originStr rangeOfArray:(NSArray*)arrStr font:(CGFloat)fontSize color :(NSString*)colorStr{

     originStr = originStr ? originStr : @"";
         NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
    if (originStr.length>0 &&arrStr.count >0) {
   
        for (NSString *str in arrStr) {
            NSRange r = [originStr rangeOfString:str];
            [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:colorStr] range:r];
        }
    }
    return attribute;
}
+ (NSMutableAttributedString*)attrbuteStrVIP:(NSString*)originStr rangeOfArray:(NSArray*)arrStr font:(CGFloat)fontSize color :(NSString*)colorStr{
    
    originStr = originStr ? originStr : @"";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"CC9F7C"]}];
    if (originStr.length>0 &&arrStr.count >0) {
        
        for (NSString *str in arrStr) {
            NSRange r = [originStr rangeOfString:str];
            [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:colorStr] range:r];
        }
    }
    return attribute;
}

+ (NSMutableAttributedString*)attrbuteStr:(NSString*)originStr rangeOfStr:(NSString*)str font:(CGFloat)fontSize{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF6600"]} range:NSMakeRange(0, 1)];
    if ([originStr rangeOfString:@"起"].location != NSNotFound) {
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange([originStr rangeOfString:@"起"].location, 1)];
    }else {
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF6600"]} range:NSMakeRange(1, [originStr rangeOfString:@"起"].location-1)];
    }
    
    return attributeString;
    
}
+ (NSMutableAttributedString*)exchangeTextStyle:(NSString*)string twoText:(NSString *)str{
    if(string.length > 0) {
    NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]};
    //[HFTextCovertImage exchangeCommonString:string]
      NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithAttributedString:[HFTextCovertImage exchangeCommonString:string]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str attributes:attribtDic2];
    [attributeString2 appendAttributedString:attributeString];
    return attributeString2;
    }
 return [[NSMutableAttributedString alloc] initWithString:@""];
}
+ (NSAttributedString *)nodeAttributesStringText:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font{
    
    //快速创建富文本
    NSDictionary *attributesDic = @{NSFontAttributeName: font, NSForegroundColorAttributeName : textColor};
    NSAttributedString *attributesString = [[NSAttributedString alloc] initWithString:text attributes:attributesDic];
    return attributesString;
    
}
@end
