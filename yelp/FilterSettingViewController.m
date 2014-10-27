//
//  FilterSettingViewController.m
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "FilterSettingViewController.h"
#import "common.h"

@interface FilterSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (weak, readonly) NSDictionary *filters;
@property (assign, nonatomic) NSInteger sortFilter;
@property (assign, nonatomic) NSInteger distanceChoice;
@property (strong, nonatomic) NSArray *allCategories;
@property (nonatomic) BOOL dealChoice;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sortOptions;
@property (strong, nonatomic) NSArray *distanceOptions;

@property (strong, nonatomic) NSMutableSet *expandedSections;
@property (strong, nonatomic) NSMutableSet *selectedCategories;

@end

@implementation FilterSettingViewController

const int MOST_POP_SECTION = 0;
const int DISTANCE_SECTION = 1;
const int SORT_SECTION = 2;
const int CATEGORY_SECTION = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = @[@"Most Popular", @"Distance", @"Sort by", @"Categories"];
        self.sortOptions = @[@"best match", @"distance", @"highest rated"];
        self.distanceOptions = @[@"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles"];
        self.expandedSections = [NSMutableSet set];
        self.sortFilter = 0;
        [self initCategories];
        self.selectedCategories = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView registerNib:[UINib nibWithNibName:@"ExpandableCell" bundle:nil] forCellReuseIdentifier:@"ExpandableCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"CheckboxCell" bundle:nil] forCellReuseIdentifier:@"CheckboxCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]
        forCellReuseIdentifier:@"SwitchCell"];
    
    self.settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Filters";
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SORT_SECTION:
            return [self numberOfRowsInSortSection];
            
        case DISTANCE_SECTION:
            return [self numberOfRowsInDistanceSection];
            
        case MOST_POP_SECTION:
            return 1;
        
        case CATEGORY_SECTION:
            return [self numberOfRowsInCategorySection];
            
        default:
            break;
    }

    return 0;
}

- (NSInteger)numberOfRowsInCategorySection {
    return [self.allCategories count];
}

- (NSInteger)numberOfRowsInDistanceSection {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:DISTANCE_SECTION]]) {
        return [self.distanceOptions count];
    }
    return 1;
}

- (NSInteger)numberOfRowsInSortSection {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:SORT_SECTION]]) {
        return [self.sortOptions count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SORT_SECTION:
            return [self cellForRowForSortSection:tableView indexPath:indexPath];

        case DISTANCE_SECTION:
            return [self cellForRowForDistanceSection:tableView indexPath:indexPath];
            
        case MOST_POP_SECTION:
            return [self cellForRowForMostPopSection:tableView indexPath:indexPath];
            
        case CATEGORY_SECTION:
            return [self cellForRowForCategorySection:tableView indexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)cellForRowForCategorySection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    SwitchCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    NSString *cateogry = self.allCategories[indexPath.row][@"name"];
    cell.titleLabel.text = cateogry;
    cell.delegate = self;
    cell.indexPath = indexPath;
    BOOL isOn = [self.selectedCategories containsObject:[NSNumber numberWithInteger:indexPath.row]];
    [cell setOn:isOn animated:NO];
    return cell;
}

- (UITableViewCell *)cellForRowForMostPopSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    SwitchCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = @"Offering a deal";
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setOn:self.dealChoice animated:NO];
    return cell;
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == MOST_POP_SECTION) {
        self.dealChoice = value;
    } else if (indexPath.section == CATEGORY_SECTION) {
        [self.selectedCategories addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
}

- (UITableViewCell *)cellForRowForDistanceSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:DISTANCE_SECTION]]) {
        CheckboxCell* cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"CheckboxCell"];
        cell.titleLabel.text = self.distanceOptions[indexPath.row];
        cell.indexPath = indexPath;
        [cell setChecked:(indexPath.row == self.distanceChoice)];
        cell.delegate = self;
        return cell;
    }
    ExpandableCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"ExpandableCell"];
    cell.titleLabel.text = self.distanceOptions[self.distanceChoice];
    cell.section = indexPath.section;
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *) cellForRowForSortSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:SORT_SECTION]]) {
        CheckboxCell* cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"CheckboxCell"];
        cell.titleLabel.text = self.sortOptions[indexPath.row];
        cell.indexPath = indexPath;
        [cell setChecked:(indexPath.row == self.sortFilter)];
        cell.delegate = self;
        return cell;
    }
    ExpandableCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"ExpandableCell"];
    cell.titleLabel.text = self.sortOptions[self.sortFilter];
    cell.section = indexPath.section;
    cell.delegate = self;
    return cell;
}
                            
- (void)onSelectSortSectionRow:(NSInteger)row {
    self.sortFilter = row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate filterSettingViewController:self didChangeFilters:self.filters];
}

- (NSDictionary *)filters {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    if (self.sortFilter) {
        [ret setObject:[NSNumber numberWithInteger:self.sortFilter] forKey:@"sortFilter"];
    }
    
    return ret;
}

