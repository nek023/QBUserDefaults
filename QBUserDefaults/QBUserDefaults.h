//
//  QBUserDefaults.h
//  QBUserDefaultsDemo
//
//  Created by Tanaka Katsuma on 2014/02/20.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUserDefaults : NSObject

+ (NSDictionary *)defaults;

- (NSString *)defaultNameForKey:(NSString *)key;
- (NSArray *)allPropertyKeys;
- (NSArray *)allKeys;
- (NSDictionary *)dictionaryRepresentation;

@end
