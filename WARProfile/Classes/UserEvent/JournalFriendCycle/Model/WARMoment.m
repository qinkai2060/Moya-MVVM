//
//  WARMoment.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMoment.h"
#import "MJExtension.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"
#import "WARDBContactHelper.h"
#import "WARDBUserManager.h"
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"
#import "NSString+UUID.h"

#define kLimitLikeCount 50

@implementation WARMoment

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        /// 发布平台（用户、机器）
        [[RACSignal combineLatest:@[RACObserve(self, publishSource)] reduce:^id (NSString* publishSource){
            WARMacSourceType publishSourceEnum = WARMacSourceTypeMac;
            if ([publishSource isEqualToString:WARMacSource_MAC]) {
                publishSourceEnum = WARMacSourceTypeMac;
            }else if ([publishSource isEqualToString:WARMacSource_IRON]){
                publishSourceEnum = WARMacSourceTypeIron;
            } else{
                
            }
            return @(publishSourceEnum);
        }] subscribeNext:^(NSNumber* publishSourceEnum) {
            @strongify(self);
            self.publishSourceEnum = publishSourceEnum.integerValue;
        }];
        
        /// 是否显示多页
        [[RACSignal combineLatest:@[RACObserve(self, displyPage)] reduce:^id (NSString* publishSource){
            BOOL isDisplyPage = NO;
            if ([publishSource isEqualToString:WARDisplyPage_TRUE]) {
                isDisplyPage = YES;
            }else if ([publishSource isEqualToString:WARDisplyPage_FALSE]){
                isDisplyPage = NO;
            } else{
                
            }
            return @(isDisplyPage);
        }] subscribeNext:^(NSNumber* isDisplyPage) {
            @strongify(self);
            self.isDisplyPage = isDisplyPage.boolValue;
        }];
        
        /// 动态类型
        [[RACSignal combineLatest:@[RACObserve(self, momentType)] reduce:^id (NSString* publishSource){
            WARMomentType momentTypeEnum = WARMomentTypeMoment;
            if ([publishSource isEqualToString:WARMomentType_MOMENT]) {
                momentTypeEnum = WARMomentTypeMoment;
            } else if ([publishSource isEqualToString:WARMomentType_GROUP]){
                momentTypeEnum = WARMomentTypeGroup;
            } else if ([publishSource isEqualToString:WARMomentType_ADVERTISEMEN]){
                momentTypeEnum = WARMomentTypeAD;
            } else{
                
            }
            return @(momentTypeEnum);
        }] subscribeNext:^(NSNumber* momentTypeEnum) {
            @strongify(self);
            self.momentTypeEnum = momentTypeEnum.boolValue;
        }];
        
        /// 点赞信息
        [[RACSignal combineLatest:@[RACObserve(self, commentWapper.thumb.thumbUserBos)] reduce:^id (NSArray <WARMomentUser *> *thumbUserBos){
            if (thumbUserBos.count > 0) {
                [self buildThumbUsersAttributedContent:thumbUserBos];
            }
            //是否显示点赞的展开收起按钮
            _showLikeExtend = thumbUserBos.count > kLimitLikeCount;
            return @(1);
        }] subscribeNext:^(NSNumber* number) {
            
        }];
    }
    return self;
}
 
