//
//  NSMutableAttributeString+range.h
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/15.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (range)

- (NSRange)rangeof:(NSString *)string after:(NSInteger)index;
@end
