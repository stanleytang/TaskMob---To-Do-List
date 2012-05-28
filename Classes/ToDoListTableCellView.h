//
//  ToDoListTableCellView.h
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToDoListTableCellView : UITableViewCell {
	IBOutlet UILabel *cellText;
	IBOutlet UIButton *checkbox;
	BOOL isChecked;
	int state;
	
}

@property (nonatomic, retain) IBOutlet UIButton *checkbox;
@property (nonatomic) int state;

- (void)toggleCheckbox;
- (void)setCheckboxForState:(NSString *)state;
- (void)setLabelText:(NSString *)_text;
- (void)layoutSubviews;

@end
