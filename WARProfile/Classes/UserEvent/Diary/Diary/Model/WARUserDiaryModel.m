//
//  WARUserDiaryModel.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/23.
//

#import "WARUserDiaryModel.h"

#import "YYModel.h"
#import "UIImage+WARBundleImage.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "WARMacros.h"


#define kDiaryTweet @"TWEET"
#define kDiaryActivity @"ACTIVITY"
#define kDiaryOrder @"ORDER"
#define kDiaryInputPhoto @"INPUTPHOTO"

#define kWARProfileBundle @"WARProfile.bundle"

@interface WARUserDiaryModel()
/** formatter */
@property (nonatomic, strong) NSDateFormatter *formatter;
@end
@implementation WARUserDiaryModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"events" : [WARUserDiaryEventModel class]};
}

- (NSString *)yearStr{
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *firstStr = strArr.firstObject;
    NSString *yearStr = [firstStr substringToIndex:4];
    return yearStr;
}

- (BOOL)isCurrentYear{
    if ([[self currentYear] isEqualToString:self.yearStr]) {
        return YES;;
    }
    return NO;
}

- (NSString *)currentYear{
    NSDate *date = [NSDate date];
   
    NSString *currentTime = [self.formatter stringFromDate:date];
    return [currentTime substringToIndex:4];
}


- (UIImage *)festivalImg{
    NSString *imageName;
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *firstStr = strArr.firstObject;
    NSString *festivalStr = [firstStr substringFromIndex:5];
    if ([festivalStr isEqualToString:@"01/01"]) {
        imageName = @"personal_newyear";
    }else if ([festivalStr isEqualToString:@"12/25"]) {
        imageName = @"personal_christmas";
    }
    return [UIImage war_imageName:imageName curClass:[self class] curBundle:kWARProfileBundle];
}

- (NSString *)showDateStr{
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *firstStr = strArr.firstObject;
    return [firstStr substringFromIndex:5];
}

- (NSString *)dateStrForTimescript:(double)timescript{
    return [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timescript/1000]];
}


- (NSDateFormatter *)formatter {
    if(!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    }
    
    return _formatter;
}
    
- (void)setTime:(double)time{
    _time = time;
    
    WS(weakSelf);

    

    //获取当天的相片
    NSMutableArray *photos = [NSMutableArray array];
    
    if (isIOS8 ) {
        //获取相册里所有的照片
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *sortResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        for (id obj in sortResult) {
            if([obj isKindOfClass:[PHAsset class]]) {
                PHAsset *item = (PHAsset *)obj;
                [assets addObject:item];
            }
        }
        
        NSMutableArray *todayItem = [NSMutableArray array];
        
        for (id obj in assets) {
            if([obj isKindOfClass:[PHAsset class]]) {

                PHAsset *item = (PHAsset *)obj;
                NSDate *itemDate = [item creationDate];
                
                NSString *timeStr = [self.formatter stringFromDate:itemDate];
                
                NSArray *strings = [timeStr componentsSeparatedByString:@" "];
                NSString *firstStr = strings.firstObject;
                
                NSString *dateStr = [self dateStrForTimescript:self.time];
                NSArray *strArr = [dateStr componentsSeparatedByString:@" "];
                NSString *firstDateStr = strArr.firstObject;
                
                if ([firstStr isEqualToString:firstDateStr]) {
                    [todayItem addObject:item];
                }
            }
        }
        
        
        
//        [sortResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[PHAsset class]]) {
//                PHAsset *item = (PHAsset *)obj;
//                [assets addObject:item];
//            }
//
//        }];
        
       
        
        
//        NSMutableArray *todayItem = [NSMutableArray array];
//        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[PHAsset class]]) {
//                PHAsset *item = (PHAsset *)obj;
//                NSDate *itemDate = [item creationDate];
//
//                NSString *timeStr = [self.formatter stringFromDate:itemDate];
//
//                NSArray *strings = [timeStr componentsSeparatedByString:@" "];
//                NSString *firstStr = strings.firstObject;
//
//                NSString *dateStr = [self dateStrForTimescript:self.time];
//                NSArray *strArr = [dateStr componentsSeparatedByString:@" "];
//                NSString *firstDateStr = strArr.firstObject;
//
//                if ([firstStr isEqualToString:firstDateStr]) {
//                    [todayItem addObject:item];
//                }
//            }
//        }];
        
        if (todayItem.count) {
            _inputPhotos = [NSArray arrayWithArray:todayItem];
        }
    }
    
}
    


