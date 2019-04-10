//
//  HXBaseDataController.m
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/29.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXBaseDataController.h"
#import <pthread.h>
#import <objc/runtime.h>

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
    
    id requestIdentifier = [self identifierForRequest:request];
    
    [self stopRequest:requestIdentifier];
    
    [self.currentProgramDataController startRequest:request];
    
    [self storageRequestCallBackBlockWithIdentifier:requestIdentifier successBlock:successBlock  failBlock:failBlock];
    
    [self.requestDesMapTable setObject:requestDescription forKey:requestIdentifier];
    
    [self.requestsMapTable setObject:request forKey:requestIdentifier];
    
    return requestIdentifier;
}

- (id)startRequest:(id)request requestDescription:(NSString *)requestDescription {
    return [self startRequest:request successBlock:nil failBlock:nil requestDescription:requestDescription];
}

- (id)startRequest:(id)request successBlock:(id)successBlock failBlock:(id)failBlock upperMethod:(SEL)upperMethod {
    
    
    NSString *methodStr = NSStringFromSelector(upperMethod);
    NSRange begin = [methodStr rangeOfString:@"requestOf"];
    NSRange end = [methodStr rangeOfString:@"With"];
    
    NSString *requestDescription = [methodStr substringWithRange:NSMakeRange(begin.location + begin.length, end.location - begin.location - begin.length)];
    
    return [self startRequest:request successBlock:successBlock failBlock:failBlock requestDescription:requestDescription];
}

- (id)startRequest:(id)request upperMethod:(SEL)upperMethod {
   return   [self startRequest:request successBlock:nil failBlock:nil upperMethod:upperMethod];
}


- (void)stopRequest:(id)requestIdentifier {
    id request = [self.requestsMapTable objectForKey:requestIdentifier];
    [self.currentProgramDataController stopRequest:request];
    [self cleanAfterRequestFinished:requestIdentifier];
}

- (void)stopAllRequest {
    DCLock
    NSArray *keysArr = [[[self.requestsMapTable keyEnumerator] allObjects] copy];
    
    for (id key in keysArr) {
        [self stopRequest:key];
    }
    DCUnlock
}

- (id)createRequestWithParameter:(id)parameter {
    if ([self.currentProgramDataController respondsToSelector:@selector(createRequestWithParameter:)]) {
        return [self.currentProgramDataController createRequestWithParameter:parameter];
    }
    return nil;
    
}

- (id)createRequestWithPath:(NSString *)path method:(NSString *)method arguments:(id)arguments {
    if ([self.currentProgramDataController respondsToSelector:@selector(createRequestWithPath:method:arguments:)]) {
        return [self.currentProgramDataController createRequestWithPath:path method:method arguments:arguments];
    }
    return nil;
}

- (id)identifierForRequest:(id)request {
    return [self.currentProgramDataController identifierForRequest:request];
}

- (BOOL)shouldCallBackForRequestIdentifier:(id)identifier {
    return YES;
}


#pragma mark - Private Method

- (void)storageRequestCallBackBlockWithIdentifier:(id)requestIdentifier successBlock:(id _Nullable)successBlock failBlock:(id)failBlock {
    
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
#pragma mark successPreprocessMethodStr

- (id)successPreprocessMethodWithRequestDescription:(NSString *)requestDescription {
    return [NSString stringWithFormat:@"_%@RequestSuccessPreprocessWithResponse:message:extendedParameter:", requestDescription];
}

#pragma mark failPreprocessMethodStr
- (id)failPreprocessMethodWithRequestDescription:(NSString *)requestDescription {
    return [NSString stringWithFormat:@"_%@RequestFailPreprocessWithNetNotReachable:message:error:extendedParameter:", requestDescription];
}


#pragma mark - Delegate
#pragma mark HXBaseDataControllerDelegate
- (void)requestSuccessWithResponse:(id _Nullable)response
                           message:(NSString * _Nullable)message
                 extendedParameter:(id _Nullable)extendedParameter
                 requestIdentifier:(id _Nonnull)requestIdentifier {
    
    if (![self shouldCallBackForRequestIdentifier:requestIdentifier]) {
        [self cleanAfterRequestFinished:requestIdentifier];
        return;
    }
    
    NSString *requestDescription = [self.requestDesMapTable objectForKey:requestIdentifier];
    if (requestDescription.length) {
        
        SEL sel = NSSelectorFromString([self successPreprocessMethodWithRequestDescription:requestDescription]);
        
        if ([self respondsToSelector:sel]) {
            
            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            
            [invocation setSelector:sel];
            [invocation setArgument:&response atIndex:2];
            [invocation setArgument:&message atIndex:3];
            [invocation setArgument:&extendedParameter atIndex:4];
            [invocation invoke];
            
            __weak HXTuple *tuple = nil;
            if ([signature methodReturnLength] != 0)
            {
                [invocation getReturnValue:&tuple];
                hx_unpackTuple(tuple, &response, &message, &extendedParameter);
            }
            
        }
        
        
    }
    
    
    DataControllerSuccessBlock block = [self successBlockWithRequestIdentifier:requestIdentifier];
    if (block) {
        block(response, message, extendedParameter);
    }
    else {
        if ([self.requestDelegate respondsToSelector:@selector(requestSuccessWithResponse:message:extendedParameter:requestDes:)]) {
            [self.requestDelegate requestSuccessWithResponse:response message:message extendedParameter:extendedParameter requestDes:requestDescription];
        }
    }
    
    [self cleanAfterRequestFinished:requestIdentifier];
}

- (void)requestFailWithNetNotReachable:(BOOL)netNotReachable message:(NSString *)message error:(NSError *)error extendedParameter:(id)extendedParameter requestIdentifier:(id)requestIdentifier globalHandled:(BOOL)globalHandled {
    
    if (![self shouldCallBackForRequestIdentifier:requestIdentifier]) {
        [self cleanAfterRequestFinished:requestIdentifier];
        return;
    }
    
    if (globalHandled) {
        
        if (self.nextHandleBlockAfterGloableHandled) {
            self.nextHandleBlockAfterGloableHandled(requestIdentifier);
        }
        
        [self cleanAfterRequestFinished:requestIdentifier];
        return;
    }
    
    NSString *requestDescription = [self.requestDesMapTable objectForKey:requestIdentifier];
    if (requestDescription.length) {
        SEL sel = NSSelectorFromString([self failPreprocessMethodWithRequestDescription:requestDescription]);
        
        if ([self respondsToSelector:sel]) {
            
            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            
            [invocation setSelector:sel];
            [invocation setArgument:&netNotReachable atIndex:2];
            [invocation setArgument:&message atIndex:3];
            [invocation setArgument:&error atIndex:4];
            [invocation setArgument:&extendedParameter atIndex:5];
            [invocation invoke];
            
            __weak HXTuple *tuple = nil;
            if ([signature methodReturnLength] != 0)
            {
                [invocation getReturnValue:&tuple];
                hx_unpackTuple(tuple, &message, &error, &extendedParameter);
            }
            
        }
    }
    
    DataControllerFailBlock block = [self failBlockWithRequestIdentifier:requestIdentifier];
    if (block) {
        block(netNotReachable, message, error, extendedParameter);
    }
    else {
        if ([self.requestDelegate respondsToSelector:@selector(requestFailWithNetNotReachable:message:error:extendedParameter:requestDes:)]) {
            [self.requestDelegate requestFailWithNetNotReachable:netNotReachable message:message error:error extendedParameter:extendedParameter requestDes:requestDescription];
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
    [self stopAllRequest];
    NSLog(@"%@ dealloc", [self class]);
}

@end
