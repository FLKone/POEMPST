//
//  AppDelegate.m
//  POEMPST
//
//  Created by FLK on 31/03/13.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // DIRECTORIES
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *diskDataCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
	NSString *diskDataAssetsCachePath = [diskDataCachePath stringByAppendingPathComponent:@"Assets"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataAssetsCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataAssetsCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
	NSString *diskDataLayerCachePath = [diskDataCachePath stringByAppendingPathComponent:@"Layers"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataLayerCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataLayerCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    // DIRECTORIES
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
