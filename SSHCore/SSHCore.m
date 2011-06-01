/* Copyright (c) 2004-2007 Sara Golemon <sarag@libssh2.org>
 * Copyright (c) 2006-2007 The Written Word, Inc.
 * Copyright (c) 2009 Daniel Stenberg
 * Copyright (C) 2008, 2009 Simon Josefsson
 * Copyright (c) 2010-2011 Luke D Hagan
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
 *   Neither the name of the copyright holder nor the names
 *   of any other contributors may be used to endorse or
 *   promote products derived from this software without
 *   specific prior written permission.
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

#import "SSHCore.h"

#include "libssh2_config.h"
#include "libssh2.h"

#ifdef HAVE_WINSOCK2_H
# include <winsock2.h>
#endif
#ifdef HAVE_SYS_SOCKET_H
# include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
# include <netinet/in.h>
#endif
#ifdef HAVE_SYS_SELECT_H
# include <sys/select.h>
#endif
# ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_ARPA_INET_H
# include <arpa/inet.h>
#endif

#include <sys/time.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <ctype.h>

unsigned long hostaddr;
int sock;
struct sockaddr_in soin;
const char *fingerprint;
LIBSSH2_SESSION *session;
LIBSSH2_CHANNEL *channel;
int rc;
int exitcode;
int bytecount = 0;
size_t len;
LIBSSH2_KNOWNHOSTS *nh;
int type;

// from libssh2 example - ssh2_exec.c
static int waitsocket(int socket_fd, LIBSSH2_SESSION *session)
{
    struct timeval timeout;
    int rc;
    fd_set fd;
    fd_set *writefd = NULL;
    fd_set *readfd = NULL;
    int dir;
	
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
	
    FD_ZERO(&fd);
	
    FD_SET(socket_fd, &fd);
	
    /* now make sure we wait in the correct direction */
    dir = libssh2_session_block_directions(session);
	
    if(dir & LIBSSH2_SESSION_BLOCK_INBOUND)
        readfd = &fd;
	
    if(dir & LIBSSH2_SESSION_BLOCK_OUTBOUND)
        writefd = &fd;
	
    rc = select(socket_fd + 1, readfd, writefd, NULL, &timeout);
	
    return rc;
}

/* diff in ms */
static long tvdiff(struct timeval newer, struct timeval older)
{
	return (newer.tv_sec-older.tv_sec)*1000+
	(newer.tv_usec-older.tv_usec)/1000;
}

@implementation ssh

-(int) initWithHost:(NSString*)host port:(int) p user:(NSString*)user key:(NSString*)k keypub:(NSString*)kpub password:(NSString*)pass {
	hostname = [host UTF8String];
	port = p;
	username = [user UTF8String];
	key = [k UTF8String];
	keypub = [kpub UTF8String];
	password = [pass UTF8String];
	
#ifdef WIN32
    WSADATA wsadata;
    WSAStartup(MAKEWORD(2,0), &wsadata);
#endif
	
    hostaddr = inet_addr(hostname);
	
    /* Ultra basic "connect to port 22 on localhost"
     * Your code is responsible for creating the socket establishing the
     * connection
     */
    sock = socket(AF_INET, SOCK_STREAM, 0);
	
    soin.sin_family = AF_INET;
    soin.sin_port = htons(port);
    soin.sin_addr.s_addr = hostaddr;
    if (connect(sock, (struct sockaddr*)(&soin),
                sizeof(struct sockaddr_in)) != 0) {
		NSLog(@"Failed to connect!");
        return -1;
    }
	
    /* Create a session instance */
    session = libssh2_session_init();
    if (!session)
        return -1;
	
    /* tell libssh2 we want it all done non-blocking */
    libssh2_session_set_blocking(session, 0);
	
    /* ... start it up. This will trade welcome banners, exchange keys,
     * and setup crypto, compression, and MAC layers
     */
    while ((rc = libssh2_session_startup(session, sock)) ==
           LIBSSH2_ERROR_EAGAIN);
    if (rc) {
		NSLog(@"Failure establishing SSH session: %d", rc);
        return -1;
    }
	
    nh = libssh2_knownhost_init(session);
    if(!nh) {
        /* eeek, do cleanup here */
        return 2;
    }
	
    /* read all hosts from here */
    libssh2_knownhost_readfile(nh, "known_hosts",
                               LIBSSH2_KNOWNHOST_FILE_OPENSSH);
	
    /* store all known hosts to here */
    libssh2_knownhost_writefile(nh, "dumpfile",
                                LIBSSH2_KNOWNHOST_FILE_OPENSSH);
	
    fingerprint = libssh2_session_hostkey(session, &len, &type);
    if(fingerprint) {
        struct libssh2_knownhost *host;
        int check = libssh2_knownhost_check(nh, (char *)hostname,
                                            (char *)fingerprint, len,
                                            LIBSSH2_KNOWNHOST_TYPE_PLAIN|
                                            LIBSSH2_KNOWNHOST_KEYENC_RAW,
                                            &host);
		
        NSLog(@"Host check: %d, key: %s", check,
                (check <= LIBSSH2_KNOWNHOST_CHECK_MISMATCH)?
                host->key:"<none>");
		
        /*****
         * At this point, we could verify that 'check' tells us the key is
         * fine or bail out.
         *****/
    }
    else {
        /* eeek, do cleanup here */
        return 3;
    }
    libssh2_knownhost_free(nh);
	
    if ( strlen(password) != 0 ) {
	if ( 1 ) {
		/* We could authenticate via password */
        while ((rc = libssh2_userauth_password(session, username, password)) ==
			   LIBSSH2_ERROR_EAGAIN);
		if (rc) {
			NSLog(@"Authentication by password failed.");
			return 1;
		}
	}
	else {
		/* Or by public key */
		while ((rc = libssh2_userauth_publickey_fromfile(session, username, keypub, key, password)) == LIBSSH2_ERROR_EAGAIN);
		if (rc) {
			NSLog(@"Authentication by public key failed");
			return 1;
		}
		}
		
#if 0
		libssh2_trace(session, ~0 );
#endif
		
	}
	return 0;
}

