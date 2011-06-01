//
//  SSHCoreViewController.m
//  SSHCore
//
//  This file is part of SSHCore
//  See https://github.com/lhagan/SSHCore for more information
//  Copyright (c) 2010-2011 Luke D Hagan
//

#import "SSHCoreViewController.h"
#import "SSHCore.h"

@implementation SSHCoreViewController

- (void)dealloc
{
    [viewText release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // output string for UITextView
	NSString *output = @"";
	
	// create an ssh object
	ssh *myssh = [[ssh alloc] init];
    
	// log in to server using password auth
	// note: leave password blank for key-based auth
	[myssh initWithHost: @"192.168.0.100"
				   port: 22
				   user: @"user"
					key: @""
				 keypub: @""
			   password: @"password"];
	
	// execute command on server
    NSString *command = @"uptime";
    NSString *result = [myssh execCommand: command];
		
    // log results to console
    NSLog(@"%@", command);
    NSLog(@"%@", result);
    
    // generate rudimentary output string for UITextView
    output = [output stringByAppendingString: command];
    output = [output stringByAppendingString: @"\r\n----------------\r\n"];
    
    // minimal handling of connection failures, etc
    if (result != nil) {
        output = [output stringByAppendingString: result];
    } else {
        output = [output stringByAppendingString: @"server returned null"];
    };
    
    // set UITextView to the output string 
	viewText.text = output;

	// close SSH connection & release object
	[myssh closeSSH];
	[myssh release];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
