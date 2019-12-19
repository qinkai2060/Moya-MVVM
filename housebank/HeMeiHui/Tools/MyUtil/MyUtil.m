//
//  MyUtil.m
//  Dcc.mc.cc
//
//  Created by Mac－wuyunlong on 15/3/25.
//  Copyright (c) 2015年 AC. All rights reserved.
//

#import "MyUtil.h"
#import <CoreText/CoreText.h>
#import "DownLoadAlertView.h"

#define kBgGaryColor [UIColor colorWithRed:0.918 green:0.914 blue:0.914 alpha:1.000]

@interface MyUtil ()

@end
@implementation MyUtil

//-----------------------------------------------------------------
//                            通用类方法
//-----------------------------------------------------------------

//------------------------------UIView----------------------------
+ (UIView *)createViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = color;
    return bgView;
}

//------------------------------UIImageView-----------------------
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    return imageView;
}

 //------------------------------UILabel---------------------------
+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    if (text) {
        label.text = text;
    }
    
    if (font) {
        label.font = font;
    }
    
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (text)
    {
        label.text = text;
    }
    
    if (font)
    {
        label.font = font;
    }
    
    if (color)
    {
        label.textColor = color;
    }
    
    return label;
}


+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (text)
    {
        label.text = text;
    }
    
    if (font)
    {
        label.font = font;
    }
    
    if (color)
    {
        label.textColor = color;
    }
    
    if (numberOfLines >= 0)
    {
        label.numberOfLines = numberOfLines;
    }
    if (textAlignment)
    {
        label.textAlignment = textAlignment;
    }
    
    return label;
}

 //------------------------------UIButton--------------------------
+ (UIButton *)createBtnFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (selectImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}


+ (UIButton *)createBtnFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (selectImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (titleSelectedColor) {
        [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }
    
    if (font) {
        btn.titleLabel.font = font;
    }
    
    if (backgroundColor) {
        [btn setBackgroundColor:backgroundColor];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}

+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)titleName titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action
{
    UIButton *btn = [MyUtil createBtnFrame:frame imageName:nil selectImageName:nil title:titleName titleColor:titleColor titleSelectedColor:nil font:font backgroundColor:backgroundColor target:target action:action];
    return btn;
}

 //------------------------------动画-------------------------------
+ (void) animateView:(UIView *)view down:(BOOL)down distance:(CGFloat)distance
{
    const CGFloat movementDistance = distance; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (down ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
//    [UIView animateWithDuration:<#(NSTimeInterval)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>]
    
    view.frame = CGRectOffset(view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

+ (void) animateView:(UIView *)view up:(BOOL)up distance:(CGFloat)distance
{
    const CGFloat movementDistance = -distance; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    view.frame = CGRectOffset(view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

//弹提示信息
+ (void)showAlertView:(NSString *)message
{
    if (message.length > 0) {
        //显示提示信息
//        UIView *view = [[UIApplication sharedApplication].delegate window];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        hud.userInteractionEnabled = NO;
//        // Configure for text only and offset down
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = message;
//        hud.margin = 10.f;
//        //    hud.yOffset = IS_IPHONE_5?200.f:150.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:2];
//
//        DYAlertView *ayAlertView = [[DYAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
////        alertView.sureColor = [UIColor colorWithRed:99/255.0 green:171/255.0 blue:67/255.0 alpha:1];
//        [ayAlertView show];
        
//        [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
        
//        NSTimer *timer;
//        
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(dismissAlertView1:)
                                       userInfo:alertView
                                        repeats:NO];
         [alertView show];
        
        
    }

//    return nil;
}

+ (NSString *)hideTelephoneNumberWithNumber:(NSString *)number
{
    if (number.length>10) {
        
        NSString *totalStr = @"";
        for (int i = 0; i<number.length-6; i++) {
            NSString *str = @"*";
            totalStr = [NSString stringWithFormat:@"%@%@",totalStr,str];
        }
        NSString *tel = [number stringByReplacingCharactersInRange:NSMakeRange(3,number.length-6) withString:totalStr];
        return tel;
    }
    return nil;
    
}

+ (NSString *)isNullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
        
    }else {
        return (NSString *)string;
    }
}


+(void)dismissAlertView1:(NSTimer*)timer{
    NSLog(@"Dismiss alert view");

    [timer.userInfo dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
}


//-----------------------------------------------------------------

+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil].size.width;
    return width;
}


+ (CGFloat)getWidthWithFont:(UIFont *)font  height:(CGFloat)height text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil].size.width;
    return width;
}

