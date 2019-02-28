//
//  HXBaseDataController.m
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/29.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXBaseDataController.h"
#import <pthread.h>

#define DCLock  pthread_mutex_lock(&_mutex);
#define DCUnlock    pthread_mutex_unlock(&_mutex);

static NSString const *successBlcokKey = @"successBlcokKey";
static NSString const *failBlcokKey = @"failBlcokKey";

@interface HXBaseDataController()
<
    HXBaseDataControllerDelegate
>
@property (nonatomic, strong) NSMapTable *requestsMapTable;
@property (nonatomic, strong) NSMapTable *callBackBlockMapTable;
@property (nonatomic, strong) NSMapTable *requestDesMapTable;
@end

@implementation HXBaseDataController
{
    pthread_mutex_t _mutex;
}

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

#pragma mark - System Method

#pragma mark - Public Method
static NSString *currentProgramDataControllerClassName;

+ (void)setDefaultClassForCurrentProgramDataController:(Class)defaultClass {
    currentProgramDataControllerClassName = NSStringFromClass(defaultClass);
}

- (id)startRequest:(id)request successBlock:(id)successBlock failBlock:(id)failBlock requestDescription:(NSString *)requestDescription {
    
    id requestIdentifier = [self.currentProgramDataController identifierForRequest:request];
    
    [self.currentProgramDataController startRequest:request];
    
    [self storageRequestCallBackBlockWithIdentifier:requestIdentifier successBlock:successBlock  failBlock:failBlock];
    
    [self.requestDesMapTable setObject:requestDescription forKey:requestIdentifier];
    
    [self.requestsMapTable setObject:request forKey:requestIdentifier];
    
    return requestIdentifier;
}

- (id)startRequest:(id)request requestDescription:(NSString *)requestDescription {
    return [self startRequest:request successBlock:nil failBlock:nil requestDescription:requestDescription];
}


- (void)stopRequest:(id)requestIdentifier {
    id request = [self.requestsMapTable objectForKey:requestIdentifier];
    [self.currentProgramDataController stopRequest:request];
    
    DCLock
    [self.requestsMapTable removeObjectForKey:requestIdentifier];
    DCUnlock
}

- (void)stopAllRequest {
    DCLock
    NSArray *keysArr = [[[self.requestsMapTable keyEnumerator] allObjects] copy];
    DCUnlock
    
    for (id key in keysArr) {
        [self stopRequest:key];
    }
}

- (id)createRequestWithParameter:(id)parameter {
    if ([self.currentProgramDataController respondsToSelector:@selector(createRequestWithParameter:)]) {
        return [self.currentProgramDataController createRequestWithParameter:parameter];
    }
    return nil;
    
}

#pragma mark - Private Method
- (void)storageRequestCallBackBlockWithIdentifier:(id)requestIdentifier successBlock:(id _Nullable)successBlock failBlock:(id)failBlock {
    DCLock
    NSMutableDictionary *blockDic = [NSMutableDictionary dictionary];
    [self.callBackBlockMapTable removeObjectForKey:requestIdentifier];
    
    if (successBlock) {
        [blockDic setObject:successBlock forKey:successBlcokKey];
    }
    
    if (failBlock) {
        [blockDic setObject:failBlock forKey:failBlcokKey];
    }
    
    if (blockDic.allKeys.count) {
        [self.callBackBlockMapTable setObject:blockDic forKey:requestIdentifier];
    }
    DCUnlock
}

- (DataControllerSuccessBlock _Nullable)successBlockWithRequestIdentifier:(id)requestIdentifier {
    NSDictionary *dic = [self.callBackBlockMapTable objectForKey:requestIdentifier];
    return [dic objectForKey:successBlcokKey];
}


- (DataControllerFailBlock _Nullable)failBlockWithRequestIdentifier:(id)requestIdentifier {
    NSDictionary *dic = [self.callBackBlockMapTable objectForKey:requestIdentifier];
    return [dic objectForKey:failBlcokKey];
}

- (void)cleanAfterRequestFinished:(id)requestIdentifier {
    [self.requestDesMapTable removeObjectForKey:requestIdentifier];
    [self.requestsMapTable removeObjectForKey:requestIdentifier];
    [self.callBackBlockMapTable removeObjectForKey:requestIdentifier];
}

#pragma mark Tool
#pragma mark success
- (id)successPreprocessResponseMethodWithRequestDescription:(NSString *)requestDescription {
    return [NSString stringWithFormat:@"_%@RequestSuccessPreprocessWithSourceResponse:", requestDescription];
}

- (id)successPreprocessMessageMethodWithRequestDescription:(NSString *)requestDescription {
    return [NSString stringWithFormat:@"_%@RequestSuccessPreprocessWithSourceMessage:", requestDescription];
}

- (id)successPreprocessExtendedParameterMethodWithRequestDescription:(NSString *)requestDescription {
    
    return [NSString stringWithFormat:@"_%@RequestSuccessPreprocessWithSourceExtendedParameter:", requestDescription];
}

#pragma mark fail
- (id)failPreprocessMessageMethodWithRequestDescription:(NSString *)requestDescription {
    return [NSString stringWithFormat:@"_%@RequestFailPreprocessWithSourceMessage:netNotReachable:", requestDescription];
}


