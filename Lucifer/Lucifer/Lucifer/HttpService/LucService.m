//
//  LucService.m
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#import "LucService.h"

@implementation LucError

+ (id)bindErrorKeys
{
    return @{
             @"code": @"errCode",
             @"message": @"errMessage"
             };
}

@end

@interface LucService ()
{
    //请求队列 key是requstIdentifer，方便取消请求
    NSMutableDictionary *requestDic;
}
@end

@implementation LucService

#pragma mark - sigle instance
+ (LucService *)sharesService
{
    static dispatch_once_t pred;
    static LucService *_service;
    dispatch_once(&pred, ^{
        _service = [[LucService alloc]init];
    });
    return _service;
}

- (void)setBaseURL:(NSString *)baseURL
{
    _baseURL = baseURL;
    [self initRestkit:baseURL];
}

//设置http的header
- (void)setHttpHeader:(NSDictionary *)headerDic
{
    AFHTTPClient* client = [[RKObjectManager sharedManager] HTTPClient];
    for (NSString *key in [headerDic allKeys]) {
        
        [client setDefaultHeader:key value:headerDic[key]];

    }
}

- (void)clearHeaders
{
    AFHTTPClient* client = [[RKObjectManager sharedManager] HTTPClient];
    [client clearAuthorizationHeader];
}

#pragma mark - custom methods
//初始化restkit的base url
- (void)initRestkit:(NSString *)baseurl
{
    //存放请求列表的
    requestDic = [NSMutableDictionary new];
    //初始化restkit
    NSURL *baseURL = [NSURL URLWithString:baseurl];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    //服务器的body只接收json形式的参数
    [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
}

- (NSMutableURLRequest *)requestForPath:(NSString *)path
                             parameters:(NSDictionary *)paras
                                 method:(RKRequestMethod)method
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    return [objectManager requestWithObject:nil method:RKRequestMethodPOST path:path parameters:paras];
}

- (void)cancleRequestWithIdentifer:(NSString *)reqIdentifer
{
    RKObjectRequestOperation *operation = [requestDic objectForKey:reqIdentifer];
    [operation cancel];
    [requestDic removeObjectForKey:reqIdentifer];
}



#pragma mark - public methods
//post请求方法
- (void)doPostRequest:(NSString *)path
           parameters:(NSDictionary *)paras
         MappingClass:(NSString *)className
          mappingPara:(NSDictionary *)mappingdic
              keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
      requestIdentify:(NSString *)reId
              success:(SuccessBlock)success
                error:(ErrorBlock)errorMessage
{
    [self doRequest:path
             method:RKRequestMethodPOST
         parameters:paras
       MappingClass:className
        mappingPara:mappingdic
            keyPath:mappingkeyPath
relationShipMappingClass:propertityMapping
    requestIdentify:reId
            success:^(NSArray *deals) {
                success(deals);
            }
              error:^(NSError *error) {
                  errorMessage(error);
              }];
}

- (void)doGetRequest:(NSString *)path
           parameters:(NSDictionary *)paras
         MappingClass:(NSString *)className
          mappingPara:(NSDictionary *)mappingdic
              keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
      requestIdentify:(NSString *)reId
              success:(SuccessBlock)success
                error:(ErrorBlock)errorMessage
{
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    [self doRequest:path
             method:RKRequestMethodGET
         parameters:paras
       MappingClass:className
        mappingPara:mappingdic
            keyPath:mappingkeyPath
relationShipMappingClass:propertityMapping
    requestIdentify:reId
            success:^(NSArray *deals) {
                success(deals);
            }
              error:^(NSError *error) {
                  errorMessage(error);
              }];
}


- (void)doGetRequestWithURL:(NSString *)url
                 parameters:(NSDictionary *)paras
               MappingClass:(NSString *)className
                mappingPara:(NSDictionary *)mappingdic
                    keyPath:(NSString *)mappingkeyPath
   relationShipMappingClass:(NSArray *)propertityMapping
            requestIdentify:(NSString *)reId
                    success:(SuccessBlock)success
                      error:(ErrorBlock)errorMessage
{
    if ([requestDic objectForKey:reId]) {
        return;
    }
    NSString *paraStr = nil;
    if (paras && paras.count > 0) {
        paraStr = @"?";
        for (id obj in paras.allKeys) {
            if ([paras[obj] isKindOfClass:[NSString class]]) {
                paraStr = [paraStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",obj,paras[obj]]];
            }
        }
    }
    if (paraStr && paraStr.length > 1) {
        url = [url stringByAppendingString:paraStr];
        url = [url stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    }
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                         method:RKRequestMethodGET
                                                                                    pathPattern:nil
                                                                                        keyPath:@"errors.message"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    RKResponseDescriptor *serverErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                               method:RKRequestMethodGET
                                                                                          pathPattern:nil
                                                                                              keyPath:@"errors.message"
                                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    RKResponseDescriptor *responseDescriptor = [LucDescriptorRegister responseDescriptorFotMappingClass:className mappingPara:mappingdic method:RKRequestMethodGET pathPattern:nil keyPath:mappingkeyPath statusCodes:nil relationShipMappingClass:propertityMapping];
    NSURL *requrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requrl];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor,errorDescriptor, serverErrorDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *newsArray)
     {
         
         [requestDic removeObjectForKey:reId];
         success([newsArray array]);
         
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         
         [requestDic removeObjectForKey:reId];
         errorMessage(error);
     }];
    [operation start];
    if (reId && reId.length > 0) {
        [requestDic setObject:operation forKey:reId];
    }
}

