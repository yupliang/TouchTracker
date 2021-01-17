//
//  QQZDrawView.h
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/9.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQZLine.h"
#import "QQZCircle.h"

NS_ASSUME_NONNULL_BEGIN

@interface QQZDrawView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary *lineInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) NSMutableArray *circles;
@property (nonatomic, weak) QQZLine *selectedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@end

NS_ASSUME_NONNULL_END