+ (CGFloat)getHeightWithFontSize:(CGFloat)font  with:(CGFloat)with text:(NSString *)text
{
    if (!text || text.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(with, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}
+ (CGFloat)getHeightWithFont:(UIFont*)font  with:(CGFloat)with text:(NSString *)text
{
    if (!text || text.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : font};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(with, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}
+ (CGSize)getSizeWithFontSize:(CGFloat)font  with:(CGFloat)with text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(with, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size;
    return size;
}

//获取富文本文字高度
+ (CGFloat)getHeightWithStr:(NSString *)str width:(CGFloat)width lineSpace:(CGFloat)lineSpace font:(CGFloat)font{
    if (!str || str.length == 0) {
        return 0;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace+4;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGSize attSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL,CGSizeMake(width, CGFLOAT_MAX), NULL);
    CFRelease(frameSetter);
    return attSize.height+1;
}

//获取label上的每行文字
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    CFRelease(frameSetter);
    CFRelease(myFont);
    CFRelease(frame);
    CGPathRelease(path);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }

    return (NSArray *)linesArray;
}

/** 分割线 */
+ (void)createLineWithFrame:(CGRect)frame WithBgView:(UIView *)bgView
{
    UIView *line = [[UIView alloc]init];
    line.frame = frame;
    line.backgroundColor = kBgGaryColor;
    [bgView addSubview:line];
    
}

/** 分割线 */
+ (UIView *)createLineWithFrame:(CGRect)frame color:(UIColor *)color WithBgView:(UIView *)bgView
{
    UIView *line = [[UIView alloc]init];
    line.frame = frame;
    line.backgroundColor = color;
    [bgView addSubview:line];
    return line;
}


#pragma mark-----------时间转换--------------------

+ (double)getTimeStampFormTimeString:(NSString *)timeStr
{
    NSArray *arr1 = [timeStr componentsSeparatedByString:@"("];
    if (arr1.count>1) {
        NSString *str1 = [arr1 objectAtIndex:1];
        NSArray *arr2 = [str1 componentsSeparatedByString:@"+"];
        if (arr2.count>1) {
            NSString *tStr = [arr2 objectAtIndex:0];
            return [tStr doubleValue]/1000;
        }
        else
        {
            NSArray *arr3 = [str1 componentsSeparatedByString:@"-"];
            if (arr3.count>0) {
                NSString *tStr = [arr3 objectAtIndex:0];
                return [tStr doubleValue]/1000;
            }
        }
        
    }
    return 0.0;
}

+(NSString *)getFormatTimeStringWithTimeString:(NSString *)timeStr{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:timeStr]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatTimeStr = [dateFormat stringFromDate:date];
    
    return formatTimeStr;
}
+(NSString *)getFormatTimeStringWithDateFormat:(NSString *)dateFormat  timeString:(NSString *)timeStr{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:timeStr]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *formatTimeStr = [formatter stringFromDate:date];
    
    return formatTimeStr;
}
+ (NSString *)dateTimeWithAllString:(NSString *)string
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:string]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *dateTimeStr = [dateFormat stringFromDate:date];
    
    return dateTimeStr;
    
}

+ (NSString *)getDateTimeWithAllString:(NSString *)string
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:string]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateTimeStr = [dateFormat stringFromDate:date];
    
    return dateTimeStr;
    
}


+(NSString *)mallGetDateTimeWithAllString:(NSString *)string{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:string]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy-MM-dd"];
    NSString *dateTimeStr = [dateFormat stringFromDate:date];
    
    return dateTimeStr;
}
+(NSString *)mallGetDateTimeWithString:(NSString *)string{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:string]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy/MM/dd"];
    NSString *dateTimeStr = [dateFormat stringFromDate:date];
    
    return dateTimeStr;
}
+(NSString *)getDateTimeWithString:(NSString *)string{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[MyUtil getTimeStampFormTimeString:string]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString *dateTimeStr = [dateFormat stringFromDate:date];
    
    return dateTimeStr;
}




