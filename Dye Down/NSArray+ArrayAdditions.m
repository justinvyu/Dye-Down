//
//  NSArray+ArrayAdditions.m
//  Dye Down
//
//  Created by Justin Yu on 4/8/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "NSArray+ArrayAdditions.h"

@implementation NSArray (ArrayAdditions)

- (id)anyObject {
    if (self.count == 0) {
        return nil;
    }
    
    return [self objectAtIndex:arc4random() % [self count]];
}

@end
