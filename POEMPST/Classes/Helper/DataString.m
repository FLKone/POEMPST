//
//  DataString.m
//  POEMPST
//
//  Created by FLK on 02/04/13.
//

#import "DataString.h"

@implementation DataString

- (id)init {
	self = [super init];
	if (self) {
        self.position = 0;
        //self.string = @"";
        
	}
	return self;
}

-(int)bytesToInt16:(NSArray *)e {
    return [self bytesToInt:e andT:2];
}

-(int)bytesToInt:(NSArray *)e andT:(int)t {
    
    //NSLog(@"bytesToInt e = %@\nbytesToInt t = %d", e, t);
    
    if (!t) t = 4;
    
    //NSLog(@"bytesToInt t = %d", t);
    
    int n = 0;
    for (int r = 0; r < t; ++r){
        n += [[e objectAtIndex:r] intValue], r < t - 1 && (n <<= 8);
    }

    
    //NSLog(@"FINAL n = %d", n);
    
    return n;
}

-(BOOL)hasData {
    
    return (self.position < self.string.length);
}

-(NSData *)getDataString {
    return self.string;
}

-(void)setDataString:(NSData *)e {
    
    self.string = e;
}


-(int)readInt8 {
    return [self readInt:1];
}

-(int)readInt16 {
    return [self readInt:2];
}

-(int)readInt:(int)e {
    //NSLog(@"e1 %d", e);
    
    if (!e) e = 4;

   // NSLog(@"e2 %d", e);
    
    int t = self.position + e;
    
    //NSLog(@"readInt B p = %d", self.position);
    
    //NSLog(@"readInt t = %d", t);
    
    if (t > self.string.length) {
        NSLog(@"Integer read exceeds bounds");
        return -1;
    }

    //NSLog(@"string %@", self.string);
    
    NSMutableArray *bytes = [NSMutableArray array];
    for (; self.position < t; ++self.position) {
        //NSLog(@"readInt 0 p = %d", self.position);
        
        unsigned char byte;
        [self.string getBytes:&byte range:NSMakeRange(self.position, 1)];
        
        NSString *stringByte = [NSString stringWithFormat:@"%x", byte];
        
        //NSLog(@"byte %d - %hu", self.position, [stringByte characterAtIndex:0]);

        int value = 0;
        sscanf([stringByte cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        //[newString appendFormat:@"%c", (char)value];
        
        //NSLog(@"byte %d - %c", value, (char)value);

        [bytes addObject:[NSString stringWithFormat:@"%d", value]];
        
        //NSLog(@"readInt 1 p = %d", self.position);
    }
    
    //NSLog(@"readInt A p = %d", self.position);
    
    //NSLog(@"bytes %@", bytes);

    return [self bytesToInt:bytes andT:e];
}

@end
