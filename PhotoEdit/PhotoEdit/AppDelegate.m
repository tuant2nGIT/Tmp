//
//  AppDelegate.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "AppDelegate.h"
#import "LuuButEditViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"template_1" ofType:@"zip"];
    LuuButEditViewController *vc = [[LuuButEditViewController alloc] initWithTemplateAtPath:path];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setOpaque:NO];
        
        [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:94.0/255.0 green:72.0/255.0 blue:205.0/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:94.0/255.0 green:72.0/255.0 blue:205.0/255.0 alpha:1]] forBarMetrics:UIBarMetricsCompact];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    return YES;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0, 10.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
