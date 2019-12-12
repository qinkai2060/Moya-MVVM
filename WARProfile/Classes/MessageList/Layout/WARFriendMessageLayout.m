//
//  WARFriendMessageLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFriendMessageLayout.h"
#import "WARMacros.h"
#import "NSString+Size.h"

static CGFloat kContentLeftRightMargin = 11.5;
static CGFloat kContentTopBottomMargin = 9;
static CGFloat kSubContentLableMaxHeight = 65;
 

static  float MediaMinWidth = 45.0;
static  float MediaMaxWidth = 110.0;
static float MediaMinHeight = 45.0;
static float MediaMaxHeight = 110.0;

@implementation WARFriendMessageLayout

+ (WARFriendMessageLayout *)remindLayout:(WARMomentRemind *)remind {
    WARFriendMessageLayout *layout = [[WARFriendMessageLayout alloc] init];
    layout.remind = remind;
 
    //userIconF
    CGFloat userIconX = kContentLeftRightMargin;
    CGFloat userIconY = kContentTopBottomMargin;
    CGFloat userIconW = 47;
    CGFloat userIconH = 47;
    layout.userIconF = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    
    //nameLabelF
    CGFloat nameLabelX = userIconX + userIconW + 9;
    CGFloat nameLabelY = 12;
    CGFloat nameLabelW = 200;
    CGFloat nameLabelH = 14;
    layout.nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    //subContentIconF
    CGFloat subContentIconW = 60;
    CGFloat subContentIconH = 60;
    CGFloat subContentIconX = kScreenWidth - kContentLeftRightMargin - subContentIconW;
    CGFloat subContentIconY = kContentTopBottomMargin;
    layout.subContentIconF = CGRectMake(subContentIconX, subContentIconY, subContentIconW, subContentIconH);
    
    //subContentVideoIconF
    CGFloat subContentVideoIconW = 20;
    CGFloat subContentVideoIconH = 13;
    CGFloat subContentVideoIconX = 4;
    CGFloat subContentVideoIconY = subContentIconH - 4 - subContentVideoIconH;
    layout.subContentVideoIconF = CGRectMake(subContentVideoIconX, subContentVideoIconY, subContentVideoIconW, subContentVideoIconH);
    
    //subContentLableF
    CGFloat subContentLableX = subContentIconX;
    CGFloat subContentLableY = subContentIconY;
    CGFloat subContentLableW = 55;
    CGFloat subContentLableH = 0;
    switch (remind.moment.bodyTypeEnum) {
        case WARMomentRemindBodyTypeText:
        {
            subContentLableH = [remind.moment.bodyAttributeString boundingRectWithSize:CGSizeMake(subContentLableW, kSubContentLableMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        }
            break;
        case WARMomentRemindBodyTypeLink:
        {
            subContentLableH = [remind.moment.linkBodyAttributeString boundingRectWithSize:CGSizeMake(subContentLableW, kSubContentLableMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        }
            break;
        default:
        {
            
        }
            break;
    }
    layout.subContentLableF = CGRectMake(subContentLableX, subContentLableY, subContentLableW, subContentLableH > kSubContentLableMaxHeight ? kSubContentLableMaxHeight : subContentLableH);
    
    //commentViewF
    CGFloat commentViewX = userIconX + userIconW + 9;
    CGFloat commentViewY = nameLabelY + nameLabelH + 3;
    CGFloat commentViewW = kScreenWidth - commentViewX - (kContentLeftRightMargin + subContentIconW) - 9;
    CGFloat commentViewH = 0;
    if (remind.commentsLayoutArr.count > 0) {
        WARFriendCommentLayout *commentLayout = remind.commentsLayoutArr.firstObject;
        commentViewH = commentLayout.cellHeight;
    }
    layout.commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
    
//    //commentContentLableF
//    CGFloat commentContentLableX = userIconX + userIconW + 9;
//    CGFloat commentContentLableY = nameLabelY + nameLabelH + 8;
//    CGFloat commentContentLableW = kScreenWidth - commentViewX - (kContentLeftRightMargin + subContentIconW) - 9;
//    CGFloat commentContentLableH = 0;
//    if (remind.commentBody.title.length > 0) {
//        commentContentLableH = [remind.commentBody.title heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] constrainedToWidth:commentContentLableW];
//    }
//    layout.commentContentLableF = CGRectMake(commentContentLableX, commentContentLableY, commentContentLableW, commentContentLableH);
//
//    //commentContentMediaF
//    CGFloat commentContentMediaX = userIconX + userIconW + 9;
//    CGFloat commentContentMediaY = commentContentLableY + commentContentLableH + ( commentContentLableH > 0 ? 4 : 0);
//    CGFloat commentContentMediaW = 0;
//    CGFloat commentContentMediaH = 0;
//    if (remind.commentBody.medias.count > 0) {
//        WARMomentMedia *media = remind.commentBody.medias.firstObject;
//        commentContentMediaW = [media.imgW floatValue];
//        commentContentMediaH = [media.imgH floatValue];
//    }
//    layout.commentContentMediaF = CGRectMake(commentContentMediaX, commentContentMediaY, commentContentMediaW, commentContentMediaH);
    
    //praiseIconF
    CGFloat praiseIconX = userIconX + userIconW + 9;
    CGFloat praiseIconY = nameLabelY + nameLabelH + 8;
    CGFloat praiseIconW = 17;
    CGFloat praiseIconH = 17;
    layout.praiseIconF = CGRectMake(praiseIconX, praiseIconY, praiseIconW, praiseIconH);
    
    //timeLableF
    CGFloat timeLableX = userIconX + userIconW + 9;
    CGFloat timeLableY = MAX(CGRectGetMaxY(layout.commentViewF), CGRectGetMaxY(layout.praiseIconF)) + 8;
//    CGFloat timeLableY = MAX(CGRectGetMaxY(layout.commentContentMediaF), CGRectGetMaxY(layout.praiseIconF)) + 8;
    CGFloat timeLableW = 200;
    CGFloat timeLableH = 13;
    layout.timeLableF = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    
    layout.lineF = CGRectMake(12, timeLableY + timeLableH + kContentTopBottomMargin - 0.5, kScreenWidth - 24, 0.5);
    
    layout.cellHeight = MAX(CGRectGetMaxY(layout.timeLableF), CGRectGetMaxY(layout.subContentLableF)) + kContentTopBottomMargin;
    
    return layout;
}

@end