- (id)copyWithZone:(NSZone *)zone {
    WARMoment *model = [[WARMoment allocWithZone:zone] init];
    model.accountId = self.accountId;
    model.ironBody = self.ironBody;
    model.momentId = self.momentId;
    model.commentWapper = self.commentWapper;
    model.latitude = self.latitude;
    model.location = self.location;
    model.longitude = self.longitude;
    model.permission = self.permission;
    model.platforms = self.platforms;
    model.publishTime = self.publishTime;
    model.publishSource = self.publishSource;
    model.reword = self.reword;
    model.traceInfo = self.traceInfo;
    model.displyPage = self.displyPage;
    model.isDisplyPage = self.isDisplyPage;
    model.momentType = self.momentType;
    model.momentTypeEnum = self.momentTypeEnum;
    
    model.pCommentWapper = self.pCommentWapper;
    model.pMoment = self.pMoment;
    model.fCommentWapper = self.fCommentWapper;
    model.fMoment = self.fMoment;
    model.isFriendMoment = self.isFriendMoment;
    model.isPublicMoment = self.isPublicMoment; 
    
    model.fromMineJournalList = self.fromMineJournalList;
    model.journalListLayout = self.journalListLayout;
    model.friendMomentLayout = self.friendMomentLayout;
    model.commentsLayoutArr = self.commentsLayoutArr;
    model.publishSourceEnum = self.publishSourceEnum;
    model.isMultilPage = self.isMultilPage;
    model.friendModel = self.friendModel;
    model.publishTimeString = self.publishTimeString;
    model.publishTimeAttributedString = self.publishTimeAttributedString;
    model.momentShowType = self.momentShowType;
    model.isMine = self.isMine;
    model.showLikeExtend = self.showLikeExtend;
    model.showCommentExtend = self.showCommentExtend;
    model.thumbUsersAttributedContent = self.thumbUsersAttributedContent;
    model.limitThumbUsersAttributedContent = self.limitThumbUsersAttributedContent;
    model.hasIncompatible = self.hasIncompatible;
    model.isFollowDetail = self.isFollowDetail;
    model.isPublishMoment = self.isPublishMoment;
    model.isShowAllContextTip = self.isShowAllContextTip;
    model.serialId = self.serialId;
    model.showSendFailView = self.showSendFailView;
    model.showSendingView = self.showSendingView; 
    return model;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"platforms" : @"NSString"};//前边，是属性数组的名字，后边就是类名
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    _isMultilPage = _isDisplyPage; 
    if (_isMultilPage) {
        _isShowAllContextTip = NO;
    }
    
    //发布时间
    if(_publishTime && _publishTime.length > 0){
        NSTimeInterval interval = [_publishTime doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];  //HH:mm
        _publishTimeString = [WARUIHelper timeInfoOfMomentWithTimeIntervalSecond:[_publishTime doubleValue]];//[formatter stringFromDate: date];
        
        [formatter setDateFormat:@"ddMM月"];
        NSString *monthDayFormat = [formatter stringFromDate: date];
        
        NSMutableAttributedString *attributedTextDay = [[NSMutableAttributedString alloc] initWithString:[monthDayFormat substringToIndex:2]];
        attributedTextDay.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
        attributedTextDay.yy_color = HEXCOLOR(0x343C4F);
        
        NSMutableAttributedString *attributedTextMonth = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[monthDayFormat substringFromIndex:2]]];
        attributedTextMonth.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:9.5];
        attributedTextMonth.yy_color = HEXCOLOR(0x343C4F);
        [attributedTextDay appendAttributedString:attributedTextMonth];
        
        _publishTimeAttributedString = attributedTextDay;
    }
    
    //accountId 获取用户信息
    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
    
    //是否是自己发布的
    _isMine = [_accountId isEqualToString:[WARDBUserManager userModel].accountId];
    
    /** 类型过滤，有的类型还没有写样式过滤出去 */
    [_ironBody.pageContents enumerateObjectsUsingBlock:^(WARFeedPageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hasIncompatible) {
            _hasIncompatible = YES;
        }
    }];
    
    /** 详情区分好友和公众 */
    _isFriendMoment = [_fMoment isEqualToString:@"TRUE"];
    _isPublicMoment = [_pMoment isEqualToString:@"TRUE"];
}

- (void)buildThumbUsersAttributedContent:(NSArray<WARMomentUser *> *)thumbUserBos  {
    NSArray<WARMomentUser *> *thumbUsersCopy = [thumbUserBos copy];

    UIImage *image = [UIImage war_imageName:@"great_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = image;
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    NSMutableAttributedString *limitAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    [limitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    
    NSMutableAttributedString *noIconAttributedText = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *noIconLimitAttributedText = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < thumbUsersCopy.count; i++) {
        WARMomentUser *model = thumbUsersCopy[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
            [noIconAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
            if (i < kLimitLikeCount) {
                [limitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                [noIconLimitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
            }
        }

        NSAttributedString *attributedContent = [self generateAttributedStringWithLikeItemName:model.nickname accoundId:model.accountId];
         
        if (i < kLimitLikeCount) {
            [limitAttributedText appendAttributedString:attributedContent];
            [noIconLimitAttributedText appendAttributedString:attributedContent];
        }
        [attributedText appendAttributedString:attributedContent];
        [noIconAttributedText appendAttributedString:attributedContent];
    }
    _thumbUsersAttributedContent = [attributedText mutableCopy];
    _limitThumbUsersAttributedContent = [limitAttributedText mutableCopy];
    
    _noIconThumbUsersAttributedContent = [noIconAttributedText mutableCopy];
    _noIconLimitThumbUsersAttributedContent = [noIconLimitAttributedText mutableCopy];
}

/**
 入参不要为nil,否则会想哭

 @param name name description
 @param accountId accountId description
 @return return value description
 */
- (NSAttributedString *)generateAttributedStringWithLikeItemName:(NSString *)name accoundId:(NSString *)accountId{

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",name]];
    UIColor *highLightColor = [UIColor clearColor];

    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : accountId} range:[name rangeOfString:[NSString stringWithFormat:@"%@",name]]];

    return attString;
}



@end
