//
// hack to fix libssh2 issues in iPhone Simulator
//

#import <UIKit/UIKit.h>
#include <dirent.h>
#include <fnmatch.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>

DIR * opendir$INODE64$UNIX2003( char * dirName )
{
    return opendir( dirName );
}

struct dirent * readdir$INODE64( DIR * dir )
{
    return readdir( dir );
}

BOOL closedir$UNIX2003( DIR * dir )
{
    return closedir( dir );
}   

int fnmatch$UNIX2003( const char * pattern, const char * string, int flags )
{
    return fnmatch( pattern, string, flags );
}

int write$UNIX2003( const void * buffer, size_t size, size_t count, FILE * stream )
{
    return fwrite( buffer, size, count, stream );
}   

FILE * fopen$UNIX2003( const char * fname, const char * mode )
{
    return fopen( fname, mode );
}

FILE * open$UNIX2003( const char * fname, int mode )
{
    return ( FILE * ) open( fname, mode );
}

int read$UNIX2003( FILE * fd, char * buffer, unsigned int n )
{
    return read( ( int ) fd, buffer, n );
}       

int close$UNIX2003( FILE * fd )
{
    return close( ( int ) fd );
}       

int stat$INODE64( const char * pcc, struct stat * pss ) 
{
    return stat( pcc, pss );
}       

int fcntl$UNIX2003( int fildes, int cmd, int one )
{
    return fcntl( fildes, cmd, one );
}

int fstat$INODE64( int filedes, struct stat * buf )
{
    return fstat( filedes, buf );
}       

ssize_t pread$UNIX2003( int fildes, void *buf, size_t nbyte, off_t offset )
{
    return pread( fildes, buf, nbyte, offset );
}  

ssize_t send$UNIX2003(int s, const void *msg, size_t len, int flags)
{
    return send ( s, msg, len, flags);
}

ssize_t recv$UNIX2003(int s, void *msg, int len, int flags)
{
    return recv ( s, msg, len, flags);
}

int select$UNIX2003(int  nfds,  fd_set  *readfds,  fd_set  *writefds, fd_set *errorfds, struct timeval *timeout)
{
    return select ( nfds, readfds, writefds, errorfds, timeout);
}

clock_t clock$UNIX2003( void )
{
    return clock ();
}