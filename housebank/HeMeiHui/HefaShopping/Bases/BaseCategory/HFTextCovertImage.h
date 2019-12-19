//
//  HFTextCovertImage.h
//  housebank
//
//  Created by usermac on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFTextCovertImage : NSObject
+ (NSMutableAttributedString *)exchangeCommonString:(NSString *)string withText:(NSString *)text imageSize:(CGSize )imageSize;
+ (NSMutableAttributedString *)exchangeCommonString:(NSString *)string;
+ (NSMutableAttributedString *)exchangeFinalString:(NSString *)string;

+ (NSMutableAttributedString*)exchangeTextStyle:(NSString*)string twoText:(NSString *)str;

+ (NSMutableAttributedString*)attrbuteStr:(NSString*)originStr rangeOfArray:(NSArray*)arrStr font:(CGFloat)fontSize color:(NSString*)colorStr;
+ (NSMutableAttributedString*)attrbuteStrVIP:(NSString*)originStr rangeOfArray:(NSArray*)arrStr font:(CGFloat)fontSize color :(NSString*)colorStr;
+(NSMutableAttributedString*)str :(NSString*)str;

+ (NSAttributedString *)nodeAttributesStringText:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
