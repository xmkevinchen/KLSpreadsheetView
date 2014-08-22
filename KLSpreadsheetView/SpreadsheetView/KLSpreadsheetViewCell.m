//
//  KLSpreadsheetViewCell.m
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/20/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "KLSpreadsheetViewCell.h"

@interface KLSpreadsheetReusableView ()

@property (nonatomic, unsafe_unretained) KLSpreadsheetView *spreadsheetView;
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation KLSpreadsheetReusableView

- (void)prepareForReuse {
    
}

@end

@implementation KLSpreadsheetViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
