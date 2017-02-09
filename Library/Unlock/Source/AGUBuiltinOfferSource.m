//
//  AGUBuiltinOfferSource.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUBuiltinOfferSource.h"

@interface AGUBuiltinOfferSource()
{
    NSString *_json;
}
@end

@implementation AGUBuiltinOfferSource

- (instancetype)initWithFilename:(NSString*)filename error:(NSError**)error
{
    return [self initWithFilename:filename inBundle:[NSBundle mainBundle] error:error];
}

- (instancetype)initWithFilename:(NSString*)filename inBundle:(NSBundle*)bundle error:(NSError**)error;
{
    self = [super init];
    if (self) {
        
        NSError*(^makeGenericError)(NSString*, NSInteger) = ^NSError*(NSString *description, NSInteger code) {
            return [NSError errorWithDomain:@"com.appgratis.unlock.offersource.builtin.error"
                                       code:code
                                   userInfo:@{NSLocalizedDescriptionKey: description}];
        };
        
        if (filename == nil) {
            if (error) {
                *error = makeGenericError(@"Cannot initialize the offer source withtout a filename", -10);
            }
            return nil;
        }
        
        NSString *jsonPath = [bundle pathForResource:filename ofType:@"json"];
        if (jsonPath == nil) {
            if (error) {
                *error = makeGenericError(@"Offer file not found. Please note that '.json' shouldn't be put in the filename, as the offer source automatically adds it. For exemple, if your file is named 'offers.json', you should use 'offers' as the filename parameter value.", -20);
            }
            return nil;
        }
        
        NSError *err;
        _json = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&err];
        
        if (_json == nil) {
            if (error) {
                NSMutableDictionary *errorUserInfo = [NSMutableDictionary new];
                errorUserInfo[NSLocalizedDescriptionKey] = @"Filesystem error";
                if (err != nil) {
                    errorUserInfo[NSUnderlyingErrorKey] = err;
                }
                
                *error = [NSError errorWithDomain:@"com.appgratis.unlock.offersource.builtin.error"
                                             code:-30
                                         userInfo:[NSDictionary dictionaryWithDictionary:errorUserInfo]];
            }
            
            return nil;
        }
        
    }
    return self;
}

- (NSString*)offersJSON
{
    return _json;
}

@end