+ (double)getFavoriteTimeStampFormTimeString:(NSString *)timeStr
{
    NSArray *arr1 = [timeStr componentsSeparatedByString:@"("];
    if (arr1.count>1) {
        NSString *str1 = [arr1 objectAtIndex:1];
        NSArray *arr2 = [str1 componentsSeparatedByString:@"+"];
        if (arr2.count>1) {
            NSString *tStr = [arr2 objectAtIndex:0];
            return [tStr doubleValue]/1000;
        }
        else
        {
            NSArray *arr3 = [str1 componentsSeparatedByString:@"-"];
            if (arr3.count>0) {
                NSString *tStr = [arr3 objectAtIndex:0];
                return [tStr doubleValue]/1000;
            }
        }
        
    }
    return 0.0;
}
+ (NSString *)getFormatTimeWithMinutes:(NSInteger)minutes
{
    NSInteger dayMinutes = 24*60;
    NSInteger hourMinutes = 60;
    NSString *text ;
    NSInteger day = minutes / dayMinutes;
    NSInteger hour = (minutes - day*24*60)/hourMinutes;
    NSInteger minute = minutes - day*24*60 - hour*60;
    if (minutes / dayMinutes)
    {
        text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",(long)day,(long)hour,(long)minute];
    }
    else if (minutes / hourMinutes)
    {
        text = [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hour,(long)minute];
    }
    else
    {
        text = [NSString stringWithFormat:@"%ld分钟",(long)minute];
    }
    
    return text;
}

