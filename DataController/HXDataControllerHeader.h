//
//  HXDataControllerHeader.h
//  ShengXue
//
//  Created by 周义进 on 2019/2/18.
//  Copyright © 2019 Sea. All rights reserved.
//

#ifndef HXDataControllerHeader_h
#define HXDataControllerHeader_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - APIMethodMacro

//example
/*
 BaseConvenienceRequsetAPIMacro(Register, Name, NSString  * _Nonnull, NSDictionary * _Nullable registerInfo, NSString * _Nullable hahaha, NSDictionary * _Nullable registerInfo);
 
 */

// Return value:request identifier (you can custom this with your imagination)

#define RequsetAPIMacro(RequestDescription) ThreeRequsetAPIMacro(RequestDescription, Parameter, id _Nullable)

#define ThreeRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType) FourRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, id _Nullable response)

#define FourRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, CustomSuccessBlockResponseParameter) FiveRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, CustomSuccessBlockResponseParameter, id _Nullable extendedParameter)

#define FiveRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, CustomSuccessBlockResponseParameter, CustomSuccessBlockExtendedParameter) BaseConvenienceRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, CustomSuccessBlockResponseParameter, CustomSuccessBlockExtendedParameter, id _Nullable extendedParameter)

#define  BaseConvenienceRequsetAPIMacro(RequestDescription, CustomParameterName, CustomParameterType, CustomSuccessBlockResponseParameter, CustomSuccessBlockExtendedParameter,  CustomFailBlockExtendedParameter) - (id _Nullable)requestOf##RequestDescription##With##CustomParameterName:(CustomParameterType)parameter successBlock:(nullable void(^)(CustomSuccessBlockResponseParameter, NSString  * _Nullable message, CustomSuccessBlockExtendedParameter))successBlock failBlock:(void(^)(BOOL netNotReachable, NSString * _Nullable message, NSError * _Nullable error, CustomFailBlockExtendedParameter))failBlock;

#pragma mark - StaticKey
static NSString const *HXDataContollerUrlKey = @"Url";
static NSString const *HXDataContollerHTTPMethodKey = @"HTTPMethod";
static NSString const *HXDataContollerParameterKey = @"Parametr";
static NSString const *HXDataContollerCustomKey = @"Custom";

static NSString const *HXHTTPMethodGET     = @"GET";
static NSString const *HXHTTPMethodPOST    = @"POST";
static NSString const *HXHTTPMethodPUT     = @"PUT";
static NSString const *HXHTTPMethodPATCH   = @"PATCH";
static NSString const *HXHTTPMethodDELETE  = @"DELETE";
static NSString const *HXHTTPMethodHEAD    = @"HEAD";

#pragma mark - CompletionHandlerBlock
typedef void (^DataControllerSuccessBlock)(id _Nullable response, NSString  * _Nullable message, id _Nullable extendedParameter);

typedef void (^DataControllerFailBlock)(BOOL netNotReachable, NSString  * _Nullable message, NSError * _Nullable error, id _Nullable extendedParameter);


#pragma mark - CompletionHandlerDelegate
@protocol HXBaseDataControllerDelegate <NSObject>

@optional

- (void)requestSuccessWithResponse:(id _Nullable)response
                           message:(NSString * _Nullable)message
                 extendedParameter:(id _Nullable)extendedParameter
                 requestIdentifier:(id _Nonnull)requestIdentifier;

- (void)requestFailWithNetNotReachable:(BOOL)netNotReachable
                       mesaage:(NSString * _Nullable)message
                         error:(NSError * _Nullable)error
             extendedParameter:(id _Nullable)extendedParameter
             requestIdentifier:(id _Nonnull)requestIdentifier;

@end


@protocol HXCurrentProgramDataControllerDelegate <NSObject>
@property (nonatomic, weak) id<HXBaseDataControllerDelegate> callBackDelegate;

@property (nonatomic, weak) UIViewController *associatedVC;

- (id _Nonnull)identifierForRequest:(id _Nonnull)request;
- (void)startRequest:(id _Nonnull)request;
- (void)stopRequest:(id _Nonnull)request;

@optional

- (id _Nullable)createRequestWithParameter:(id _Nonnull)paramter;

@end


#endif /* HXDataControllerHeader_h */
