//
//  main.m
//  SSHCore
//
//  This file is part of SSHCore
//  See https://github.com/lhagan/SSHCore for more information
//  Copyright (c) 2010-2011 Luke D Hagan
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