+ (NSString *)getSecondsTimeWithSeconds:(NSInteger)seconds
{
    NSString *text ;
//    NSInteger day = seconds / 60/60/24;
//    NSInteger hour = (seconds - day*24*60*60)/60/60;
    
//    NSInteger minute = (seconds - day*24*60*60 - hour*60*60)/60;
//    NSInteger second = seconds%60;
    
    NSInteger hour = seconds/60/60;
//    NSInteger day = hour/24;
    NSInteger minute = (seconds-hour*60*60)/60;
    NSInteger second = seconds%60;
    if (hour >= 100) {
        text = [NSString stringWithFormat:@"%ld时%02ld分%02ld秒",(long)hour,(long)minute,(long)second];
    }else{
        text = [NSString stringWithFormat:@"%02ld时%02ld分%02ld秒",(long)hour,(long)minute,(long)second];
    }
    
//    if (day > 0)
//    {
//        text = [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒",(long)day,(long)hour,(long)minute,(long)second];
//    }
//    else
//    if (hour > 0)
//    {
//        text = [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hour,(long)minute,(long)second];
//    }
//    else if(minute > 0)
//    {
//        text = [NSString stringWithFormat:@"%ld分%ld秒",(long)minute,(long)second];
//    }else{
//        text = [NSString stringWithFormat:@"%ld秒",(long)second];
//    }
    
    return text;
}
+(NSString *)getSecondsTimeWithLeftTime:(NSInteger)seconds{
    NSString *text ;
    //    NSInteger day = seconds / 60/60/24;
    //    NSInteger hour = (seconds - day*24*60*60)/60/60;
    
    //    NSInteger minute = (seconds - day*24*60*60 - hour*60*60)/60;
    //    NSInteger second = seconds%60;
    
    NSInteger hour = seconds/60/60;
    //    NSInteger day = hour/24;
    NSInteger minute = (seconds-hour*60*60)/60;
    NSInteger second = seconds%60;
    if (hour >= 100) {
        text = [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    }else{
        text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    }
    
    //    if (day > 0)
    //    {
    //        text = [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒",(long)day,(long)hour,(long)minute,(long)second];
    //    }
    //    else
    //    if (hour > 0)
    //    {
    //        text = [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hour,(long)minute,(long)second];
    //    }
    //    else if(minute > 0)
    //    {
    //        text = [NSString stringWithFormat:@"%ld分%ld秒",(long)minute,(long)second];
    //    }else{
    //        text = [NSString stringWithFormat:@"%ld秒",(long)second];
    //    }
    
    return text;
}
+(NSString *)getCompareTimeWithDate:(NSDate *)date curDate:(NSDate *)curDate{
    NSTimeInterval timeInterval = [curDate timeIntervalSinceDate:date];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if ((temp = timeInterval / 60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if ((temp = temp / 60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if ((temp = temp / 24) < 30){
        if (temp > 3) {
            NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            result = [dateFormat stringFromDate:date];
        } else {
            result = [NSString stringWithFormat:@"%ld天前",temp];
        }
        
    } else  {
        NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormat stringFromDate:date];
    }
    return result;
}
+(NSArray *)getTwoDataMin:(NSString *)stamp1 andWith:(NSString *)stamp2{
    
    NSTimeInterval timeInterval1 = [stamp1 doubleValue];
    
    NSTimeInterval timeInterval2 = [stamp2 doubleValue];
    
    NSDate *dateBefore1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    
    NSDate *dateBefore2 = [NSDate dateWithTimeIntervalSince1970:timeInterval2];
    
    //   NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    
    //    [dateFormat setDateFormat:@"HH:mm:ss"];
    
    //    NSString  * date1 =[dateFormat stringFromDate:dateBefore1];
    
    //    NSString  * date2 =[dateFormat stringFromDate:dateBefore1];
    
    // 当前日历
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    
    NSCalendarUnit unit = NSCalendarUnitYear |  NSCalendarUnitMonth
    
    | NSCalendarUnitDay | NSCalendarUnitHour |  NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateBefore1 toDate:dateBefore2  options:0];
    
    NSArray  *  dataArray  = @[[NSString stringWithFormat:@"%ld",dateCom.hour],[NSString stringWithFormat:@"%ld",dateCom.minute],[NSString stringWithFormat:@"%ld",dateCom.second]];
    
    return  dataArray;
    
}


+ (NSMutableAttributedString *)getAttributedWithString:(NSString *)string Color:(UIColor *)color font:(UIFont *)font range:(NSRange)range
{
    if (string.length >= range.length) {
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:string];
        [strAttributed addAttribute:NSForegroundColorAttributeName value:color range:range];
        [strAttributed addAttribute:NSFontAttributeName value:font range:range];
        return strAttributed;
    }
    return nil;
}
+ (NSString *)hidePhoneNumberWithNumber:(NSString *)phone
{
    if (phone.length>7) {
        NSString *tel = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return tel;
    }
    return phone;
}
//-----------------------------------------------------------------
//                      针对本App封装的类方法
//-----------------------------------------------------------------

+ (NSString *)hideFirstNameWithNameString:(NSString *)nameString{
    
    if(nameString.length > 0 ){
        
        NSString *name=[NSString stringWithFormat:@"%@**",[nameString substringToIndex:1]];
        
        return name;
    }
    return nameString;
}
//+(CGSize)downloadImageSizeWithURL:(id)imageURL
//{
//    NSURL* URL = nil;
//    if([imageURL isKindOfClass:[NSURL class]]){
//        URL = imageURL;
//    }
//    if([imageURL isKindOfClass:[NSString class]]){
//        URL = [NSURL URLWithString:imageURL];
//    }
//    if(URL == nil)
//        return CGSizeZero;
//
//    NSString* absoluteString = URL.absoluteString;
//
//    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
//    {
//        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
//        return image.size;
//    }
//
//    NSData *imgData = [[NSData alloc] initWithContentsOfURL:URL];
//    UIImage *img = [[UIImage alloc] initWithData:imgData];
//
//    return img.size;
//}


//+(CGSize)downloadImageSizeWithURL:(id)imageURL
//{
//    NSURL* URL = nil;
//    if([imageURL isKindOfClass:[NSURL class]]){
//        URL = imageURL;
//    }
//    if([imageURL isKindOfClass:[NSString class]]){
//        URL = [NSURL URLWithString:imageURL];
//    }
//    if(URL == nil)
//        return CGSizeZero;
//    
//    NSString* absoluteString = URL.absoluteString;
//    
//#ifdef dispatch_main_sync_safe
//    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
//    {
//        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
//        if(!image)
//        {
//            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
//            image = [UIImage imageWithData:data];
//        }
//        if(!image)
//        {
//            return image.size;
//        }
//    }
//#endif
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
//    
//    CGSize size = CGSizeZero;
//    if([pathExtendsion isEqualToString:@"png"]){
//        size =  [self downloadPNGImageSizeWithRequest:request];
//    }
//    else if([pathExtendsion isEqual:@"gif"])
//    {
//        size =  [self downloadGIFImageSizeWithRequest:request];
//    }
//    else{
//        size = [self downloadJPGImageSizeWithRequest:request];
//    }
//    if(CGSizeEqualToSize(CGSizeZero, size))
//    {
//        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
//        UIImage* image = [UIImage imageWithData:data];
//        if(image)
//        {
//#ifdef dispatch_main_sync_safe
//            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
//#endif
//            size = image.size;
//        }
//    }
//    return size;
//}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
//手机号码验证
+ (BOOL)validatePhone:(NSString *)phone
{
//    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

//手机验证码 验证 0-9 6位数字
+ (BOOL)validateCode:(NSString *)code
{
    NSString *codeRegex = @"^[0-9]{6}$";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codePredicate evaluateWithObject:code];
}



//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
/**
 *  条形码验证
 *
 *  @return 返回是否符合
 */
+(BOOL)validateBarCode:(NSString *)barCode
{
    //非0开头的12位数字
    NSString *barCodeRegex =@"[1-9]";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",barCodeRegex];
    return [codePredicate evaluateWithObject:barCode];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//生成随机8位用户名
+ (NSString *)randomUserName
{
    char data[8];
    for (int x=0;x<8;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
}

//随机密码
+ (NSString *)randomPassword
{
    
    //自动生成8位随机密码
    
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    
    NSLog(@"now:%.8f",random);
    
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    
    NSLog(@"randompassword:%@",randompassword);
    
    
    return randompassword;
    
}


/**
 *  获取当前手机屏幕尺寸
 *
 *  @return 尺寸
 */
+ (int)getScreenSize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            if([UIScreen mainScreen].bounds.size.height == 480){
                // iPhone retina-3.5 inch
                return 35;
            } else if([UIScreen mainScreen].bounds.size.height == 568){
                // iPhone retina-4.0 inch
                return 40;
            }else if([UIScreen mainScreen].bounds.size.height == 667){
                // iPhone retina-4.7 inch
                return 47;
            }
        }
        else if ([[UIScreen mainScreen] scale] == 3.0) {
            if([UIScreen mainScreen].bounds.size.height == 736){
                // iPhone retina-5.5 inch
                return 55;
            }
        }
    }
    return 0;
}

+ (CGFloat)getHeightWithScreenHeight
{
    if ([MyUtil getScreenSize] == 35) {
        return 0;
    }else if ([MyUtil getScreenSize] == 40) {
        return 0;
    }else if ([MyUtil getScreenSize] == 47) {
        return 6;
    }else if ([MyUtil getScreenSize] == 55) {
        return 9;
    }
    
    return 0;
}


/**
 *  修改视图某一个角为圆角
 *
 *  @param view        视图
 *  @param corners     指定哪一个角
 *  @param cornerRadii 角的尺寸
 */
+ (UIView *)changeView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

#ifdef MCF_TYPE_APPStore
#else
//检查是否安装过某个应用
//+(BOOL)IsInstalledApp:(NSString*)identifier
//{
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *apps = [workspace performSelector:@selector(allInstalledApplications)];
//    for (id info in apps) {
//        NSArray *objcIdentifiers = [info performSelector:@selector(groupIdentifiers)];
//        for (NSString *str in objcIdentifiers) {
//
//            if ([str rangeOfString:identifier].location!=NSNotFound) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}
#endif


/**
 *  打电话
 *
 *  @param number 手机号
 *  @param view   父视图 一般为 self.View
 */
+ (void)MakeAPhoneCallWithTelephoneNumber:(NSString *)number withBgView:(UIView *)view
{
    if (!number || [number isEqualToString:@""]) {
        return;
    }
    UIWebView  *callWebView = [[UIWebView alloc]init];
    NSURL *telUrl = [NSURL URLWithString: [NSString stringWithFormat:@"tel:%@",number]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
    [view addSubview:callWebView];
}


+ (NSString *)numberDecimalFormString:(NSString *)str
{
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:kCFNumberFormatterDecimalStyle];
    NSNumber *num = [NSNumber numberWithInt:[str intValue]];
    return [numFormat stringFromNumber:num];
}


+ (NSString *)floatDecimalFormString:(NSString *)str{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    return formattedNumberString;
}


/**
 // 创建警告框 并且3秒后自动消失  样式
 居中图片
 下载成功（失败）
 成功或失败描述
 */
+(DownLoadAlertView*)createDownLoadStateAlertViewWithImageName:(NSString *)imageName title:(NSString *)titleStr describeStr:(NSString *)describeStr{
    DownLoadAlertView *alertView = [[DownLoadAlertView alloc] initWithImageName:imageName title:titleStr describeStr:describeStr isLoading:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(dismissDownLoadAlertView:)
                                   userInfo:alertView
                                    repeats:NO];

    [alertView show];
    return alertView;
}

+(void)dismissDownLoadAlertView:(NSTimer*)timer{
    if (timer.userInfo) {
        [timer.userInfo removeFromSuperview];
    }
//    [timer.userInfo dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
}


+(CGSize)getImageSizeWithURL:(id)imageURL{
    
    NSURL* URL =nil;
    
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    
    if(URL ==nil){
        return CGSizeZero;                 // url不正确返回CGSizeZero
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL];
    //    [URL.pathExtension]
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size =CGSizeZero;
    
    if([pathExtendsion isEqualToString:@"png"]){
        
        size =  [self getPNGImageSizeWithRequest:request];
        
    }else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size))                   //如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        
        UIImage* image = [UIImage imageWithData:data];
        
        if(image){
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小

+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request

{
    
    [request setValue:@"bytes=16-23"forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length ==8)
        
    {
        
        int w1 =0, w2 =0, w3 =0, w4 =0;
        
        [data getBytes:&w1 range:NSMakeRange(0,1)];
        
        [data getBytes:&w2 range:NSMakeRange(1,1)];
        
        [data getBytes:&w3 range:NSMakeRange(2,1)];
        
        [data getBytes:&w4 range:NSMakeRange(3,1)];
        
        int w = (w1 <<24) + (w2 <<16) + (w3 <<8) + w4;
        
        int h1 =0, h2 =0, h3 =0, h4 =0;
        
        [data getBytes:&h1 range:NSMakeRange(4,1)];
        
        [data getBytes:&h2 range:NSMakeRange(5,1)];
        
        [data getBytes:&h3 range:NSMakeRange(6,1)];
        
        [data getBytes:&h4 range:NSMakeRange(7,1)];
        
        int h = (h1 <<24) + (h2 <<16) + (h3 <<8) + h4;
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}

+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request

{
    
    [request setValue:@"bytes=0-209"forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <=0x58) {
        
        return CGSizeZero;
        
    }
    if ([data length] <210) {//肯定只有一个DQT字段
        
        short w1 =0, w2 =0;
        
        [data getBytes:&w1 range:NSMakeRange(0x60,0x1)];
        
        [data getBytes:&w2 range:NSMakeRange(0x61,0x1)];
        
        short w = (w1 <<8) + w2;
        
        short h1 =0, h2 =0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e,0x1)];
        
        [data getBytes:&h2 range:NSMakeRange(0x5f,0x1)];
        
        short h = (h1 <<8) + h2;
        
        return CGSizeMake(w, h);
        
    } else {
        
        short word =0x0;
        
        [data getBytes:&word range:NSMakeRange(0x15,0x1)];
        
        if (word ==0xdb) {
            
            [data getBytes:&word range:NSMakeRange(0x5a,0x1)];
            
            if (word ==0xdb) {//两个DQT字段
                
                short w1 =0, w2 =0;
                
                [data getBytes:&w1 range:NSMakeRange(0xa5,0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0xa6,0x1)];
                
                short w = (w1 <<8) + w2;
                
                short h1 =0, h2 =0;
                
                [data getBytes:&h1 range:NSMakeRange(0xa3,0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0xa4,0x1)];
                
                short h = (h1 <<8) + h2;
                
                return CGSizeMake(w, h);
                
            } else {//一个DQT字段
                
                short w1 =0, w2 =0;
                
                [data getBytes:&w1 range:NSMakeRange(0x60,0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0x61,0x1)];
                
                short w = (w1 <<8) + w2;
                
                short h1 =0, h2 =0;
                
                [data getBytes:&h1 range:NSMakeRange(0x5e,0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0x5f,0x1)];
                
                short h = (h1 <<8) + h2;
                
                return CGSizeMake(w, h);
            }
            
        } else {
            
            return CGSizeZero;
        }
    }
}

