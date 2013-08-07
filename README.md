WebP-UIImage
============

<code>UIImage</code> category to work with <code>WebP</code> image files in iOS.

## Installation ##

Drag and drop the <code>Classes</code> folder and <code>WebP.framework</code> into your project.

## Usage ##

Getting started with <code>WebP-UIImage</code> is simple. 
Import framework <code>#import "UIImage+WebP.h"</code> and call following methods:

```objc
- (NSData *)dataWebPWithQuality:(float)quality;//quality = 0..100
+ (UIImage*)imageWithWebPAtPath:(NSString *)filePath;

+ (UIImage *)imageWithWebPData:(NSData *)imgData;
@property (nonatomic, readonly) NSData *dataWebPLossless;

- (BOOL)writeWebPToDocumentsWithFileName:(NSString *)filename quality:(float)quality;
- (BOOL)writeWebPLosslessToDocumentsWithFileName:(NSString *)filename;
```

## Bonus ##
I made also an <code>NSValueTransformer</code> subclass called <code>ImageToWebPDataTransformer</code>.
You can use it in CoreData to store images with less sizes than jpeg.
I use 75 quality value as it is default Google value. 

## Thanks ##
The project is heavily based on [<code>nyteshade/iOSWebPWithAlphaExample</code>](https://github.com/nyteshade/iOSWebPWithAlphaExample)

## License ##
MIT

## Tests ##
No speed/size tests were done. You can make your own and commit it here.

