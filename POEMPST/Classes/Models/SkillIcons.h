//
//  SkillIcons.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SkillIcons : NSObject

@property (nonatomic, retain) NSMutableDictionary *skillPositions;
@property (nonatomic, retain) NSMutableDictionary *images;
@property IconType iconType;
@property (nonatomic, retain) NSString *urlPath;

- (void)OpenOrDownloadImages;

@end
