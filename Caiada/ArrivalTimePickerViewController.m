//
//  ArrivalTimePickerViewController.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "ArrivalTimePickerViewController.h"
#import "SLHArrivalTimeManager.h"

@interface ArrivalTimePickerViewController ()

@end

@implementation ArrivalTimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    NSDate *arrival = (NSDate *)[[NSUserDefaults standardUserDefaults] valueForKey:@"Arrival"];
    self.arrivalTimeDatePicker.date = arrival;
    self.scheduledWorkingMinutes.text = [[NSString alloc] initWithFormat:@"%i", (int)[SLHArrivalTimeManager sharedArrivalTimeManager].requiredWorkingTime/60];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeWithoutChanges:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)pickArrivalTimeNow:(id)sender {
    [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate = [[NSDate alloc] init];
    [SLHArrivalTimeManager sharedArrivalTimeManager].requiredWorkingTime = [self.scheduledWorkingMinutes.text doubleValue]*60;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickArrivalTimeUserProvided:(id)sender {
    [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate =  [self.arrivalTimeDatePicker date];
    [SLHArrivalTimeManager sharedArrivalTimeManager].requiredWorkingTime = [self.scheduledWorkingMinutes.text doubleValue]*60;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
