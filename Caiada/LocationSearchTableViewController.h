//
//  LocationSearchTableViewController.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 25.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSearchTableViewController : UITableViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
