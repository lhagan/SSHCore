SSHCore Framework
===========
A Cocoa wrapper for libssh2

**Note: SSHCore is no longer supported or under active development. You might want to try
[libssh2-for-iOS](https://github.com/x2on/libssh2-for-iOS) instead.**

SSHCore is a start at wrapping libssh2 into a convenient package for use on iOS. It's currently
just a proof of concept so functionality is limited and error handling is very minimal. The whole thing
is also quite subject to change. The long-term goal of the project is to provide a simple, drop-in
framework that allows iOS applications to interact with SSH servers.

It's been significantly rewritten
from the first version to exclusively support the iOS Simulator and devices (iPhone, iPad, etc.). The
present implementation is a demo project that can:

* connect to an SSH server using password or key-based authentication
* run commands on the remote server and get any stdout back as an NSString

Currently, SSHCore can only connect to a (stock) Mac OS X system using key-based authentication. The OS X SSH
server is configured out of the box to reject password authentication, requiring instead interactive auth.

To Do:
------

* re-implementation of SCP & SFTP support (removed for version 0.1.0)
* improved authentication support
* actual error handling
* framework architecture

Usage
-------

Here is a simple usage example. Currently, this entire project is an example, so you'll find pretty much the same
thing in `SSHCoreViewController.m`.

To use, copy SSHCore.m & .h and everything from the Supporting Files/Library group into your project. 
Make sure you add `-lz` to Other Compiler Flags in your project's settings as SSHCore's libraries require libz.

    #import "SSHCore.h"
    
    // create an ssh object
    ssh *myssh = [[ssh alloc] init];
    
    // get the libssh2 version
    [myssh libssh2ver];
	
   	// log in to server using password auth
   	[myssh initWithHost: @"192.168.0.100"
   				   port: 22
   				   user: @"user"
   					key: @""
   				 keypub: @""
   			   password: @"password"];
   			   
  	// or log in to server using key (leave password blank)
  	[myssh initWithHost: @"192.168.0.100"
  				   port: 22
  				   user: @"user"
  					key: @"/path/to/key"
  				 keypub: @"/path/to/key.pub"
  			   password: @""];

    // execute a command on the remote server
    NSString *result = [myssh execCommand: "uptime"];
    NSLog(@"%@", result);
    
    // close SSH connection & release object
    [myssh closeSSH];
    [myssh release];

Building Libraries
------------------

The precompiled library binaries (*.a) currently only support armv6 and i386. See `library-build-notes.txt` for steps to build universal binaries of these libraries for all current iOS hardware and the simulator.

Using on OS X
-------------

This framework is targeted at iOS only, but Dan Finneran has written a [libssh2 wrapper for OS X](http://thebsdbox.co.uk/?p=257) based on SSHCore that you might want to check out.

License
-------

Copyright (c) 2010-2011 Luke D Hagan
All rights reserved.
Released under the BSD license.

Includes a copy of libssh2, an open-source library released
under the BSD licence. libssh2 is copyright the libssh2 team
and respective authors. See [http://www.libssh2.org](http://www.libssh2.org)
for more information.

Redistribution and use in source and binary forms,
with or without modification, are permitted provided
that the following conditions are met:

   Redistributions of source code must retain the above
   copyright notice, this list of conditions and the
   following disclaimer.

   Redistributions in binary form must reproduce the above
   copyright notice, this list of conditions and the following
   disclaimer in the documentation and/or other materials
   provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.
