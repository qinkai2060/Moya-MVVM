//
//  HFTextField.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFTextField.h"

@implementation HFTextField
- (void)paste:(id)sender {
    self.text = [self pasteStr:[[UIPasteboard generalPasteboard] string]];  
}
- (NSString *)pasteStr:(NSString *)string {
    NSString* spaceStr = @" ";
    NSMutableString *mStrTemp = [NSMutableString string];
    
    int spaceCount = 0;
    if (string.length < 3 && string.length > -1) {
        spaceCount = 0;
    }else if (string.length < 7&& string.length > 2){
        spaceCount = 1;
    }else if (string.length < 12&& string.length > 6){
        spaceCount = 2;
    }
    for (int i = 0; i < spaceCount; i++){
        if (i == 0) {
            [mStrTemp appendFormat:@"%@%@", [string substringWithRange:NSMakeRange(0, 3)],spaceStr];
        }else if (i == 1){
            [mStrTemp appendFormat:@"%@%@", [string substringWithRange:NSMakeRange(3, 4)], spaceStr];
            if(string.length == 7) {
                [mStrTemp deleteCharactersInRange:NSMakeRange(8, 1)];
            }
        }else if (i == 2){
            [mStrTemp appendFormat:@"%@%@", [string substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
    }
    
    if (string.length == 11){
        [mStrTemp appendFormat:@"%@%@", [string substringWithRange:NSMakeRange(7, 4)], spaceStr];
    }
    
    if (string.length < 4 && string.length > 0){
        [mStrTemp appendString:[string substringWithRange:NSMakeRange(string.length-string.length % 3,string.length % 3)]];
    }else if(string.length > 3){
        NSString *str = [string substringFromIndex:3];
        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,str.length % 4)]];
        if (string.length == 11){
            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }

    return [mStrTemp copy];
}
@end
