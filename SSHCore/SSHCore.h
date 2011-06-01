/* SSHCore Framework - a Cocoa wrapper for libssh2
 * 
 * Revision History:
 * 0.1.0 - 2011-05-31 - heavily reworked to work on iPhone
 * 0.0.1 - 2010-04-03 - proof of concept
 *
 *
 * Copyright (c) 2010-2011 Luke D Hagan
 * All rights reserved.
 * 
 * Includes a copy of libssh2, an open-source library released
 * under the BSD licence. libssh2 is copyright the libssh2 team
 * and respective authors. See http://www.libssh2.org for more
 * information.
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
	const char *hostname;
	int port;
    const char *username;
    const char *password;
	const char *key;
	const char *keypub;
}

-(int) initWithHost:(NSString*)host port:(int) p user:(NSString*)user key:(NSString*)k keypub:(NSString*)kpub password:(NSString*)pass;
-(NSString*) execCommand: (NSString*)commandline;
-(int) closeSSH;

-(void) libssh2ver;

@end
