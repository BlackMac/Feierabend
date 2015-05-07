//
//  SLHLocationManager.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 06.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SLHLocationManager : NSObject <CLLocationManagerDelegate>
@property (nonatomic) CLLocation *location;
@property (nonatomic) BOOL available;
+ (SLHLocationManager *)sharedLocationManager;
-(void)updateLocation;
@end

