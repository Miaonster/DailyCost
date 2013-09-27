//
//  UUID.m
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "UUID.h"

@implementation UUID

+ (NSString *)randomUUID {
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid uppercaseString]);
}

@end
