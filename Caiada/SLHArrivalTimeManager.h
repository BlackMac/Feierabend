//
//  SLHArrivalTimeManager.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLHArrivalTimeUpdatedNotification @"SLHArrivalTimeUpdatedNotification"

@interface SLHArrivalTimeManager : NSObject

@property (nonatomic, retain) NSDate *arrivalDate;
@property (nonatomic, readonly) NSDate *leaveDate;
@property (nonatomic) NSTimeInterval requiredWorkingTime;
@property (nonatomic) BOOL notifyBeforeTTL;

+ (SLHArrivalTimeManager *)sharedArrivalTimeManager;
- (void)scheduleNotification;
- (void)setupPreferences;
@end
