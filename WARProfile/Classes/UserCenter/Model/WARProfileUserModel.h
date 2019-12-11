//
//  WARProfileUserModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/11.
//

#import <Foundation/Foundation.h>
@class WARProfileMasksModel;
@class WARProfileUserSettingModel;
@interface WARProfileUserModel : NSObject
/**用户ID*/
@property (nonatomic,copy) NSString *accountId;
/**账号号码*/
@property (nonatomic,copy) NSString *accNum;
/**账号号码*/
@property (nonatomic,strong) NSArray<WARProfileMasksModel*> *masks;
/**是否是粉丝 关注 互相关注*/
@property (nonatomic,copy) NSString *followRelation;
/**是否是朋友关系*/
@property (nonatomic,copy) NSString *friendRelation;
/**是不是自己*/
@property (nonatomic,assign) BOOL isMine;
/**是否是朋友关系*/
@property (nonatomic,strong) WARProfileUserSettingModel *setting;
@property (nonatomic,strong) WARProfileUserSettingModel *guySetting;
@property (nonatomic,strong) WARProfileMasksModel *guyMask;
/**兴趣*/
@property (nonatomic,strong) NSArray *MasksArr;
/**他人数据*/
@property (nonatomic,strong) WARProfileMasksModel *otherMaskModel;

//
- (void)praseData:(id)obj;
//- (void)praseOtherData:(id)obj;
@end

@interface WARProfileMasksModel : NSObject
/**maskID*/
@property (nonatomic,copy) NSString *maskId;
/**用户昵称*/
@property (nonatomic,copy) NSString *nickname;
/**faceID*/
@property (nonatomic,copy) NSString *faceId;
/**bgId*/
@property (nonatomic,copy) NSString *bgId;
/**性别*/
@property (nonatomic,copy) NSString *gender;
/**签名*/
@property (nonatomic,copy) NSString *signature;
/**cityCode*/
@property (nonatomic,copy) NSString *cityCode;
/**films*/
@property (nonatomic,copy) NSString *provinceCode;
/**家乡省直辖市*/
@property (nonatomic,copy) NSString *province;
/**家乡市*/
@property (nonatomic,copy) NSString *city;
/**是否是默认面具*/
@property (nonatomic,assign) BOOL defaults;
/**公司*/
@property (nonatomic,copy) NSString *company;
/**学校*/
@property (nonatomic,copy) NSString *school;
/**行业*/
@property (nonatomic,copy) NSString *industry;
/**职业*/
@property (nonatomic,copy) NSString *job;
/**情感状态*/
@property (nonatomic,copy) NSString *affectiiveState;
/**朋友数量*/
@property (nonatomic,assign) NSInteger friendCount;
/**其他标签*/
@property (nonatomic,copy) NSArray *others;
/**旅游标签*/
@property (nonatomic,strong) NSArray *tourisms;
/**音乐标签*/
@property (nonatomic,strong) NSArray *musics;
/**音乐标签*/
@property (nonatomic,strong) NSArray *books;
/**游戏标签*/
@property (nonatomic,strong) NSArray *games;
/**美食标签*/
@property (nonatomic,strong) NSArray *delicacies;
/**films*/
@property (nonatomic,strong) NSArray *films;
/**运动标签*/
@property (nonatomic,strong) NSArray *sports;
/**个人消息数组*/
@property (nonatomic,strong) NSArray *userInfoArr;
/**兴趣*/
@property (nonatomic,strong) NSArray *interestsArr;
/**对应面具图*/
@property (nonatomic,copy) NSString *faceImg;
/**备注*/
@property (nonatomic,copy) NSString *remark;
/**出生日期*/
@property (nonatomic,copy) NSString *bornDay;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *day;
+ (NSString*)affectiveState:(id)obj;
@end

@interface WARProfileUserMasksModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,copy)NSString *detailInfoStr;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)NSInteger sort;
@property(nonatomic,assign)NSInteger provicesort;

- (instancetype)initWithName:(NSString*)name content:(NSString*)content;
+ (instancetype)name:(NSString*)name content:(NSString*)content;
- (instancetype)initWithName:(NSString*)name tags:(NSArray*)tags;
+ (instancetype)name:(NSString*)name tags:(NSArray*)tags;
@end

@interface WARProfileUserSettingModel : NSObject

@property (nonatomic, strong) NSString *background;//背景图片
@property (nonatomic, strong) NSString *momentReceive;//是否接收动态
@property (nonatomic, strong) NSString *momentsAccess;//查看个人空间权限
@property (nonatomic, strong) NSString *showSelf;//对他隐身
@property (nonatomic, strong) NSString *black;
@property (nonatomic, strong) NSString *msgCall;//消息免打扰
@property (nonatomic, strong) NSString *msgTop;//聊天顶置
@property (nonatomic, strong) NSString *remarkName;//备注名
@end
