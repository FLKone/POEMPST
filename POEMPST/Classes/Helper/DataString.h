//
//  DataString.h
//  POEMPST
//
//  Created by FLK on 02/04/13.
//

#import <Foundation/Foundation.h>

@interface DataString : NSObject

@property int position;
@property (nonatomic, strong) NSData *string;

-(int)bytesToInt16:(NSArray *)e;
-(int)bytesToInt:(NSArray *)e andT:(int)t;

-(BOOL)hasData;

-(NSData *)getDataString;
-(void)setDataString:(NSData *)e;

-(int)readInt8;
-(int)readInt16;
-(int)readInt:(int)e;

@end
