//
//  WARNewUserDiaryModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import "WARNewUserDiaryModel.h"
#import "WARFriendMomentLayout.h"
#import "WARFeedModel.h"
#import "MJExtension.h"
#import "WARFeedComponentLayout.h"
#import "WARDBContactHelper.h"
#import "WARDBUserManager.h"
#import "WARFriendCommentLayout.h"

#define kLimitLikeCount 50

@implementation WARNewUserDiaryModel

+ (void)load{
    [WARNewUserDiaryModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{ @"moments" : [WARNewUserDiaryMoment class]};
    }];
}

@end

#pragma mark - WARNewUserDiaryMoment

@implementation WARNewUserDiaryMoment


- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, weather)] reduce:^id (NSString* weather){
            WARWeatherType type = WARWeatherTypeSunny;
            if ([weather isEqualToString:WEATHER_SUNNY]) {
                type = WARWeatherTypeSunny;
            }else if ([weather isEqualToString:WEATHER_CLOUDY]){
                type = WARWeatherTypeCloudy;
            }else if ([weather isEqualToString:WEATHER_RAIN]){
                type = WARWeatherTypeRain;
            }else{
                
            }
            return @(type);
        }] subscribeNext:^(NSNumber* type) {
            @strongify(self);
            self.weatherType = type.integerValue;
        }];
    }
    return self;
}
    
+ (void)load{
    [WARNewUserDiaryMoment mj_setupObjectClassInArray:^NSDictionary *{
        return @{ 
                 @"pageContents":[WARFeedPageModel class],
                 @"platforms":[NSString class],
                 @"thumbUsers":[WARNewUserDiaryThumbUser class]
                 };
    }];
}

- (void)mj_keyValuesDidFinishConvertingToObject { 
    //发布时间
    NSTimeInterval interval = [_publishTime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];  //HH:mm
    _publishTimeString = [formatter stringFromDate: date];
    
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
    
    //accountId 获取用户信息
    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId]; 
    
    //cell类型
    _cellType = (_pageContents.count == 1) ? WARFriendCellTypeSinglePage : WARFriendCellTypeMultiPage;
    
    //是否是自己发布的
    _isMine = [_accountId isEqualToString:[WARDBUserManager userModel].accountId];
    
    //点赞信息
    if (_thumbUsers.count > 0) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i = 0; i < kLimitLikeCount + 5; i++) {
//            [array addObject:_thumbUsers[0]];
//        }
//        _thumbUsers = array;
        [self buildThumbUsersAttributedContent:_thumbUsers];
    }
    
    //是否显示点赞的展开收起按钮
    _showLikeExtend = _thumbUsers.count > kLimitLikeCount;
}

- (void)setThumbUsers:(NSArray<WARNewUserDiaryThumbUser *> *)thumbUsers {
    _thumbUsers = thumbUsers;
    
//    if (_thumbUsers.count > 0) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i = 0; i < kLimitLikeCount + 5; i++) {
//            [array addObject:_thumbUsers[0]];
//        }
//        _thumbUsers = array;
//    }
    
    [self buildThumbUsersAttributedContent:_thumbUsers];
    
    //是否显示点赞的展开收起按钮
    _showLikeExtend = _thumbUsers.count > kLimitLikeCount;
}

- (void)buildThumbUsersAttributedContent:(NSArray<WARNewUserDiaryThumbUser *> *)thumbUsers  {
    NSArray<WARNewUserDiaryThumbUser *> *thumbUsersCopy = [thumbUsers copy];
    
    UIImage *image = [UIImage war_imageName:@"great_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = image;
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    NSMutableAttributedString *limitAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    for (int i = 0; i < thumbUsersCopy.count; i++) {
        WARNewUserDiaryThumbUser *model = thumbUsersCopy[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            if (i < kLimitLikeCount) {
                [limitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            }
        }
        
        NSAttributedString *attributedContent = [self generateAttributedStringWithLikeItemName:model.name accoundId:model.accountId];
        if (model.name == nil) {
            attributedContent = [self generateAttributedStringWithLikeItemName:model.getFriendModel.nickname accoundId:model.accountId];
        } 
        
        if (i < kLimitLikeCount) {
            [limitAttributedText appendAttributedString:attributedContent];
        }
        [attributedText appendAttributedString:attributedContent];
    }
    _thumbUsersAttributedContent = [attributedText mutableCopy];
    _limitThumbUsersAttributedContent = [limitAttributedText mutableCopy];
}

- (NSAttributedString *)generateAttributedStringWithLikeItemModel:(WARNewUserDiaryThumbUser *)model{

    WARDBContactModel *friendModel = [model getFriendModel];
    NSString *text =  [NSString stringWithFormat:@"%@",friendModel.nickname];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor clearColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.accountId} range:[text rangeOfString:text]];
    
    return attString;
}


