//
//  SLHArrivalTimeManager.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@import WatchConnectivity;

#define SLHArrivalTimeUpdatedNotification @"SLHArrivalTimeUpdatedNotification"
#define SLHArrivalTimeAddressUpdatedNotification @"SLHArrivalTimeAddressUpdatedNotification"

@interface SLHArrivalTimeManager : NSObject <WCSessionDelegate>

@property (nonatomic, retain) NSDate *arrivalDate;
@property (nonatomic, readonly) NSDate *leaveDate;
@property (readonly) float remainingTime;
@property (nonatomic) NSTimeInterval requiredWorkingTime;
@property (nonatomic) BOOL notifyBeforeTTL;
@property (nonatomic, readonly) NSString *workLocationAddress;
@property (nonatomic) CLLocation *workLocation;
@property (nonatomic) WCSession *watchConnectivitySession;

+ (SLHArrivalTimeManager *)sharedArrivalTimeManager;
- (void)scheduleNotification;
- (void)setupPreferences;
- (float)getElapsed;
- (void)synchronizeSettings;
- (NSString *)formattedArrivalTime;
- (NSString *)formattedLeavingTime;
- (NSString *)formattedRemainingTime;
- (NSString *)formattedRequiredTime;
@end
