//
//  GTFormSectionDescriptor.m
//  GTForm ( https://github.com/xmartlabs/GTForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GTForm.h"
#import "GTFormSectionDescriptor.h"
#import "NSPredicate+GTFormAdditions.h"
#import "NSString+GTFormAdditions.h"
#import "UIView+GTFormAdditions.h"


@interface GTFormDescriptor (_GTFormSectionDescriptor)

@property (readonly) NSDictionary* allRowsByTag;

-(void)addRowToTagCollection:(GTFormRowDescriptor*)rowDescriptor;
-(void)removeRowFromTagCollection:(GTFormRowDescriptor*) rowDescriptor;
-(void)showFormSection:(GTFormSectionDescriptor*)formSection;
-(void)hideFormSection:(GTFormSectionDescriptor*)formSection;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(GTPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(GTPredicateType)predicateType;

@end

@interface GTFormSectionDescriptor()

@property NSMutableArray * formRows;
@property NSMutableArray * allRows;
@property BOOL isDirtyHidePredicateCache;
@property (nonatomic) NSNumber* hidePredicateCache;

@end

@implementation GTFormSectionDescriptor

@synthesize hidden = _hidden;
@synthesize hidePredicateCache = _hidePredicateCache;

-(instancetype)init
{
    self = [super init];
    if (self){
        _formRows = [NSMutableArray array];
        _allRows = [NSMutableArray array];
        _sectionInsertMode = GTFormSectionInsertModeLastRow;
        _sectionOptions = GTFormSectionOptionNone;
        _title = nil;
        _footerTitle = nil;
        _hidden = @NO;
        _hidePredicateCache = @NO;
        _isDirtyHidePredicateCache = YES;
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        _cellTitleEqualWidth = YES;
        _cellTitleMaxWidth = 0;
        [self addObserver:self forKeyPath:@"formRows" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:0];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title sectionOptions:(GTFormSectionOptions)sectionOptions sectionInsertMode:(GTFormSectionInsertMode)sectionInsertMode{
    self = [self init];
    if (self){
        _sectionInsertMode = sectionInsertMode;
        _sectionOptions = sectionOptions;
        _title = title;
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        if ([self canInsertUsingButton]){
            _multivaluedAddButton = [GTFormRowDescriptor formRowDescriptorWithTag:nil rowType:GTFormRowDescriptorTypeButton title:@"Add Item"];
            [_multivaluedAddButton.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
            _multivaluedAddButton.action.formSelector = NSSelectorFromString(@"multivaluedInsertButtonTapped:");
            [self insertObject:_multivaluedAddButton inFormRowsAtIndex:0];
            [self insertObject:_multivaluedAddButton inAllRowsAtIndex:0];
        }
    }
    return self;
}

+(instancetype)formSection
{
    return [[self class] formSectionWithTitle:nil];
}

+(instancetype)formSectionWithTitle:(NSString *)title
{
    return [[self class] formSectionWithTitle:title sectionOptions:GTFormSectionOptionNone];
}

+(instancetype)formSectionWithTitle:(NSString *)title multivaluedSection:(BOOL)multivaluedSection
{
    return [[self class] formSectionWithTitle:title sectionOptions:(multivaluedSection ? GTFormSectionOptionCanInsert | GTFormSectionOptionCanDelete : GTFormSectionOptionNone)];
}

+(instancetype)formSectionWithTitle:(NSString *)title sectionOptions:(GTFormSectionOptions)sectionOptions
{
    return [[self class] formSectionWithTitle:title sectionOptions:sectionOptions sectionInsertMode:GTFormSectionInsertModeLastRow];
}

+(instancetype)formSectionWithTitle:(NSString *)title sectionOptions:(GTFormSectionOptions)sectionOptions sectionInsertMode:(GTFormSectionInsertMode)sectionInsertMode
{
    return [[[self class] alloc] initWithTitle:title sectionOptions:sectionOptions sectionInsertMode:sectionInsertMode];
}

- (void)setHeaderHeight:(CGFloat)headerHeight {
    _headerHeight = headerHeight;

    if (headerHeight == 0) {
        _headerHeight = 0.1;
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight {
    _footerHeight = footerHeight;

    if (footerHeight == 0) {
        _footerHeight = 0.1;
    }
}

- (CGFloat)cellTitleMaxWidth
{
    CGFloat maxTitleWidth = 0;
    for (GTFormRowDescriptor *rowDescriptor in self.allRows) {
        CGFloat rowWidth = [rowDescriptor.title GTForm_sizeWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] maxWidth:[UIScreen mainScreen].bounds.size.width maxHeight:CGFLOAT_MAX].width;
        maxTitleWidth = MAX(maxTitleWidth, rowWidth);
    }
    return maxTitleWidth;
}

-(BOOL)isMultivaluedSection
{
    return (self.sectionOptions != GTFormSectionOptionNone);
}

-(void)addFormRow:(GTFormRowDescriptor *)formRow
{
    NSUInteger index;
    
    if ([self canInsertUsingButton]) {
        index = ([self.formRows count] > 0) ? [self.formRows count] - 1 : 0;
    } else {
        index = [self.allRows count];
    }

    [self insertObject:formRow inAllRowsAtIndex:index];
}

-(void)addFormRow:(GTFormRowDescriptor *)formRow afterRow:(GTFormRowDescriptor *)afterRow
{
    NSUInteger allRowIndex = [self.allRows indexOfObject:afterRow];
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex+1];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
}

-(void)addFormRow:(GTFormRowDescriptor *)formRow beforeRow:(GTFormRowDescriptor *)beforeRow
{
    
    NSUInteger allRowIndex = [self.allRows indexOfObject:beforeRow];
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
}

-(void)removeFormRowAtIndex:(NSUInteger)index
{
    if (self.formRows.count > index){
        GTFormRowDescriptor *formRow = [self.formRows objectAtIndex:index];
        NSUInteger allRowIndex = [self.allRows indexOfObject:formRow];
        [self removeObjectFromFormRowsAtIndex:index];
        [self removeObjectFromAllRowsAtIndex:allRowIndex];
    }
}

-(void)removeFormRow:(GTFormRowDescriptor *)formRow
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formRows indexOfObject:formRow]) != NSNotFound){
        [self removeFormRowAtIndex:index];
    }
    else if ((index = [self.allRows indexOfObject:formRow]) != NSNotFound){
        if (self.allRows.count > index){
            [self removeObjectFromAllRowsAtIndex:index];
        }
    };
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex
{
    if ((sourceIndex.row < self.formRows.count) && (destinationIndex.row < self.formRows.count) && (sourceIndex.row != destinationIndex.row)){
        GTFormRowDescriptor * row = [self objectInFormRowsAtIndex:sourceIndex.row];
        GTFormRowDescriptor * destRow = [self objectInFormRowsAtIndex:destinationIndex.row];
        [self.formRows removeObjectAtIndex:sourceIndex.row];
        [self.formRows insertObject:row atIndex:destinationIndex.row];
        
        [self.allRows removeObjectAtIndex:[self.allRows indexOfObject:row]];
        [self.allRows insertObject:row atIndex:[self.allRows indexOfObject:destRow]];
    }
}

-(void)dealloc
{
    [self.formDescriptor removeObserversOfObject:self predicateType:GTPredicateTypeHidden];
    @try {
        [self removeObserver:self forKeyPath:@"formRows"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - Show/hide rows

-(void)showFormRow:(GTFormRowDescriptor*)formRow{
    
    NSUInteger formIndex = [self.formRows indexOfObject:formRow];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allRows indexOfObject:formRow];
    if (index != NSNotFound){
        while (formIndex == NSNotFound && index > 0) {
            GTFormRowDescriptor* previous = [self.allRows objectAtIndex:--index];
            formIndex = [self.formRows indexOfObject:previous];
        }
        if (formIndex == NSNotFound){ // index == 0 => insert at the beginning
            [self insertObject:formRow inFormRowsAtIndex:0];
        }
        else {
            [self insertObject:formRow inFormRowsAtIndex:formIndex+1];
        }
        
    }
}

-(void)hideFormRow:(GTFormRowDescriptor*)formRow{
    NSUInteger index = [self.formRows indexOfObject:formRow];
    if (index != NSNotFound){
        [self removeObjectFromFormRowsAtIndex:index];
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.formDescriptor.delegate) return;
    if ([keyPath isEqualToString:@"formRows"]){
        if ([self.formDescriptor.formSections containsObject:self]){
            if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
                NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                GTFormRowDescriptor * formRow = [((GTFormSectionDescriptor *)object).formRows objectAtIndex:indexSet.firstIndex];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
            else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
                NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                GTFormRowDescriptor * removedRow = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenRemoved:removedRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
        }
    }
}



#pragma mark - KVC

-(NSUInteger)countOfFormRows
{
    return self.formRows.count;
}

- (id)objectInFormRowsAtIndex:(NSUInteger)index
{
    return [self.formRows objectAtIndex:index];
}

- (NSArray *)formRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.formRows objectsAtIndexes:indexes];
}

- (void)insertObject:(GTFormRowDescriptor *)formRow inFormRowsAtIndex:(NSUInteger)index
{
    formRow.sectionDescriptor = self;
    [self.formRows insertObject:formRow atIndex:index];
}

- (void)removeObjectFromFormRowsAtIndex:(NSUInteger)index
{
    [self.formRows removeObjectAtIndex:index];
}

#pragma mark - KVC ALL

-(NSUInteger)countOfAllRows
{
    return self.allRows.count;
}

- (id)objectInAllRowsAtIndex:(NSUInteger)index
{
    return [self.allRows objectAtIndex:index];
}

- (NSArray *)allRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.allRows objectsAtIndexes:indexes];
}

