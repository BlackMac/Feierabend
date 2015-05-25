//
//  TimePickerTableViewCell.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 25.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerDateChanged:(id)sender;

@end
