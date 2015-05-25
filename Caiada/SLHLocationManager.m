//
//  SLHLocationManager.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 06.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "SLHLocationManager.h"

@interface SLHLocationManager()
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation SLHLocationManager

+(SLHLocationManager *)sharedLocationManager {
    static SLHLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SLHLocationManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.available = NO;
        [self initLocationTracking];
    }
    return self;
}

- (void)initLocationTracking
{
    if (![CLLocationManager locationServicesEnabled]) return;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusDenied) {
        return;
    }
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
    } else {
        self.available = YES;
        //[self.manager startUpdatingLocation];
        [self.manager startMonitoringSignificantLocationChanges];
        [self updateLocation];
    }
}

-(void)updateLocation {
    self.location = self.manager.location;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.available = YES;
        //[self.manager startUpdatingLocation];
        [self.manager startMonitoringSignificantLocationChanges];
        [self updateLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //self.location = [locations lastObject];
}
@end