- (void)insertObject:(GTFormRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    row.sectionDescriptor = self;
    [self.formDescriptor addRowToTagCollection:row];
    [self.allRows insertObject:row atIndex:index];
    row.disabled = row.disabled;
    row.hidden = row.hidden;
}

- (void)removeObjectFromAllRowsAtIndex:(NSUInteger)index
{
    GTFormRowDescriptor * row = [self.allRows objectAtIndex:index];
    [self.formDescriptor removeRowFromTagCollection:row];
    [self.formDescriptor removeObserversOfObject:row predicateType:GTPredicateTypeDisabled];
    [self.formDescriptor removeObserversOfObject:row predicateType:GTPredicateTypeHidden];
    [self.allRows removeObjectAtIndex:index];
}

#pragma mark - Helpers

-(BOOL)canInsertUsingButton
{
    return (self.sectionInsertMode == GTFormSectionInsertModeButton && self.sectionOptions & GTFormSectionOptionCanInsert);
}

#pragma mark - Predicates


-(NSNumber *)hidePredicateCache
{
    return _hidePredicateCache;
}

-(void)setHidePredicateCache:(NSNumber *)hidePredicateCache
{
    NSParameterAssert(hidePredicateCache);
    self.isDirtyHidePredicateCache = NO;
    if (!_hidePredicateCache || ![_hidePredicateCache isEqualToNumber:hidePredicateCache]){
        _hidePredicateCache = hidePredicateCache;
    }
}

