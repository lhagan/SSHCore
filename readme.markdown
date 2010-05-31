SSHCore Framework
===========
A Cocoa wrapper for libssh2

So far, SSHCore is my initial attempt at packaging libssh2 into a Cocoa framework. It's currently
just a proof of concept so functionality is limited and error handling is minimal. The whole thing
is also quite subject to change. The long-term goal of the project is to provide a simple, drop-in
framework that allows Cocoa applications (including iPhone) to interact with SSH servers. The
present implementation can:

* run commands on the remote server,
* upload and download via SCP
* upload and download via SFTP

Only key-based authentication is supported for now, however it should be trivial to add password-based
login functionality.

The copy of libssh2.dylib included with the framework is Intel-only, so you'll need to recompile for any other
platform, including the iPhone. The Intel version of the framework works fine in the iPhone Simulator, however.
Try [these instructions]("http://sites.google.com/site/olipion/cross-compilation/libssh2") if you're
interested in using SSHCore on iPhone.

SSHCore and libssh2 are both BSD-licensed, so you can use the framework pretty much any way you want.

Many thanks to [Cocoaism]("http://cocoaism.com/how-to-bundle-dynamic-library-files-with-your-application/#comments")
and [Cocoa is My Girlfriend]("http://www.cimgf.com/2008/09/04/cocoa-tutorial-creating-your-very-own-framework/") for the
great tutorials that helped me put SSHCore together.

Usage
-------

Usage is the same as any Cocoa framework:

1. Open the SSHCore project in XCode and build it
2. Drag `SSHCore.framework` from the `build` folder into the "Frameworks" group in your application's XCode project window
3. Check "Copy items into destination group's folder (if needed)," then click "Add"
4. Right-click your application's Target under "Targets" in the "Groups & Files" list and select Add > New Build Phase >
New Copy Files Build Phase
5. Select "Frameworks" from the drop down menu in the resulting window, then close the window
6. Click the little arrow next to your application's target to show the new "Copy Files" build phase
7. Drag SSHCore.framework from the "Frameworks" group onto the "Copy Files" phase
8. Add `#import <SSHCore/SSHCore.h>` to your source code

Here are some usage examples:
    
    // create an ssh object
    ssh *myssh = [[ssh alloc] init];
    
    // get the libssh2 version
    [myssh libssh2ver];

    // log in to server using public key
    [myssh initWithHost: "192.168.0.100"
    			   port: 22
    			   user: "username"
    				key: "~/.ssh/id_dsa"
    			 keypub: "~/.ssh/id_dsa.pub"];

    // execute a command on the remote server
    NSString *result = [myssh execCommand: "uptime"];
    NSLog(@"%@", result);

    // get contents of a remote file via SCP
    NSLog(@"%@", [myssh receiveSCP: "test.txt"]);
    
    // send a file via SCP
    [myssh sendSCPfile:"~/test1.txt" dest:"test1.txt"];
    
    // get remote directory listing via SFTP
    NSMutableArray *ftpdirs = [myssh dirSFTP:"/"];
    NSLog(@"%@", ftpdirs);

    // get contents of a file via SFTP
    NSString *result = [myssh receiveSFTP:"~/test1.txt"];
    NSLog(@"Got data: %@", result);
    
    // close SSH connection & release object
    [myssh closeSSH];
    [myssh release];


License
-------

Copyright (c) 2010 Luke D Hagan
All rights reserved.

Includes a copy of libssh2, an open-source library released
under the BSD licence. libssh2 is copyright the libssh2 team
and respective authors. See http://www.libssh2.org for more
information.

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
