//
// UIImage+WebP.m
//
// Created by Gabriel Harrison <nyteshade@gmail.com>
// Much inspiration for code comes from Carson McDonald
// his website is http://www.ioncannon.net
//
// Modified (encoding added) by Dmitry Shmidt, mail@shmidtlab.com
#define kWebPLossless 146
#import "UIImage+WebP.h"

/**
 * This gets called when the UIImage gets collected and frees the 
 * underlying image.
 */
static void free_image_data(void *info, const void *data, size_t size)
{
    free((void *)data);
}

@implementation UIImage (WebP)

/**
 * The imageFromWebP function loads a file with the specified filePath. It
 * makes the assumption that the file exists within the main bundle. If the
 * main screen is running at a scale greater than 1.0, it will automatically
 * attempt to append @2x to the file name as per the convention that Apple
 * follows (as I understand it). 
 *
 * If it does change the name from pic.webp to pic@2x.webp and there is no
 * file by that name, it will revert and try to load the lo-res image name
 * instead. 
 *
 * If for any reason we end up without a path after asking the main bundle for
 * the file name with the supplied extension, nil will be returned.
 *
 * @param filePath a path, relative to the main bundle, where the file resides
 * @return a valid UIImage or nil if there was a problem locating the image.
 */
+ (UIImage *)imageWithWebPAtPath:(NSString *)filePath {
  NSString *path = NULL;
  NSString *name = [filePath stringByDeletingPathExtension];
  NSString *ext = [filePath pathExtension];

  BOOL isRetina = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] 
      == YES && [[UIScreen mainScreen] scale] > 1.f;
  
  if (isRetina) {
    NSString *at2XName = [NSString stringWithFormat:@"%@@2x", name];
    BOOL at2XExists = [[NSFileManager defaultManager]
        fileExistsAtPath: [NSString stringWithFormat:@"%@.%@",
        at2XName, ext]];
    
    if (at2XExists) {
      name = at2XName;
    }
  }
  
  // Now, finally, get the path relative to the bundle
  path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
  
  // Return nil if we don't have a path
  if (!path) {
    return nil;
  }

  // Find the path of the selected WebP image in the bundle and read
  // it into memory.
  NSData *imgData = [NSData dataWithContentsOfFile:path];

  return [self imageWithWebPData:imgData];
}
+ (UIImage *)imageWithWebPData:(NSData *)imgData{
    int rc = WebPGetDecoderVersion();
    NSLog(@"WebP decoder version: %d", rc);
    // Get width and height of the selected WebP image
    int width = 0, height = 0;
    WebPGetInfo(imgData.bytes, imgData.length, &width, &height);
    //NSLog(@"Image Width: %d Height: %d", width, height);
    
    // Decode the WebP image data into a RGBA value array
    uint8_t *data = WebPDecodeRGBA([imgData bytes], [imgData length], &width,
                                   &height);
    
    // Construct a UIImage from the decoded RGBA value array
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data,
                                                              width * height * 4, free_image_data);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault |
    kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width,
                                        colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    
    // Clean up
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    
    return result;
}

- (NSData *)dataWebPWithQuality:(float)quality{
    int rc = WebPGetEncoderVersion();
    NSLog(@"WebP encoder version: %d", rc);
    
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (CGColorSpaceGetModel(colorSpace) != kCGColorSpaceModelRGB) {
        NSLog(@"Sorry, we need RGB");
    }
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef imageData = CGDataProviderCopyData(dataProvider);
    const UInt8 *rawData = CFDataGetBytePtr(imageData);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    uint8_t *output;
    NSUInteger stride = CGImageGetBytesPerRow(imageRef);
    size_t ret_size;
    
    if (quality == kWebPLossless) {
        ret_size = WebPEncodeLosslessRGB(rawData, width, height, stride, &output);
    }else ret_size = WebPEncodeRGBA(rawData, width, height, stride, quality, &output);
    
    if (ret_size == 0) {
        NSLog(@"Oops, no data");
    }
    CFRelease(imageData);
    CGColorSpaceRelease(colorSpace);
    NSData *data = [NSData dataWithBytes:(const void *)output length:ret_size];

    return data;
}

- (NSData *)dataWebPLossless{
    
    return [self dataWebPWithQuality:kWebPLossless];
}

- (BOOL)writeWebPToDocumentsWithFileName:(NSString *)filename quality:(float)quality{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.webp",filename]];
    
    NSData *imgData = [self dataWebPWithQuality:quality];

    return [imgData writeToFile:filePath atomically:YES];
}
- (BOOL)writeWebPLosslessToDocumentsWithFileName:(NSString *)filename{
    
    return [self writeWebPToDocumentsWithFileName:filename quality:kWebPLossless];
}
@end
