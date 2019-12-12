//
//  WARPhotoListModel.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import "WARPhotoListModel.h"
#import "WARGroupModel.h"
#import "YYModel.h"
@implementation WARPhotoListModel
- (void)prase:(id)obj {
    NSDictionary *dict = (NSDictionary*)obj;
    
    self.lastShootTime = [WARPhotoListModel dataStr:[WARPhotoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[dict[@"lastShootTime"] integerValue]]]];
    self.lastFindId  = [WARPhotoListModel EmptyCheckobjnil:dict[@"lastFindId"]];
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *pictures = dict[@"pictures"];
    
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
        WARPhotoPictureModel *videoModel  = [[WARPhotoPictureModel alloc] init];
        [videoModel prase:dictPicture];
        [array addObject:videoModel];
    }

    [self.pictures addObjectsFromArray:[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WARPhotoPictureModel *objM1 = obj1;
        WARPhotoPictureModel *objM2 = obj2;
        
        return [[self dataStr:objM2.date] compare:[self dataStr:objM1.date]];
    }]];

}
- (NSMutableArray *)pictures {
    if (!_pictures) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
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
@implementation WARPhotoPictureModel
- (void)prase:(NSDictionary*)obj {
   
    self.date = [WARPhotoListModel dataStr:[WARPhotoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[obj[@"date"] integerValue]]]];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *array = obj[@"dateData"];
    for (NSDictionary *dict in array) {
        WARPictureModel *model = [WARPictureModel yy_modelWithDictionary:dict];;
        model.sortTime = self.date;
        model.type = @"PICTURE";
        [arrayM addObject:model];
    }
    [self.dateData addObjectsFromArray:arrayM] ;
}
- (NSMutableArray *)dateData {
    if (!_dateData) {
        _dateData = [NSMutableArray array];
    }
    return _dateData;
}
@end
//@implementation WARAlbumPictureModel
//- (void)prase:(NSDictionary *)obj {
//    self.albumId = [WARPhotoListModel EmptyCheckobjnil:obj[@"albumId"]];
//    self.desc = [WARPhotoListModel EmptyCheckobjnil:obj[@"desc"]];
//    self.pictureId = [WARPhotoListModel EmptyCheckobjnil:obj[@"pictureId"]];
//}
//- (void)praseOther:(NSDictionary *)obj {
//    self.albumId = [WARPhotoListModel EmptyCheckobjnil:obj[@"albumId"]];
//    self.desc = [WARPhotoListModel EmptyCheckobjnil:obj[@"desc"]];
//    self.pictureId = [WARPhotoListModel EmptyCheckobjnil:obj[@"pictureId"]];
//    self.sortTime = [WARAlbumPictureModel dataStr:[WARPhotoListModel EmptyCheckobjnil:[NSString stringWithFormat:@"%zd",[obj[@"sortTime"] integerValue]]]];
//}
//+ (NSString*)dataStr:(NSString*)number {
//    
//    NSDate *newdate =   [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    NSDateComponents* components = [calendar components:kCFCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear fromDate:newdate];
//    return    [NSString stringWithFormat:@"%zd-%02zd-%02zd",[components year],[components month],[components day]];
//}
//@end
