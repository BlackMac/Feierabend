//
//  SLHArrivalTimeManager.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "SLHArrivalTimeManager.h"
#import <UIKit/UIKit.h>

@interface SLHArrivalTimeManager ()
@property (nonatomic) UILocalNotification *timeUpLocalNotification;
// etc.
@end

@implementation SLHArrivalTimeManager

+(SLHArrivalTimeManager *)sharedArrivalTimeManager {
    static SLHArrivalTimeManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SLHArrivalTimeManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)setupPreferences {
    BOOL reset = YES;
    NSDate *arrival = (NSDate *)[[NSUserDefaults standardUserDefaults] valueForKey:@"Arrival"];
    if (arrival) {
        reset = NO;
        if ([arrival timeIntervalSinceNow] > 39600) {
            reset = YES;
        }
    }
    
    if (reset) {
        arrival = [[NSDate alloc] init];
    }
    self.arrivalDate = arrival;
    
    NSTimeInterval required = [[NSUserDefaults standardUserDefaults] doubleForKey:@"SchduledTime"];
    if (required == 0.0) {
        required = 480.0*60.0;
    }
    self.requiredWorkingTime = required;
}

-(id)init {
    self = [super init];
    if (self) {
        [self setupPreferences];
        
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
        self.notifyBeforeTTL = YES;
        [self scheduleNotification];
    }
    return self;
}

-(void)setArrivalDate:(NSDate *)date {
    _arrivalDate = date;
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"Arrival"];
    [self scheduleNotification];
}

-(NSDate *)leaveDate {
    return [NSDate dateWithTimeInterval:self.requiredWorkingTime sinceDate:self.arrivalDate];
}

-(void)scheduleNotification {
    if (self.timeUpLocalNotification != nil) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    if (self.notifyBeforeTTL) {
        self.timeUpLocalNotification = [[UILocalNotification alloc] init];
        if (self.timeUpLocalNotification == nil)
            return;
        
        NSDate *notificationDate = [NSDate dateWithTimeInterval:-900 sinceDate:self.leaveDate];
        if ([notificationDate timeIntervalSinceNow] > 0) {
            NSLog(@"Notification: %@", notificationDate);
            self.timeUpLocalNotification.fireDate = notificationDate;
            self.timeUpLocalNotification.alertBody = @"Feierabend in 15 Minuten";
            self.timeUpLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
            self.timeUpLocalNotification.soundName = @"horn.wav";
            [[UIApplication sharedApplication] scheduleLocalNotification:self.timeUpLocalNotification];
        }
        
    }

}

-(void)setRequiredWorkingTime:(NSTimeInterval)requiredWorkingTime {
    [[NSUserDefaults standardUserDefaults] setDouble:requiredWorkingTime  forKey:@"SchduledTime"];
    _requiredWorkingTime = requiredWorkingTime;
    [self scheduleNotification];
}
@end
