//
//  WARFriendCommentLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentLayout.h"
#import "WARFriendComment.h"
#import "WARMacros.h"
#import "WARCommentsTool.h"
#import "UIColor+HEX.h"
#import "NSAttributedString+YYText.h"
#import "WARCFaceManager.h"
#import "WARTweetBaseTool.h"
#import "WARCommentTextLinePositionModifier.h"

static  float MediaMinWidth = 45.0;
static  float MediaMaxWidth = 110.0;
static float MediaMinHeight = 45.0;
static float MediaMaxHeight = 110.0;

@interface WARFriendCommentLayout()

@end

@implementation WARFriendCommentLayout

#pragma mark - 消息列表
+ (WARFriendCommentLayout *)commentMessageListLayout:(WARFriendComment *)comment {
    WARFriendCommentLayout *layout = [[WARFriendCommentLayout alloc]init];
    layout.isMessageListUsed = YES;
    
    layout.comment = comment;
    
    CGFloat paddingLeft = 0;
    CGFloat paddingTop = 6.5;
    
    // 评论回复cell的宽度
    CGFloat middleContentW = kScreenWidth - 67.5 - 84.5;
    
    layout.textLayout = nil;
    
    NSMutableAttributedString *text = [self _replyContentText:comment fontSize:14 textColor:HEXCOLOR(0x343C4F)];
//    if (text.length == 0) return layout;
    
    WARCommentTextLinePositionModifier *modifier = [WARCommentTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    modifier.paddingTop = 2;
    modifier.paddingBottom = 0;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(middleContentW, HUGE);
    container.linePositionModifier = modifier;
    
    layout.textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!layout.textLayout) return layout;
    
    CGFloat textHeight = [modifier heightForLineCount:layout.textLayout.rowCount];
    layout.contentLabelF = CGRectFlatMake(paddingLeft, 0, middleContentW, textHeight);
    
    CGFloat tempY = CGRectGetMaxY(layout.contentLabelF);
    
    // 视频或图片
    if (!kArrayIsEmpty(comment.medias)) { 
        CGFloat collectionViewY = tempY + paddingTop;
        WARMomentMedia *media = [comment.medias objectAtIndex:0];
        layout.collectionViewF = CGRectFlatMake(paddingLeft, collectionViewY, middleContentW, [media.imgH floatValue]);
        tempY = CGRectGetMaxY(layout.collectionViewF);
    }
    
    // 语音
    if(!kStringIsEmpty(comment.commentVoiceInfo.voiceId)){
        UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
        layout.playAudioBtnF = CGRectFlatMake(paddingLeft, tempY + paddingTop, img.size.width, img.size.height);
        tempY = CGRectGetMaxY(layout.playAudioBtnF);
    }
    
    layout.cellHeight = (tempY+paddingTop);
    
    return layout;
}

#pragma mark - 朋友圈表评论布局
+ (WARFriendCommentLayout *)commentLayout:(WARFriendComment *)comment
                        openCommentLayout:(BOOL)openCommentLayout {
    WARFriendCommentLayout *layout = [[WARFriendCommentLayout alloc]init];
    
    layout.comment = comment;
    
    CGFloat paddingLeft = 8;
    CGFloat paddingTop = 6.5;
    
    // 评论回复cell的宽度
    CGFloat middleContentW = kCommentContentWidth - kCommentMargin*2;
    
    layout.textLayout = nil;
    
    NSMutableAttributedString *text = [self _replyText:comment fontSize:15 textColor:HEXCOLOR(0x343C4F)];
    if (text.length == 0) return layout;
    
    WARCommentTextLinePositionModifier *modifier = [WARCommentTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:14.5];
    modifier.paddingTop = 2;
    modifier.paddingBottom = 0;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(middleContentW, HUGE);
    container.linePositionModifier = modifier;
    
    layout.textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!layout.textLayout) return layout;
    
    CGFloat textHeight = [modifier heightForLineCount:layout.textLayout.rowCount];
    layout.contentLabelF = CGRectFlatMake(paddingLeft, 0, middleContentW, textHeight);
    
    CGFloat tempY = CGRectGetMaxY(layout.contentLabelF);
    
    // 视频或图片
    if (!kArrayIsEmpty(comment.medias)) {
        CGFloat collectionViewY = tempY + paddingTop;
        layout.collectionViewF = CGRectFlatMake(paddingLeft, collectionViewY, middleContentW, kCommentReplyCellWH);
        tempY = CGRectGetMaxY(layout.collectionViewF);
    }
    
    // 语音
    if(!kStringIsEmpty(comment.commentVoiceInfo.voiceId)){
        UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
        layout.playAudioBtnF = CGRectFlatMake(paddingLeft, tempY + paddingTop, img.size.width, img.size.height);
        tempY = CGRectGetMaxY(layout.playAudioBtnF);
    }
    
    layout.cellHeight = (tempY+paddingTop);
    
    return layout;
}

