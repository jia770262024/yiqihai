//
//  LucService.h
//  testPostRestkit
//
//  Created by wallstreetcn on 14-9-10.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RestKit/RestKit.h>
#import "RestKit.h"
#import "LucDescriptorRegister.h"

@interface LucError : NSObject

@property (nonatomic, assign) int errCode;
@property (nonatomic, copy) NSString *errMessage;

+ (id)bindErrorKeys;

@end

typedef void (^SuccessBlock)(NSArray *deals);
typedef void (^ErrorBlock)(NSError *error);

@interface LucService : NSObject

@property (nonatomic, strong) NSString *baseURL;

+ (LucService *)sharesService;

//设置http的header
- (void)setHttpHeader:(NSDictionary *)headerDic;

- (void)clearHeaders;

/**
 Restkit发起一个http请求
 @path path 请求路径
 @param method 请求方式get or post
 @param paras 请求参数，无参数则为nil
 @param className 用于mapping的实体类名
 @param mappingdic 是否自定义实体映射机制，若为nil，则自定使用实体类中的bindkeys方法(所以在非自定义的情况下，必须保证实体类中存在bindkeys方法)
 @param mappingkeyPath 返回数据结构中找到keypath，映射到实体类
 @param propertityMapping 实体类的属性为实体类的时候，需要传此参数
 @param reId 自定义请求的唯一标识，区分是什么请求
 @param success 请求成功之后执行此block
 @param errorMessage 请求失败执行此block
 */
- (void)doRequest:(NSString *)path
           method:(RKRequestMethod)method
       parameters:(NSDictionary *)paras
     MappingClass:(NSString *)className
      mappingPara:(NSDictionary *)mappingdic
          keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
  requestIdentify:(NSString *)reId
          success:(SuccessBlock)success
            error:(ErrorBlock)errorMessage;

/**
 Restkit发起一个post方式的http请求
 @path path 请求路径
 @param paras 请求参数，无参数则为nil
 @param className 用于mapping的实体类名
 @param mappingdic 是否自定义实体映射机制，若为nil，则自定使用实体类中的bindkeys方法(所以在非自定义的情况下，必须保证实体类中存在bindkeys方法)
 @param mappingkeyPath 返回数据结构中找到keypath，映射到实体类
 @param propertityMapping 实体类的属性为实体类的时候，需要传此参数
 @param reId 自定义请求的唯一标识，区分是什么请求
 @param success 请求成功之后执行此block
 @param errorMessage 请求失败执行此block
 */
- (void)doPostRequest:(NSString *)path
           parameters:(NSDictionary *)paras
         MappingClass:(NSString *)className
          mappingPara:(NSDictionary *)mappingdic
              keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
      requestIdentify:(NSString *)reId
              success:(SuccessBlock)success
                error:(ErrorBlock)errorMessage;

/**
 Restkit发起一个get方式的http请求
 @path path 请求路径
 @param paras 请求参数，无参数则为nil
 @param className 用于mapping的实体类名
 @param mappingdic 是否自定义实体映射机制，若为nil，则自定使用实体类中的bindkeys方法(所以在非自定义的情况下，必须保证实体类中存在bindkeys方法)
 @param mappingkeyPath 返回数据结构中找到keypath，映射到实体类
 @param propertityMapping 实体类的属性为实体类的时候，需要传此参数
 @param reId 自定义请求的唯一标识，区分是什么请求
 @param success 请求成功之后执行此block
 @param errorMessage 请求失败执行此block
 */
- (void)doGetRequest:(NSString *)path
          parameters:(NSDictionary *)paras
        MappingClass:(NSString *)className
         mappingPara:(NSDictionary *)mappingdic
             keyPath:(NSString *)mappingkeyPath
relationShipMappingClass:(NSArray *)propertityMapping
     requestIdentify:(NSString *)reId
             success:(SuccessBlock)success
               error:(ErrorBlock)errorMessage;

/**
 Restkit发起一个get方式的http请求
 @path url 请求的完整url
 @param paras 请求参数，无参数则为nil
 @param className 用于mapping的实体类名
 @param mappingdic 是否自定义实体映射机制，若为nil，则自定使用实体类中的bindkeys方法(所以在非自定义的情况下，必须保证实体类中存在bindkeys方法)
 @param mappingkeyPath 返回数据结构中找到keypath，映射到实体类
 @param propertityMapping 实体类的属性为实体类的时候，需要传此参数
 @param reId 自定义请求的唯一标识，区分是什么请求
 @param success 请求成功之后执行此block
 @param errorMessage 请求失败执行此block
 */
- (void)doGetRequestWithURL:(NSString *)url
                 parameters:(NSDictionary *)paras
               MappingClass:(NSString *)className
                mappingPara:(NSDictionary *)mappingdic
                    keyPath:(NSString *)mappingkeyPath
   relationShipMappingClass:(NSArray *)propertityMapping
            requestIdentify:(NSString *)reId
                    success:(SuccessBlock)success
                      error:(ErrorBlock)errorMessage;


/**
 Restkit发起一个get方式的http请求
 @path url 请求的完整url
 @param paras 请求参数，无参数则为nil
 @param className 用于mapping的实体类名
 @param mappingdic 是否自定义实体映射机制，若为nil，则自定使用实体类中的bindkeys方法(所以在非自定义的情况下，必须保证实体类中存在bindkeys方法)
 @param mappingkeyPath 返回数据结构中找到keypath，映射到实体类
 @param propertityMapping 实体类的属性为实体类的时候，需要传此参数
 @param reId 自定义请求的唯一标识，区分是什么请求
 @param success 请求成功之后执行此block
 @param errorMessage 请求失败执行此block
 */


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
                error:(ErrorBlock)errorMessage;


/**
 *取消请求
 */
- (void)cancleRequest:(NSString *)reId;

@end
