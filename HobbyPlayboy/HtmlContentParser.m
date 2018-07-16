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

- (void)getGalleries{
    //TODO: make this a variable rather than hard-code
    NSString *urlString = @"http://www.18h-mmcg.com/serch_doujinall/%E7%9F%AD%E7%AF%87%E3%80%81%E5%90%8C%E4%BA%BA%E5%85%A8%E9%83%A8%E5%88%97%E8%A1%A8_92.htm";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:urlString forHTTPHeaderField:@"Referer"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            NSArray<TFHppleElement *> *links  = [xpathParser searchWithXPathQuery:@"//a[@class='c1']"];
            for (TFHppleElement *linkElement in links) {
//                if (!linkElement.attributes[@"href"]) {
//                    JSContext *context = [JSContext new];
//                    [context evaluateScript:scriptsElement.firstChild.content];
//                    JSValue *showKey = [context evaluateScript:@"showkey;"];
//
//                    if (![showKey.toString isEqualToString:@"undefined"]) {
//                        completionToMainThread(HentaiParserStatusSuccess, showKey.toString);
//                        return;
//                    }
//                }
            }
        }
        
        
//        completionToMainThread(HentaiParserStatusParseFail, nil);
    }] resume];
    
    
    
    
    
}




- (void)list{
//    NSData  * data      = [NSData dataWithContentsOfFile:@"index.html"];
//
//    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
//    NSArray * elements  = [doc search:@"//a[@class='sponsor']"];
//
//    TFHppleElement * element = [elements objectAtIndex:0];
//    [e text];                       // The text inside the HTML element (the content of the first text node)
//    [e tagName];                    // "a"
//    [e attributes];                 // NSDictionary of href, class, id, etc.
//    [e objectForKey:@"href"];       // Easy access to single attribute
//    [e firstChildWithTagName:@"b"]; // The first "b" child node
}






@end
