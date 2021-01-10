//
//  QQZDrawViewController.m
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/9.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import "QQZDrawViewController.h"
#import "QQZDrawView.h"

@interface QQZDrawViewController ()

@end

@implementation QQZDrawViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%s", __FUNCTION__);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (NSString *)filePath {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [document stringByAppendingPathComponent:@"aa.txt"];
    return filePath;
}

- (void)save {
    QQZDrawView *view1 = (QQZDrawView *)self.view;
    NSLog(@"%@", self.filePath);
    NSError *err;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:view1.finishedLines requiringSecureCoding:YES error:&err];
    [data writeToFile:self.filePath atomically:YES];
    NSLog(@"error1 %@", err);
}

- (void)loadView {
    self.view = [[QQZDrawView alloc] initWithFrame:CGRectZero];
    NSLog(@"%@", self.filePath);
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSError *err;
    QQZDrawView *view1 = (QQZDrawView *)self.view;
    if (data != nil) {
        NSMutableArray *arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class],[QQZLine class],[NSValue class],[UIColor class], nil] fromData:data error:&err];
        if (arr != nil) {
            view1.finishedLines = arr;
        }
        NSLog(@"err: %@", err);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
