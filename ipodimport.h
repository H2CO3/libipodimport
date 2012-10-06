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

// Metadata keys
#define kIPIKeyPath		@"path"		// NSString, filesystem path to the file to be imported
#define kIPIKeyTitle		@"title"	// NSString, title of the song
#define kIPIKeyArtist		@"artist"	// NSString, name of the singer/author etc...
#define kIPIKeyAlbum		@"album"	// NSString, title of the album
#define kIPIKeyGenre		@"genre"	// NSString, human-readable genre, such as Rock, Pop, Classical or Dance
#define kIPIKeyDuration		@"duration"	// NSNumber with `int`, duration in milliseconds
#define kIPIKeyYear		@"year"		// NSNumber with `int`
#define kIPIKeyMediaType	@"type"		// One of the kIPIMedia constants, media type, defaults to kIPIMediaSong if unspecified
#define kIPIKeyArtworkPath @"artworkPath" // NSString with the path to the Artwork Image

// Media type keys
#define kIPIMediaSong		@"song"		// Song, music
#define kIPIMediaMusicVideo	@"music-video"	// Video
#define kIPIMediaPodcast	@"podcast"	// Podcast
#define kIPIMediaRingtone	@"ringtone"	// Ringtone
#define kIPIMediaSoftware	@"software"	// ??? AppStore application ???
#define kIPIMediaDocument	@"document"	// ???
#define kIPIMediaITunesU	@"itunes-u"	// iTunes U piece
#define kIPIMediaBook		@"book"		// Book
#define kIPIMediaEBook		@"ebook"	// E-Book
#define kIPIMediaTVEpisode	@"tv-episode"	// TV episode

@interface IPIPodImporter: NSObject

+ (IPIPodImporter *)sharedInstance;
- (void)importFileAtPath:(NSString *)path withMetadata:(NSDictionary *)metadata;

@end

#endif /* __IPODIMPORT_H__ */
