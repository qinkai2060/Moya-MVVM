//
//  WARActivationExplorationLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARActivationExplorationLayout.h"
#import "WARMacros.h"
#import "WARFeedMacro.h"
#import "NSString+Size.h"

@implementation WARActivationExplorationLayout

+ (WARActivationExplorationLayout *)layoutWithActivationExploration:(WARActivationExploration *)activationExploration {
    WARActivationExplorationLayout *layout = [[WARActivationExplorationLayout alloc]init];
    layout.activationExploration = activationExploration;
    
    WARMomentTrackInfoLayout *trackInfoLayout = [WARMomentTrackInfoLayout layoutWithTraceInfo:activationExploration.traceInfo];
    layout.trackInfoLayout = trackInfoLayout;
    
    /// 足迹宽高
    CGFloat trackWidth = kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin;
    CGFloat trackHeight = 66;
    
    /// userHeaderF
    CGFloat userImageX = kCellContentMargin;
    CGFloat userImageY = 14;
    CGFloat userImageW = kUserImageWidthHeight;
    CGFloat userImageH = kUserImageWidthHeight;
    layout.userHeaderF = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    /// timeF
    CGFloat timeW = 70;
    CGFloat timeH = 12;
    CGFloat timeX = kScreenWidth - kCellContentMargin - timeW;
    CGFloat timeY = 18;
    layout.timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    //nameLable
    CGFloat nameLableX = userImageX + userImageW + kUserImageContentMargin;
    CGFloat nameLableY = 16.5;
    CGFloat nameLableH = 16;
    CGFloat nameLableW = trackWidth - timeW - 20;//[[NSString stringWithFormat:@"%@",activationExploration.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    layout.userNameF = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
     
    /// trackF
    CGFloat trackX = kFeedMainContentLeftMargin;
    CGFloat trackY = userImageY + userImageH + 9;
    layout.trackF = CGRectMake(trackX, trackY, trackWidth, trackHeight);
    
    layout.lineF = CGRectMake(0, trackY + trackHeight + 15, kScreenWidth, 0.5);
    
    return layout;
}

@end