- (id)failPreprocessErrorMethodWithRequestDescription:(NSString *)requestDescription {
    
    return [NSString stringWithFormat:@"_%@RequestFailPreprocessWithSourceError:netNotReachable:", requestDescription];
}


- (id)failPreprocessExtendedParameterMethodWithRequestDescription:(NSString *)requestDescription {
    
    return [NSString stringWithFormat:@"_%@RequestFailPreprocessWithSourceExtendedParameter:netNotReachable:", requestDescription];
}

#pragma mark - Delegate
#pragma mark HXBaseDataControllerDelegate
- (void)requestSuccessWithResponse:(id _Nullable)response
                           message:(NSString * _Nullable)message
                 extendedParameter:(id _Nullable)extendedParameter
                 requestIdentifier:(id _Nonnull)requestIdentifier {
    
    NSString *requestDescription = [self.requestDesMapTable objectForKey:requestIdentifier];
    if (requestDescription.length) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        SEL preprocessResponseSEL = NSSelectorFromString([self successPreprocessResponseMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessResponseSEL]) {
            response = [self performSelector:preprocessResponseSEL withObject:response];
        }
        
        
        SEL preprocessMessageSEL = NSSelectorFromString([self successPreprocessMessageMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessMessageSEL]) {
            message = [self performSelector:preprocessMessageSEL withObject:message];
        }
        
        SEL preprocessExtandedParameterSEL = NSSelectorFromString([self successPreprocessExtendedParameterMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessExtandedParameterSEL]) {
            extendedParameter = [self performSelector:preprocessExtandedParameterSEL withObject:extendedParameter];
        }
        
#pragma clang diagnostic pop
    }
    
    
    DataControllerSuccessBlock block = [self successBlockWithRequestIdentifier:requestIdentifier];
    if (block) {
        block(response, message, extendedParameter);
    }
    else {
        if ([self.requestDelegate respondsToSelector:@selector(requestSuccessWithResponse:message:extendedParameter:requestIdentifier:)]) {
            [self.requestDelegate requestSuccessWithResponse:response message:message extendedParameter:extendedParameter requestIdentifier:requestIdentifier];
        }
    }
    
    [self cleanAfterRequestFinished:requestIdentifier];
}

- (void)requestFailWithNetNotReachable:(BOOL)netNotReachable mesaage:(NSString *)message error:(NSError *)error extendedParameter:(id)extendedParameter requestIdentifier:(id)requestIdentifier {
    
    NSString *requestDescription = [self.requestDesMapTable objectForKey:requestIdentifier];
    if (requestDescription.length) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        SEL preprocessErrorSEL = NSSelectorFromString([self failPreprocessErrorMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessErrorSEL]) {
            error = [self performSelector:preprocessErrorSEL withObject:error withObject:@(netNotReachable)];
        }
        
        
        SEL preprocessMessageSEL = NSSelectorFromString([self failPreprocessMessageMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessMessageSEL]) {
            message = [self performSelector:preprocessMessageSEL withObject:message withObject:@(netNotReachable)];
        }
        
        SEL preprocessExtandedParameterSEL = NSSelectorFromString([self failPreprocessExtendedParameterMethodWithRequestDescription:requestDescription]);
        if ([self respondsToSelector:preprocessExtandedParameterSEL]) {
            extendedParameter = [self performSelector:preprocessExtandedParameterSEL withObject:extendedParameter withObject:@(netNotReachable)];
        }
        
#pragma clang diagnostic pop
    }
    
    
    DataControllerFailBlock block = [self failBlockWithRequestIdentifier:requestIdentifier];
    if (block) {
        block(netNotReachable, message, error, extendedParameter);
    }
    else {
        if ([self.requestDelegate respondsToSelector:@selector(requestFailWithNetNotReachable:mesaage:error:extendedParameter:requestIdentifier:)]) {
            [self.requestDelegate requestFailWithNetNotReachable:netNotReachable mesaage:message error:error extendedParameter:extendedParameter requestIdentifier:requestIdentifier];
        }
    }
    
    [self cleanAfterRequestFinished:requestIdentifier];
}

#pragma mark - Setter And Getter
- (NSMapTable *)requestsMapTable {
    if (!_requestsMapTable) {
        _requestsMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    }
    return _requestsMapTable;
}

- (NSMapTable *)callBackBlockMapTable {
    if (!_callBackBlockMapTable) {
        _callBackBlockMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    }
    return _callBackBlockMapTable;
}

- (NSMapTable *)requestDesMapTable {
    if (!_requestDesMapTable) {
        _requestDesMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    }
    return _requestDesMapTable;
}

- (id<HXCurrentProgramDataControllerDelegate>)currentProgramDataController {
    if (!_currentProgramDataController) {
        if (!currentProgramDataControllerClassName.length) {
            NSAssert(0, @"please call method  setDefaultClassForCurrentProgramDataController");
            return nil;
        }
        _currentProgramDataController = [[NSClassFromString(currentProgramDataControllerClassName) alloc] init];
        if ([_currentProgramDataController respondsToSelector:@selector(setAssociatedVC:)]) {
            _currentProgramDataController.associatedVC = self.associatedVC;
        }
        _currentProgramDataController.callBackDelegate = self;
    }
    return _currentProgramDataController;
}




#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

@end
