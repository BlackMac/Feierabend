//
//  ViewController.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "ViewController.h"
#import "SLHArrivalTimeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [self updateTimeData];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                            target:self
                          selector:@selector(updateTimeData)
                          userInfo:nil
                           repeats:YES];
    
    [super viewDidLoad];
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
