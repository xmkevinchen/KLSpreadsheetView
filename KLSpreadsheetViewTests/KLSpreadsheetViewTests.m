//
//  KLSpreadsheetViewTests.m
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/20/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KLSpreadsheetView.h"

SPEC_BEGIN(KLSpreadsheetViewSpec)

describe(@"NSIndexPath", ^{
    it(@"should return correct row and column value", ^{
        NSInteger row = 1;
        NSInteger column = 2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row andColumn:column];
        
        [[theValue(indexPath.row) should] equal:theValue(row)];
        [[theValue(indexPath.column) should] equal:theValue(column)];
        [[indexPath.description should] equal:@"1.2"];
        
    });
});

describe(@"KLSpreadsheetView", ^{
    it(@"should compute correct contentSize", ^{
        
        id dataSource = [KWMock mockForProtocol:@protocol(KLSpreadsheetDataSource)];
        id delegate = [KWMock mockForProtocol:@protocol(KLSpreadsheetDelegate)];
        NSInteger numberOfRows = 100;
        NSInteger numberOfColumns = 100;
        [dataSource stub:@selector(numberOfRowsInSpreadsheetView:) andReturn:theValue(numberOfRows)];
        [dataSource stub:@selector(numberOfColumnsInSpreadsheetView:) andReturn:theValue(numberOfColumns)];
        
        CGFloat heightForRow = 30.0f;
        CGFloat widthForColumn = 100.0f;
        [delegate stub:@selector(spreadsheetView:heightForRow:) andReturn:theValue(heightForRow)];
        [delegate stub:@selector(spreadsheetView:widthForColumn:) andReturn:theValue(widthForColumn)];
        
        CGRect frame = CGRectMake(0, 0, 320, 568);
        KLSpreadsheetView *spreadsheetView = [[KLSpreadsheetView alloc] initWithFrame:frame];
        spreadsheetView.dataSource = dataSource;
        spreadsheetView.delegate = delegate;
        
        [spreadsheetView reloadData];
        
        [[theValue(spreadsheetView.contentSize.width) should] equal:theValue(numberOfColumns * widthForColumn)];
        [[theValue(spreadsheetView.contentSize.height) should] equal:theValue(numberOfRows * heightForRow)];
        
    });
});

SPEC_END