- (void)doRequest:(NSString *)path
           method:(RKRequestMethod)method
       parameters:(NSDictionary *)paras
     MappingClass:(NSString *)className
      mappingPara:(NSDictionary *)mappingdic
          keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
  requestIdentify:(NSString *)reId
          success:(SuccessBlock)success
            error:(ErrorBlock)errorMessage
{
    if ([requestDic objectForKey:reId]) {
        return;
    }
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor *descriptor = [LucDescriptorRegister responseDescriptorFotMappingClass:className
                                                                                    mappingPara:mappingdic
                                                                                         method:method
                                                                                    pathPattern:nil
                                                                                        keyPath:mappingkeyPath
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                                                       relationShipMappingClass:propertityMapping];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping: [RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                                 method:method
                                                                                            pathPattern:nil
                                                                                                keyPath:@"errors.message"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptorsFromArray:@[descriptor,errorResponseDescriptor]];
    NSMutableURLRequest *request = [objectManager requestWithObject:nil method:method path:path parameters:paras];
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                                                                                       NSArray* resultsArray = [mappingResult array];
                                                                                       success(resultsArray);
                                                                                       [requestDic removeObjectForKey:reId];
                                                                                   }
                                                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       errorMessage(error);
                                                                                       [requestDic removeObjectForKey:reId];
                                                                                       DLog(@"💙 errorMessage: %@", [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey]);
                                                                                   }];
    
    [operation start];
    if (reId && reId.length > 0) {
        [requestDic setObject:operation forKey:reId];
    }
}

//form表单形式的上传(支持多媒体)
- (void)doMutiRequest:(NSString *)path
              withobj:(id)obj
             withFile:(NSData *)fileData
           method:(RKRequestMethod)method
           parameters:(NSDictionary *)paras
         MappingClass:(NSString *)className
          mappingPara:(NSDictionary *)mappingdic
              keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
  requestIdentify:(NSString *)reId
          success:(SuccessBlock)success
            error:(ErrorBlock)errorMessage
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor *descriptor = [LucDescriptorRegister responseDescriptorFotMappingClass:className
                                                                                    mappingPara:mappingdic
                                                                                         method:method
                                                                                    pathPattern:nil
                                                                                        keyPath:mappingkeyPath
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                                                       relationShipMappingClass:propertityMapping];
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:method
                                                                                    pathPattern:nil
                                                                                        keyPath:@"errors.message"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    RKResponseDescriptor *serverErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:method
                                                                                          pathPattern:nil
                                                                                              keyPath:@"errors"
                                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    [objectManager addResponseDescriptorsFromArray:@[descriptor, errorDescriptor, serverErrorDescriptor]];
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:obj
                                                                                            method:method
                                                                                              path:path
                                                                                        parameters:paras
                                                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                             if (fileData) {
                                                                                 [formData appendPartWithFileData:fileData name:@"upload" fileName:@"photo.png" mimeType:@"image/png"];
                                                                             }
                                                                         }];
    
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                       
                                                                                       NSArray* resultsArray = [mappingResult array];
                                                                                       success(resultsArray);
                                                                                       [requestDic removeObjectForKey:reId];
                                                                                       
                                                                                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       
                                                                                       errorMessage(error);
                                                                                       [requestDic removeObjectForKey:reId];
                                                                                       
                                                                                       DLog(@"💙 errorMessage: %@", [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey]);
                                                                                       
                                                                                   }];
    [operation start];
//    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
    if (reId && reId.length > 0) {
        [requestDic setObject:operation forKey:reId];
    }
}

//取消请求
- (void)cancleRequest:(NSString *)reId
{
    if (!reId || reId.length == 0) {
        return;
    }
    RKObjectRequestOperation *operation = [requestDic objectForKey:reId];
    if (operation) {
        [operation cancel];
        [requestDic removeObjectForKey:reId];
        operation = nil;
    }
}


@end
