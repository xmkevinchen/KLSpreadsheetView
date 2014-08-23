//
//  KLSpreadsheetView.m
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/20/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "KLSpreadsheetView.h"
#import "KLSpreadsheetViewCell.h"




@interface KLSpreadsheetView () {
    
    NSMutableDictionary *_registerCellNibs;
    NSMutableDictionary *_registerCellClasses;
    NSMutableDictionary *_reusableCellsQueues;
    NSMutableDictionary *_visibleViews;
    
    
    CGSize _visibleBounds;
    NSInteger _numberOfRows;
    NSInteger _numberOfColumns;
    CGFloat _heightOfRow;
    CGFloat _widthOfColumn;
    
    CGPoint _minPossibleContentOffset;
    CGPoint _maxPossibleContentOffset;
    
    KLSpreadsheetViewIndexPath *_firstIndexPath;
    KLSpreadsheetViewIndexPath *_lastIndexPath;
}


@end

@implementation KLSpreadsheetView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    _registerCellNibs = [[NSMutableDictionary alloc] init];
    _registerCellClasses = [[NSMutableDictionary alloc] init];
    _reusableCellsQueues = [[NSMutableDictionary alloc] init];
    _visibleViews = [[NSMutableDictionary alloc] init];
    
    _minPossibleContentOffset = (CGPoint){.x = 0, .y = 0};
    _maxPossibleContentOffset = (CGPoint){.x = 0, .y = 0};
    
}


#pragma mark - UIView


#pragma mark - SpreadsheetView

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    NSArray *topLevelObjects = [nib instantiateWithOwner:nil options:nil];
#pragma unused(topLevelObjects)
    NSAssert(topLevelObjects.count == 1 && [topLevelObjects[0] isKindOfClass:KLSpreadsheetViewCell.class],
             @"must contain exactly 1 top level object which is a KLSpreadsheetViewCell");
    
    _registerCellNibs[identifier] = nib;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    NSParameterAssert(cellClass);
    NSParameterAssert(identifier);
    _registerCellClasses[identifier] = cellClass;
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(KLSpreadsheetViewIndexPath *)indexPath {
    NSMutableArray *reusableCells = _reusableCellsQueues[identifier];
    KLSpreadsheetViewCell *cell = [reusableCells lastObject];
    
    if (cell) {
        [reusableCells removeObjectAtIndex:reusableCells.count - 1];
    } else {
        if (_registerCellNibs[identifier]) {
            UINib *cellNib = _registerCellNibs[identifier];
            cell = [cellNib instantiateWithOwner:self options:nil][0];
        } else {
            Class cellClass = _registerCellClasses[identifier];
            cell = [cellClass new];
        }
        
        cell.spreadsheetView = self;
        cell.reuseIdentifier = identifier;
    }
    
    return cell;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self loadRequiredItems];
    
}

- (void)reloadData {
    
    CGPoint previousContentOffset = self.contentOffset;
    
    [_visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:UIView.class]) {
            [obj removeFromSuperview];
        }
    }];
    [_visibleViews removeAllObjects];
    
    [self recomputeSize];
    CGPoint newContentOffset = CGPointMake(MIN(_maxPossibleContentOffset.x, previousContentOffset.x), MIN(_maxPossibleContentOffset.y, previousContentOffset.y));
    newContentOffset = CGPointMake(MAX(newContentOffset.x, _minPossibleContentOffset.x), MAX(newContentOffset.y, _minPossibleContentOffset.y));
    self.contentOffset = newContentOffset;
        
    [self setNeedsLayout];
    
}

- (void)recomputeSize {
    _numberOfRows = [self.dataSource numberOfRowsInSpreadsheetView:self];
    _numberOfColumns = [self.dataSource numberOfColumnsInSpreadsheetView:self];
    
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    
    for (int row = 0; row < _numberOfRows; row++) {
        height += [self.delegate spreadsheetView:self heightForRow:row];
    }
    
    for (int column = 0; column < _numberOfColumns; column++) {
        width += [self.delegate spreadsheetView:self widthForColumn:column];
    }
    
    CGSize newContentSize = (CGSize){.width = width, .height = height};
    _minPossibleContentOffset = CGPointMake(0, 0);
    _maxPossibleContentOffset = CGPointMake(newContentSize.width - self.bounds.size.width,
                                            newContentSize.height - self.bounds.size.height);
    
    if (!CGSizeEqualToSize(self.contentSize, newContentSize)) {
        self.contentSize = newContentSize;
    }
    
}



