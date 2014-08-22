//
//  NSIndexPath+KLSpreadsheetView.m
//  SEGSAP
//
//  Created by Kevin Chen on 8/21/14.
//  Copyright (c) 2014 Health Interact Pty Ltd. All rights reserved.
//

#import "NSIndexPath+KLSpreadsheetView.h"

@implementation NSIndexPath (KLSpreadsheetView)

+ (NSIndexPath *)indexPathForSpreadsheetRow:(NSInteger)row spreadsheetColumn:(NSInteger)column {
    NSUInteger indexs[] = {row, column};
    return [NSIndexPath indexPathWithIndexes:indexs length:2];
}

- (NSInteger) spreadsheetRow {
    return [self indexAtPosition:0];
}

- (NSInteger) spreadsheetColumn {
    return [self indexAtPosition:1];
}

- (NSString *)spreadsheetDescription {
    return [NSString stringWithFormat:@"R%d.C%d", [self spreadsheetRow], [self spreadsheetColumn]];
}

@end
