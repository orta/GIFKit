//
//  GIF.h
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIF : NSObject <NSCoding>

- (instancetype)initWithDownloadURL:(NSString *)downloadURL thumbnail:(NSString *)thumbnail andSource:(NSString *)source;

- (NSString *)imageUID;
- (NSString *)imageRepresentationType;

- (id) imageRepresentation;
- (NSURL *)downloadURL;
- (NSURL *)sourceURL;

@property (nonatomic, readonly) NSDate *dateAdded;

@end
