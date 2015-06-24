//
//  LucDescriptorRegister.m
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import "LucDescriptorRegister.h"


@implementation LucDescriptorRegister

+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                mappingPara:(NSDictionary *)dic
                                                     method:(RKRequestMethod)requestType
                                                pathPattern:(NSString *)pathPattern
                                                    keyPath:(NSString *)keyPath
                                                statusCodes:(NSIndexSet *)statusCodes
                                   relationShipMappingClass:(NSArray *)array
{
    if (!array || array.count <= 0) {
        
        return [self responseDescriptorFotMappingClass:classname mappingPara:dic method:requestType keyPath:keyPath];
    }
    RKObjectMapping *entitymapping = [LucMappingProvider mappingForClass:classname mappingParas:dic withRelationshipMappingParas:array];
    
    return [self responseDescriptorFotMapping:entitymapping
                                       method:requestType
                                  pathPattern:pathPattern
                                      keyPath:keyPath
                                  statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                     method:(RKRequestMethod)requestType
                                                pathPattern:(NSString *)pathPattern
                                                    keyPath:(NSString *)keyPath
                                                statusCodes:(NSIndexSet *)statusCodes
                                   relationShipMappingClass:(NSArray *)array
{
    if (!array || array.count <= 0) {
        return [self responseDescriptorFotMappingClass:classname
                                           mappingPara:nil
                                                method:requestType
                                               keyPath:keyPath];
    }
    RKObjectMapping *entitymapping = [LucMappingProvider mappingForClass:classname withRelationshipMappingParas:array];
    
    return [self responseDescriptorFotMapping:entitymapping
                                       method:requestType
                                  pathPattern:pathPattern
                                      keyPath:keyPath
                                  statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)responseDescriptorFotMappingClass:(NSString *)classname
                                                mappingPara:(NSDictionary *)dic
                                                     method:(RKRequestMethod)requestType
                                                    keyPath:(NSString *)keyPath
{
    RKObjectMapping *entitymapping = [LucMappingProvider mappingForClass:classname mappingParas:dic];

    return [self responseDescriptorFotMapping:entitymapping
                                       method:requestType
                                  pathPattern:nil
                                      keyPath:keyPath
                                  statusCodes:nil];
}

+ (RKResponseDescriptor *)responseDescriptorFotMapping:(RKObjectMapping *)mapping
                                                method:(RKRequestMethod)requestType
                                           pathPattern:(NSString *)pathPattern
                                               keyPath:(NSString *)keyPath
                                           statusCodes:(NSIndexSet *)statusCodes
{
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:requestType
                                                                                       pathPattern:pathPattern
                                                                                           keyPath:keyPath
                                                                                       statusCodes:statusCodes];
    return responseDescriptor;
}
@end
