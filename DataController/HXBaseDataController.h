//
//  HXBaseDataController.h
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/29.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HXDataControllerHeader.h"
#import "HXTuple.h"

#pragma mark - Notice

#pragma mark RequestSuccessPreprocessSnippet
//- (HXTuple *)_<#RequestDes#>RequestSuccessPreprocessWithResponse:(id)response message:(NSString *)message extendedParameter:(id)extendedParameter {
//
//    return hx_packTuple(<#response#>, <#message#>, <#extendedParameter#>);
//}

#pragma mark RequestFailPreprocessSnippet
//- (HXTuple *)_<#RequestDes#>RequestFailPreprocessWithNetNotReachable: (BOOL)netNotReachable message:(NSString *)message error:(NSError *)error extendedParameter:(id)extendedParameter {
//
//    return hx_packTuple(<#message#>, <#error#>, <#extendedParameter#>);
//}

@protocol HXDataControllerRequestHandleDelegate <NSObject>

@optional

- (void)requestSuccessWithResponse:(id _Nullable)response
                           message:(NSString * _Nullable)message
                 extendedParameter:(id _Nullable)extendedParameter
                        requestDes:(NSString *)requestDes;

- (void)requestFailWithNetNotReachable:(BOOL)netNotReachable
                               message:(NSString * _Nullable)message
                                 error:(NSError * _Nullable)error
                     extendedParameter:(id _Nullable)extendedParameter
                            requestDes:(NSString *)requestDes;

@end


@interface HXBaseDataController : NSObject
#pragma mark - Require Tip
@property (nonatomic, weak) id<HXDataControllerRequestHandleDelegate> requestDelegate;
@property (nonatomic, weak) UIViewController *associatedVC;

//noti retain
@property (nonatomic, copy) void(^nextHandleBlockAfterGloableHandled)(id requestIdentifier);

//default Class come from set class method  as below: setDefaultClassForCurrentProgramDataController
//you can override this property
@property (nonatomic, strong) id<HXCurrentProgramDataControllerDelegate> currentProgramDataController;

// this must call otherwise this server of data controller can't work
+ (void)setDefaultClassForCurrentProgramDataController:(Class)defaultClass;


//retrun:  [self.currentProgramDataController identifierForRequest:request]
- (id _Nonnull)startRequest:(id _Nonnull)request
        successBlock:(id _Nullable)successBlock
           failBlock:(id _Nullable)failBlock
  requestDescription:(NSString *)requestDescription;

//callback use delegate not block
- (id _Nonnull)startRequest:(id _Nonnull)request
         requestDescription:(NSString *)requestDescription;

//for convience
- (id _Nonnull)startRequest:(id _Nonnull)request
               successBlock:(id _Nullable)successBlock
                  failBlock:(id _Nullable)failBlock
                upperMethod:(SEL)upperMethod;

- (id _Nonnull)startRequest:(id _Nonnull)request
         upperMethod:(SEL)upperMethod;


- (void)stopRequest:(id _Nonnull)requestIdentifier;

- (void)stopAllRequest;


#pragma mark -Can Overrride

//default return: [self.currentProgramDataController identifierForRequest:request]
- (id _Nonnull)identifierForRequest:(id _Nonnull)request;

//default return: [self.currentProgramDataController createRequestWithParameter:paramter]
- (id _Nullable)createRequestWithParameter:(id _Nonnull)paramter;

//default return: [self.currentProgramDataController createRequestWithPath:path method:method arguments:arguments]
- (id _Nullable)createRequestWithPath:(NSString *)path method:(NSString *)method arguments:(id _Nullable)arguments;

//decide should callback after request finished
//default yes
- (BOOL)shouldCallBackForRequestIdentifier:(id)identifier;

@end