/**
 入参不要为nil,否则会想哭

 @param name <#name description#>
 @param accountId <#accountId description#>
 @return <#return value description#>
 */
- (NSAttributedString *)generateAttributedStringWithLikeItemName:(NSString *)name accoundId:(NSString *)accountId{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",name]];
        UIColor *highLightColor = [UIColor clearColor];
    
    
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : accountId} range:[name rangeOfString:[NSString stringWithFormat:@"%@",name]]];
    
    return attString;
}

 
- (id)copyWithZone:(NSZone *)zone {
    WARNewUserDiaryMoment *model = [[WARNewUserDiaryMoment allocWithZone:zone] init];
    model.accountId = self.accountId;
    model.collectCount = self.collectCount;
    model.commentCount = self.commentCount;
    model.commentWrapper = self.commentWrapper;
    model.latitude = self.latitude;
    model.location = self.location;
    model.longitude = self.longitude;
    model.momentId = self.momentId;
    model.pageContents = self.pageContents;
    model.permission = self.permission;
    model.platforms = self.platforms;
    model.praiseCount = self.praiseCount;
    model.publishTime = self.publishTime;
    model.stepNum = self.stepNum;
    model.stepRank = self.stepRank;
    model.thumbUp = self.thumbUp;
    model.thumbUsers = self.thumbUsers; 
    model.weather = self.weather;
    model.thumbUsersAttributedContent = self.thumbUsersAttributedContent;
    model.limitThumbUsersAttributedContent = self.limitThumbUsersAttributedContent;
    
    model.momentLayout = self.momentLayout;
    model.friendMomentLayout = self.friendMomentLayout;
    model.friendModel = self.friendModel;
    model.publishTimeString = self.publishTimeString;
    model.cellType = self.cellType;
    model.momentShowType = self.momentShowType;
    model.weatherType = self.weatherType;
    model.isMine = self.isMine;
    return model;
}

@end


#pragma mark - WARNewUserDiaryThumbUser

@implementation WARNewUserDiaryThumbUser

- (void)setAccountId:(NSString *)accountId {
    _accountId = accountId; 
    
//    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
//    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
}

- (WARDBContactModel *)getFriendModel {
    return [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
}

@end


#pragma mark - WARNewUserDiaryCommentWrapper

@implementation WARNewUserDiaryCommentWrapper

+ (void)load{
    
    [WARNewUserDiaryCommentWrapper mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"comments":[WARNewUserDiaryComment class],
                 };
    }];
}

@end

#pragma mark - WARNewUserDiaryComment

@implementation WARNewUserDiaryComment

+ (void)load{
    [WARNewUserDiaryComment mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"medias":[WARNewUserDiaryMedia class],
                 };
    }];
}

- (NSString *)totalTitle {
    NSString *string;
    if (kObjectIsEmpty(_replyorInfo)) { //名字(_commentorInfo.nickname) + 内容(_title)
        NSString* commentUserName = kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname;
        NSString* content = kStringIsEmpty(_title) ? @"" : _title;
        string = [NSString stringWithFormat:@"%@ ：%@",commentUserName,  content];
    } else { //名字(_commentorInfo.nickname) 回复 + 内容(_title)
        NSString* commentUserName = kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname;
        NSString* replyUserName = kStringIsEmpty(_replyorInfo.nickname) ? @"" : _replyorInfo.nickname;
        NSString* content = kStringIsEmpty(_title) ? @"" : _title;
        string = [NSString stringWithFormat:@"%@ 回复 %@：%@",commentUserName, replyUserName, content];
    }
    
   
    return string;
}

@end

#pragma mark - WARNewUserDiaryVoice

@implementation WARNewUserDiaryVoice 
- (instancetype)init{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, voiceId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *voiceId) {
            @strongify(self);
            self.voiceURLStr = kVideoUrl(voiceId).absoluteString;
            self.voiceURL = kVideoUrl(voiceId);
        }];
    }
    return self;
}
@end

#pragma mark - WARNewUserDiaryUser

@implementation WARNewUserDiaryUser

@end

#pragma mark - WARNewUserDiaryMedia

@implementation WARNewUserDiaryMedia

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, imgId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *imgId) {
            @strongify(self);
            self.imageURL = kPhotoUrl(imgId);
            self.originalImgURL = kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, kScreenHeight), imgId);
        }];
        
        [[RACObserve(self, videoId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *videoId) {
            @strongify(self);
            self.videoURL = kVideoUrl(videoId);
        }];
    }
    return self;
}

@end

@implementation FriendCommentTextLinePositionModifier
- (instancetype)init {
    self = [super init];
    
    //    if (kiOS9Later) {
    //        _lineHeightMultiple = 1.34;   // for PingFang SC
    //    } else {
    _lineHeightMultiple = 1.3125; // for Heiti SC
    //    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    FriendCommentTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end
