//
//  WARPhotoVideoListModel.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import "WARPhotoVideoListModel.h"
#import "WARGroupModel.h"
#import "YYModel.h"
@implementation WARPhotoVideoListModel
- (void)prase:(id)obj {
    NSDictionary *dict = (NSDictionary*)obj;
    
    self.lastShootTime = [WARPhotoVideoListModel dataStr:[WARPhotoVideoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[dict[@"lastShootTime"] integerValue]]]];
    self.lastFindId  = [WARPhotoVideoListModel EmptyCheckobjnil:dict[@"lastFindId"]];
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *pictures = dict[@"videos"];
    
    NSArray *timeArr = [pictures valueForKey:@"sortTime"];
    //筛选
    NSSet *timeSet = [NSSet setWithArray:timeArr];
    
    NSMutableArray *dateArr = [NSMutableArray array];
    
    [timeSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
        [timeDict setObject:obj forKey:@"date"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortTime == %@ ",obj];
        NSArray *indexArray = [pictures filteredArrayUsingPredicate:predicate];
        [timeDict setObject:indexArray forKey:@"dateData"];
        [dateArr addObject:timeDict];
        
    }];
    
    for (NSDictionary *dictPicture in dateArr) {
        WARPhotoVideoModel *videoModel  = [[WARPhotoVideoModel alloc] init];
        [videoModel prase:dictPicture];
        [array addObject:videoModel];
    }

    [self.videos addObjectsFromArray:[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WARPhotoVideoModel *objM1 = obj1;
        WARPhotoVideoModel *objM2 = obj2;

        return [[self dataStr:objM2.date] compare:[self dataStr:objM1.date]];
    }]];

}
- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}
- (NSDate*)dataStr:(NSString*)number{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd";
    return    [dateFormater dateFromString:number];
    
}
+ (id)EmptyCheckobjnil:(id)obj
{
    if ([obj isEqual:[NSNull null]]) {
        return @"";
    }
    else if (obj==nil)
    {
        return @"";
    }
    else {
        return obj;
    }
}
+ (NSString*)dataStr:(NSString*)number {
    
    NSDate *newdate =   [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear fromDate:newdate];
    return    [NSString stringWithFormat:@"%zd-%02zd-%02zd",[components year],[components month],[components day]];
}
@end
@implementation WARPhotoVideoModel
- (void)prase:(NSDictionary*)obj {
    self.date = [WARPhotoVideoListModel dataStr:[WARPhotoVideoListModel EmptyCheckobjnil:obj[@"date"]]];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *array = obj[@"dateData"];
    for (NSDictionary *dict in array) {
        WARPictureModel *model = [WARPictureModel yy_modelWithDictionary:dict];;
        model.sortTime = self.date;
        model.timelength =  [WARPhotoVideoModel getNewTimeFromDurationSecond:[[WARPhotoVideoListModel EmptyCheckobjnil:[[dict valueForKey:@"video"] valueForKey:@"duration"]] integerValue]];
        model.videoId = [WARPhotoVideoListModel EmptyCheckobjnil:[[dict valueForKey:@"video"] valueForKey:@"videoId"]];
        model.type = @"VIDEO";
        [arrayM addObject:model];
    }
    self.dateData = arrayM;
}
- (NSMutableArray *)dateData {
    if (!_dateData) {
        _dateData = [NSMutableArray array];
    }
    return _dateData;
}
+ (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%02zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%02zd:%zd",min,sec];
        }
    }
    return newTime;
}
@end