- (void)extandableCell:(ExpandableCell *)cell sectionExpanded:(NSInteger)section {
    [self.expandedSections addObject:[NSNumber numberWithInteger:section]];
    [self.settingTableView reloadData];
}

- (void)checkboxCell:(CheckboxCell *)cell cellChecked:(NSIndexPath *)indexPath {
    if (indexPath.section == SORT_SECTION) {
        [self.expandedSections removeObject:[NSNumber numberWithInteger:indexPath.section]];
        self.sortFilter = indexPath.row;
    } else if (indexPath.section == DISTANCE_SECTION) {
        [self.expandedSections removeObject:[NSNumber numberWithInteger:indexPath.section]];
        self.distanceChoice = indexPath.row;
    }
    [self.settingTableView reloadData];
}

- (void)initCategories {
    self.allCategories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                            @{@"name" : @"African", @"code": @"african" },
                            @{@"name" : @"American, New", @"code": @"newamerican" },
                            @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                            @{@"name" : @"Arabian", @"code": @"arabian" },
                            @{@"name" : @"Argentine", @"code": @"argentine" },
                            @{@"name" : @"Armenian", @"code": @"armenian" },
                            @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                            @{@"name" : @"Asturian", @"code": @"asturian" },
                            @{@"name" : @"Australian", @"code": @"australian" },
                            @{@"name" : @"Austrian", @"code": @"austrian" },
                            @{@"name" : @"Baguettes", @"code": @"baguettes" },
                            @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                            @{@"name" : @"Barbeque", @"code": @"bbq" },
                            @{@"name" : @"Basque", @"code": @"basque" },
                            @{@"name" : @"Bavarian", @"code": @"bavarian" },
                            @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                            @{@"name" : @"Beer Hall", @"code": @"beerhall" },
                            @{@"name" : @"Beisl", @"code": @"beisl" },
                            @{@"name" : @"Belgian", @"code": @"belgian" },
                            @{@"name" : @"Bistros", @"code": @"bistros" },
                            @{@"name" : @"Black Sea", @"code": @"blacksea" },
                            @{@"name" : @"Brasseries", @"code": @"brasseries" },
                            @{@"name" : @"Brazilian", @"code": @"brazilian" },
                            @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                            @{@"name" : @"British", @"code": @"british" },
                            @{@"name" : @"Buffets", @"code": @"buffets" },
                            @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
                            @{@"name" : @"Burgers", @"code": @"burgers" },
                            @{@"name" : @"Burmese", @"code": @"burmese" },
                            @{@"name" : @"Cafes", @"code": @"cafes" },
                            @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
                            @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
                            @{@"name" : @"Cambodian", @"code": @"cambodian" },
                            @{@"name" : @"Canadian", @"code": @"New)" },
                            @{@"name" : @"Canteen", @"code": @"canteen" },
                            @{@"name" : @"Caribbean", @"code": @"caribbean" },
                            @{@"name" : @"Catalan", @"code": @"catalan" },
                            @{@"name" : @"Chech", @"code": @"chech" },
                            @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
                            @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
                            @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
                            @{@"name" : @"Chilean", @"code": @"chilean" },
                            @{@"name" : @"Chinese", @"code": @"chinese" },
                            @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
                            @{@"name" : @"Corsican", @"code": @"corsican" },
                            @{@"name" : @"Creperies", @"code": @"creperies" },
                            @{@"name" : @"Cuban", @"code": @"cuban" },
                            @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
                            @{@"name" : @"Cypriot", @"code": @"cypriot" },
                            @{@"name" : @"Czech", @"code": @"czech" },
                            @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
                            @{@"name" : @"Danish", @"code": @"danish" },
                            @{@"name" : @"Delis", @"code": @"delis" },
                            @{@"name" : @"Diners", @"code": @"diners" },
                            @{@"name" : @"Dumplings", @"code": @"dumplings" },
                            @{@"name" : @"Eastern European", @"code": @"eastern_european" },
                            @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
                            @{@"name" : @"Fast Food", @"code": @"hotdogs" },
                            @{@"name" : @"Filipino", @"code": @"filipino" },
                            @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
                            @{@"name" : @"Fondue", @"code": @"fondue" },
                            @{@"name" : @"Food Court", @"code": @"food_court" },
                            @{@"name" : @"Food Stands", @"code": @"foodstands" },
                            @{@"name" : @"French", @"code": @"french" },
                            @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
                            @{@"name" : @"Galician", @"code": @"galician" },
                            @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
                            @{@"name" : @"Georgian", @"code": @"georgian" },
                            @{@"name" : @"German", @"code": @"german" },
                            @{@"name" : @"Giblets", @"code": @"giblets" },
                            @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
                            @{@"name" : @"Greek", @"code": @"greek" },
                            @{@"name" : @"Halal", @"code": @"halal" },
                            @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
                            @{@"name" : @"Heuriger", @"code": @"heuriger" },
                            @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
                            @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
                            @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
                            @{@"name" : @"Hot Pot", @"code": @"hotpot" },
                            @{@"name" : @"Hungarian", @"code": @"hungarian" },
                            @{@"name" : @"Iberian", @"code": @"iberian" },
                            @{@"name" : @"Indian", @"code": @"indpak" },
                            @{@"name" : @"Indonesian", @"code": @"indonesian" },
                            @{@"name" : @"International", @"code": @"international" },
                            @{@"name" : @"Irish", @"code": @"irish" },
                            @{@"name" : @"Island Pub", @"code": @"island_pub" },
                            @{@"name" : @"Israeli", @"code": @"israeli" },
                            @{@"name" : @"Italian", @"code": @"italian" },
                            @{@"name" : @"Japanese", @"code": @"japanese" },
                            @{@"name" : @"Jewish", @"code": @"jewish" },
                            @{@"name" : @"Kebab", @"code": @"kebab" },
                            @{@"name" : @"Korean", @"code": @"korean" },
                            @{@"name" : @"Kosher", @"code": @"kosher" },
                            @{@"name" : @"Kurdish", @"code": @"kurdish" },
                            @{@"name" : @"Laos", @"code": @"laos" },
                            @{@"name" : @"Laotian", @"code": @"laotian" },
                            @{@"name" : @"Latin American", @"code": @"latin" },
                            @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
                            @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
                            @{@"name" : @"Malaysian", @"code": @"malaysian" },
                            @{@"name" : @"Meatballs", @"code": @"meatballs" },
                            @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
                            @{@"name" : @"Mexican", @"code": @"mexican" },
                            @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
                            @{@"name" : @"Milk Bars", @"code": @"milkbars" },
                            @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
                            @{@"name" : @"Modern European", @"code": @"modern_european" },
                            @{@"name" : @"Mongolian", @"code": @"mongolian" },
                            @{@"name" : @"Moroccan", @"code": @"moroccan" },
                            @{@"name" : @"New Zealand", @"code": @"newzealand" },
                            @{@"name" : @"Night Food", @"code": @"nightfood" },
                            @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
                            @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
                            @{@"name" : @"Oriental", @"code": @"oriental" },
                            @{@"name" : @"Pakistani", @"code": @"pakistani" },
                            @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
                            @{@"name" : @"Parma", @"code": @"parma" },
                            @{@"name" : @"Persian/Iranian", @"code": @"persian" },
                            @{@"name" : @"Peruvian", @"code": @"peruvian" },
                            @{@"name" : @"Pita", @"code": @"pita" },
                            @{@"name" : @"Pizza", @"code": @"pizza" },
                            @{@"name" : @"Polish", @"code": @"polish" },
                            @{@"name" : @"Portuguese", @"code": @"portuguese" },
                            @{@"name" : @"Potatoes", @"code": @"potatoes" },
                            @{@"name" : @"Poutineries", @"code": @"poutineries" },
                            @{@"name" : @"Pub Food", @"code": @"pubfood" },
                            @{@"name" : @"Rice", @"code": @"riceshop" },
                            @{@"name" : @"Romanian", @"code": @"romanian" },
                            @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
                            @{@"name" : @"Rumanian", @"code": @"rumanian" },
                            @{@"name" : @"Russian", @"code": @"russian" },
                            @{@"name" : @"Salad", @"code": @"salad" },
                            @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
                            @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
                            @{@"name" : @"Scottish", @"code": @"scottish" },
                            @{@"name" : @"Seafood", @"code": @"seafood" },
                            @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
                            @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
                            @{@"name" : @"Singaporean", @"code": @"singaporean" },
                            @{@"name" : @"Slovakian", @"code": @"slovakian" },
                            @{@"name" : @"Soul Food", @"code": @"soulfood" },
                            @{@"name" : @"Soup", @"code": @"soup" },
                            @{@"name" : @"Southern", @"code": @"southern" },
                            @{@"name" : @"Spanish", @"code": @"spanish" },
                            @{@"name" : @"Steakhouses", @"code": @"steak" },
                            @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                            @{@"name" : @"Swabian", @"code": @"swabian" },
                            @{@"name" : @"Swedish", @"code": @"swedish" },
                            @{@"name" : @"Swiss Food", @"code": @"swissfood" },
                            @{@"name" : @"Tabernas", @"code": @"tabernas" },
                            @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                            @{@"name" : @"Tapas Bars", @"code": @"tapas" },
                            @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
                            @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
                            @{@"name" : @"Thai", @"code": @"thai" },
                            @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
                            @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
                            @{@"name" : @"Trattorie", @"code": @"trattorie" },
                            @{@"name" : @"Turkish", @"code": @"turkish" },
                            @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
                            @{@"name" : @"Uzbek", @"code": @"uzbek" },
                            @{@"name" : @"Vegan", @"code": @"vegan" },
                            @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                            @{@"name" : @"Venison", @"code": @"venison" },
                            @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
                            @{@"name" : @"Wok", @"code": @"wok" },
                            @{@"name" : @"Wraps", @"code": @"wraps" },
                            @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
}

@end
