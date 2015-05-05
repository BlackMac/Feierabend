//
//  ArrivalTimePickerViewController.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrivalTimePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *arrivalTimeDatePicker;
- (IBAction)pickArrivalTimeNow:(id)sender;
- (IBAction)pickArrivalTimeUserProvided:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *scheduledWorkingMinutes;

@end
