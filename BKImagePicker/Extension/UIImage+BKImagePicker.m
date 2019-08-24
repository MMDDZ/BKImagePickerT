//
//  UIImage+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "UIImage+BKImagePicker.h"
#import "BKImagePicker.h"

@implementation UIImage (BKImagePicker)

#pragma mark - 调整图片方向

/**
 修改图片方向为正方向
 */
-(UIImage*)bk_editImageOrientation
{
    if ([self isKindOfClass:[UIImage class]]) {
        
        UIImage* tmpImage = self;
        UIImage* contextedImage;
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        if (tmpImage.imageOrientation == UIImageOrientationUp) {
            contextedImage = tmpImage;
            return contextedImage;
        } else {
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, tmpImage.size.height);
                    transform = CGAffineTransformRotate(transform, M_PI);
                }
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                }
                    break;
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, 0,tmpImage.size.height);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                }
                    break;
                default:
                    break;
            }
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDownMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                }
                    break;
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:
                {
                    transform = CGAffineTransformTranslate(transform, tmpImage.size.height, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                }
                    break;
                default:
                    break;
            }
            
            CGContextRef ctx = CGBitmapContextCreate(NULL, tmpImage.size.width, tmpImage.size.height, CGImageGetBitsPerComponent(tmpImage.CGImage), 0, CGImageGetColorSpace(tmpImage.CGImage), CGImageGetBitmapInfo(tmpImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            
            switch (tmpImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                {
                    CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.height,tmpImage.size.width), tmpImage.CGImage);
                }
                    break;
                default:
                {
                    CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height), tmpImage.CGImage);
                }
                    break;
            }
            
            CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
            contextedImage = [UIImage imageWithCGImage:cgimg];
            CGContextRelease(ctx);
            CGImageRelease(cgimg);
            
            return contextedImage;
        }
    }else{
        return nil;
    }
}

/**
 修改图片方向
 */
-(UIImage*)bk_editImageOrientation:(UIImageOrientation)orientation
{
    if ([self isKindOfClass:[UIImage class]]) {
        
        CGImageRef imageRef = self.CGImage;
        CGRect rect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        
        CGRect editRect = rect;
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (orientation) {
            case UIImageOrientationDown:
            {
                transform = CGAffineTransformMakeTranslation(rect.size.width, rect.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
            }
                break;
            case UIImageOrientationLeft:
            {
                editRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
                transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            }
                break;
            case UIImageOrientationRight:
            {
                editRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
                transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            }
                break;
            case UIImageOrientationUpMirrored:
            {
                transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
            }
                break;
            case UIImageOrientationDownMirrored:
            {
                transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
                transform = CGAffineTransformScale(transform, 1.0, -1.0);
            }
                break;
            case UIImageOrientationLeftMirrored:
            {
                editRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
                transform = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            }
                break;
            case UIImageOrientationRightMirrored:
            {
                editRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            }
                break;
            default:
            {
                return self;
            }
                break;
        }
        
        UIGraphicsBeginImageContext(editRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        switch (orientation)
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            {
                CGContextScaleCTM(ctx, -1.0, 1.0);
                CGContextTranslateCTM(ctx, -rect.size.height, 0.0);
            }
                break;
            default:
            {
                CGContextScaleCTM(ctx, 1.0, -1.0);
                CGContextTranslateCTM(ctx, 0.0, -rect.size.height);
            }
                break;
        }
        
        CGContextConcatCTM(ctx, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imageRef);
        
        UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultImage;
        
    }else{
        return nil;
    }
}

#pragma mark - 获取图片

/**
 BKImagePicker获取图片
 */
+(UIImage*)imageWithImageName:(NSString*)imageName
{
    NSString * path = [[NSBundle bundleForClass:[BKImagePicker class]] pathForResource:@"BKImagePicker" ofType:@"bundle"];
    UIImage * image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", path, imageName]];
    return image;
}

@end
