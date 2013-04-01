//
//  Assets.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Asset : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) UIImage *UIImage;

- (void)OpenOrDownloadImages;

@end