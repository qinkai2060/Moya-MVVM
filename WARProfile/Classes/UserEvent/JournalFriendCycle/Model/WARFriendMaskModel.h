//
//  WARFriendMaskModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/25.
//

#import <Foundation/Foundation.h>

@interface WARFriendMaskModel : NSObject

@property (nonatomic, copy) NSString *maskId;
@property (nonatomic, copy) NSString *faceName;
@property (nonatomic, copy) NSString *faceImg;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *year;
//
//@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *friendCount;
//
//是否是默认的
@property (nonatomic, assign) BOOL  defaults;
//@property (nonatomic, copy)NSString *bgId;
//
////情感状态
//@property (nonatomic, copy)NSString *affectiveState;
//@property (nonatomic, copy,readonly)NSString *showAffectiveString;
//
//@property (nonatomic, copy)NSString *school;
//@property (nonatomic, copy)NSString *company;
//
//@property (nonatomic, copy)NSString *industry;
//@property (nonatomic, copy)NSString *job;
//
//@property (nonatomic, copy)NSString *province;
//@property (nonatomic, copy)NSString *provinceCode;
//@property (nonatomic, copy)NSString *city;
//@property (nonatomic, copy)NSString *cityCode;
//
//
////书籍标签
//@property (nonatomic, copy)NSArray *books;
////美食标签
//@property (nonatomic, copy)NSArray *delicacies;
////电影标签
//@property (nonatomic, copy)NSArray *films;
////游戏标签
//@property (nonatomic, copy)NSArray *games;
////音乐标签
//@property (nonatomic, copy)NSArray *musics;
////运动标签
//@property (nonatomic, copy)NSArray *sports;
////旅游标签
//@property (nonatomic, copy)NSArray *tourisms;
////其他兴趣标签
//@property (nonatomic, copy)NSArray *others;
//
//
//
////年月日
//@property (nonatomic, copy)NSString *dateStr;
//
//
////辅助
////当前face下的分组
//@property (nonatomic, copy) NSArray *categoriesForCurFace;
//@property (nonatomic, copy,readonly) NSString *age;
//
//
//
//- (NSString *)getBirthdayString;

/** 辅助字段 */
/** 好友圈 是否已选中 */
@property (nonatomic, assign) BOOL hasSelected;
/** 全部好友 */
@property (nonatomic, assign) BOOL isAllFriends;

@end
