//
//  PopAppointViewControllerToos.m
//  HeMeiHui
//
//  Created by 任为 on 2017/10/11.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "PopAppointViewControllerToos.h"

@implementation PopAppointViewControllerToos
static PopAppointViewControllerToos *tool;

+ (id)sharePopAppointViewControllerToos {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[self alloc] init];
        
    });
    return tool;
}

+(instancetype)shareTools
{
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return tool;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return tool;
}

/**
 找到改url应该得加载方式，是切换tab,还开新窗口，还是直接加载

 @param url <#url description#>
 @return <#return value description#>
 */
- (mianTab_type)isPopNewWindowWithcheckUrl:(NSString*)url{
      PopAppointViewControllerModel*appointModel = [NavigationContrl getModelFrom:url];
    PageUrlConfigModel *pageUrlmodel =  [NavigationContrl getPageurlModelFrom:url];
    if (!pageUrlmodel) {//如果根据url取不到主urlmodel 就根据 appointModel的pagetage 取 pageUrlmodel
        pageUrlmodel = [NavigationContrl getPageurlModelByPageTag:appointModel.pageTag];
    }
    if ([pageUrlmodel.tabbarName isEqualToString:@"main"]) {
        
        if ([pageUrlmodel.pageTag containsString:@"main_home"]) {//首页
            //跳到首页tab
            return main_home;
            
        }else if([pageUrlmodel.pageTag containsString:@"main_mall"]){//合发购
            //跳到合发购tab
            return main_mall;
            
        }else if ([pageUrlmodel.pageTag containsString:@"main_globalhome"]){//全球家
            
            return main_globalhome;
        }else if ([pageUrlmodel.pageTag containsString:@"main_OTO"]){//OTO
            
            return main_moments;
            
        }else if([pageUrlmodel.pageTag containsString:@"main_mine"]){//我的
            //跳到我的tab
            return main_mine;
            
        }
    }
  
    for (int i = 0; i<self.popWindowUrlsArrary.count; i++) {
        PopAppointViewControllerModel*model = self.popWindowUrlsArrary[i];
        if ([self validateCustomRegex:model.url TargetString:url]) {
            //正则匹配到
            if ([model.pageTag hasPrefix:@"main_"]) {
                continue;
            }
          if([[model.pageTag substringToIndex:3] containsString:@"fy_"]){//正则匹配非首页加载
                if ([model.pageTag containsString:@"main_home"]) {//首页
                    //跳到首页tab
                       self.currentPopModle = model;
                    return main_home;
                
                }else if([model.pageTag containsString:@"main_mall"]){//合发购
                    //跳到合发购tab
                       self.currentPopModle = model;
                    return main_mall;

                }else if ([model.pageTag containsString:@"main_globalhome"]){//全球家
                       self.currentPopModle = model;
                    return main_globalhome;
                }else if ([model.pageTag containsString:@"main_moments"]){//合友圈
                       self.currentPopModle = model;
                    return main_moments;
                    
                }else if([model.pageTag containsString:@"main_mine"]){//我的
                       self.currentPopModle = model;
                    //跳到我的tab
                    return main_mine;
                    
                }else if([model.pageTag isEqualToString:@"fy_external_domain"]||[model.pageTag isEqualToString:@"fy_kefu"]){
                     self.currentPopModle = model;
                    return external_domain;
                    
                }else {//匹配到，但是不是切换tab
                    self.currentPopModle = model;
                    return openNewPop;
                }
          }else{//匹配到，但是不是切换tab
              if ([url isEqualToString:[NSString stringWithFormat:@"%@/html/home/#/user/home",fyMainHomeUrl]]) {
                  return main_mine;
              }
               NSLog(@"tab---------------------%@",url );
              self.currentPopModle = model;
              return openNewPop;
          }
        }else if(i>=self.popWindowUrlsArrary.count-1){//没有匹配到，网页自己打开加载
            
            return loadByWebView;
        }
    }
    return loadByWebView;
}
// 类方法自定义正则验证
- (BOOL)validateCustomRegex:(NSString *)customRegex TargetString:(NSString *)targetString{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",customRegex];
    return [predicate evaluateWithObject:targetString];
}

@end
