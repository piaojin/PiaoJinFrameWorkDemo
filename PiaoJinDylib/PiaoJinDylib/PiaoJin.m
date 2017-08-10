//
//  PiaoJin.m
//  PiaoJinDylib
//
//  Created by 飘金 on 2017/8/10.
//  Copyright © 2017年 cn.mjbang. All rights reserved.
//

#import "PiaoJin.h"
#import <UIKit/UIKit.h>

@implementation PiaoJin

- (void)love{
    NSLog(@"love you more than I can say!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"love you more than I can say by 飘金!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
