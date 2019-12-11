//
//  WARFeedGameRank.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@interface WARFeedGameRank : NSObject
/** accountId */
@property (nonatomic, copy) NSString *accountId;
/** headId */
@property (nonatomic, copy) NSString *headId;
/** nickname */
@property (nonatomic, copy) NSString *nickname;
/** score */
@property (nonatomic, copy) NSString *score;
/** 排名 */
@property (nonatomic, assign) NSInteger ranking;
/** 辅助字段 */
/** 是否是自己 */
@property (nonatomic, assign) BOOL isMine;
///** 名次 */
//@property (nonatomic, assign) NSInteger rank;
/** 是否属于多页 */
@property (nonatomic, assign) BOOL isMultiPage;
/** nickname宽度 */
@property (nonatomic, assign) CGFloat nicknameWidth;
/** listNicknameWidth宽度 */
@property (nonatomic, assign) CGFloat listNicknameWidth;
/** 积分宽度 */
@property (nonatomic, assign) CGFloat scoreWidth;
/** 列表积分宽度 */
@property (nonatomic, assign) CGFloat listScoreWidth;
@end
