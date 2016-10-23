//
//  PhotoBroswerHelper.h
//  QiCheng51
//
//  Created by Hancle on 16/8/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"

@interface PhotoBroswerHelper : NSObject 

+ (PhotoBroswerHelper *)pushphotoBroswerInVC:(UIViewController *)vc photos:(NSArray *)photos currentIndex:(NSUInteger)index;

@end
