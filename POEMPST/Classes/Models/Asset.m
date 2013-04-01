//
//  Assets.m
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "Asset.h"

@implementation Asset

- (void)OpenOrDownloadImages {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *diskAssetCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Data/Assets/%@.png", self.name]];

    if (![fileManager fileExistsAtPath:diskAssetCachePath])
    {
        //NSLog(@"dl %@%@", self.urlPath, key);
        
        [fileManager createFileAtPath:diskAssetCachePath contents:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlPath]] attributes:nil];
    }
    
    self.localPath = diskAssetCachePath;
    self.UIImage = [UIImage imageWithContentsOfFile:self.localPath];
}

@end
