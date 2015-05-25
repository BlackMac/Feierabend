//
//  TimePickerTableViewCell.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 25.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "TimePickerTableViewCell.h"
#import "SLHArrivalTimeManager.h"

@implementation TimePickerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)datePickerDateChanged:(UIDatePicker *)sender {
    [[SLHArrivalTimeManager sharedArrivalTimeManager] setRequiredWorkingTime:[sender.date timeIntervalSince1970]];
}
@end