#pragma mark - 关注详情评论布局
+ (WARFriendCommentLayout *)commentFollowDetailLayout:(WARFriendComment *)comment
                                    openCommentLayout:(BOOL)openCommentLayout {
    WARFriendCommentLayout *layout = [[WARFriendCommentLayout alloc]init];
    
    layout.comment = comment;
    
    CGFloat paddingLeft = 8;
    CGFloat paddingTop = 6.5;
    
    // 评论回复cell的宽度
    CGFloat middleContentW = kScreenWidth - kCellContentMargin*2;
    
    layout.textLayout = nil;
    
    NSMutableAttributedString *text = [self _replyText:comment fontSize:15 textColor:HEXCOLOR(0x343C4F)];
    if (text.length == 0) return layout;
    
    WARCommentTextLinePositionModifier *modifier = [WARCommentTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:14.5];
    modifier.paddingTop = 2;
    modifier.paddingBottom = 0;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(middleContentW, HUGE);
    container.linePositionModifier = modifier;
    
    layout.textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!layout.textLayout) return layout;
    
    CGFloat textHeight = [modifier heightForLineCount:layout.textLayout.rowCount];
    layout.contentLabelF = CGRectFlatMake(paddingLeft, 0, middleContentW, textHeight);
    
    CGFloat tempY = CGRectGetMaxY(layout.contentLabelF);
    
    // 视频或图片
    if (!kArrayIsEmpty(comment.medias)) {
        CGFloat collectionViewY = tempY + paddingTop;
        layout.collectionViewF = CGRectFlatMake(paddingLeft, collectionViewY, middleContentW, kCommentReplyCellWH);
        tempY = CGRectGetMaxY(layout.collectionViewF);
    }
    
    // 语音
    if(!kStringIsEmpty(comment.commentVoiceInfo.voiceId)){
        UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
        layout.playAudioBtnF = CGRectFlatMake(paddingLeft, tempY + paddingTop, img.size.width, img.size.height);
        tempY = CGRectGetMaxY(layout.playAudioBtnF);
    }
    
    layout.cellHeight = (tempY+paddingTop);
    
    return layout;
}


