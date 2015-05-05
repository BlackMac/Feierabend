//
//  DismissSeque.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 03.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "DismissSeque.h"

@implementation DismissSeque

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
