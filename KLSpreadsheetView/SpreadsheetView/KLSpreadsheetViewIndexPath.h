//
//  KLSpreadsheetViewIndexPath.h
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/23/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLSpreadsheetViewIndexPath : NSObject

+ (instancetype)indexWithRow:(NSUInteger)row column:(NSUInteger)column;

@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;

@end