#pragma mark - 日志详情评论布局
+ (WARFriendCommentLayout *)commentDiaryDetailLayout:(WARFriendComment *)comment
                                   openCommentLayout:(BOOL)openCommentLayout {
    
    WARFriendCommentLayout *layout = [[WARFriendCommentLayout alloc]init];
    layout.comment = comment;
    
    CGFloat paddingLeft = 5;
    CGFloat paddingTop = 6.5;
    
    // 评论回复cell的宽度
    CGFloat middleContentW = kScreenWidth - kCellJournalMargin*2;
    
    //commentIcon
    CGFloat commentIconX = 12;
    CGFloat commentIconY = 15;
    CGFloat commentIconW = 14;
    CGFloat commentIconH = 14;
    CGRect commentIconFrame = CGRectMake(commentIconX, commentIconY, commentIconW, commentIconH);
    layout.commentIconF = commentIconFrame;
    
    //userIconView
    CGFloat userIconX = 8 + commentIconX + commentIconW;
    CGFloat userIconY = 15;
    CGFloat userIconW = 35;
    CGFloat userIconH = 35;
    CGRect userIconFrame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    layout.userIconF = userIconFrame;
    
    //name text
    layout.nameTextLayout = nil;
    NSMutableAttributedString *nameText = [self _replyNameText:comment fontSize:14 textColor:HEXCOLOR(0x343C4F)];
    if (nameText.length == 0) return layout;
    
    WARCommentTextLinePositionModifier *nameModifier = [WARCommentTextLinePositionModifier new];
    nameModifier.font = [UIFont fontWithName:@"Heiti SC" size:14];
    nameModifier.paddingTop = 2;
    nameModifier.paddingBottom = 0;
    
    YYTextContainer *nameContainer = [YYTextContainer new];
    nameContainer.size = CGSizeMake(middleContentW * 0.5, HUGE);
    nameContainer.linePositionModifier = nameModifier; 
    
    layout.nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText]; 

    CGFloat nameHeight = [nameModifier heightForLineCount:layout.nameTextLayout.rowCount];
    layout.nameLabelF = CGRectFlatMake(userIconX + 40, 15, middleContentW * 0.5, nameHeight);
    
    //time
    CGFloat timeW = 120;
    CGFloat timeH = 17;
    CGFloat timeX = middleContentW - timeW - kCellJournalMargin;
    CGFloat timeY = 15;
    layout.timeLableF = CGRectMake(timeX, timeY, timeW, timeH);
    
    //content text
    layout.contentTextLayout = nil;
    NSMutableAttributedString *text = [self _replyContentText:comment fontSize:14 textColor:HEXCOLOR(0x111111)];
    
    WARCommentTextLinePositionModifier *modifier = [WARCommentTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:14];
    modifier.paddingTop = 2;
    modifier.paddingBottom = 0;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(middleContentW - 84, HUGE);
    container.linePositionModifier = modifier;
    
    layout.contentTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!layout.contentTextLayout) return layout;
    
    CGFloat textHeight = [modifier heightForLineCount:layout.contentTextLayout.rowCount];
    layout.contentLabelF = CGRectFlatMake(userIconX + 40, CGRectGetMaxY(layout.nameLabelF) + 5, middleContentW - 84, textHeight);
    
    CGFloat tempY = CGRectGetMaxY(layout.contentLabelF);
    
    // 视频或图片
    if (!kArrayIsEmpty(comment.medias)) {
        CGFloat collectionViewY = tempY + paddingTop;
        layout.collectionViewF = CGRectFlatMake(userIconX + 40, collectionViewY, middleContentW - (userIconX + 40), kCommentReplyCellWH);
        tempY = CGRectGetMaxY(layout.collectionViewF);
    }
    
    // 语音
    if(!kStringIsEmpty(comment.commentVoiceInfo.voiceId)){
        UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
        layout.playAudioBtnF = CGRectFlatMake(userIconX + 40, tempY + paddingTop, img.size.width, img.size.height);
        tempY = CGRectGetMaxY(layout.playAudioBtnF);
    }
    
    layout.containerViewF = CGRectMake(kCellJournalMargin, 0, middleContentW, (tempY+paddingTop));
    
    layout.cellHeight = (tempY+paddingTop);
    
    return layout;
}

