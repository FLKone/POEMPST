//
//  constants.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#ifndef POEMPST_constants_h
#define POEMPST_constants_h

#define NSLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

typedef enum {
	kNormal,
    kNotable,
	kKeystone
} IconType;

#define SkillSpriteID 10000000
#define SkillOverlayID 1
#define Zoom 2.61f
#define MiniScale 2
#define StrokeWidth 10

static float skillsPerOrbit[] = {1.0f   , 6.0f  , 12.0f     , 12.0f     , 12.0f};
static float orbitRadii[] =     {0.0f   , 83.5f , 163.0f    , 336.0f    , 489.0f};

#endif



//Vendor
#import "AFNetworking.h"
#import "RegexKitLite.h"
#import "JSONKit.h"

#import "UIImage+WBImage.h"
#import "NSData+Base64.h"
#import "base64.h"

//Helper
#import "DataString.h"
#import "UIView+Image.h"

//Models
#import "SkillIcons.h"
#import "SkillNode.h"
#import "NodeGroup.h"
#import "Asset.h"

//Views
#import "SkillTreeView.h"
#import "SkillLinksView.h"
#import "SkillLinkView.h"