//
//  WARFriendCommentVoiceView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import <UIKit/UIKit.h>
@class WARMomentVoice,WARFriendCommentVoiceView;

@interface WARFriendVoiceProgressView : UIView
- (void)drawProgress:(CGFloat )progress;
@end

@protocol WARFriendCommentVoiceViewDelegate <NSObject>
@optional

- (void)audioPlay:(WARMomentVoice *)audio sender:(UIButton*)sender voiceView:(WARFriendCommentVoiceView *)voiceView;
@end

@interface WARFriendCommentVoiceView : UIView
 
@property (nonatomic, strong) WARMomentVoice *voice;
@property (nonatomic, copy) NSString* voiceId;
@property (nonatomic, assign) float voiceDuration;
@property (nonatomic, strong) UIButton* playBtn;
@property (copy, nonatomic) void(^audioPlayBlock)(WARMomentVoice* audio, UIButton *sender, WARFriendCommentVoiceView* voiceView);

+ (CGSize)voiceViewSize;

- (void)pauseVoicePlay;

@property (nonatomic, weak) id <WARFriendCommentVoiceViewDelegate> delegate;

@end
