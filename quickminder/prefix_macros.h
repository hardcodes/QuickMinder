//
//  prefix_macmros.h
//  QuickMinder
//
//  Created by Putze Sven on 23.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#ifndef QuickMinder_prefix_macmros_h
#define QuickMinder_prefix_macmros_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHEXWithAlpha(rgbValue) [UIColor colorWithRed: ((float)((rgbValue & 0xFF000000) >> 24))/255.0 green: ((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue: ((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha: ((float)(rgbValue & 0xFF))/255.0]

#endif
