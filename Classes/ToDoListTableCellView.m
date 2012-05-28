//
//  ToDoListTableCellView.m
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ToDoListTableCellView.h"


@implementation ToDoListTableCellView

@synthesize checkbox, state;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
	[checkbox release];
}

- (void)toggleCheckbox {
	UIImage *image;
	if (isChecked) {
		image = [UIImage imageNamed:@"checkbox-uncheck.png"]; 
		isChecked = NO;
	} else {
		image = [UIImage imageNamed:@"checkbox-check.png"]; 
		isChecked = YES;
	}
	[checkbox setBackgroundImage:image forState:UIControlStateNormal]; 
	[checkbox setBackgroundImage:image forState:UIControlStateHighlighted]; 
}

- (void)setCheckboxForState:(NSString *)aState {
	UIImage *image;
	if ([aState isEqualToString:@"check"]) {
		image = [UIImage imageNamed:@"checkbox-check.png"]; 
		isChecked = YES;
	} else {
		image = [UIImage imageNamed:@"checkbox-uncheck.png"]; 
		isChecked = NO;
	}
	[checkbox setBackgroundImage:image forState:UIControlStateNormal]; 
	[checkbox setBackgroundImage:image forState:UIControlStateHighlighted]; 
}

- (void)setLabelText:(NSString *)_text;{
	cellText.text = _text;
}


//For custom indentation

- (void)layoutSubviews
{
    [super layoutSubviews];
	
    self.contentView.frame = CGRectMake(0,                                          
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width, 
                                        self.contentView.frame.size.height);
	
    if (self.editing
        && ((state & UITableViewCellStateShowingEditControlMask)
			&& !(state & UITableViewCellStateShowingDeleteConfirmationMask)) || 
		((state & UITableViewCellStateShowingEditControlMask)
         && (state & UITableViewCellStateShowingDeleteConfirmationMask))) 
    {
        //float indentPoints = self.indentationLevel * self.indentationWidth;
		float indentPoints = 40;
		
        self.contentView.frame = CGRectMake(indentPoints,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width - indentPoints, 
                                            self.contentView.frame.size.height);    
    }
}


- (void)willTransitionToState:(UITableViewCellStateMask)aState
{
    [super willTransitionToState:aState];
    self.state = aState;
}

@end
