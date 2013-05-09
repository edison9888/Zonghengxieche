//
//  BaseTableViewCell.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CoreService.h"
#import "UIImage+UIImageExtras.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleImageWithUrl:(NSString *)urlString withSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:@"loading"];
    image = [image imageByScalingToSize:size];
    [self.imageView setImage:image];
    
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSString *handledUrlString = [urlString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        handledUrlString = [handledUrlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir, handledUrlString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            image = [image imageByScalingToSize:size];
            [self.imageView  setImage:image];
        }else{
            [[CoreService sharedCoreService] loadDataWithURL:urlString
                                                  withParams:nil
                                         withCompletionBlock:^(id data) {
                                             UIImage *image = [UIImage imageWithData:data];
                                             image = [image imageByScalingToSize:size];
                                             [self.imageView setImage:image];
                                         } withErrorBlock:nil];
        }
    }
}


@end
