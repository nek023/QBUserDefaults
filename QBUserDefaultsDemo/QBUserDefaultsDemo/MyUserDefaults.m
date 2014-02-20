//
//  MyUserDefaults.m
//  QBUserDefaultsDemo
//
//  Created by Tanaka Katsuma on 2014/02/20.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "MyUserDefaults.h"

@implementation MyUserDefaults

+ (NSDictionary *)defaults
{
    return @{
             @"foo": @"hoge",
             @"bar": @(1)
             };
}

@end
