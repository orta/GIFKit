//
//  GIF.h
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIF : NSObject <NSCoding>

- (instancetype)initWithDownloadURL:(NSString *)downloadAddresss thumbnail:(NSString *)thumbnailAddress source:(NSString *)sourceAddress sourceTitle:(NSString *)sourceTitle;

- (NSString *)imageUID;
- (NSString *)imageRepresentationType;

- (id) imageRepresentation;
- (NSURL *)downloadURL;
- (NSURL *)sourceURL;

@property (nonatomic, copy, readonly) NSString *sourceTitle;
@property (nonatomic, readonly) NSDate *dateAdded;
@property (nonatomic, assign, readonly) BOOL adultContent;

@end
