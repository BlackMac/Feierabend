//
//  ViewController.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "OverviewViewController.h"
#import "SLHArrivalTimeManager.h"
#import "SLHLocationManager.h"
#import "SLHBackgroundLayer.h"
#import "CZWeatherKit.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [self updateTimeData];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                            target:self
                          selector:@selector(updateTimeData)
                          userInfo:nil
                           repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeManagerUpdated:)
                                                 name:SLHArrivalTimeUpdatedNotification
                                               object:nil];
    CAGradientLayer *bgLayer = [SLHBackgroundLayer greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    [self updateWeatherData];
    [super viewDidLoad];
}

-(void)timeManagerUpdated:(id)object {
    [self updateTimeData];
    [self updateWeatherData];
}

-(void)updateWeatherData {
    if ([SLHLocationManager sharedLocationManager].available) {
        NSLog(@"WeatherData");
        CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
        request.location = [CZWeatherLocation locationWithCLLocation:[SLHLocationManager sharedLocationManager].location];
        request.service = [[CZForecastioService alloc] initWithKey:@"ffe70d26224e27f7cdac0f21af9a0ef0"];
        [request performRequestWithHandler:^(id data, NSError *error) {
            if (data) {
                NSArray *forecasts = (NSArray *)data;
                for (CZWeatherCondition *condition in forecasts) {
                    if ([condition.date timeIntervalSinceDate:[SLHArrivalTimeManager sharedArrivalTimeManager].leaveDate] >0.0) {
                        NSLog(@"%@: %f", condition.date, condition.temperature.c);
                        self.weatherConditionDisplay.text = [NSString stringWithFormat:@"%c", condition.climaconCharacter];
                        self.temperatureDisplay.text = [NSString stringWithFormat:@"%.0f℃", condition.temperature.c];
                        break;
                    }
                }
                
                // Do whatever you like with the data here
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleDataDisplay:(id)sender {
    
}

- (void)updateTimeData {
    NSDate *arrivalDate = [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate;
    NSDate *leavingDate = [SLHArrivalTimeManager sharedArrivalTimeManager].leaveDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    dateFormatter.locale = deLocale;
    
    [self.currentDate setText:[dateFormatter stringFromDate:arrivalDate]];
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    timeFormatter.dateStyle = NSDateFormatterNoStyle;
    timeFormatter.locale = deLocale;
    NSString *formattedArrivalTime = [timeFormatter stringFromDate:arrivalDate];
    NSString *arrivalTimeInfo = [NSString stringWithFormat:@"Ankunft um %@ Uhr", formattedArrivalTime];
    [self.currentArrivalTime setText:arrivalTimeInfo];
    
    NSString *formattedLeavingTime = [timeFormatter stringFromDate:leavingDate];
    NSString *leavingTimeInfo = [NSString stringWithFormat:@"bis zum Feierabend um %@ Uhr", formattedLeavingTime];
    [self.currentLeavingTime setText:leavingTimeInfo];
    //TODO: replace with getElapsed
    NSTimeInterval diff = [leavingDate timeIntervalSinceNow];
    self.currentProgressView.elapsed = 1-diff/[SLHArrivalTimeManager sharedArrivalTimeManager].requiredWorkingTime;
    int hours=diff/60/60;
    int mins=(diff/60)-hours*60;
    NSString *formattedDiffTime = @"Feierabend";
    if (diff > 0) {
        self.currentTimeIntervalToLeavingTime.textColor = [UIColor darkTextColor];
        formattedDiffTime = [[NSString alloc] initWithFormat:@"%d Std %d Min", hours, mins];
    } else {
        formattedDiffTime = [[NSString alloc] initWithFormat:@"%d Std %d Min", hours*-1, mins*-1];
        self.currentTimeIntervalToLeavingTime.textColor = [UIColor redColor];
        [self.currentLeavingTime setText:[NSString stringWithFormat:@"seit Feierabend um %@ Uhr", formattedLeavingTime]];
    }
    [self.currentTimeIntervalToLeavingTime setText:formattedDiffTime];
}


- (IBAction)pickArrivalDateNow:(id)sender {
    [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate = [[NSDate alloc] init];
}
@end
