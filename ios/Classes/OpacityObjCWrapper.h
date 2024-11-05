#import <Foundation/Foundation.h>

@interface OpacityObjCWrapper : NSObject

+ (void)handleStatus:(int)status
                json:(char *)json
               proof:(char *)proof
                 err:(char *)err
          completion:(void (^)(NSString *json, NSString *proof,
                               NSError *error))completion;

+ (void)initialize:(NSString *)api_key andDryRun:(BOOL)dry_run;
// uber
+ (void)getUberRiderProfile:(void (^)(NSString *json, NSString *proof,
                                      NSError *error))completion;
+ (void)getUberRiderTripHistory:(NSString *)cursor
                  andCompletion:(void (^)(NSString *json, NSString *proof,
                                          NSError *error))completion;
+ (void)getUberRiderTrip:(NSString *)uuid
           andCompletion:(void (^)(NSString *json, NSString *proof,
                                   NSError *error))completion;
+ (void)getUberDriverProfile:(void (^)(NSString *json, NSString *proof,
                                       NSError *error))completion;
+ (void)getUberDriverTrips:(NSString *)startDate
                andEndDate:(NSString *)endDate
                 andCursor:(NSString *)cursor
             andCompletion:(void (^)(NSString *json, NSString *proof,
                                     NSError *error))completion;
+ (void)getUberFareEstimate:(NSNumber *)pickupLatitude
         andPickupLongitude:(NSNumber *)pickupLongitude
     andDestinationLatitude:(NSNumber *)destinationLatitude
    andDestinationLongitude:(NSNumber *)destinationLongitude
              andCompletion:(void (^)(NSString *json, NSString *proof,
                                      NSError *error))completion;
// Reddit
+ (void)getRedditAccount:(void (^)(NSString *json, NSString *proof,
                                   NSError *error))completion;
+ (void)getRedditFollowedSubreddits:(void (^)(NSString *json, NSString *proof,
                                              NSError *error))completion;
+ (void)getRedditComments:(void (^)(NSString *json, NSString *proof,
                                    NSError *error))completion;
+ (void)getRedditPosts:(void (^)(NSString *json, NSString *proof,
                                 NSError *error))completion;
//  Zabka
+ (void)getZabkaAccount:(void (^)(NSString *json, NSString *proof,
                                  NSError *error))completion;
+ (void)getZabkaPoints:(void (^)(NSString *json, NSString *proof,
                                 NSError *error))completion;
// Carta
+ (void)getCartaProfile:(void (^)(NSString *json, NSString *proof,
                                  NSError *error))completion;
+ (void)getCartaOrganizations:(void (^)(NSString *json, NSString *proof,
                                        NSError *error))completion;
+ (void)getCartaPortfolioInvestments:(NSString *)firm_id
                        andAccountId:(NSString *)account_id
                       andCompletion:(void (^)(NSString *json, NSString *proof,
                                               NSError *error))completion;
+ (void)getCartaHoldingsCompanies:(NSString *)accountId
                    ancCompletion:(void (^)(NSString *json, NSString *proof,
                                            NSError *error))completion;
+ (void)getCartaCorporationSecurities:(NSString *)account_id
                     andCorporationId:(NSString *)corporation_id
                        andCompletion:(void (^)(NSString *json, NSString *proof,
                                                NSError *error))completion;
@end
