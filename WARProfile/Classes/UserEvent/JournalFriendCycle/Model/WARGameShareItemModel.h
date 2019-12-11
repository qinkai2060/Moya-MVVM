//
//  WARGameShareItemModel.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import <Foundation/Foundation.h>

@interface WARGameShareItemModel : NSObject
/** accountId */
@property (nonatomic, copy) NSString *accountId;
/** naem */
@property (nonatomic, copy) NSString *name;
/** headId  网络图片*/
@property (nonatomic, strong) NSString *headId;
/** localHeadId  本地图片 */
@property (nonatomic, strong) NSString *localHeadId;
@end