//- (void)setComment:(WARFriendComment *)comment {
//    _comment = comment;
//
//    CGFloat paddingLeft = 8;
//    CGFloat paddingTop = 6.5;
//
//    // 评论回复cell的宽度
//    CGFloat middleContentW = kCommentContentWidth - kCommentMargin*2;
//
//    _textLayout = nil;
//
//    NSMutableAttributedString *text = [self _replyText:comment fontSize:15 textColor:HEXCOLOR(0x000000)];
//    if (text.length == 0) return;
//
//    WARCommentTextLinePositionModifier *modifier = [WARCommentTextLinePositionModifier new];
//    modifier.font = [UIFont fontWithName:@"Heiti SC" size:14.5];
//    modifier.paddingTop = 2;
//    modifier.paddingBottom = 0;
//
//    YYTextContainer *container = [YYTextContainer new];
//    container.size = CGSizeMake(middleContentW, HUGE);
//    container.linePositionModifier = modifier;
//
//    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
//    if (!_textLayout) return;
//
//    CGFloat textHeight = [modifier heightForLineCount:_textLayout.rowCount];
//    _contentLabelF = CGRectFlatMake(paddingLeft, 0, middleContentW, textHeight);
//
//    CGFloat tempY = CGRectGetMaxY(_contentLabelF);
//
//    // 视频或图片
//    if (!kArrayIsEmpty(comment.medias)) {
//        CGFloat collectionViewY = tempY + paddingTop;
//        _collectionViewF = CGRectFlatMake(paddingLeft, collectionViewY, middleContentW, kCommentReplyCellWH);
//        tempY = CGRectGetMaxY(_collectionViewF);
//    }
//
//    // 语音
//    if(!kStringIsEmpty(comment.commentVoiceInfo.voiceId)){
//        UIImage *img = [WARCommentsTool commentsGetImg:@"voice_progress"];
//        _playAudioBtnF = CGRectFlatMake(paddingLeft, tempY + paddingTop, img.size.width, img.size.height);
//        tempY = CGRectGetMaxY(_playAudioBtnF);
//    }
//
//    _cellHeight = (tempY+paddingTop);
//}

#pragma mark - Private

- (NSMutableAttributedString *)_replyText:(WARFriendComment *)comment fontSize:(CGFloat)fontSize textColor:(UIColor*)color{
    
    if (!comment) return nil;
    NSMutableString *string = comment.totalTitle.mutableCopy;
    //NDLog(@"string = %@", string);
    if (string.length == 0) return nil;
    if (comment.whisper) {
        color = HEXCOLOR(0x502B9E);
    }
    
    // 字体
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithHexString:@"bfdffe"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = color;
      
    if (!kStringIsEmpty(comment.commentorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.commentorInfo.nickname options:kNilOptions range:searchRange];
        if (range.location == NSNotFound) return text;
        
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.commentorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
    }
    
    if (!kStringIsEmpty(comment.replyorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.replyorInfo.nickname options:NSBackwardsSearch range:searchRange];
        if (range.location == NSNotFound) return text;
        
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.replyorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
    }
    
    // 匹配 url
    NSArray *urlAddressResults = [[WARTweetBaseTool urlAddress] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *url in urlAddressResults) {
        if (url.range.location == NSNotFound && url.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:url.range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkURLName : [text.string substringWithRange:NSMakeRange(url.range.location, url.range.length)]};
            [text yy_setTextHighlight:highlight range:url.range];
        }
    }
    
    // 匹配表情
    NSArray<NSTextCheckingResult *> *emoticonResults = [[WARTweetBaseTool regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        UIImage *image = [WARCFaceManager faceImageWithFaceName:emoString];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize-2];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    return text;
}

