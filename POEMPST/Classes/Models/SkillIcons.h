//
//  SkillIcons.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillIcons : NSObject

@property (nonatomic, strong) NSMutableDictionary *skillPositions;
@property (nonatomic, strong) NSMutableDictionary *images;
@property IconType iconType;
@property (nonatomic, strong) NSString *urlPath;

- (void)OpenOrDownloadImages;

@end
