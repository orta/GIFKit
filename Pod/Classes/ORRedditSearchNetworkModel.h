//
//  ORRedditSearchNetworkModel.h
//  GIFs
//
//  Created by orta therox on 13/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ORGIFSource.h"
#import <Foundation/Foundation.h>

@interface ORRedditSearchNetworkModel : NSObject <ORGIFSource>

@property (nonatomic, assign, readwrite) BOOL filterResults;

- (void)setSearchQuery:(NSString *)query;

@end
