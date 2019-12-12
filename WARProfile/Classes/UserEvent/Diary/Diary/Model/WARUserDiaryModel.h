//
//  WARUserDiaryModel.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/23.
//

#import <Foundation/Foundation.h>

@class WARUserDiaryEventModel;

@interface WARUserDiaryModel : NSObject

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, assign) BOOL  isShowYear;
    
@property (nonatomic, readonly, copy) NSString *showDateStr;
@property (nonatomic, readonly, strong) UIImage *festivalImg;
@property (nonatomic, readonly, assign) NSInteger  todaySteps;
@property (nonatomic, readonly, copy) NSArray *inputPhotos;
@property (nonatomic, readonly, assign) BOOL  isCurrentYear;
@property (nonatomic, readonly, strong) UIImage *diaryLocationImg;

/**
 默认NO
 */
@property (nonatomic, assign) BOOL  isHiddenInputBtn;


@property (nonatomic, copy)NSString *diaryLocationStr;

@property (nonatomic, copy)NSArray<WARUserDiaryEventModel *> *events;

@end


typedef NS_ENUM(NSInteger,WARUserDiaryEventType) {
    WARUserDiaryEventTypeOfTweet,
    WARUserDiaryEventTypeOfOrder,
    WARUserDiaryEventTypeOfActivity,
    WARUserDiaryEventTypeOfInputPhoto,
    WARUserDiaryEventTypeOfNone,
    WARUserDiaryEventTypeOfPage,
};

@interface WARUserDiaryEventModel:NSObject

@property (nonatomic, copy)NSString *diaryType;
@property (nonatomic, readonly, assign) WARUserDiaryEventType  eventType;
@property (nonatomic, readonly, strong) UIImage *diaryTypeImg;

@property (nonatomic, assign) double time;
@property (nonatomic, readonly, copy) NSString *showTimeStr;
@property (nonatomic, readonly, strong) UIImage *diaryTimeImg;
@property (nonatomic, copy) NSString *diaryText;

@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *diaryLocationStr;
@property (nonatomic, readonly, strong) UIImage *diaryLocationImg;

@property (nonatomic, assign) NSInteger  thumpUpCount;
@property (nonatomic, assign) NSInteger  commentsCount;

@property (nonatomic, copy) NSString *orderTitle;
@property (nonatomic, copy) NSString *orderPrice;

@property (nonatomic, assign)double activityTime;
@property (nonatomic,readonly,copy)NSString *showActivityTime;
@property (nonatomic, copy)NSString *activityPlace;
@property (nonatomic, copy) NSString *joinerCount;


@end


@interface WARDiaryManager : NSObject

- (NSArray *)setUpUserDiaryData;


@end
