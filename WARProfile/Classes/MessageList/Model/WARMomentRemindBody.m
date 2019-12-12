//
//  WARMomentRemindBody.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARMomentRemindBody.h"
#import "ReactiveObjC.h"
#import "MJExtension.h"
#import "UIImage+WARBundleImage.h"
#import "YYText.h"
#import "WARMacros.h"

@implementation WARMomentRemindBody
  
- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, type)] reduce:^id (NSString* type){
            WARMomentRemindBodyType bodyTypeEnum = WARMomentRemindBodyTypeText;
            if ([type isEqualToString:WARMoment_RemindBody_Text]) {
                bodyTypeEnum = WARMomentRemindBodyTypeText;
            }else if ([type isEqualToString:WARMoment_RemindBody_Link]){
                bodyTypeEnum = WARMomentRemindBodyTypeLink;
            }else if ([type isEqualToString:WARMoment_RemindBody_Picture]){
                bodyTypeEnum = WARMomentRemindBodyTypePicture;
            }else if ([type isEqualToString:WARMoment_RemindBody_Video]){
                bodyTypeEnum = WARMomentRemindBodyTypeVideo;
            }else{
                
            }
            return @(bodyTypeEnum);
        }] subscribeNext:^(NSNumber* bodyTypeEnum) {
            @strongify(self);
            self.bodyTypeEnum = bodyTypeEnum.integerValue;
        }];
    }
    return self;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    //cell 右侧文本内容
    UIImage *image = [UIImage war_imageName:@"link_w" curClass:[self class] curBundle:@"WARProfile.bundle"];
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = image;
    attach.bounds = CGRectMake(0, -3, 17, 17);
    NSAttributedString *linkIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *linkBodyAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:linkIcon];
    NSMutableAttributedString *bodyAttributeString = [[NSMutableAttributedString alloc] init];
    
    if (_body && _body.length > 0) {
        NSMutableAttributedString *linkBodyAttri = [[NSMutableAttributedString alloc] initWithString:_body];
        linkBodyAttri.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        linkBodyAttri.yy_color = HEXCOLOR(0x575C68);
        [linkBodyAttributeString appendAttributedString:linkBodyAttri];
        
        NSMutableAttributedString *bodyAttri = [[NSMutableAttributedString alloc] initWithString:_body];
        bodyAttri.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        bodyAttri.yy_color = HEXCOLOR(0x343C4F);
        [bodyAttributeString appendAttributedString:bodyAttri];
    } else {
        [linkBodyAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [bodyAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    _linkBodyAttributeString = linkBodyAttributeString;
    _bodyAttributeString = bodyAttributeString;
}

@end
