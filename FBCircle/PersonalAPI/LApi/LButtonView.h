//
//  LButtonView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LButtonView : UIView

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)url
   placeHolderImage:(UIImage *)defaulImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action;

@end