// from libssh2 example - ssh2_exec.c
-(NSString*) execCommand: (NSString *)commandline {
	NSString *result;
	const char * cmd = [commandline UTF8String];
	
    /* Exec non-blocking on the remote host */
    while( (channel = libssh2_channel_open_session(session)) == NULL &&
		  libssh2_session_last_error(session,NULL,NULL,0) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    if( channel == NULL )
    {
        NSLog(@"Error\n");
        exit( 1 );
    }
    while( (rc = libssh2_channel_exec(channel, cmd)) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    if( rc != 0 )
    {
        NSLog(@"Error\n");
        exit( 1 );
    }
    for( ;; )
    {
        /* loop until we block */
        int rc1;
        do
        {
            char buffer[0x4000];
            rc1 = libssh2_channel_read( channel, buffer, sizeof(buffer) );
            if( rc1 > 0 )
            {
				result = [NSString stringWithCString:buffer encoding: 4];
				
                //int i;
                bytecount += rc1;
                /*fprintf(stderr, "We read:\n");
                for( i=0; i < rc1; ++i )
                    fputc( buffer[i], stderr);
                fprintf(stderr, "\n");*/
            }
            else {
                NSLog(@"libssh2_channel_read returned %d", rc1);
            }
        }
        while( rc1 > 0 );
		
        /* this is due to blocking that would occur otherwise so we loop on
		 this condition */
        if( rc1 == LIBSSH2_ERROR_EAGAIN )
        {
            waitsocket(sock, session);
        }
        else
            break;
    }
    exitcode = 127;
    while( (rc = libssh2_channel_close(channel)) == LIBSSH2_ERROR_EAGAIN )
        waitsocket(sock, session);
	
    if( rc == 0 )
    {
        exitcode = libssh2_channel_get_exit_status( channel );
    }
    NSLog(@"\nEXIT: %d bytecount: %d", exitcode, bytecount);
	
    libssh2_channel_free(channel);
    channel = NULL;
	
    return result;

}
	
-(int) closeSSH {	
    libssh2_session_disconnect(session,
                               "Normal Shutdown, Thank you for playing");
    libssh2_session_free(session);
	
#ifdef WIN32
    closesocket(sock);
#else
    close(sock);
#endif
    NSLog(@"all done\n");
	
	return 0;
}
	
-(void) libssh2ver {
	NSString *version = [NSString stringWithCString:libssh2_version(0) encoding: 4];
	NSLog(@"We are using libssh2 version: %@", version);
}

@end
