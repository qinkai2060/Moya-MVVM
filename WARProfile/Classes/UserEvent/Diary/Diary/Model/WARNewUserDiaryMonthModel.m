//
//  WARNewUserDiaryMonthModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//

#import "WARNewUserDiaryMonthModel.h"
#import "MJExtension.h"
#import "WARMacros.h"

// cell 与屏幕间距
#define kCellContentMargin 11.5
// 头像宽高
#define kUserImageWidthHeight 42
// 内容顶部间距
#define FeedMainContentTopMargin 15
// 内容与屏幕左间距
#define kFeedMainContentLeftMargin (63.5)
// 内容宽度缩放比
#define kContentScale ((kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin - 13) / 345.0)
// 多页高度
#define kFeedMultilPageViewHeight (481)
// 内容高度按比例缩放
#define kFeedMainContentViewHeight (kFeedMultilPageViewHeight * kContentScale + 40 + 20) //内容高度481,滑块40，内容上下间距10+10
//图片内容与文本内容宽度比
#define kImageTextScale (247.0/300.0)

@interface WARNewUserDiaryMonthModel()

@end

@implementation WARNewUserDiaryMonthModel

+ (void)load{
    [WARNewUserDiaryMonthModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"momentOutlines":[WARNewUserDiaryMomentOutline class], 
                 };
    }];
}

- (void)mj_keyValuesDidFinishConvertingToObject { 
    NSTimeInterval interval = [_date doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    //日期字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    _dateString = [formatter stringFromDate: date];
    
    //年
    [formatter setDateFormat:@"yyyy"];
    _year = [formatter stringFromDate: date];
    
    //月
    [formatter setDateFormat:@"MM"];
    _month = [formatter stringFromDate: date];
    
    //日志悬浮月份标题
    NSString *preMonthYear = kUserDefaultObjectForKey(kPreMonthYearKey);
    if ([_year isEqualToString:preMonthYear]) {
        _diaryMonthViewTitle = [NSString stringWithFormat:@"%@月",_month];
        _diaryToolBarTitle = [NSString stringWithFormat:@"%@月",_month];
        _showYear = NO;
    } else {
        _diaryMonthViewTitle = [NSString stringWithFormat:@"%@月|%@",_month,_year];
        _diaryToolBarTitle = [NSString stringWithFormat:@"%@月%@",_month,_year];
        _showYear = YES;
    }
    kUserDefaultSetObjectForKey(_year, kPreMonthYearKey);
 
    //该月 篇数
    _count = _momentOutlines.count;
    
    //该月内容高度
    _currentMonthDisplayHeight = 0;
    for (WARNewUserDiaryMomentOutline *momentOutline  in _momentOutlines) {
        _currentMonthDisplayHeight += momentOutline.displayMomentHeight;
    }
}

@end


@implementation WARNewUserDiaryMomentOutline

- (void)mj_keyValuesDidFinishConvertingToObject {
    
    _isSinglePage = (_pageCount <= 1);
    
    if (_isSinglePage) { //单页
        _displayMomentHeight = _displayHeight * kContentScale * kImageTextScale + 55.5 + 15;//55.5 = top:(15) + bottomview:(40) + line:0.5
    } else {//多页
        _displayMomentHeight = _displayHeight * kContentScale + 55.5;//55.5 = top:(15) + bottomview:(40) + line:0.5
        _displayMomentHeight += 40 + 20;//加上 上一页，下一页滑块高度 40， 内容上下间距10+10
    }
}

@end