- (void)recomputeIndexesRangeFromOffset:(CGPoint)offset {
    CGPoint contentOffset = CGPointMake(MAX(0, offset.x), MAX(0, offset.y));
    
    CGFloat width = 0;
    NSInteger firstColumn = -1;
    NSInteger lastColumn = -1;
    for (int column = 0; column < _numberOfColumns; column++) {
        width += [self.delegate spreadsheetView:self widthForColumn:column];
        if (width > contentOffset.x && firstColumn == -1) {
            firstColumn = column;
        } else if (width > self.bounds.size.width + contentOffset.x) {
            lastColumn = column;
            break;
        }
    }
    
    if (lastColumn == -1) {
        lastColumn = _numberOfColumns - 1;
    }
    
    CGFloat height = 0;
    NSInteger firstRow = -1;
    NSInteger lastRow = -1;
    for (int row = 0; row < _numberOfRows; row++) {
        height += [self.delegate spreadsheetView:self heightForRow:row];
        if (height > contentOffset.y && firstRow == -1) {
            firstRow = row;
        } else if (height > self.bounds.size.height + contentOffset.y) {
            lastRow = row;
            break;
        }
    }
    
    if (lastRow == -1) {
        lastRow = _numberOfRows - 1;
    }
    
    _firstIndexPath = [KLSpreadsheetViewIndexPath indexWithRow:firstRow column:firstColumn];
    _lastIndexPath = [KLSpreadsheetViewIndexPath indexWithRow:lastRow column:lastColumn];
    
//     NSLog(@"%@, %@, %@", NSStringFromCGPoint(self.contentOffset), _firstIndexPath, _lastIndexPath);
}

- (void)loadRequiredItems {
    
    [self recomputeIndexesRangeFromOffset:self.contentOffset];
    
    NSMutableDictionary *itemKeysToAddDict = [NSMutableDictionary dictionary];
    
    CGPoint startPosition = (CGPoint){.x = 0, .y = 0};
    for (int i = 0; i < _firstIndexPath.column; i++) {
        startPosition.x += [self.delegate spreadsheetView:self widthForColumn:i];
    }
    
    for (int i = 0; i < _firstIndexPath.row; i++) {
        startPosition.y += [self.delegate spreadsheetView:self heightForRow:i];
    }
    
    CGPoint itemPosition = startPosition;
    
    for (NSInteger row = _firstIndexPath.row; row <= _lastIndexPath.row; row++) {
        
        CGFloat height = [self.delegate spreadsheetView:self heightForRow:row];
        itemPosition.x = startPosition.x;
        for (NSInteger column = _firstIndexPath.column; column <= _lastIndexPath.column; column++) {
            
            CGFloat width = [self.delegate spreadsheetView:self widthForColumn:column];
                        
            KLSpreadsheetViewIndexPath *indexPath = [KLSpreadsheetViewIndexPath indexWithRow:row column:column];
            NSString *itemKey = [indexPath description];
            
            itemKeysToAddDict[itemKey] = [indexPath description];
            
            KLSpreadsheetReusableView *view = _visibleViews[itemKey];
            if (!view) {
                view = [self createPreparedCellForItemAtIndexPath:indexPath];
                view.clipsToBounds = YES;
                
                if (view) {
                    _visibleViews[itemKey] = view;
                    
                    // Calculate position
                    view.frame = CGRectMake(itemPosition.x, itemPosition.y, width, height);
                    [self insertSubview:view atIndex:0];
                }
            }
            
            itemPosition.x += width;
        }
        
        itemPosition.y += height;
    }
    
    NSMutableSet *allVisibleItemKeys = [NSMutableSet setWithArray:[_visibleViews allKeys]];
    [allVisibleItemKeys minusSet:[NSSet setWithArray:[itemKeysToAddDict allKeys]]];
    
    // Clean invisible views and prepare them for re-use.
    for (NSString *itemKey in allVisibleItemKeys) {
        KLSpreadsheetReusableView *reusableView = _visibleViews[itemKey];
        if (reusableView) {
            [reusableView removeFromSuperview];
            [_visibleViews removeObjectForKey:itemKey];
            [self reuseCell:(KLSpreadsheetViewCell *)reusableView];
        }
    }
    
}

- (KLSpreadsheetViewCell *) createPreparedCellForItemAtIndexPath:(KLSpreadsheetViewIndexPath *)indexPath {
    KLSpreadsheetViewCell *cell = [self.dataSource spreadsheetView:self cellForItemAtIndex:indexPath];
    
    return cell;
}

- (void)reuseCell:(KLSpreadsheetViewCell *)cell {
    [self queueReusableView:cell inQueue:_reusableCellsQueues withIdentifier:cell.reuseIdentifier];
}

- (void)queueReusableView:(KLSpreadsheetReusableView *)reusableView
                  inQueue:(NSMutableDictionary *)queue
           withIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier.length > 0);
    
    [reusableView removeFromSuperview];
    [reusableView prepareForReuse];
    
    // enqueue cell
    NSMutableArray *reusableViews = queue[identifier];
    if (!reusableViews) {
        reusableViews = [NSMutableArray array];
        queue[identifier] = reusableViews;
    }
    
    [reusableViews addObject:reusableView];
}


@end

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
