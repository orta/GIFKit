//
//  GIF+RedditDictionary.m
//  Pods
//
//  Created by Orta on 7/1/14.
//
//

#import "GIF+RedditDictionary.h"

@interface GIF()
@property (nonatomic, assign, readwrite) BOOL adultcontent;
@end

@implementation GIF (RedditDictionary)

- (instancetype)initWithRedditDictionary:(NSDictionary *)dictionary
{
    NSDictionary *data = dictionary[@"data"];
    NSString *thumbnailURL = data[@"thumbnail"];
    NSString *downloadURL = data[@"url"];
    NSString *sourceURL = [NSString stringWithFormat:@"http://reddit.com%@", dictionary[@"data"][@"permalink"]];

    if (thumbnailURL.length == 0) {
        if ([downloadURL rangeOfString:@"imgur"].location != NSNotFound) {
            thumbnailURL = [downloadURL stringByReplacingOccurrencesOfString:@".gif" withString:@"b.jpg"];

        } else {
            // ergh, this would take a while
            thumbnailURL = downloadURL;
        }
    }

    downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"http://imgur.com/" withString:@"http://imgur.com/download/"];
    downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@".gifv" withString:@".gif"];

    // http://imgur.com/download/a/1iZuu -> http://i.imgur.com/3r3yeIz.gif

    if ([downloadURL hasPrefix:@"http://imgur.com/download/a/"]) {
        downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"http://imgur.com/download/a/" withString:@""];
        downloadURL = [NSString stringWithFormat:@"http://i.imgur.com/%@.gif", downloadURL];
    }

    // http://gifsound.com/?gif=http%3A%2F%2Fi.imgur.com%2FWcpOt.gif&sound=http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DZii3FYWaE4I&start=0  ->  http://i.imgur.com/3r3yeIz.gif

    if ([downloadURL hasPrefix:@"http://gifsound.com/?gif="]) {
        downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"http://gifsound.com/?gif=" withString:@""];
        downloadURL = [downloadURL componentsSeparatedByString:@"&amp;sound="][0];
        downloadURL = [downloadURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    if ([downloadURL hasPrefix:@"http://imgur.com/download/gallery/"]) {
        return nil;
    }

    if ([downloadURL rangeOfString:@"imgur"].location == NSNotFound && [downloadURL rangeOfString:@"media.tumblr.com"].location == NSNotFound) {
        return nil;
    }

    self = [self initWithDownloadURL:downloadURL thumbnail:thumbnailURL source:sourceURL sourceTitle:data[@"title"]];
    [self setAdultcontent: [data[@"over_18"] boolValue]];

    return self;
}


@end
