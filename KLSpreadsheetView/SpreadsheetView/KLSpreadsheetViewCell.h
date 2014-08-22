//
//  KLSpreadsheetViewCell.h
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/20/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLSpreadsheetView;

@interface KLSpreadsheetReusableView : UIView;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end

@interface KLSpreadsheetReusableView(Internal)

@property (nonatomic, unsafe_unretained) KLSpreadsheetView *spreadsheetView;
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@interface KLSpreadsheetViewCell : KLSpreadsheetReusableView

/**
 *  add custom subviews to the cell's contentView;
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  The background view is a subview behind all other views.
 */
@property (nonatomic, strong) UIView *backgroundView;




@end
