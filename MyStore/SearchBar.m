//
//  SearchBar.m
//  MyStore
//
//  Created by Hancle on 16/8/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

+ (SearchBar *)initSearchBarWith:(CGRect)frame {
    SearchBar *bar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    bar.frame = frame;
    bar.layer.cornerRadius = 3.0;
    bar.backgroundColor = MainBackColor;
    return bar;
}

@end
