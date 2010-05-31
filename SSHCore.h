/* SSHCore Framework - a Cocoa wrapper for libssh2
 * 
 * Revision History:
 * 0.0.1 - 2010-04-03 - proof of concept
 *
 *
 * Copyright (c) 2010 Luke D Hagan
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms,
 * with or without modification, are permitted provided
 * that the following conditions are met:
 *
 *   Redistributions of source code must retain the above
 *   copyright notice, this list of conditions and the
 *   following disclaimer.
 *
 *   Redistributions in binary form must reproduce the above
 *   copyright notice, this list of conditions and the following
 *   disclaimer in the documentation and/or other materials
 *   provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>


@interface ssh : NSObject {	
	char *hostname;
	int port;
    char *username;
    char *password;
	char *key;
	char *keypub;
}

-(int) initWithHost:(char *)host port:(int) p user:(char *)user key:(char *)k keypub:(char *)kpub;
-(NSString*) execCommand: (char *)commandline;
-(NSString*) receiveSCP: (char *)scppath;
-(int) sendSCPfile:(char *)loclfile dest:(char *)scppath;
-(NSMutableArray*) dirSFTP:(char *)sftppath;
-(NSString*) receiveSFTP:(char *)sftppath;
-(int) sendFTP:(char *)dest;
-(int) closeSSH;

-(void) libssh2ver;

@end
