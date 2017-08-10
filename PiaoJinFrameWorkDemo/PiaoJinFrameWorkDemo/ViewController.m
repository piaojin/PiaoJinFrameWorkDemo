//
//  ViewController.m
//  PiaoJinFrameWorkDemo
//
//  Created by 飘金 on 2017/8/10.
//  Copyright © 2017年 cn.mjbang. All rights reserved.
//

#import "ViewController.h"
#import <dlfcn.h>
static void *libHandle = NULL;
@interface ViewController ()

@property (weak, nonatomic) NSBundle *bundle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//通过Bundle方式加载FrameWork
- (IBAction)loadFrameWorkByBundle:(id)sender {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/Documents/PiaoJinDylib.framework",NSHomeDirectory()];
    
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *str = @"加载动态库失败!";
    if ([bundle loadAndReturnError:&err]) {
        NSLog(@"bundle load framework success.");
        str = @"加载动态库成功!";
        self.bundle = bundle;
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}


- (IBAction)dlopenLoadDylibWithPath:(id)sender {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载(注意需要加上PiaoJinDylib)
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/Documents/PiaoJinDylib.framework/PiaoJinDylib",NSHomeDirectory()];
    libHandle = NULL;
    libHandle = dlopen([frameworkPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    NSString *str = @"加载动态库失败!";
    
    if (libHandle == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
    } else {
        NSLog(@"dlopen load framework success.");
        str = @"加载动态库成功!";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

//调用FrameWork的方法,利用runTime运行时
- (IBAction)callMethodOfFrameWork:(id)sender {
    Class piaoJinClass = NSClassFromString(@"PiaoJin");
    if(piaoJinClass){
        //事先要知道有什么方法在这个FrameWork中
        id object = [[piaoJinClass alloc] init];
        //由于没有引入相关头文件故通过performSelector调用
        [object performSelector:@selector(love)];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"调用方法失败!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];

    }
}

- (IBAction)unLoadFrameWork:(id)sender {
    if([self.bundle unload]){
        NSLog(@"释放成功!");
    }else{
        NSLog(@"释放失败!");
    }
}

- (IBAction)dlcloseFrameWork:(id)sender {
    int result = dlclose(libHandle);
    //为0表示释放成功
    if(result == 0){
        NSLog(@"释放成功!");
    }else{
        NSLog(@"释放失败!");
    }
}


@end
