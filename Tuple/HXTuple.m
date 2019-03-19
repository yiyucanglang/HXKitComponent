//
//  HXTuple.m
//  ShengXue
//
//  Created by 周义进 on 2019/3/18.
//  Copyright © 2019 Sea. All rights reserved.
//

#import "HXTuple.h"

id hx_packTuple_end() {
    static id end;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        end = [[NSObject alloc] init];
    });
    return end;
}

void* hx_unpackTuple_end(){
    static id end;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        end = [[NSObject alloc] init];
    });
    return (void *)&end;
}

@implementation HXTuple
{
    NSPointerArray *_storage;
}

#pragma mark - Life Cycle
- (id)init {
    self = [super init];
    if (!self)
        return nil;
    _storage = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
    return self;
}

- (instancetype)initWithObjects:(id)obejct,... {
    self = [self init];
    if (!self)
        return nil;
    
    va_list ap;
    va_start(ap, obejct);
    
    id obj = obejct;
    id end = hx_packTuple_end();
    while (obj != end) {
        [_storage addPointer:(__bridge void * _Nullable)(obj)];
        obj = va_arg(ap, id);
    }
    va_end(ap);
    
    return self;
}

#pragma mark - System Method
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_storage countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Public Method
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < 0 || idx >= _storage.count)
        return nil;
    return (id)[_storage pointerAtIndex:idx];
}

- (void)unpack:(__strong id *)receiver, ... {
    
    va_list ap;
    va_start(ap, receiver);
    
    __strong id *pp = receiver;
    int i = 0;
    while (pp != hx_unpackTuple_end()) {
        *pp = [self objectAtIndexedSubscript:i];
         pp = va_arg(ap, __strong id *);
        i++;
    }
    va_end(ap);
}

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter

#pragma mark - Dealloc

@end
