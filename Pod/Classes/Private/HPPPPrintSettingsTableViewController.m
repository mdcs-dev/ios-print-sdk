//
//  HPPPPrintSettingsTableViewController.m
//  Pods
//
//  Created by Fredy on 2/5/15.
//
//

#import "HPPP.h"
#import "HPPPPaper.h"
#import "HPPPPrintSettingsTableViewController.h"
#import "HPPPPaperSizeTableViewController.h"
#import "HPPPPaperTypeTableViewController.h"

@interface HPPPPrintSettingsTableViewController  () <HPPPPaperSizeTableViewControllerDelegate, HPPPPaperTypeTableViewControllerDelegate>

@property (nonatomic, strong) HPPP *hppp;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *printerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *paperSizeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *paperTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedPrinterLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPaperSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPaperTypeLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UITableViewCell *paperTypeCell;


@end

@implementation HPPPPrintSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hppp = [HPPP sharedInstance];
    
    self.selectedPrinterLabel.text = self.printSettings.printer;
    self.selectedPaperSizeLabel.text = self.printSettings.paper.sizeTitle;
    self.selectedPaperTypeLabel.text = self.printSettings.paper.typeTitle;
    
    self.printerLabel.font = self.hppp.tableViewCellLabelFont;
    self.paperSizeLabel.font = self.hppp.tableViewCellLabelFont;
    self.paperTypeLabel.font = self.hppp.tableViewCellLabelFont;
    self.selectedPrinterLabel.font = self.hppp.tableViewCellLabelFont;
    self.selectedPaperSizeLabel.font = self.hppp.tableViewCellLabelFont;
    self.selectedPaperTypeLabel.font = self.hppp.tableViewCellLabelFont;
    
    self.paperTypeCell.hidden = self.printSettings.paper.paperSize != SizeLetter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HPPPPaperSizeTableViewControllerDelegate

- (void)paperSizeTableViewController:(HPPPPaperSizeTableViewController *)paperSizeTableViewController didSelectPaper:(HPPPPaper *)paper
{
    self.printSettings.paper = paper;
    self.selectedPaperSizeLabel.text = paper.sizeTitle;
    
    if (paper.paperSize == SizeLetter) {
        self.paperTypeCell.hidden = NO;
        self.printSettings.paper.paperType = Plain;
        self.printSettings.paper.typeTitle = [HPPPPaper titleFromType:Plain];
        self.selectedPaperTypeLabel.text = self.printSettings.paper.typeTitle;
        
    } else {
        self.paperTypeCell.hidden = YES;
        self.printSettings.paper.paperType = Photo;
        self.printSettings.paper.typeTitle = [HPPPPaper titleFromType:Photo];
        self.selectedPaperTypeLabel.text = self.printSettings.paper.typeTitle;
    }
    
    if ([self.delegate respondsToSelector:@selector(printSettingsTableViewController:didChangePrintSettings:)]) {
        [self.delegate printSettingsTableViewController:self didChangePrintSettings:self.printSettings];
    }
}

#pragma mark - HPPPPaperTypeTableViewControllerDelegate

- (void)paperTypeTableViewController:(HPPPPaperTypeTableViewController *)paperTypeTableViewController didSelectPaper:(HPPPPaper *)paper
{
    self.printSettings.paper = paper;
    self.selectedPaperTypeLabel.text = paper.typeTitle;
    
    
    if ([self.delegate respondsToSelector:@selector(printSettingsTableViewController:didChangePrintSettings:)]) {
        [self.delegate printSettingsTableViewController:self didChangePrintSettings:self.printSettings];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PaperSizeSegue"]) {
        
        HPPPPaperSizeTableViewController *vc = (HPPPPaperSizeTableViewController *)segue.destinationViewController;
        vc.currentPaper = self.printSettings.paper;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"PaperTypeSegue"]) {
        
        HPPPPaperTypeTableViewController *vc = (HPPPPaperTypeTableViewController *)segue.destinationViewController;
        vc.currentPaper = self.printSettings.paper;
        vc.delegate = self;
    }
}

@end
