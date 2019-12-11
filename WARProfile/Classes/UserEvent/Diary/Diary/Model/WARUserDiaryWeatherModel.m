//
//  WARWeatherModel.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/23.
//

#import "WARUserDiaryWeatherModel.h"

#import "YYModel.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"

#define kWARProfileBundle @"WARProfile.bundle"


@implementation WARUserDiaryWeatherModel

- (NSString *)dateStr{
    
    switch (self.time) {
        case 0:
            return WARLocalizedString(@"今天");
            break;
        case 1:
            return WARLocalizedString(@"明天");
            break;
        default:
            return [self dateForAddedDay:self.time];
            break;
    }
    return nil;
}

- (NSString *)dateForAddedDay:(NSInteger)addedDay{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    return [formatter stringFromDate:[date dateByAddingTimeInterval:addedDay*24*60*60]];
}


- (NSString *)temperatureStr{
    return [NSString stringWithFormat:@"%ld℃-%ld℃",self.lowestTemp,self.highestTemp];
}


- (UIImage *)weatherImg{
    NSString *imageName;
    switch (self.weatherType) {
        case 0:
            imageName = @"homepage_qt_a";
            break;
        case 1:
            imageName = @"homepage_dy_a";
            break;
        case 2:
            imageName = @"homepage_yt_a";
            break;
        case 3:
            imageName = @"homepage_zy_a";
            break;
        case 4:
            imageName = @"homepage_lzy_a";
            break;
        case 5:
            imageName = @"homepage_zyandbb_a";
            break;
        case 6:
            imageName = @"homepage_yjx_a";
            break;
        case 7:
            imageName = @"homepage_xy_a";
            break;
        case 8:
            imageName = @"homepage_zhongy_a";
            break;
        case 9:
            imageName = @"homepage_day_a";
            break;
        case 10:
            imageName = @"homepage_by_a";
            break;
        case 11:
            imageName = @"homepage_by_dby_a";
            break;
        case 12:
            imageName = @"homepage_tdby_a";
            break;
        case 13:
            imageName = @"homepage_zx_a";
            break;
        case 14:
            imageName = @"homepage_xx_a";
            break;
        case 15:
            imageName = @"homepage_zhongx_a";
            break;
        case 16:
            imageName = @"homepage_dx_a";
            break;
        case 17:
            imageName = @"homepage_bx_a";
            break;
        case 18:
            imageName = @"homepage_w_a";
            break;
        case 19:
            imageName = @"homepage_dongy_a";
            break;
        case 20:
            imageName = @"homepage_scb_a";
            break;
        case 21:
            imageName = @"homepage_xy_zy_a";
            break;
        case 22:
            imageName = @"homepage_zy_dy_a";
            break;
        case 23:
            imageName = @"homepage_dy_by_a";
            break;
        case 24:
            imageName = @"homepage_by_dby_a";
            break;
        case 25:
            imageName = @"homepage_dby_tdby_a";
            break;
        case 26:
            imageName = @"homepage_xx_zhongx_a";
            break;
        case 27:
            imageName = @"homepage_zx_dx_a";
            break;
        case 28:
            imageName = @"homepage_dx_bx_a";
            break;
        case 29:
            imageName = @"homepage_fc_a";
            break;
        case 30:
            imageName = @"homepage_ys_a";
            break;
        case 31:
            imageName = @"homepage_qscb_a";
            break;
        case 53:
            imageName = @"homepage_m_a";
            break;
        default:
            break;
    }
    
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}


//@"0":@"homepage_qt@2x.png", //晴
//@"1":@"homepage_dy@2x.png", //多云
//@"2":@"homepage_yt@2x.png",// 阴天
//@"3":@"homepage_zy@2x.png",// 阵雨
//@"4":@"homepage_lzy@2x.png", //雷阵雨
//@"5":@"homepage_zyandbb@2x.png",// 雷阵雨伴有冰雹
//
//@"6":@"homepage_yjx@2x.png", //雨夹雪
//@"7":@"homepage_xy@2x.png", //小雨
//@"8":@"homepage_zhongy@2x.png",// 中雨
//@"9":@"homepage_day@2x.png",// 大雨
//@"10":@"homepage_by@2x.png", //暴雨
//@"11":@"homepage_by_dby@2x.png", // 大暴雨
//
//@"12":@"homepage_tdby@2x.png", //特大暴雨
//@"13":@"homepage_zx@2x.png", //阵雪
//@"14":@"homepage_xx@2x.png",// 小雪
//@"15":@"homepage_zhongx@2x.png",// 中雪
//@"16":@"homepage_dx@2x.png", //大雪
//@"17":@"homepage_bx@2x.png", // 暴雪
//
//@"18":@"homepage_w@2x.png", //雾
//@"19":@"homepage_dongy@2x.png",// 冻雨
//@"20":@"homepage_scb@2x.png",// 沙尘暴
//@"21":@"homepage_xy_zy@2x.png",// 小雨-中雨
//@"22":@"homepage_zy_dy@2x.png", //中雨-大雨
//@"23":@"homepage_dy_by@2x.png", // 大雨-暴雨
//
//@"24":@"homepage_by_dby@2x.png", //暴雨-大暴雨
//@"25":@"homepage_dby_tdby@2x.png", //大暴雨-特大暴雨
//@"26":@"homepage_xx_zhongx@2x.png",// 小雪-中雪
//@"27":@"homepage_zx_dx@2x.png",// 中雪-大雪
//@"28":@"homepage_dx_bx@2x.png", //大雪-暴雪
//@"29":@"homepage_fc@2x.png", // 浮尘
//
//@"30":@"homepage_ys@2x.png", //扬沙
//@"31":@"homepage_qscb@2x.png", // 强沙尘暴
//@"53":@"homepage_m@2x.png" // 霾

@end


@implementation WARWeatherManager


- (NSArray *)setUpWeatherData{
    NSDictionary *rowData = [self jsonWithFileName:@"weather" curClass:self curBundle:@"WARProfile.bundle"];
    NSArray *weathers = [NSArray yy_modelArrayWithClass:[WARUserDiaryWeatherModel class] json:rowData[@"weathers"]];
    return weathers;
}



#pragma mark - private methods

- (NSDictionary *)jsonWithFileName:(NSString *)fileName curClass:(Class)cls curBundle:(NSString *)bundleName{
    if (!cls || (bundleName.length <= 0)) {
        return nil;
    }
    NSBundle* curBundle = [NSBundle bundleForClass:cls];
    NSString* strPath = [curBundle pathForResource:fileName ofType:@"json" inDirectory:bundleName];
    NSString *parseJson = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [parseJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return dic;
}
@end
