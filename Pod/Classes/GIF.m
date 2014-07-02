//
//  GIF.m
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "GIF.h"

@interface GIF()

@property (nonatomic, copy, readonly) NSString *thumbnailAddress;
@property (nonatomic, copy, readonly) NSString *downloadAddress;
@property (nonatomic, copy, readonly) NSString *sourceAddress;
@property (nonatomic, strong, readwrite) NSDate *dateAdded;
@end

@implementation GIF

- (instancetype)initWithRedditDictionary:(NSDictionary *)dictionary
{

    NSString *thumbnailURL = dictionary[@"data"][@"thumbnail"];
    NSString *downloadURL = dictionary[@"data"][@"url"];
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

    self = [self initWithDownloadURL:downloadURL thumbnail:thumbnailURL andSource:sourceURL];
    return self;
}

- (instancetype)initWithDownloadURL:(NSString *)downloadURL thumbnail:(NSString *)thumbnail andSource:(NSString *)source
{
    self = [super init];
    if (!self) return nil;
    
    _thumbnailAddress = thumbnail;
    _downloadAddress = downloadURL;
    _sourceAddress = source;

    return self;
}

#define ORGIFDownloadKey       @"ORGIFDownloadKey"
#define ORGIFThumbnailKey      @"ORGIFThumbnailKey"
#define ORGIFDateAddedKey      @"ORGIFDateAddedKey"
#define ORGIFSourceKey         @"ORGIFSourceKey"


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_thumbnailAddress forKey:ORGIFThumbnailKey];
    [encoder encodeObject:_downloadAddress forKey:ORGIFDownloadKey];
    [encoder encodeObject:_dateAdded forKey:ORGIFDateAddedKey];
    [encoder encodeObject:_sourceAddress forKey:ORGIFSourceKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSString *thumbnail = [decoder decodeObjectForKey:ORGIFThumbnailKey];
    NSString *download = [decoder decodeObjectForKey:ORGIFDownloadKey];
    NSString *source = [decoder decodeObjectForKey:ORGIFSourceKey];
    NSDate *date = [decoder decodeObjectForKey:ORGIFDateAddedKey];

    GIF *gif = [[self.class alloc] initWithDownloadURL:download thumbnail:thumbnail andSource:source];
    gif.dateAdded = date;
    return gif;
}

- (NSString *)imageUID
{
    return self.downloadAddress;
}

- (NSString *)imageRepresentationType
{
#ifndef TARGET_OS_IPHONE
    #import <QuartzCore/QuartzCore.h>
    return IKImageBrowserNSURLRepresentationType;
#endif
    return @"GIF";
}

- (id) imageRepresentation
{
    if (!self.thumbnailAddress) return nil;
    return [NSURL URLWithString:self.thumbnailAddress];
}

- (NSURL *)downloadURL
{
    if (!self.downloadAddress) return nil;
    return  [NSURL URLWithString:self.downloadAddress];
}

- (NSURL *)sourceURL
{
    if (!self.sourceAddress) return nil;
    return  [NSURL URLWithString:self.sourceAddress];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", NSStringFromClass(self.class), self.imageUID];
}

- (NSUInteger)hash
{
    return self.imageUID.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:self.class]) {
        return [self.imageUID isEqualToString:[object imageUID]];
    }
    return  [super isEqual:object];
}

@end
