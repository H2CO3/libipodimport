/*
 * server.m
 * libipodimport
 *
 * iPod library import support library
 * Created by Arpad Goretity on 24/09/2012.
 *
 * Licensed under the 3-clause BSD License
 * (See LICENSE for furhter information)
 */

#include <Foundation/Foundation.h>
#include <AppSupport/CPDistributedMessagingCenter.h>
#include <substrate.h>
#include "ipodimport.h"

@class SSDownload, SSDownloadQueue, SSDownloadMetadata, SSDownloadHandler;

static IMP _orig_SpringBoard_init;

id _mod_SpringBoard_init(id self, SEL _cmd, NSDictionary *dictionary)
{
	self = _orig_SpringBoard_init(self, _cmd);
	
	CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"org.h2co3.ipodimport"];
	[center runServerOnCurrentThread];
	[center registerForMessageName:@"org.h2co3.ipodimport.exec" target:self selector:@selector(handleMessageName:userInfo:)];
	
	return self;
}

void ipodimport_messageHandler(id self, SEL _cmd, NSString *name, NSDictionary *userInfo)
{
	NSString *path = [userInfo objectForKey:kIPIKeyPath];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"is-in-queue"];

	// Pre-initialize metadata with required defaults	
	SSDownloadMetadata *metad = [[SSDownloadMetadata alloc] initWithDictionary:dict];
	[metad setCopyright:@"This song was added to iPod using libipodimport by H2CO3."];
	[metad setPurchaseDate:[NSDate date]]; // now
	[metad setViewStoreItemURL:[NSURL URLWithString:@"http://twitter.com/H2CO3_iOS"]];
	[metad setPrimaryAssetURL:[NSURL fileURLWithPath:path]];
	[metad setReleaseDate:[NSDate date]]; // now

	// Set user-defined fields
	NSString *kind = [userInfo objectForKey:kIPIKeyMediaType];
	[metad setKind:kind != nil ? kind : kIPIMediaSong];
	[metad setTitle:[userInfo objectForKey:kIPIKeyTitle]]; // NSString
	[metad setArtistName:[userInfo objectForKey:kIPIKeyArtist]]; // NSString
	[metad setCollectionName:[userInfo objectForKey:kIPIKeyAlbum]]; // NSString
	[metad setGenre:[userInfo objectForKey:kIPIKeyGenre]]; // NSString
	[metad setDurationInMilliseconds:[userInfo objectForKey:kIPIKeyDuration]]; // NSNumber, int
	[metad setReleaseYear:[userInfo objectForKey:kIPIKeyYear]]; // NSNumber, int
	
	SSDownloadQueue *dlQueue = [[SSDownloadQueue alloc] initWithDownloadKinds:[SSDownloadQueue mediaDownloadKinds]];
	SSDownload *downl = [[SSDownload alloc] initWithDownloadMetadata:metad];
	[metad release];
	[downl setDownloadHandler:nil completionBlock:^{
		[dlQueue release];
	}];
	[dlQueue addDownload:downl];
	[downl release];
}

__attribute__((constructor))
void init()
{
	class_addMethod(
		objc_getClass("SpringBoard"),
		@selector(handleMessageName:userInfo:),
		ipodimport_messageHandler,
		"v@:@@"
	);
	MSHookMessageEx(
		objc_getClass("SpringBoard"),
		@selector(init),
		_mod_SpringBoard_init,
		&_orig_SpringBoard_init
	);
}