- (UIImage *)diaryLocationImg{
    NSString *imageName;
    if ([self.diaryLocationStr isEqualToString:@"北京·故宫"]) {
        imageName = @"personal_gg";
    }else if ([self.diaryLocationStr isEqualToString:@"上海·东方明珠"]){
        imageName = @"personal_dfmz";
    }
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}

@end


@interface WARUserDiaryEventModel ()
/** formatter */
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation WARUserDiaryEventModel
    
- (NSDateFormatter *)formatter {
    if(!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    }
    return _formatter;
}
static NSString * extracted() {
    return kDiaryTweet;
}

- (WARUserDiaryEventType)eventType{
    if ([self.diaryType isEqualToString:extracted()]) {
     
        return WARUserDiaryEventTypeOfTweet;
    }else if ([self.diaryType isEqualToString:kDiaryOrder]){
        return WARUserDiaryEventTypeOfOrder;
    }else if ([self.diaryType isEqualToString:kDiaryActivity]){
        return WARUserDiaryEventTypeOfActivity;
    }else if ([self.diaryType isEqualToString:kDiaryInputPhoto]){
        return WARUserDiaryEventTypeOfInputPhoto;
    }
    return WARUserDiaryEventTypeOfNone;
}


- (UIImage *)diaryTypeImg{
    NSString *imageName;
    if ([self.diaryType isEqualToString:kDiaryTweet]) {
        imageName = @"personal_dt";
    }else if ([self.diaryType isEqualToString:kDiaryOrder]){
        imageName = @"personal_sp";
    }else if ([self.diaryType isEqualToString:kDiaryActivity]){
        imageName = @"personal_hd";
    }
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}

- (UIImage *)diaryTimeImg{
    NSString *imageName;
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *lastStr = strArr.lastObject;
    NSString *hourStr = [lastStr substringToIndex:2];
    NSInteger hour = [hourStr integerValue];
    if (hour >= 6 && hour <= 18) {
        imageName = @"personal_day";
    }else{
        imageName = @"personal_night";
    }
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}

- (UIImage *)festivalImg{
    NSString *imageName;
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *firstStr = strArr.firstObject;
    NSString *festivalStr = [firstStr substringFromIndex:2];
    if ([festivalStr isEqualToString:@"01/01"]) {
        imageName = @"personal_newyear";
    }else if ([festivalStr isEqualToString:@"12/25"]) {
        imageName = @"personal_christmas";
    }
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}

- (NSString *)showTimeStr{
    NSString *date = [self dateStrForTimescript:self.time];
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSString *lastStr = strArr.lastObject;
    return [lastStr substringToIndex:5];
}

- (NSString *)dateStrForTimescript:(double)timescript{
    return [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timescript/1000]];
}


- (UIImage *)diaryLocationImg{
    NSString *imageName;
    if ([self.diaryLocationStr isEqualToString:@"北京·故宫"]) {
        imageName = @"personal_gg";
    }else if ([self.diaryLocationStr isEqualToString:@"上海·东方明珠"]){
        imageName = @"personal_dfmz";
    }
    return [UIImage war_imageName:imageName curClass:self curBundle:kWARProfileBundle];
}


- (NSString *)showActivityTime{
    NSString *timeStr = [self dateStrForTimescript:self.activityTime];
    return [timeStr substringToIndex:16];
}


@end


@implementation WARDiaryManager

- (NSArray *)setUpUserDiaryData{
    NSDictionary *rowData = [self jsonWithFileName:@"userDiary" curClass:self curBundle:@"WARProfile.bundle"];
    NSArray *arr = [NSArray yy_modelArrayWithClass:[WARUserDiaryModel class] json:rowData[@"userDiary"]];
    
    //处理年份
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [arr enumerateObjectsUsingBlock:^(WARUserDiaryModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dic.allKeys containsObject:obj.yearStr]) {
            NSMutableArray *arr = dic[obj.yearStr];
            [arr addObject:obj];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:obj];
            [dic setObject:arr forKey:obj.yearStr];
        }
    }];
    
    for (int i = 0 ; i< dic.allKeys.count; i++) {
        NSString *key = dic.allKeys[i];
        NSMutableArray *arr = dic[key];
        for (int j = 0; j < arr.count; j++) {
            if (j == 0) {
                WARUserDiaryModel *model = arr[j];
                model.isShowYear = YES;
                break;
            }
        }
    }
    
    return arr;
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
