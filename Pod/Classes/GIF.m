//
//  GIF.m
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC
@import Quartz;
#endif


#import "GIF.h"

@interface GIF()
@property (nonatomic, copy, readonly) NSString *thumbnailAddress;
@property (nonatomic, copy, readonly) NSString *downloadAddress;
@property (nonatomic, copy, readonly) NSString *sourceAddress;
@property (nonatomic, strong, readwrite) NSDate *dateAdded;
@property (nonatomic, assign, readwrite) BOOL adultcontent;
@end

@implementation GIF

- (instancetype)initWithDownloadURL:(NSString *)downloadAddresss thumbnail:(NSString *)thumbnailAddress source:(NSString *)sourceAddress sourceTitle:(NSString *)sourceTitle
{
    self = [super init];
    if (!self) return nil;

    _thumbnailAddress = thumbnailAddress;
    _downloadAddress = downloadAddresss;
    _sourceAddress = sourceAddress;
    _sourceTitle = sourceTitle;
    _dateAdded = [NSDate date];

    return self;
}

#define ORGIFDownloadKey       @"ORGIFDownloadKey"
#define ORGIFThumbnailKey      @"ORGIFThumbnailKey"
#define ORGIFDateAddedKey      @"ORGIFDateAddedKey"
#define ORGIFSourceKey         @"ORGIFSourceKey"
#define ORGIFSourceTitleKey    @"ORGIFSourceTitleKey"

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_thumbnailAddress forKey:ORGIFThumbnailKey];
    [encoder encodeObject:_downloadAddress forKey:ORGIFDownloadKey];
    [encoder encodeObject:_dateAdded forKey:ORGIFDateAddedKey];
    [encoder encodeObject:_sourceAddress forKey:ORGIFSourceKey];
    [encoder encodeObject:_sourceTitle forKey:ORGIFSourceTitleKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSString *thumbnail = [decoder decodeObjectForKey:ORGIFThumbnailKey];
    NSString *download = [decoder decodeObjectForKey:ORGIFDownloadKey];
    NSString *source = [decoder decodeObjectForKey:ORGIFSourceKey];
    NSDate *date = [decoder decodeObjectForKey:ORGIFDateAddedKey];
    NSString *sourceTitle = [decoder decodeObjectForKey:ORGIFSourceTitleKey];

    GIF *gif = [[self.class alloc] initWithDownloadURL:download thumbnail:thumbnail source:source sourceTitle:sourceTitle];
    gif.dateAdded = date;
    return gif;
}

- (NSString *)imageUID
{
    return self.downloadAddress;
}

- (NSString *)imageRepresentationType
{
#if TARGET_OS_IPHONE
    return @"GIF";
#elif TARGET_OS_MAC
    return IKImageBrowserNSURLRepresentationType;
#endif
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
