//
//  ViewController.m
//  CCPCoreMotion
//
//  Created by liqunfei on 16/3/4.
//  Copyright © 2016年 chuchengpeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface ViewController ()
{
    CMMotionManager *motionManager;
    float anger;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    anger = 0.0;
    self.backView.layer.cornerRadius = 100.0f;
    self.roundView.layer.cornerRadius = 25.0f;
    [self startMonitoring];
}

- (void)startMonitoring {
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.01;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        NSLog(@"accelerometerData.acceleration.z:%lf",accelerometerData.acceleration.z);
        if (fabs(accelerometerData.acceleration.z)  > 0.9) {
            [motionManager stopDeviceMotionUpdates];
            self.myImageView.transform = CGAffineTransformIdentity;
        }
        else {
            motionManager.deviceMotionUpdateInterval = 0.01f;
            if (![motionManager isDeviceMotionActive] && [motionManager isDeviceMotionAvailable]) {
                [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                    double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
                    self.myImageView.transform = CGAffineTransformMakeRotation(rotation);
                    if (motion.userAcceleration.x < -2.5f) {
                        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.roundView.layer.transform = CATransform3DMakeTranslation(0, 0, 5.0);
                            self.roundView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
                        } completion:^(BOOL finished) {
                            self.roundView.layer.transform = CATransform3DIdentity;
                        }];
                    }
                }];
            }
        }
    }];
}

@end
