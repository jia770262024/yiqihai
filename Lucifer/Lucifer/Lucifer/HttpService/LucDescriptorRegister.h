//
//  LucDescriptorRegister.h
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RestKit/RestKit.h>
#import "RestKit.h"
#import "LucMappingProvider.h"

@interface LucDescriptorRegister : NSObject

/**
 返回一个Restkit的Objectmapping的描述器
 
 @param classname 关系映射到实体类
 @param dic 实体类和返回数据结构的映射关系（自定义，若无，则使用默认的bindkey）
 @param keyPath 映射到实体类的路径
 @param array 实体类的属性 是否包含另一个实体类
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @return An `RKResponseDescriptor` object.
 */
+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                mappingPara:(NSDictionary *)dic
                                                     method:(RKRequestMethod)requestType
                                                pathPattern:(NSString *)pathPattern
                                                    keyPath:(NSString *)keyPath
                                                statusCodes:(NSIndexSet *)statusCodes
                                   relationShipMappingClass:(NSArray *)array;

/**
 返回一个Restkit的Objectmapping的描述器(无需自定义实体类和返回数据结构的映射关系，使用默认的bindkeys)
 @param classname 关系映射到实体类
 @param keyPath 映射到实体类的路径
 @param array 实体类的属性 是否包含另一个实体类
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @return An `RKResponseDescriptor` object.
 */
+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                     method:(RKRequestMethod)requestType
                                                pathPattern:(NSString *)pathPattern
                                                    keyPath:(NSString *)keyPath
                                                statusCodes:(NSIndexSet *)statusCodes
                                   relationShipMappingClass:(NSArray *)array;

/**
 返回一个Restkit的Objectmapping的描述器
 @param dic 实体类和返回数据结构的映射关系（自定义，若无，则使用默认的bindkey）
 @param classname 关系映射到实体类
 @param keyPath 映射到实体类的路径
 @param array 实体类的属性 是否包含另一个实体类
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @return An `RKResponseDescriptor` object.
 */
+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                mappingPara:(NSDictionary *)dic
                                                     method:(RKRequestMethod)requestType
                                                    keyPath:(NSString *)keyPath;

@end
