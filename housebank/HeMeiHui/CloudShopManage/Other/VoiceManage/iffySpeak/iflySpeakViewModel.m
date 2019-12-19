//
//  iflySpeakViewModel.m
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import "iflySpeakViewModel.h"
#import "IATConfig.h"
@implementation iflySpeakViewModel

/**
 parse JSON data
 params,for example：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 **/
- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}


/**
 parse JSON data for cloud grammar recognition
 **/
- (NSString *)stringFromABNFJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSArray *wordArray = [resultDic objectForKey:@"ws"];
    for (int i = 0; i < [wordArray count]; i++) {
        NSDictionary *wsDic = [wordArray objectAtIndex: i];
        NSArray *cwArray = [wsDic objectForKey:@"cw"];
        
        for (int j = 0; j < [cwArray count]; j++) {
            NSDictionary *wDic = [cwArray objectAtIndex:j];
            NSString *str = [wDic objectForKey:@"w"];
            NSString *score = [wDic objectForKey:@"sc"];
            [tempStr appendString: str];
            [tempStr appendFormat:@" Confidence:%@",score];
            [tempStr appendString: @"\n"];
        }
    }
    return tempStr;
}

- (void)initRecognizer {
    if (self.speakRecongizer == nil) {
        self.speakRecongizer = [IFlySpeechRecognizer sharedInstance];
        [self.speakRecongizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        [self.speakRecongizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        if (self.speakRecongizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //set timeout of recording
            [self.speakRecongizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //set VAD timeout of end of speech(EOS)
            [self.speakRecongizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //set VAD timeout of beginning of speech(BOS)
            [self.speakRecongizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //set network timeout
            [self.speakRecongizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //set sample rate, 16K as a recommended option
            [self.speakRecongizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            //set language
            [self.speakRecongizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //set accent
            [self.speakRecongizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            //set whether or not to show punctuation in recognition results
            [self.speakRecongizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
            [self initWtihPcmRecorder];
        }
        if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
            if([IATConfig sharedInstance].isTranslate){
                [self translation:NO];
            }
        }
        else{
            if([IATConfig sharedInstance].isTranslate){
                [self translation:YES];
            }
        }
    }
}

- (void)initWtihPcmRecorder {
    if (self.pcmRecorder == nil)
    {
        self.pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    [self.pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    [self.pcmRecorder setSaveAudioPath:nil];
}

-(void)translation:(BOOL) langIsZh
{
    [self.speakRecongizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_SCH]];
    if(langIsZh){
        [self.speakRecongizer setParameter:@"cn" forKey:@"orilang"];
        [self.speakRecongizer setParameter:@"en" forKey:@"translang"];
    }
    else{
        [self.speakRecongizer setParameter:@"en" forKey:@"orilang"];
        [self.speakRecongizer setParameter:@"cn" forKey:@"translang"];
    }
    [self.speakRecongizer setParameter:@"translate" forKey:@"addcap"];
    [self.speakRecongizer setParameter:@"its" forKey:@"trssrc"];
}
@end
