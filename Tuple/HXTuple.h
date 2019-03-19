//
//  HXTuple.h
//  ShengXue
//
//  Created by 周义进 on 2019/3/18.
//  Copyright © 2019 Sea. All rights reserved.
//

#import <Foundation/Foundation.h>

//可变参数结尾对象
id hx_packTuple_end(void);
void* hx_unpackTuple_end(void);

#define hx_packTuple(...) [[HXTuple alloc] initWithObjects:__VA_ARGS__, hx_packTuple_end()]

#define hx_unpackTuple(tuple, ...) [tuple unpack:__VA_ARGS__, hx_unpackTuple_end()]

@interface HXTuple : NSObject<NSFastEnumeration>

- (instancetype)initWithObjects:(id)obejct,...;

- (void)unpack:(__strong id *)receiver, ...;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end

