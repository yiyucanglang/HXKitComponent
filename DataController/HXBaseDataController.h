//
//  HXBaseDataController.h
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/29.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXDataControllerHeader.h"

@interface HXBaseDataController : NSObject
#pragma mark - Require Tip
@property (nonatomic, weak) id<HXBaseDataControllerDelegate> requestDelegate;
@property (nonatomic, weak) UIViewController *associatedVC;

//default Class come from set class method  as below: setDefaultClassForCurrentProgramDataController
//you can override this property
@property (nonatomic, strong) id<HXCurrentProgramDataControllerDelegate> currentProgramDataController;

// this must call first otherwise dataController can't work
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




