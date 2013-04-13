//
//  Assets.h
//  POEMPST
//
//  Created by FLK on 01/04/13.
//

#import <Foundation/Foundation.h>

@interface Asset : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) UIImage *UIImage;

- (void)OpenOrDownloadImages;

@end