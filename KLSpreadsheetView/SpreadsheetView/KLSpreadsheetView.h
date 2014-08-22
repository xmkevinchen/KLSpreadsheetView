//
//  KLSpreadsheetView.h
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/20/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSIndexPath+KLSpreadsheetView.h"

@protocol KLSpreadsheetDataSource;
@protocol KLSpreadsheetDelegate;

@class KLSpreadsheetViewCell;

@interface KLSpreadsheetView : UIScrollView

@property (nonatomic, weak) IBOutlet id<UIScrollViewDelegate, KLSpreadsheetDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<KLSpreadsheetDataSource> dataSource;



- (void)reloadData;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end


@protocol KLSpreadsheetDataSource <NSObject>

@required
- (NSUInteger)numberOfRowsInSpreadsheetView:(KLSpreadsheetView *)spreadsheetView;
- (NSUInteger)numberOfColumnsInSpreadsheetView:(KLSpreadsheetView *)spreadsheetView;
- (KLSpreadsheetViewCell *)spreadsheetView:(KLSpreadsheetView *)spreadsheetView cellForItemAtIndex:(NSIndexPath *)indexPath;

@end

@protocol KLSpreadsheetDelegate <UIScrollViewDelegate>

@required
- (CGFloat)spreadsheetView:(KLSpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row;
- (CGFloat)spreadsheetView:(KLSpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column;


@end
