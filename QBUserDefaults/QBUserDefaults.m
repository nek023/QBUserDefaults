//
//  QBUserDefaults.m
//  QBUserDefaults
//
//  Created by Tanaka Katsuma on 2014/02/20.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "QBUserDefaults.h"
#import <objc/runtime.h>

@interface QBUserDefaults ()

@property (nonatomic, strong) NSMutableArray *observingKeys;

@end

@implementation QBUserDefaults

+ (NSDictionary *)defaults
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Initialize
        self.observingKeys = [NSMutableArray array];
        
        // Add observers to all properties
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
        
        for (int i = 0; i < propertyCount; i++) {
            // Get property name
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            [self addObserverForKey:key];
        }
        
        free(properties);
    }
    
    return self;
}

- (void)dealloc
{
    // Remove all observers
    for (NSString *key in [self.observingKeys copy]) {
        [self removeObserverForKey:key];
    }
}


#pragma mark - Managing Defaults

- (NSString *)defaultNameForKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@.%@.%@", [[NSBundle mainBundle] bundleIdentifier], NSStringFromClass([self class]), key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:[self defaultNameForKey:key]];
    [userDefaults synchronize];
}

- (id)objectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:[self defaultNameForKey:key]];
}

- (NSArray *)allPropertyKeys
{
    return [self.observingKeys copy];
}

- (NSArray *)allKeys
{
    NSMutableArray *allKeys = [NSMutableArray array];
    
    for (NSString *key in self.observingKeys) {
        [allKeys addObject:[self defaultNameForKey:key]];
    }
    
    return allKeys;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.observingKeys) {
        [dictionary setObject:[self objectForKey:key]
                       forKey:[self defaultNameForKey:key]];
    }
    
    return [dictionary copy];
}


#pragma mark - Object Subscriting

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    if ([(NSString *)key isKindOfClass:[NSString class]]) {
        return [self objectForKey:(NSString *)key];
    }
    
    return nil;
}

- (void)setObject:(id) object forKeyedSubscript:(id <NSCopying>)key {
    if ([(NSString *)key isKindOfClass:[NSString class]]) {
        [self setObject:object forKey:(NSString *)key];
    }
}


#pragma mark - Key-Value Observing

- (void)addObserverForKey:(NSString *)key
{
    if ([self.observingKeys containsObject:key]) {
        return;
    }
    
    [self.observingKeys addObject:key];
    
    // Port values from NSUserDefaults
    id value = [self objectForKey:key];
    
    // Load default if value is nil
    if (value == nil) {
        value = [[[self class] defaults] objectForKey:key];
    }
    
    // Set value to property if value is not nil
    if (value) {
        [self setValue:value forKeyPath:key];
    }
    
    // Add observer
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForKey:(NSString *)key
{
    if ([self.observingKeys containsObject:key]) {
        // Remove observer
        [self removeObserver:self forKeyPath:key];
        [self.observingKeys removeObject:key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setObject:change[@"new"] forKey:keyPath];
}

@end
