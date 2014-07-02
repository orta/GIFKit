//
//  ORGIFSource.h
//  Pods
//
//  Created by Orta on 7/1/14.
//
//

#import <Foundation/Foundation.h>

@class GIF;
@protocol ORGIFSource <NSObject>

- (void)getNextGIFs:(void (^)(NSArray *newGIFs, NSError *error))completion;
- (NSInteger)numberOfGifs;
- (GIF *)gifAtIndex:(NSInteger)index;

@end
