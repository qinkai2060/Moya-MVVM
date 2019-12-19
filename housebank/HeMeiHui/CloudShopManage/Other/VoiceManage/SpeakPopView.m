//
//  SpeakPopView.m
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import "SpeakPopView.h"
#import <Lottie/Lottie.h>
#import "IATConfig.h"
#import "iflySpeakViewModel.h"
@interface SpeakPopView ()<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>
@property (nonatomic, strong) UILabel * alertLabel;
@property (nonatomic, strong) LOTAnimationView *launchAnimation;
@property (nonatomic, strong) UIView *launchMask;
@property (nonatomic, strong) iflySpeakViewModel * speakViewModel;
@end
@implementation SpeakPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.voiceView];
        [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.width.equalTo(@(WScale(200)));
            make.height.equalTo(@38);
        }];
        
        [self addSubview:self.alertLabel];
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.voiceView.mas_top).offset(-14);
            make.height.equalTo(@20);
        }];
        
        [self addSubview:self.launchMask];
        [self.launchMask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.alertLabel.mas_top).offset(-30);
            make.width.equalTo(@254);
            make.height.equalTo(@(WScale(49)));
        }];
        
        [self.launchMask addSubview:self.launchAnimation];
        [self.launchAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.launchMask);
        }];
        
        [self addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.launchMask.mas_top).offset(-30);
            make.height.equalTo(@30);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.missBlock) {
        self.missBlock();
    }
}

- (void)clearPopView {
    self.topLabel.text = @"";
    self.launchAnimation.hidden = YES;
    [self.launchAnimation pause];
}

- (void)changeTopLabelStatus:(NSString *)voiceString {
    
    [self.launchAnimation pause];
    [self.speakViewModel.speakRecongizer stopListening];
    self.topLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    if (voiceString.length > 0) {
        if ([voiceString isEqualToString:@"。"]) {
            return;
        }
        self.topLabel.text = voiceString;
        if (self.callBackBlock) {
            self.callBackBlock(self.topLabel.text);
        }
    }else {
        self.topLabel.text = @"未检出到语音";
        self.topLabel.textColor = [UIColor colorWithHexString:@"#FF0000"];
    }
    self.topLabel.hidden = NO;
}

/** 开始识别*/
- (void)touchDidBegan {
    if (self.begainBlock) {
        self.begainBlock();
    }
   self.alertLabel.hidden = NO;
   self.voiceView.voiceBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
   self.topLabel.text = @"";
    if (self.launchMask && self.launchAnimation) {
        self.launchAnimation.hidden = NO;
        if (self.speakViewModel.speakRecongizer == nil) {
            [self.speakViewModel initRecognizer];
        }
        [self.speakViewModel.speakRecongizer cancel];
        [self.speakViewModel.speakRecongizer setDelegate:self];
        self.speakViewModel.pcmRecorder.delegate = self;
        [self.speakViewModel.speakRecongizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        [self.speakViewModel.speakRecongizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        [self.speakViewModel.speakRecongizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        BOOL ret = [self.speakViewModel.speakRecongizer startListening];
        if (ret) {
            self.voiceView.voiceBtn.enabled = NO;
        }
        @weakify(self);
        [self.launchAnimation playWithCompletion:^(BOOL animationFinished) {
        @strongify(self);
        [self.launchAnimation play];
        }];
    }
}

/** 在区域内*/
- (void)touchupglide {
    self.alertLabel.text = @"松开手指，取消搜索";
    
    [self.speakViewModel.speakRecongizer cancel];
    [self.speakViewModel.speakRecongizer stopListening];
}

/**不在区域内*/
- (void)touchDown {
   self.alertLabel.text = @"手指上划 取消搜索";
}

/** 松开*/
- (void)touchDidEnd {
    self.alertLabel.text = @"手指上划 取消搜索";
    self.alertLabel.hidden = YES;
    [self.launchAnimation pause];
    self.launchAnimation.hidden = YES;
    [self.speakViewModel.speakRecongizer stopListening];
    if (self.endBlock) {
        self.endBlock();
    }
    self.voiceView.voiceBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

/** IFlySpeechRecognizerDelegate协议实现*/
//识别结果返回代理
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSLog(@"%@",resultString);
    NSString * resultFromJson =  nil;
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
       [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [self.speakViewModel stringFromJson:resultString];
    }
    [self changeTopLabelStatus:resultFromJson];
}

//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{
    self.voiceView.voiceBtn.enabled = YES;
}

//停止录音回调
- (void) onEndOfSpeech{
//    [self.speakViewModel.pcmRecorder stop];
    [self.speakViewModel.speakRecongizer stopListening];
}

//开始录音回调
- (void) onBeginOfSpeech{
}

//音量回调函数
- (void) onVolumeChanged: (int)volume{
}
//会话取消回调
- (void) onCancel{
    self.topLabel.hidden = YES;
    self.voiceView.voiceBtn.enabled = YES;
}
- (void)dealloc {
    [self.speakViewModel.speakRecongizer setDelegate:nil];
    [self.speakViewModel.speakRecongizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [self.speakViewModel.speakRecongizer cancel];
    [self.speakViewModel.speakRecongizer stopListening];
}

#pragma mark - IFlyPcmRecorderDelegate
- (void)onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size {
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    int ret = [self.speakViewModel.speakRecongizer writeAudio:audioBuffer];
    if (!ret){
        [self.speakViewModel.speakRecongizer stopListening];
        [self.voiceView.voiceBtn setEnabled:YES];
    }
}

- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error{
}

//range from 0 to 30
- (void) onIFlyRecorderVolumeChanged:(int) power{
}

#pragma mark -- lazy load
- (VoiceTouchView *)voiceView {
    if (!_voiceView) {
        _voiceView = [[VoiceTouchView alloc]init];
        _voiceView.areaY = -40;//设置滑动高度
        _voiceView.clickTime = 0.5;//设置长按时间
        __weak typeof(self) weakSelf = self;
        _voiceView.touchBegan = ^(){
            [weakSelf touchDidBegan];
        };
        _voiceView.upglide = ^(){
            [weakSelf touchupglide];
        };
        _voiceView.down = ^(){
            [weakSelf touchDown];
        };
        _voiceView.touchEnd = ^(){
            [weakSelf touchDidEnd];
        };
    }
    return _voiceView;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [UILabel new];
        _alertLabel.text = @"手指上划 取消搜索";
        _alertLabel.textColor = [UIColor colorWithHexString:@"#4D88FF"];
        _alertLabel.font = kFONT(14);
        _alertLabel.hidden = YES;
    }
    return _alertLabel;
}

- (UIView *)launchMask {
    if (!_launchMask) {
        _launchMask = [UIView new];
    }
    return _launchMask;
}

- (LOTAnimationView *)launchAnimation {
    if (!_launchAnimation) {
        _launchAnimation = [LOTAnimationView animationNamed:@"data"];
        _launchAnimation.cacheEnable = NO;
        _launchAnimation.contentMode = UIViewContentModeScaleAspectFit;
        _launchAnimation.animationSpeed = 1;
        _launchAnimation.hidden = YES;
    }
    return _launchAnimation;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _topLabel.font = kFONT(20);
    }
    return _topLabel;
}

- (iflySpeakViewModel *)speakViewModel {
    if (!_speakViewModel) {
        _speakViewModel = [[iflySpeakViewModel alloc]init];
        _speakViewModel.speakRecongizer.delegate = self;
    }
    return _speakViewModel;
}

@end
