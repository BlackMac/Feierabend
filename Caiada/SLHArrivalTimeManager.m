//
//  SLHArrivalTimeManager.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "SLHArrivalTimeManager.h"
#import <UIKit/UIKit.h>

#define SLHArrivalTimeScheduledTimeDefaultsKey @"ScheduledTime"
#define SLHArrivalTimeArrivalTimeDefaultsKey @"Arrival"
#define SLHArrivalTimeWorkplaceLongitudeDefaultsKey @"WorkLocationLong"
#define SLHArrivalTimeWorkplaceLatitudeDefaultsKey @"WorkLocationLat"

@interface SLHArrivalTimeManager ()
@property (nonatomic) UILocalNotification *timeUpLocalNotification;
@property BOOL supressUpdateNotification;
@property NSUserDefaults *sharedUserDefaults;
@property NSString *_workLocationAddress;
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

- (void)_updateAddress {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.workLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *address = @"";
             
             if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                 address = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             else
                 address = @"Address Not found";
             
             self._workLocationAddress = address;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:SLHArrivalTimeAddressUpdatedNotification object:self];
     }];
}

-(void)setupPreferences {
    BOOL reset = YES;
    self.supressUpdateNotification = YES;
    NSDate *arrival = (NSDate *)[self.sharedUserDefaults valueForKey:SLHArrivalTimeArrivalTimeDefaultsKey];
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
    
    NSTimeInterval required = [self.sharedUserDefaults doubleForKey:SLHArrivalTimeScheduledTimeDefaultsKey];
    if (required == 0.0) {
        required = 480.0*60.0;
    }
    self.requiredWorkingTime = required;
    
    float workLocationLatitude = [self.sharedUserDefaults floatForKey:SLHArrivalTimeWorkplaceLatitudeDefaultsKey];
    float workLocationLongitude = [self.sharedUserDefaults floatForKey:SLHArrivalTimeWorkplaceLongitudeDefaultsKey];
    if (workLocationLatitude != 0) {
        CLLocation *workLocation = [[CLLocation alloc] initWithLatitude:workLocationLatitude longitude:workLocationLongitude];
    
        self.workLocation = workLocation;
    }
    self.supressUpdateNotification = NO;
    [self updated];
}

-(id)init {
    self = [super init];
    if (self) {
        self.sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.app-architect.Feierabend"];
        [self setupPreferences];
#ifndef APP_EXTENSION
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];

        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
#endif
        self._workLocationAddress = @"Searching";
        self.notifyBeforeTTL = YES;
        [self scheduleNotification];
    }
    return self;
}

-(void)updated {
    if (self.supressUpdateNotification) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:SLHArrivalTimeUpdatedNotification object:self];
}

-(float)getElapsed {
    NSTimeInterval diff = [self.leaveDate timeIntervalSinceNow];
    return 1-diff/self.requiredWorkingTime;
}
-(void)setArrivalDate:(NSDate *)date {
    if (![_arrivalDate isEqualToDate:date]) {
        _arrivalDate = date;
        [self.sharedUserDefaults setObject:date forKey:SLHArrivalTimeArrivalTimeDefaultsKey];
        [self scheduleNotification];
        [self updated];
    }
}

-(NSDate *)leaveDate {
    return [NSDate dateWithTimeInterval:self.requiredWorkingTime sinceDate:self.arrivalDate];
}

-(void)scheduleNotification {
#ifndef APP_EXTENSION
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
#endif
}

-(NSString *)_formattedTime:(NSDate *)date {
    NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    timeFormatter.dateStyle = NSDateFormatterNoStyle;
    timeFormatter.locale = deLocale;
    return [timeFormatter stringFromDate:date];
}

-(NSString *)formattedRequiredTime {
    NSTimeInterval interval = self.requiredWorkingTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [dateFormatter stringFromDate:date];
}

-(NSString *)formattedArrivalTime {
    return [self _formattedTime:self.arrivalDate];
}

-(NSString *)formattedLeavingTime {
    return [self _formattedTime:self.leaveDate];
}

-(NSString *)formattedRemainingTime {
    NSString *formattedDiffTime;
    NSTimeInterval diff = [self.leaveDate timeIntervalSinceNow];
    int hours=diff/60/60;
    int mins=(diff/60)-hours*60;
    if (diff > 0) {
        formattedDiffTime = [[NSString alloc] initWithFormat:@"%d Std %d Min", hours, mins];
    } else {
        formattedDiffTime = [[NSString alloc] initWithFormat:@"%d Std %d Min", hours*-1, mins*-1];
    }
    return formattedDiffTime;
}

-(void)setRequiredWorkingTime:(NSTimeInterval)requiredWorkingTime {
    if (_requiredWorkingTime != requiredWorkingTime) {
        [self.sharedUserDefaults setDouble:requiredWorkingTime forKey:SLHArrivalTimeScheduledTimeDefaultsKey];
        _requiredWorkingTime = requiredWorkingTime;
        [self scheduleNotification];
        [self updated];
    }
}

-(void)setWorkLocation:(CLLocation *)workLocation {
    self._workLocationAddress = @"Searching";
    _workLocation = workLocation;
    [self.sharedUserDefaults setFloat:workLocation.coordinate.latitude forKey:SLHArrivalTimeWorkplaceLatitudeDefaultsKey];
    [self.sharedUserDefaults setFloat:workLocation.coordinate.longitude forKey:SLHArrivalTimeWorkplaceLongitudeDefaultsKey];
    [self _updateAddress];
}

-(NSString *)workLocationAddress {
    return self._workLocationAddress;
}
@end