// 根据获取缓存中的图片 若没有缓存 则存入
+ (UIImage *)getCacheImageWithImageUrl:(NSString *)imgUrl{
    UIImage *cashImage;
    cashImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgUrl];
    
    if (!cashImage) {
        cashImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrl];
    }
    if (!cashImage) {
        cashImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgUrl];
    }
    UIImage *image1;
    if (!cashImage) {
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        [[SDImageCache sharedImageCache] storeImage:image1 forKey:imgUrl completion:^{
        }];
        [[SDImageCache sharedImageCache] storeImage:image1 forKey:imgUrl toDisk:YES completion:^{
        }];
    }
    if (cashImage) {
        return cashImage;
    } else if(image1){
        return image1;
    } else {
        return [[UIImage alloc] init];
    }
}

//获取当前的时间

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前时间戳有两种方法(以秒为单位)

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



+(NSString *)getNowTimeTimestamp2{
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    
    return timeString;
    
}

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
//获取当地时间

+ (NSString *)getCurrentTime {
    
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
   [formatter setDateFormat:@"MM月dd日"];
    
   NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
   return dateTime;
    
}

//将字符串转成NSDate类型

+ (NSDate *)dateFromString:(NSString *)dateString {
    
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
   [dateFormatter setDateFormat: @"MM月dd日"];
    
  NSDate *destDate= [dateFormatter dateFromString:dateString];
    
 return destDate;
    
}

