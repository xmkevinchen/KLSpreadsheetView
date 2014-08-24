//
//  KLSpreadsheetViewIndexPath.m
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/23/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "KLSpreadsheetViewIndexPath.h"

@interface KLSpreadsheetViewIndexPath ()

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

@end

@implementation KLSpreadsheetViewIndexPath

+ (instancetype)indexWithRow:(NSUInteger)row column:(NSUInteger)column {
    KLSpreadsheetViewIndexPath *indexPath = [[KLSpreadsheetViewIndexPath alloc] init];
    if (indexPath) {
        indexPath.row = row;
        indexPath.column = column;
    }
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"R%d.C%d", _row, _column];
}


@end
