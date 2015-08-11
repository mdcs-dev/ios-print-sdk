//
// Hewlett-Packard Company
// All rights reserved.
//
// This file, its contents, concepts, methods, behavior, and operation
// (collectively the "Software") are protected by trade secret, patent,
// and copyright laws. The use of the Software is governed by a license
// agreement. Disclosure of the Software to third parties, in any form,
// in whole or in part, is expressly prohibited except as authorized by
// the license agreement.
//

#import <Foundation/Foundation.h>
#import "HPPPPageRange.h"
#import "HPPPPrintSettings.h"
#import "HPPPPrintItem.h"

@protocol HPPPPrintManagerDelegate;

/*!
 * @abstract Error types returned by the @directPrint:color:pageRange:numCopies function
 */
typedef enum {
    HPPPPrintManagerErrorNone,
    HPPPPrintManagerErrorNoPrinterUrl,
    HPPPPrintManagerErrorPrinterNotAvailable,
    HPPPPrintManagerErrorNoPaperType,
    HPPPPrintManagerErrorDirectPrintNotSupported,
    HPPPPrintManagerErrorUnknown
} HPPPPrintManagerError;

/*!
 * @abstract Class used to print on iOS 8 and greater systems
 */
@interface HPPPPrintManager : NSObject

/*!
 * @abstract Used to hold the print settings for the print job
 */
@property (strong, nonatomic) HPPPPrintSettings *currentPrintSettings;

/*!
 * @abstract The delegate that will receive callbacks from the print job
 */
@property (strong, nonatomic) id<HPPPPrintManagerDelegate> delegate;


/*!
 * @abstract Used to construct an HPPPPrintManager with a set of print settings
 * @param printSettings The print settings to use for the print job
 * @returns An initialized HPPPPrintManager object
 */
- (id)initWithPrintSettings:(HPPPPrintSettings *)printSettings;

/*!
 * @abstract Used to perform a print job
 * @discussion If the printSettings object does not contain enough information
 *  to send the print job, no print job will be started and FALSE will be returned.
 *  If run on a version of iOS prior to iOS 8, no print job will be started and
 *  FALSE will be returned
 * @param printItem The item to be printed
 * @param color If TRUE, a color print will be generated.  If FALSE, a black and 
 *  white print will be generated.
 * @param pageRange The page range to be printed
 * @param numCopies The number of copies to print
 * @param error The NSError object will be populated with any error generated by running
 *   this function
 */
- (void)directPrint:(HPPPPrintItem *)printItem
              color:(BOOL)color
          pageRange:(HPPPPageRange *)pageRange
          numCopies:(NSInteger)numCopies
              error:(NSError **)errorPtr;

/*!
 * @abstract Used to prepare a @UIPrintInterationController for printing
 * @discussion This function may be used on iOS 7 and greater.
 * @param controller The @UIPrintInteractionController to configure
 * @param printItem The item to be printed
 * @param color If TRUE, a color print will be generated.  If FALSE, a black and
 *  white print will be generated.
 * @param pageRange The page range to be printed
 * @param numCopies The number of copies to print
 */
- (void)prepareController:(UIPrintInteractionController *)controller
                printItem:(HPPPPrintItem *)printItem
                    color:(BOOL)color
                pageRange:(HPPPPageRange *)pageRange
                numCopies:(NSInteger)numCopies;

@end

/*!
 * @abstract Protocol used to indicate that a page range was selected
 */
@protocol HPPPPrintManagerDelegate <NSObject>
@optional

/*!
 * @abstract Called when the print job completes
 * @param completed If TRUE, the print job completed successfully.
 * @param error Any error associated with the print job
 */
- (void)didFinishPrintJob:(UIPrintInteractionController *)printController completed:(BOOL)completed error:(NSError *)error;

@end