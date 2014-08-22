//
//  NSIndexPath+KLSpreadsheetView.h
//  SEGSAP
//
//  Created by Kevin Chen on 8/21/14.
//  Copyright (c) 2014 Health Interact Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (KLSpreadsheetView)

+ (NSIndexPath *)indexPathForSpreadsheetRow:(NSInteger)row spreadsheetColumn:(NSInteger)column;

- (NSInteger) spreadsheetColumn;
- (NSInteger) spreadsheetRow;
- (NSString *) spreadsheetDescription;

@end
