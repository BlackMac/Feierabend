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
    NSDate *arrival = [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate;
    self.arrivalTimeDatePicker.date = arrival;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickArrivalTimeUserProvided:(id)sender {
    [SLHArrivalTimeManager sharedArrivalTimeManager].arrivalDate =  [self.arrivalTimeDatePicker date];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
