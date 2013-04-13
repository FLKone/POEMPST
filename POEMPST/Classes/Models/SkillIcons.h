//
//  SkillIcons.h
//  POEMPST
//
//  Created by FLK on 01/04/13.
//

#import <Foundation/Foundation.h>

@interface SkillIcons : NSObject

@property (nonatomic, strong) NSMutableDictionary *skillPositions;
@property (nonatomic, strong) NSMutableDictionary *images;
@property IconType iconType;

- (void)OpenOrDownloadImages;

@end