+ (NSMutableAttributedString *)_replyText:(WARFriendComment *)comment fontSize:(CGFloat)fontSize textColor:(UIColor*)color{
    
    if (!comment) return nil;
    NSMutableString *string = comment.totalTitle.mutableCopy;
    //NDLog(@"string = %@", string);
    if (string.length == 0) return nil;
    
    // 字体
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithHexString:@"bfdffe"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = color;
    
    if (!kStringIsEmpty(comment.commentorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.commentorInfo.nickname options:kNilOptions range:searchRange];
        if (range.location == NSNotFound) return text;

        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            [text yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15] range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.commentorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
        
        //悄悄说文字颜色修改
        if (comment.whisper) {
            NSString *whisperString = [text.string componentsSeparatedByString:@"："].firstObject;
            NSRange searchWhisperRange = NSMakeRange(0, whisperString.length); ;
            NSRange whisperRange = [text.string rangeOfString:@"悄悄说" options:kNilOptions range:searchWhisperRange];
            if (whisperRange.location == NSNotFound) return text;
            
            [text yy_setColor:HEXCOLOR(0x737373) range:whisperRange];
            [text yy_setFont:font range:whisperRange];
        }
    }
    
    if (!kStringIsEmpty(comment.replyorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.replyorInfo.nickname options:NSBackwardsSearch range:searchRange];
        if (range.location == NSNotFound) return text;
        
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            [text yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15] range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.replyorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
        
        //悄悄说文字颜色修改
        if (comment.whisper) {
            NSString *whisperString = [text.string componentsSeparatedByString:@"："].firstObject;
            NSRange searchWhisperRange = NSMakeRange(0, whisperString.length); ;
            NSRange whisperRange = [text.string rangeOfString:@"悄悄说" options:kNilOptions range:searchWhisperRange];
            if (whisperRange.location == NSNotFound) return text;
            
            [text yy_setColor:HEXCOLOR(0x737373) range:whisperRange];
            [text yy_setFont:font range:whisperRange];
        }
    }
    
    //悄悄说的评论内容
    if (comment.whisper) {
        NSString *whisperString = [text.string componentsSeparatedByString:@"："].firstObject;
        NSString *commentContent = [text.string substringFromIndex:whisperString.length];
        NSRange commentContentRange = NSMakeRange(whisperString.length, commentContent.length);
        if (commentContentRange.location == NSNotFound) return text;
        
        [text yy_setColor:HEXCOLOR(0x502B9E) range:commentContentRange];
        [text yy_setFont:font range:commentContentRange];
    }
    
    // 匹配 url
    NSArray *urlAddressResults = [[WARTweetBaseTool urlAddress] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *url in urlAddressResults) {
        if (url.range.location == NSNotFound && url.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:url.range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkURLName : [text.string substringWithRange:NSMakeRange(url.range.location, url.range.length)]};
            [text yy_setTextHighlight:highlight range:url.range];
        }
    }
    
    // 匹配表情
    NSArray<NSTextCheckingResult *> *emoticonResults = [[WARTweetBaseTool regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        UIImage *image = [WARCFaceManager faceImageWithFaceName:emoString];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize-2];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    return text;
}


+ (NSMutableAttributedString *)_replyContentText:(WARFriendComment *)comment fontSize:(CGFloat)fontSize textColor:(UIColor*)color{
    
    if (!comment) return nil;
    NSMutableString *string = comment.contentTitle.mutableCopy;
    //NDLog(@"string = %@", string);
    
    if (comment.whisper) {
        color = HEXCOLOR(0x502B9E);
    }
    
    // 字体
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithHexString:@"bfdffe"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = color;
    
    // 匹配 url
    NSArray *urlAddressResults = [[WARTweetBaseTool urlAddress] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *url in urlAddressResults) {
        if (url.range.location == NSNotFound && url.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:url.range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkURLName : [text.string substringWithRange:NSMakeRange(url.range.location, url.range.length)]};
            [text yy_setTextHighlight:highlight range:url.range];
        }
    }
    
    // 匹配表情
    NSArray<NSTextCheckingResult *> *emoticonResults = [[WARTweetBaseTool regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        UIImage *image = [WARCFaceManager faceImageWithFaceName:emoString];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize-2];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    return text;
}


+ (NSMutableAttributedString *)_replyNameText:(WARFriendComment *)comment fontSize:(CGFloat)fontSize textColor:(UIColor*)color{
    
    if (!comment) return nil;
    NSMutableString *string = comment.nameTitle.mutableCopy;
    //NDLog(@"string = %@", string);
    if (string.length == 0) return nil;
    
    // 字体
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithHexString:@"bfdffe"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = color;
    
    if (!kStringIsEmpty(comment.commentorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.commentorInfo.nickname options:kNilOptions range:searchRange];
        if (range.location == NSNotFound) return text;
        
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.commentorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
    }
    
    if (!kStringIsEmpty(comment.replyorInfo.nickname)) {
        NSRange searchRange = NSMakeRange(0, text.string.length);
        NSRange range = [text.string rangeOfString:comment.replyorInfo.nickname options:NSBackwardsSearch range:searchRange];
        if (range.location == NSNotFound) return text;
        
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [text yy_setColor:HEXCOLOR(0x576B95) range:range];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{kLinkReplyName : comment.replyorInfo};
            [text yy_setTextHighlight:highlight range:range];
        }
    }
    return text;
}
@end



