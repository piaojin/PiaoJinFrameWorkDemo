### framework是Cocoa/Cocoa Touch程序中使用的一种资源打包方式，可以将将代码文件、头文件、资源文件、说明文档等集中在一起，方便开发者使用，作为一名Cocoa/Cocoa Touch程序员每天都要跟各种各样的Framework打交道。Cocoa/Cocoa Touch开发框架本身提供了大量的Framework，比如Foundation.framework/UIKit.framework/AppKit.framework等。需要注意的是，这些framework无一例外都是动态库。
 
### 但残忍的是，Cocoa Touch上并不允许我们使用自己创建的framework。不过由于framework是一种优秀的资源打包方式，拥有无穷智慧的程序员们便想出了以framework的形式打包静态库的招数，因此我们平时看到的第三方发布的framework无一例外都是静态库，真正的动态库是上不了AppStore的。
 
### WWDC2014给我的一个很大感触是苹果对iOS的开放态度：允许使用动态库、允许第三方键盘、App Extension等等，这些在之前是想都不敢想的事。
 
### iOS上动态库可以做什么
### 和静态库在编译时和app代码链接并打进同一个二进制包中不同，动态库可以在运行时手动加载，这样就可以做很多事情，比如：
 
* ### 应用插件化
### 目前很多应用功能越做越多，软件显得越来越臃肿。因此插件化就成了很多软件发展的必经之路，比如支付宝这种平台级别的软件：
![](http://www.cocoachina.com/cms/uploads/allimg/140613/8370_140613105121_1.png)

### 首页上密密麻麻的功能，而且还在增多，照这个趋势发展下去，软件包的大小将会不可想象。目前常用的解决方案是使用web页面，但用户体验和Native界面是没法比的。
 
### 设想，如果每一个功能点都是一个动态库，在用户想使用某个功能的时候让其从网络下载，然后手动加载动态库，实现功能的的插件化，就再也不用担心功能点的无限增多了，这该是件多么美好的事！
 
* ### 软件版本实时模块升级
### 还在忍受苹果动辄一周，甚至更长的审核周期吗？有了动态库妈妈就再也不用担心你的软件升级了！
 
### 如果软件中的某个功能点出现了严重的bug，或者想在其中新增功能，你的这个功能点又是通过动态库实现的，这时候你只需要在适当的时候从服务器上将新版本的动态库文件下载到本地，然后在用户重启应用的时候即可实现新功能的展现。
 
* ### 共享可执行文件
### 在其它大部分平台上，动态库都可以用于不同应用间共享，这就大大节省了内存。从目前来看，iOS仍然不允许进程间共享动态库，即iOS上的动态库只能是私有的，因为我们仍然不能将动态库文件放置在除了自身沙盒以外的其它任何地方。
 
### 不过iOS8上开放了App Extension功能，可以为一个应用创建插件，这样主app和插件之间共享动态库还是可行的。
 
#### PS： 上述关于动态库在iOS平台的使用，在技术上都是可行的，但本人并没有真正尝试过做出一个上线AppStore的应用，因此并不保证按照上述方式使用动态库一定能通过苹果审核！

> ## 创建动态库

![image.png](http://upload-images.jianshu.io/upload_images/3362328-e35b40996b9f365f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](http://upload-images.jianshu.io/upload_images/3362328-f4e604fa6b7fdbb4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 这边是PiaoJinDylib
> ## 创建你测试类PiaoJin
### 头文件部分
```
#import <Foundation/Foundation.h>

@interface PiaoJin : NSObject

- (void)love;

@end
```

### 实现部分
```
#import "PiaoJin.h"
#import <UIKit/UIKit.h>

@implementation PiaoJin

- (void)love{
    NSLog(@"love you more than I can say!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"love you more than I can say by 飘金!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
```

### 在PiaoJinDylib中引入
```
#import <UIKit/UIKit.h>

//! Project version number for PiaoJinDylib.
FOUNDATION_EXPORT double PiaoJinDylibVersionNumber;

//! Project version string for PiaoJinDylib.
FOUNDATION_EXPORT const unsigned char PiaoJinDylibVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PiaoJinDylib/PublicHeader.h>
#import "PiaoJin.h"
```

### 设置开放的头文件
一个库里面可以后很多的代码，但是我们需要设置能够提供给外界使用的接口，可以通过Target—>Build Phases—>Headers来设置，如下图所示：

![image.png](http://upload-images.jianshu.io/upload_images/3362328-df378f49549957f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 我们只需将希望开放的头文件放到Public列表中即可，比如我开放了Dylib.h和Person.h两个头文件，在生成的framework的Header目录下就可以看到这两个头文件.一切完成，Run以后就能成功生成framework文件了。

##前面只是我们只是创建了一个动态库文件，但是和静态库类似，该动态库并同时不支持真机和模拟器，可以通过以下步骤创建通用动态库：
 
> ## 创建Aggregate Target(PiaoJinDylib工程下)

![image.png](http://upload-images.jianshu.io/upload_images/3362328-a42784b6233d18b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![image.png](http://upload-images.jianshu.io/upload_images/3362328-40fce1ff119b9f02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 我给Aggregate的Target的命名是CommonDylib。
### 设置Target Dependencies
### 按以下路径设置CommonDylib对应的Target Dependencies:
```
TARGETS-->CommonDylib-->Build Phases-->Target Dependencies 
```
### 将真正的动态库PiaoJinDylib Target添加到其中。
 
### 添加Run Script
### 按以下路径为CommonDylib添加Run Script:
```
TARGETS-->CommonDylib-->Build Phases-->Run Script 
```
### 添加的脚本为：
```
# Sets the target folders and the final framework product. 
FMK_NAME=${PROJECT_NAME} 
 
# Install dir will be the final output to the framework. 
# The following line create it in the root folder of the current project. 
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework 
 
# Working dir will be deleted after the framework creation. 
WRK_DIR=build 
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework 
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework 
 
# -configuration ${CONFIGURATION}  
# Clean and Building both architectures. 
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build 
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build 
 
# Cleaning the oldest. 
if [ -d "${INSTALL_DIR}" ] 
then 
rm -rf "${INSTALL_DIR}" 
fi 
 
mkdir -p "${INSTALL_DIR}" 
 
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/" 
 
# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product. 
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}" 
 
rm -r "${WRK_DIR}" 
```

### 添加以后的效果:

![image.png](http://upload-images.jianshu.io/upload_images/3362328-6514287f8bf90891.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 脚本的主要功能是：
 
#### 1.分别编译生成真机和模拟器使用的framework；
#### 2.使用lipo命令将其合并成一个通用framework；
#### 3.最后将生成的通用framework放置在工程根目录下新建的Products目录下。
 
#### 如果一切顺利，对CommonDylib target执行run操作以后就能生成一个如图所示的通用framework文件了：

![image.png](http://upload-images.jianshu.io/upload_images/3362328-ab103ded0d2e6bab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](http://upload-images.jianshu.io/upload_images/3362328-e13d96b2257c6081.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> ## 使用动态库
### 实际过程中动态库是需要从服务器下载并且保存到app的沙盒中的,这边直接模拟已经下载好了动态库并且保存到沙盒中:

![image.png](http://upload-images.jianshu.io/upload_images/3362328-8a17ae2f015a295e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> ## 使用动态库
### 使用NSBundle加载动态库
```
- (IBAction)loadFrameWorkByBundle:(id)sender {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/Documents/PiaoJinDylib.framework",NSHomeDirectory()];
    
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *str = @"加载动态库失败!";
    if ([bundle loadAndReturnError:&err]) {
        NSLog(@"bundle load framework success.");
        str = @"加载动态库成功!";
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
```

### 使用dlopen加载动态库
### 以PiaoJinDylib.framework为例，动态库中真正的可执行代码为PiaoJinDylib.framework/PiaoJinDylib文件，因此使用dlopen时指定加载动态库的路径为PiaoJinDylib.framework/PiaoJinDylib。
```
 NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents/PiaoJinDylib.framework/PiaoJinDylib",NSHomeDirectory()]; 
[self dlopenLoadDylibWithPath:documentsPath];
    if (dlopen([path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW) == NULL) { 
        char *error = dlerror(); 
        NSLog(@"dlopen error: %s", error); 
    } else { 
        NSLog(@"dlopen load framework success."); 
 } 
```

> ## 调用动态库中的方法
```
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
```
### 监测动态库的加载和移除
### 我们可以通过下述方式，为动态库的加载和移除添加监听回调：
```
+ (void)load 
{ 
  _dyld_register_func_for_add_image(&image_added); 
  _dyld_register_func_for_remove_image(&image_removed); 
} 
```
### github上有一个完整的[示例代码](https://github.com/ddeville/ImageLogger)。

> ## 后记

### 这边只是一件最简单的例子,实际项目中肯定需要与动态库所代表的模块进行交互,数据的共享等等,这些都是需要去根据实际项目场景再去设计解决的!
### 如果是真机调试可以通过运行需打开iTunes导入到PiaoJinFrameWorkDemo应用中。

### 福建文档写的最烂的男人

### 参考文档：
[WWDC2014之iOS使用动态库](http://www.cocoachina.com/industry/20140613/8810.html)
