//
//  QQZLine.m
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/9.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import "QQZLine.h"

@implementation QQZLine

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:[NSValue value:&_begin withObjCType:@encode(CGPoint)] forKey:NSStringFromSelector(@selector(begin))];
    [coder encodeObject:[NSValue value:&_end withObjCType:@encode(CGPoint)] forKey:NSStringFromSelector(@selector(end))];
    [coder encodeObject:self.color forKey:NSStringFromSelector(@selector(color))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        [[coder decodeObjectForKey:NSStringFromSelector(@selector(begin))] getValue:&_begin];
        [[coder decodeObjectForKey:NSStringFromSelector(@selector(end))] getValue:&_end];
        self.color = [coder decodeObjectForKey:NSStringFromSelector(@selector(color))];
    }
    return self;
}

@end