-(BOOL)isHidden
{
    if (self.isDirtyHidePredicateCache) {
        return [self evaluateIsHidden];
    }
    return [self.hidePredicateCache boolValue];
}

-(BOOL)evaluateIsHidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]) {
        if (!self.formDescriptor) {
            self.isDirtyHidePredicateCache = YES;
        } else {
            @try {
                self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.formDescriptor.allRowsByTag ?: @{}]);
            }
            @catch (NSException *exception) {
                // predicate syntax error.
                self.isDirtyHidePredicateCache = YES;
            };
        }
    }
    else{
        self.hidePredicateCache = _hidden;
    }
    if ([self.hidePredicateCache boolValue]){
        if ([self.formDescriptor.delegate isKindOfClass:[GTFormViewController class]]){
            GTFormBaseCell* firtResponder = (GTFormBaseCell*) [((GTFormViewController*)self.formDescriptor.delegate).tableView findFirstResponder];
            if ([firtResponder isKindOfClass:[GTFormBaseCell class]] && firtResponder.rowDescriptor.sectionDescriptor == self){
                [firtResponder resignFirstResponder];
            }
        }
        [self.formDescriptor hideFormSection:self];
    }
    else{
        [self.formDescriptor showFormSection:self];
    }
    return [self.hidePredicateCache boolValue];
}


-(id)hidden
{
    return _hidden;
}

-(void)setHidden:(id)hidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor removeObserversOfObject:self predicateType:GTPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor addObserversOfObject:self predicateType:GTPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}

@end