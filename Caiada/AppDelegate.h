//
//  AppDelegate.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WatchConnectivity;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

