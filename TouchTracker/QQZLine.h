//
//  QQZLine.h
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/9.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQZLine : NSObject<NSSecureCoding>

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
