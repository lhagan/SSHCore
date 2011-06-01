//
//  SSHCoreAppDelegate.h
//  SSHCore
//
//  This file is part of SSHCore
//  See https://github.com/lhagan/SSHCore for more information
//  Copyright (c) 2010-2011 Luke D Hagan
//

#import <UIKit/UIKit.h>

@class SSHCoreViewController;

@interface SSHCoreAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SSHCoreViewController *viewController;

@end
