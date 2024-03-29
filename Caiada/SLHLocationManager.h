//
//  SLHLocationManager.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 06.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define SLHLocationOfficeEnteredNotification @"SLHLocationOfficeEnteredNotification"


@interface SLHLocationManager : NSObject <CLLocationManagerDelegate>
@property (nonatomic) CLLocation *location;
@property (nonatomic) BOOL available;
@property (nonatomic) NSString *address;
+ (SLHLocationManager *)sharedLocationManager;
-(void)monitorOfficeEntry:(CLLocation *) location;
-(void)updateLocation;
@end

