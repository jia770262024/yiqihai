//
//  LucMappingProvider.m
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import "LucMappingProvider.h"
#import <objc/runtime.h>
//#import "User.h"
//多级映射 key-实体类名
#define kRSMClass @"kRSMClass"
//多级映射 key-实体类映射 Source key
#define kRSMFromKeyPath @"kRSMFromKeyPath"
//多级映射 key-实体类映射 Destination key
#define kRSMToKeyPath @"kRSMToKeyPath"

//多级映射
#define kRSMKeys @"kRSMKeys"

#define kRSMNextSeriesArray @"kRSMNextSeriesArray"

@implementation LucMappingProvider

+ (RKObjectMapping *)mappingForClass:(NSString *)className
{
    RKObjectMapping* entityMapping = [RKObjectMapping mappingForClass:[NSClassFromString(className) class] ];
    Class entityClass = NSClassFromString(className);
    SEL sel = NSSelectorFromString(@"bindKeys");
    IMP imp = [entityClass methodForSelector:sel];
    NSDictionary *dic1 = imp(entityClass, sel, YES, YES);
    [entityMapping addAttributeMappingsFromDictionary:dic1];
    return entityMapping;
}

+ (RKObjectMapping *)mappingForClass:(NSString *)className mappingParas:(NSDictionary *)dic
{
    if (!dic || dic.count <= 0) {
        return [self mappingForClass:className];
    } else {
        RKObjectMapping* entityMapping = [RKObjectMapping mappingForClass:[NSClassFromString(className) class] ];
        [entityMapping addAttributeMappingsFromDictionary:dic];
        return entityMapping;
    }
}

+ (RKObjectMapping *)mappingForClass:(NSString *)classname
  withRelationshipMappingFromKeyPath:(NSString *)fromPath
                           toKeyPath:(NSString *)toPath
                     andMappingClass:(NSString *)relationshipClassName
{
    RKObjectMapping *entityMapping = [self mappingForClass:classname];
    RKObjectMapping *relationShipMapping = [self mappingForClass:relationshipClassName];
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:fromPath
                                                                                  toKeyPath:toPath
                                                                                withMapping:relationShipMapping]];
    return entityMapping;
}


+ (RKObjectMapping *)mappingForClass:(NSString *)classname
                        mappingParas:(NSDictionary *)dic
  withRelationshipMappingFromKeyPath:(NSString *)fromPath
                           toKeyPath:(NSString *)toPath
                     andMappingClass:(NSString *)relationshipClassName
{
    RKObjectMapping *entityMapping = [self mappingForClass:classname mappingParas:dic];
    RKObjectMapping *relationShipMapping = [self mappingForClass:relationshipClassName];
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:fromPath
                                                                                  toKeyPath:toPath
                                                                                withMapping:relationShipMapping]];
    return entityMapping;
}


+ (RKObjectMapping *)mappingForClass:(NSString *)className
        withRelationshipMappingParas:(NSArray *)relationArrays
{
    RKObjectMapping *entityMapping = [self mappingForClass:className];
    if (!relationArrays || relationArrays.count <= 0) {
        return entityMapping;
    }
    for (NSDictionary *relationMappingDic in relationArrays) {
        NSString *relationshipMappingClass = [relationMappingDic objectForKey:kRSMClass];
        NSString *relationshipMappingFromKeyPath = [relationMappingDic objectForKey:kRSMFromKeyPath];
        NSString *relationshipMappingToKeyPath = [relationMappingDic objectForKey:kRSMToKeyPath];
        NSArray *nextSeriesRelationMappingArray = [relationMappingDic objectForKey:kRSMNextSeriesArray];
        NSDictionary *mappingbindKeys = [relationMappingDic objectForKey:kRSMKeys];
        RKObjectMapping *relationObjMapping = nil;
        if (!mappingbindKeys || mappingbindKeys.count <= 0) {
            relationObjMapping = [self mappingForClass:relationshipMappingClass withRelationshipMappingParas:nextSeriesRelationMappingArray];
        } else {
            relationObjMapping = [self mappingForClass:relationshipMappingClass mappingParas:mappingbindKeys withRelationshipMappingParas:nextSeriesRelationMappingArray];
        }
        [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:relationshipMappingFromKeyPath
                                                                                      toKeyPath:relationshipMappingToKeyPath
                                                                                    withMapping:relationObjMapping]];
    }
    return entityMapping;
}


+ (RKObjectMapping *)mappingForClass:(NSString *)className
                        mappingParas:(NSDictionary *)dic
        withRelationshipMappingParas:(NSArray *)relationArrays
{
    RKObjectMapping *entityMapping = [self mappingForClass:className mappingParas:dic];
    if (!relationArrays || relationArrays.count <= 0) {
        return entityMapping;
    }
    for (NSDictionary *relationMappingDic in relationArrays) {
        NSString *relationshipMappingClass = [relationMappingDic objectForKey:kRSMClass];
        NSString *relationshipMappingFromKeyPath = [relationMappingDic objectForKey:kRSMFromKeyPath];
        NSString *relationshipMappingToKeyPath = [relationMappingDic objectForKey:kRSMToKeyPath];
        NSArray *nextSeriesRelationMappingArray = [relationMappingDic objectForKey:kRSMNextSeriesArray];
        NSDictionary *mappingbindKeys = [relationMappingDic objectForKey:kRSMKeys];
        RKObjectMapping *relationObjMapping = nil;
        if (!mappingbindKeys || mappingbindKeys.count <= 0) {
            relationObjMapping = [self mappingForClass:relationshipMappingClass withRelationshipMappingParas:nextSeriesRelationMappingArray];
        } else {
            relationObjMapping = [self mappingForClass:relationshipMappingClass mappingParas:mappingbindKeys withRelationshipMappingParas:nextSeriesRelationMappingArray];
        }
        [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:relationshipMappingFromKeyPath
                                                                                      toKeyPath:relationshipMappingToKeyPath
                                                                                    withMapping:relationObjMapping]];
    }
    return entityMapping;
}

+ (NSArray *)propertiesForClass:(Class) aClass
{
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    for (unsigned int i = 0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNamesArr addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArr;
}



@end
