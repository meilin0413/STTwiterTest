//
//  NSMutableAttributeString+range.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/15.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "NSMutableAttributeString+range.h"

@implementation NSString (range)

- (NSRange)rangeof:(NSString *)string after:(NSInteger)index
{
    const char *c = [self UTF8String];
    const char *findString = [string UTF8String];
    NSRange range = {NSNotFound,0};
    
    NSInteger findIndex = 0;
    for (NSInteger i = index; i < [self length]; i++)
    {
        
        if (c[i] == findString[findIndex])
        {
            if (range.location == NSNotFound)
            {
                range.location = i;
            }
            findIndex++;
            if (findIndex >= [string length])
            {
                return range;
            }
        }
        else
        {
            i = i - findIndex;
            findIndex = 0;
            range.location = NSNotFound;
        }
    }
    return range;
}
//- (NSArray *)findURLWith:(NSString *)string
//{
//    const char *c = [self UTF8String];
//    const char *findString = [string UTF8String];
//    for(NSInteger index = 0; index <[self length]; index++)
//    {
//        
//    }
//}
@end
