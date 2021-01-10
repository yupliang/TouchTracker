//
//  QQZCircle.h
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/10.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQZCircle : NSObject

@property (nonatomic) CGPoint point1;
@property (nonatomic) CGPoint point2;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
