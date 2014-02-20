//
//  AppDelegate.m
//  QBUserDefaultsDemo
//
//  Created by Tanaka Katsuma on 2014/02/20.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "AppDelegate.h"

#import "MyUserDefaults.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MyUserDefaults *userDefaults = [[MyUserDefaults alloc] init];
    
    NSLog(@"foo: %@", userDefaults.foo);
    NSLog(@"bar: %ld", userDefaults.bar);
    
    userDefaults.foo = @"piyo";
    userDefaults.bar = 2;
    
    NSLog(@"foo: %@", userDefaults.foo);
    NSLog(@"bar: %ld", userDefaults.bar);
}

@end
