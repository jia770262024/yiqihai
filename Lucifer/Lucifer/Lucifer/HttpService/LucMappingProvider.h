//
//  LucMappingProvider.h
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RestKit/RestKit.h>
#import "RestKit.h"


@interface LucMappingProvider : NSObject

/**
 适合简单的mapping结构，只有一级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)className;

/**
 适合简单的mapping结构，只有一级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @param dic 数据直接映射到实体类所需要的键值对
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)className
                        mappingParas:(NSDictionary *)dic;

/**
 适合两级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @param fromPath 返回的数据结构中的keypath
 @param toPath 实体类的属性，将fromPath的数据映射到实体类
 @param relationshipClassName classname实体类的属性的类名
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)classname
  withRelationshipMappingFromKeyPath:(NSString *)fromPath
                           toKeyPath:(NSString *)toPath
                     andMappingClass:(NSString *)relationshipClassName;


/**
 适合两级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @param fromPath 返回的数据结构中的keypath
 @param toPath 实体类的属性，将fromPath的数据映射到实体类
 @param relationshipClassName classname实体类的属性的类名
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)classname
                        mappingParas:(NSDictionary *)dic
  withRelationshipMappingFromKeyPath:(NSString *)fromPath
                           toKeyPath:(NSString *)toPath
                     andMappingClass:(NSString *)relationshipClassName;

/**
 适合多级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @param relationArrays 实体类属性，以及属性的属性的mapping关系
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)className
        withRelationshipMappingParas:(NSArray *)relationArrays;


/**
 适合多级的映射结构
 @param className 实体类的类名，返回的数据直接映射到实体类
 @param relationArrays 实体类属性，以及属性的属性的mapping关系
 @return An `RKObjectMapping` object.
 */
+ (RKObjectMapping *)mappingForClass:(NSString *)className
                        mappingParas:(NSDictionary *)dic
        withRelationshipMappingParas:(NSArray *)relationArrays;

@end
