//
//  WARMomentRemind.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARMomentRemind.h"
#import "ReactiveObjC.h" 
#import "NSDate+Profile.h"
#import "MJExtension.h"
#import "YYText.h"
#import "WARMacros.h"

@implementation WARMomentRemind

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, commentType)] reduce:^id (NSString* commentType){
            WARMomentRemindType remindTypeEnum = WARMomentRemindTypeDefault;
            if ([commentType isEqualToString:WARMoment_Remind_Comment]) {
                remindTypeEnum = WARMomentRemindTypeComment;
            }else if ([commentType isEqualToString:WARMoment_Remind_Thumb]){
                remindTypeEnum = WARMomentRemindTypeThumb;
            } else{
                
            }
            return @(remindTypeEnum);
        }] subscribeNext:^(NSNumber* remindTypeEnum) {
            @strongify(self);
            self.remindTypeEnum = remindTypeEnum.integerValue;
        }];
    }
    return self;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
    //发布时间
    _commentTimeDesc = [NSDate bch_timeInfoWithTimeInterval:_commentTime];
    
    //name
    if (_replyorInfo.nickname) {
        NSMutableAttributedString *nameAttributeString = [[NSMutableAttributedString alloc] initWithString:_replyorInfo.nickname];
        nameAttributeString.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        nameAttributeString.yy_color = HEXCOLOR(0x576B95);
        if (_whisper) {
            NSMutableAttributedString *whisperAttri = [[NSMutableAttributedString alloc] initWithString:@"悄悄说"];
            whisperAttri.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            whisperAttri.yy_color = HEXCOLOR(0x8D93A4);
            [nameAttributeString appendAttributedString:whisperAttri];
            
        }
        _nameAttributeString = nameAttributeString;
    }
    
}

@end
