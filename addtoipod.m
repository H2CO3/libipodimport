/*
 * addtoipod.m
 * A command line tool for adding media to the iPod library
 * 
 * Created by Árpád Goretity on 24/09/2012.
 * Licensed under the 3-clause BSD License
 * (See LICENSE for further information)
 */

#include <stdio.h>
#include <stdarg.h>
#include <ipodimport.h>
#include <Foundation/Foundation.h>

void c_printf(NSString *fmt, ...)
{
        va_list args;
        va_start(args, fmt);
        NSString *res = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        printf("%s", [res UTF8String]);
        [res release];
}

void print_usage(NSString *progname)
{
        c_printf(@"%@ - a CLI tool for adding media to the iPod library\n", progname);
        c_printf(@"Usage: %@ [options] file\n", progname);
        c_printf(@"Where options can be:\n");
	c_printf(@"\t-k <kind>\t\tSet media kind/type\n");
        c_printf(@"\t-t <title>\t\tSet song title\n");
        c_printf(@"\t-a <artist>\t\tSet artist\n");
	c_printf(@"\t-b <album>\t\tSet album title\n");
        c_printf(@"\t-l <length>\t\tSong length in seconds\n");
        c_printf(@"\t-g <genre>\t\tHuman-readable genre name\n");
        c_printf(@"\t-y <title>\t\tSet release year\n\n");
	c_printf(@"Specifying the -t option is mandatory\n\n");
	c_printf(@"The -k option accepts the following parameters:\n");
	c_printf(@"song, music-video, ringtone, podcast, itunes-u, tv-episode,\n");
	c_printf(@"software, document, book, ebook\n\n");
}

NSArray *args_to_array(int argc, char **argv)
{
        NSMutableArray *arr = [NSMutableArray array];
        int i;
        for (i = 0; i < argc; i++) {
                NSString *str = [NSString stringWithUTF8String:argv[i]];
                [arr addObject:str];
        }
        return arr;
}

NSDictionary *parse_args(NSArray *args)
{
        NSString *progname = [args objectAtIndex:0];

        if ([args count] < 2) {
                print_usage(progname);
                exit(1);
        }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        int i = 1;
        while (i < [args count]) {
                NSString *arg = [args objectAtIndex:i];

		if ([arg isEqualToString:@"-k"]) {
                        NSString *kind = [args objectAtIndex:i + 1];
                        [dict setObject:kind forKey:kIPIKeyMediaType];
                        i += 2;
		} else if ([arg isEqualToString:@"-t"]) {
                        NSString *title = [args objectAtIndex:i + 1];
                        [dict setObject:title forKey:kIPIKeyTitle];
                        i += 2;
                } else if ([arg isEqualToString:@"-a"]) {
                        NSString *artist = [args objectAtIndex:i + 1];
                        [dict setObject:artist forKey:kIPIKeyArtist];
                        i += 2;
                } else if ([arg isEqualToString:@"-b"]) {
                        NSString *album = [args objectAtIndex:i + 1];
                        [dict setObject:album forKey:kIPIKeyAlbum];
                        i += 2;
                } else if ([arg isEqualToString:@"-l"]) {
                        NSString *len = [args objectAtIndex:i + 1];
                        float secs = [len floatValue];
                        int msecs = secs * 1000;
                        NSNumber *length = [NSNumber numberWithInt:msecs];
                        [dict setObject:length forKey:kIPIKeyDuration];
                        i += 2;
                } else if ([arg isEqualToString:@"-g"]) {
                        NSString *genre = [args objectAtIndex:i + 1];
                        [dict setObject:genre forKey:kIPIKeyGenre];
                        i += 2;
                } else if ([arg isEqualToString:@"-y"]) {
                        NSString *yrStr = [args objectAtIndex:i + 1];
                        int yr = [yrStr intValue];
                        NSNumber *year = [NSNumber numberWithInt:yr];
                        [dict setObject:year forKey:kIPIKeyYear];
                        i += 2;
                } else {
                        // Assume a file if not an option
                        [dict setObject:arg forKey:@"FILE_PATH"];
                        i++;
                }
        }

        return dict;
}

int main(int argc, char **argv)
{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSArray *args = args_to_array(argc, argv);
        NSDictionary *meta = parse_args(args);
        NSString *path = [meta objectForKey:@"FILE_PATH"];

        [[IPIPodImporter sharedInstance] importFileAtPath:path withMetadata:meta];

        [pool release];
        return 0;
}

