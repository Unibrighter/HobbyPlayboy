//
//  HtmlContentParser.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HtmlContentParser.h"
#import "TFHpple.h"
#import "Gallery.h"

@implementation HtmlContentParser

+ (instancetype)sharedInstance{
    static HtmlContentParser *_sharedInstance;
    if (!_sharedInstance){
        _sharedInstance = [[HtmlContentParser alloc] init];
    }
    return _sharedInstance;
}

- (void)getGalleriesCount:(NSInteger)count pageNumOffset:(NSInteger)pageNumoffset completion:(void(^) (NSArray<Gallery *>*, NSError *))completionBlock{
    
    //TODO: make this a variable rather than hard-code
    NSMutableString *urlString = [@"https://18h.mm-cg.com/serch_doujinall/%E7%9F%AD%E7%AF%87%E3%80%81%E5%90%8C%E4%BA%BA%E5%85%A8%E9%83%A8%E5%88%97%E8%A1%A8_" mutableCopy];
    [urlString appendFormat:@"%d.htm", (int)pageNumoffset];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:urlString forHTTPHeaderField:@"Referer"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray <Gallery *> *galleries;
        if (!error) {
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            NSArray<TFHppleElement *> *links  = [xpathParser searchWithXPathQuery:@"//a[@class='c1']"];
            galleries = [[NSMutableArray alloc] initWithCapacity:links.count];
            for (TFHppleElement *linkElement in links) {
                Gallery *gallery = [[Gallery alloc] init];
                
                NSString *referenceURL = [linkElement objectForKey:@"href"];
                NSString *rawTitle = linkElement.text;
                
                gallery.rawTitle = rawTitle;
                gallery.referenceURLStr = referenceURL;
                [galleries addObject:gallery];
            }
        }
        completionBlock(galleries,error);
    }] resume];
}



@end
