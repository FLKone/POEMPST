//
//  constants.h
//  POEMPST
//
//  Created by FLK on 01/04/13.
//

#ifndef POEMPST_constants_h
#define POEMPST_constants_h

#define NSLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

typedef enum {
	kNormal,
    kNotable,
	kKeystone
} IconType;

#define SkillOverlayID 1
#define SkillLinkID 1

#define Zoom 2.61f
#define MiniScale 2
#define StrokeWidth 10
#define TouchLayerScaleDown 0.85
#define TouchLayerScaleUp   1.00

#define MaxZoom 2.01f

#define BTNID           100000000
#define MARAUDERBTNID   100000000
#define RANGERBTNID     200000000
#define WITCHBTNID      300000000
#define DUELISTBTNID    400000000
#define TEMPLARBTNID    500000000
#define SIXBTNID        600000000
#define ACTIVEFACEID    600000010

#define MAXSKILLS       120

#define LOADSTEP11      0.05f    //base
#define LOADSTEP1       0.10f   //after sprites
#define LOADSTEP2       0.15f   //after sprites
#define LOADSTEP3       0.30f   //after assets
#define LOADSTEP4       0.40f   //endparsing assets
#define LOADSTEP5       0.55f   //after drawBG
#define LOADSTEP6       0.70f   //after skill
#define LOADSTEP7       0.85f   //after links
#define LOADSTEP8       0.95f    //after touch
#define LOADSTEP9       1.00f    //after touch

static float skillsPerOrbit[] = {1.0f   , 6.0f  , 12.0f     , 12.0f     , 12.0f};
static float orbitRadii[] =     {0.0f   , 83.5f , 163.0f    , 336.0f    , 489.0f};

#endif

#import "apikey.h"

//Vendor
#import "Crittercism.h"
//#import "TestFlight.h"
#import "SFObservers.h"
#import "AFNetworking.h"
#import "RegexKitLite.h"
#import "JSONKit.h"
#import "PESGraph.h"
#import "PESGraphEdge.h"
#import "PESGraphNode.h"
#import "PESGraphRoute.h"

#import "UIImage+WBImage.h"
#import "NSData+Base64.h"
#import "base64.h"

//Helper
#import "DataString.h"
#import "UIView+Image.h"
#import "URLTextField.h"
#import "CustomPopoverBackgroundView.h"
#import "UIScrollView+ZoomToPoint.h"

//Models
#import "SkillIcons.h"
#import "SkillNode.h"
#import "NodeGroup.h"
#import "Asset.h"

//Views
#import "ViewController.h"
#import "SkillTreeView.h"
#import "SkillLinksView.h"
#import "SkillLinkView.h"
#import "SkillTouchView.h"

//Controllers
#import "SkillSelectionViewController.h"
