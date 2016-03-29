//
//  SettingsTableViewController.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 24.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TimePickerTableViewCell.h"
#import "SLHArrivalTimeManager.h"

@interface SettingsTableViewController () {
    NSMutableArray *expandedPaths;
    BOOL datePickerOpen;
    UIColor *defaultDetailLabelColor;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    expandedPaths = [[NSMutableArray alloc] init];
    datePickerOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addressUpdated:)
                                                 name:SLHArrivalTimeAddressUpdatedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeManagerUpdated:)
                                                 name:SLHArrivalTimeUpdatedNotification
                                               object:nil];
    [super viewDidLoad];
}

-(void)timeManagerUpdated:(id)object {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)addressUpdated:(id)object {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + (datePickerOpen ? 1 : 0);
}

- (UITableViewCell *)timePickerCellForTableView:(UITableView *)tableView {
    TimePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimePickerCellIdentifier"];
    
    NSDate *arrival = [NSDate dateWithTimeIntervalSince1970:[[SLHArrivalTimeManager sharedArrivalTimeManager] requiredWorkingTime]];
    cell.datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    cell.datePicker.date = arrival;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (datePickerOpen && indexPath.row == 1) {
        return 218;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 1 && datePickerOpen) {
        return [self timePickerCellForTableView:tableView];
    }
    UITableViewCell *cell;

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSettingsCellIdentifier"];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TimeSettingsCellIdentifier"];
        }
        cell.textLabel.text = @"Arbeitszeit";
        if (datePickerOpen) {
            cell.detailTextLabel.textColor = self.view.tintColor;
        } else {
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        cell.detailTextLabel.text = [[SLHArrivalTimeManager sharedArrivalTimeManager] formattedRequiredTime];
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BreakSettingsCellIdentifier"];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BreakSettingsCellIdentifier"];
        }
        cell.textLabel.text = @"Pause";
        if (datePickerOpen) {
            cell.detailTextLabel.textColor = self.view.tintColor;
        } else {
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        cell.detailTextLabel.text = [[SLHArrivalTimeManager sharedArrivalTimeManager] formattedRequiredTime];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LocationSettingsCellIdentifier"];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationSettingsCellIdentifier"];
        }
        
        cell.textLabel.text = @"Arbeitsplatz";
        if ([[SLHArrivalTimeManager sharedArrivalTimeManager] workLocation]) {
            cell.detailTextLabel.text = [[SLHArrivalTimeManager sharedArrivalTimeManager] workLocationAddress];
            cell.textLabel.textColor = [UIColor darkTextColor];
        } else {
            cell.detailTextLabel.text = @"";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    NSIndexPath *dateDisplayPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *datePickerPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
        if (!datePickerOpen) {
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];

                datePickerOpen = YES;
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:datePickerPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:dateDisplayPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                         bundle: nil];
                UITableViewController *info=[MainStoryboard instantiateViewControllerWithIdentifier:@"SLHWorkplaceSearchStoryboard"];
                [self.navigationController pushViewController:info animated:YES];
                
                //SLHWorkplaceSearchStoryboard
            }
        } else {
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            datePickerOpen = NO;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:datePickerPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:dateDisplayPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
