//
//  SearchBar.h
//  MyStore
//
//  Created by Hancle on 16/8/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"

@interface SearchBar : SuperView

@property (weak, nonatomic) IBOutlet UITextField *textfield;
+ (SearchBar *)initSearchBarWith:(CGRect)frame;

@end
