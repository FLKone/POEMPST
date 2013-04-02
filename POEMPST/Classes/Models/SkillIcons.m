//
//  SkillIcons.m
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillIcons.h"

static NSString *urlPath = @"http://www.pathofexile.com/image/build-gen/passive-skill-sprite/";

@implementation SkillIcons

- (id)init {
	self = [super init];
	if (self) {
        self.skillPositions = [NSMutableDictionary dictionary];
        self.images = [NSMutableDictionary dictionary];

	}
	return self;
}

- (void)OpenOrDownloadImages {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *diskAssetsCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Assets"];
    
    NSArray* keys = [self.images allKeys];
    for( NSString *key in keys ) {

        if (![fileManager fileExistsAtPath:[diskAssetsCachePath stringByAppendingPathComponent:key]])
		{
			//NSLog(@"dl %@%@", self.urlPath, key);
			
			[fileManager createFileAtPath:[diskAssetsCachePath stringByAppendingPathComponent:key] contents:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlPath, key]]] attributes:nil];
		}
        
        //NSLog(@"path %@", [diskAssetsCachePath stringByAppendingPathComponent:key]);
        [self.images setValue:[UIImage imageWithContentsOfFile:[diskAssetsCachePath stringByAppendingPathComponent:key]] forKey:key];
		
        //self.UIImage = [UIImage imageWithContentsOfFile:self.localPath];

    }
    
    //NSLog(@"self.images %@", self.images);
}
@end