//传入今天的时间，返回明天的时间

+ (NSString *)GetTomorrowDay:(NSDate *)aDate {
    
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
   [components setDay:([components day]+1)];
 NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
 NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"MM月dd日"];
    return [dateday stringFromDate:beginningOfWeek];
    
}

+(NSString*)compareTwoTime:(NSString*)time1 time2:(NSString*)time2
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];//@"yyyy-MM-dd-HHMMss"
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[time2 doubleValue]/1000];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"开始时间: %@", dateString);
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[time1 doubleValue]/1000];
    NSString *dateString2 = [formatter stringFromDate:date2];
    NSLog(@"结束时间: %@", dateString2);
    
    NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
    NSLog(@"两个时间相隔：%f", seconds);
    return [NSString stringWithFormat:@"%f",seconds];

    
}
+ (NSString*)getDays:(NSDate *)startTime endDay:(NSDate *)endTime{
    
    NSDate *startDate =startTime;
    NSDate *endDdate = endTime;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    NSDateComponents *dateComponents = [cal components:unit fromDate:startDate toDate:endDdate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    
    NSString *timeStr=[NSString stringWithFormat:@"%zd",day];
    
    return timeStr;
}
//将时间戳转换为时间
+(NSDate *)timestampToDate:(CGFloat)timestamp {
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    //解决8小时时差问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    
    return localeDate;
}
//将时间转换为时间戳
+(NSString *)dateToTimestamp:(NSDate*)date {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    NSDate *newDate=[formatter dateFromString:[formatter stringFromDate:date]];
    NSString *localeDate=[NSString stringWithFormat:@"%ld", (long)[newDate timeIntervalSince1970]];
   
    
    return localeDate;
}
@end
