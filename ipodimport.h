/*
 * ipodimport.h
 * libipodimport
 *
 * iPod library import support library
 * Created by Arpad Goretity on 24/09/2012.
 *
 * Licensed under the 3-clause BSD License
 * (See LICENSE for furhter information)
 */

#ifndef __IPODIMPORT_H__
#define __IPODIMPORT_H__

#include <Foundation/Foundation.h>

#define kIPIKeyPath		@"path"		// NSString, filesystem path to the file to be imported
#define kIPIKeyTitle		@"title"	// NSString, title of the song
#define kIPIKeyArtist		@"artist"	// NSString, name of the singer/author etc...
#define kIPIKeyGenre		@"genre"	// NSString, human-readable genre, such as Rock, Pop, Classical or Dance
#define kIPIKeyDuration		@"duration"	// NSNumber with `int`, duration in milliseconds
#define kIPIKeyYear		@"year"		// NSNumber with `int`

@interface IPIPodImporter: NSObject

+ (IPIPodImporter *)sharedInstance;
- (void)importFileAtPath:(NSString *)path withMetadata:(NSDictionary *)metadata;

@end

#endif /* __IPODIMPORT_H__ */
