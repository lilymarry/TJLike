//
//  TextLabel.m
//  UILabrlCoreText
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TextLabel.h"
#import <CoreText/CoreText.h>


void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.height;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 3;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (NSString *)CFBridgingRelease(refCon);
    return [UIImage imageNamed:imageName].size.width;//[UIImage imageNamed:imageName].size.width;
}

@interface TextLabel()

@property (nonatomic, strong)NSString *myStr;
@property (nonatomic, assign)BOOL     isLand;
@property (nonatomic, assign)NSUInteger myLength;

@end

@implementation TextLabel

- (instancetype)initWithFrame:(CGRect)frame withStr:(NSString *)str withLength:(NSUInteger)length withLandlord:(BOOL)isLandlord
{
    self = [self initWithFrame:frame];
    if (self) {
        self.myStr = str;
        self.isLand = isLandlord;
        self.myLength = length;

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    [self drawCharAndPicture];
    
}


-(void)drawCharAndPicture
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.myStr];
    
    
    if (_isLand) {
        //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        NSString *imgName = @"louzhu_.png";
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1;
        imageCallbacks.dealloc = RunDelegateDeallocCallback;
        imageCallbacks.getAscent = RunDelegateGetAscentCallback;
        imageCallbacks.getDescent = RunDelegateGetDescentCallback;
        imageCallbacks.getWidth = RunDelegateGetWidthCallback;
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(imgName));
        NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
        CFRelease(runDelegate);
        
        [imageAttributedString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
        
        [attributedString insertAttributedString:imageAttributedString atIndex:self.myLength];
    }
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //最大行高
    CGFloat maxHeightSize = 50.0f;  //最大行高不能超过50个像素，超过按照最大像素来
    CTParagraphStyleSetting maxHeightSetting;
    maxHeightSetting.spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    maxHeightSetting.value = &maxHeightSize;
    maxHeightSetting.valueSize = sizeof(float);
    
    //多行高
    CGFloat multipleHeight = 1.2f;  //1.2倍原来的高度
    CTParagraphStyleSetting multipleHeightSetting;
    multipleHeightSetting.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    multipleHeightSetting.value = &multipleHeight;
    multipleHeightSetting.valueSize = sizeof(float);
    
    //最大行距
    CGFloat maxLineSpace = 5.0f;//最大行距不能超过5像素，超过了按最大行距画图，最小行距同理，行距调整只在中间值中进行
    CTParagraphStyleSetting maxLineSpaceSetting;
    maxLineSpaceSetting.spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    maxLineSpaceSetting.valueSize = sizeof(float);
    maxLineSpaceSetting.value = &maxLineSpace;
    
    //行距
    CGFloat lineSpace = 30.0f;  //行距25像素
    CTParagraphStyleSetting lineSpaceSetting;
    lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceSetting.value = &lineSpace;
    lineSpaceSetting.valueSize = sizeof(float);
    
    CTFontRef font = CTFontCreateWithName(NULL, 17, NULL);
    NSMutableDictionary *attributesColor = [NSMutableDictionary dictionaryWithObject:(id)COLOR(45, 150, 232, 1).CGColor forKey:(id)kCTForegroundColorAttributeName];
    [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0,(_isLand?self.myStr.length + 1:self.myStr.length))];
    
//    long kernNumber = 5;
//    CFNumberRef kernNum = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &kernNumber);
//    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)kernNum range:(NSRange){0, 4}];
    
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,
        maxHeightSetting,
        multipleHeightSetting,
        maxLineSpaceSetting,
        lineSpaceSetting
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // set attributes to attributed string
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    [attributedString addAttributes:attributesColor range:NSMakeRange(0, self.myLength)];
  //  TLog(@"%ld",(long)self.myLength);
    
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
//    NSLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
//        NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
//        NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//            NSLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y - 3;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
}

@end
