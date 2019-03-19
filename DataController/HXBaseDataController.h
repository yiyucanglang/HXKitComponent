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

@interface HXBaseDataController : NSObject
#pragma mark - Require Tip

@property (nonatomic, weak) id<HXBaseDataControllerDelegate> requestDelegate;
@property (nonatomic, weak) UIViewController *associatedVC;

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


- (void)stopRequest:(id _Nonnull)requestIdentifier;

- (void)stopAllRequest;


#pragma mark -Can Overrride
//return: [self.currentProgramDataController createRequestWithParameter:paramter]
- (id _Nullable)createRequestWithParameter:(id _Nonnull)paramter;
@end




