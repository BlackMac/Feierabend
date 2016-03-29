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
@property (nonatomic) CLRegion *monitoredRegion;
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
        [self.manager requestAlwaysAuthorization];
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

-(void)monitorOfficeEntry:(CLLocation *) location {
    if (self.monitoredRegion != nil) {
        [self.manager stopMonitoringForRegion:self.monitoredRegion];
    }
    self.monitoredRegion = [[CLCircularRegion alloc] initWithCenter:location.coordinate radius:50 identifier:@"OfficeRegion"];
    [self.manager startMonitoringForRegion:self.monitoredRegion];
     
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [[NSNotificationCenter defaultCenter] postNotificationName:SLHLocationOfficeEnteredNotification object:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Location updated");
    //self.location = [locations lastObject];
}
@end
