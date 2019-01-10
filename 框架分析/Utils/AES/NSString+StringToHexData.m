//
//  NSString+StringToHexData.m
//  DataPool
//
//  Created by Yang on 2/11/15.
//  Copyright (c) 2015 GFI. All rights reserved.
//

#import "NSString+StringToHexData.h"

@implementation NSString (StringToHexData)
- (NSData *) stringToHexData{
    int len = [self length] / 2; // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

@end
