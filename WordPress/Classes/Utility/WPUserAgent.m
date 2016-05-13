#import "WPUserAgent.h"

static NSString* const WPUserAgentKeyUserAgent = @"UserAgent";

@implementation WPUserAgent

+ (NSString *)defaultUserAgent
{
    static NSString * _defaultUserAgent;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:WPUserAgentKeyUserAgent] != nil){
            NSLog(@"To get the real default nothing should be already be set here");
        }
        if ([NSThread isMainThread]){
            _defaultUserAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _defaultUserAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            });
        }
    });
    NSAssert(_defaultUserAgent != nil, @"User agent shouldn't be nil");
    NSAssert([_defaultUserAgent length] > 0, @"User agent shouldn't be empty");

    return _defaultUserAgent;
}

+ (NSString *)wordPressUserAgent
{
    static NSString * _wordPressUserAgent;
    if (_wordPressUserAgent == nil) {
        NSString *defaultUA = [self defaultUserAgent];
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _wordPressUserAgent = [NSString stringWithFormat:@"%@ wp-iphone/%@", defaultUA, appVersion];
    }
    
    return _wordPressUserAgent;
}

+ (void)useWordPressUserAgentInUIWebViews
{
    // Cleanup unused NSUserDefaults keys from older WPUserAgent implementation
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultUserAgent"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppUserAgent"];

    NSString *userAgent = [self wordPressUserAgent];

    NSParameterAssert([userAgent isKindOfClass:[NSString class]]);
    
    NSDictionary *dictionary = @{WPUserAgentKeyUserAgent: userAgent};
    // We have to call registerDefaults else the change isn't picked up by UIWebViews.
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    DDLogVerbose(@"User-Agent set to: %@", userAgent);
}

@end
