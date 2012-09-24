/*
 * client.m
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
#include "ipodimport.h"

static id shared = nil;

@implementation IPIPodImporter

+ (IPIPodImporter *)sharedInstance
{
	if (shared == nil) {
		shared = [[self alloc] init];
	}
	return shared;
}

- (void)importFileAtPath:(NSString *)path withMetadata:(NSDictionary *)metadata
{
	// Copy over the file since the iPod library subsystem deletes it (!) after importing
	NSString *fileName = [path lastPathComponent];
	NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] copyItemAtPath:path toPath:tempPath error:NULL];
	
	// Set up the context information
	NSMutableDictionary *info = [metadata mutableCopy];
	[info setObject:tempPath forKey:kIPIKeyPath];
	
	// And actually call the server
	CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"org.h2co3.ipodimport"];
	[center sendMessageName:@"org.h2co3.ipodimport.exec" userInfo:info];
}

@end
