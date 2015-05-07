//
//  ViewController.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLHCaiadaView.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *temperatureDisplay;
@property (weak, nonatomic) IBOutlet UILabel *weatherConditionDisplay;
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *currentArrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentLeavingTime;
@property (weak, nonatomic) IBOutlet SLHCaiadaView *currentProgressView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeIntervalToLeavingTime;
- (IBAction)pickArrivalDateNow:(id)sender;
- (void)timeManagerUpdated:(id)object;
- (void)updateWeatherData;

@end

