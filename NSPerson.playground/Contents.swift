import Foundation

// MARK: - Examples

/// First example built from components.
private func performFirstExample() {
    var grace = PersonNameComponents()
    grace.namePrefix = "Mrs."
    grace.givenName = "Grace"
    grace.middleName = "Murray"
    grace.familyName = "Hopper"
    grace.nameSuffix = "PhD."
    // Note: no nickname here

    log(grace)
}

/// Another example built from components, plus examples parsed from `String`s.
private func performSecondExample() {
    var bill = PersonNameComponents()
    bill.namePrefix = "Mr."
    bill.givenName = "William"
    bill.middleName = "James \"Frickin\""
    bill.familyName = "Murray"
    bill.nameSuffix = "Esq."
    bill.nickname = "Bill"

    log(bill)

    // Note: multiple values within components
    let william = "Mr. William James \"Frickin\" Murray-Jones de la Rocha Jr."
    let nameFormatter = PersonNameComponentsFormatter()
    if let nameComps  = nameFormatter.personNameComponents(from: william) {
        // Note: no automatic "Bill" for short/nickname
        log(nameComps)
    }
    let willy = "Mr. William James \"Frickin\" Murray-Jones de la Rocha MD. III"
    if let nameComps  = nameFormatter.personNameComponents(from: willy) {
        // Note: the shifting relative to the above example! (Bug?)
        log(nameComps)
    }
}

/// An example built from components using CJK/logographic characters.
private func performThirdExample() {
    var chiangKaiShek = PersonNameComponents()
    chiangKaiShek.familyName = "蔣"
    chiangKaiShek.givenName = "介石"
    var chiangPhonetic = PersonNameComponents()
    chiangPhonetic.familyName = "Chiang"
    chiangPhonetic.givenName = "Kai-shek"
    chiangKaiShek.phoneticRepresentation = chiangPhonetic

    // Note: the use of phonetics
    // Note: no spaces between name components in the output, as is appropriate for this name
    // Note: instead of a single space at the end of the component description, there are two
    log(chiangKaiShek)
    print("❇️\tFormatting components with phonetics:")
    logPhonetics(chiangKaiShek)
    print("❇️\tFormatting the phonetic component version directly:")
    logPhonetics(chiangPhonetic)
    print("❇️\tFormatting the phonetic component version after making the relationship bidirectional:")
    chiangPhonetic.phoneticRepresentation = chiangKaiShek
    logPhonetics(chiangPhonetic)
}

/// An example showing other formatting methods.
private func performFourthExample() {
    var dave = PersonNameComponents()
    dave.givenName = "Dave"
    dave.familyName = "Grohl"

    // TODO: MUNC: formatter options?
    let nameFormatter = PersonNameComponentsFormatter()
    print("❇️\tPlain & unlocalized = '\(nameFormatter.string(from: dave))'")
    let attributed = nameFormatter.annotatedString(from: dave)
    // Note: the keys here are NS-prefixed.
    print("❇️\tAttributed & annotated = \n\(attributed)")
    // TODO: MUNC: get the keys, etc. print("❇️\tExtracted from attributed = \n\(attributed[NSPersonNameComponentGivenName])")
}

/// An example to highlight some differences between the NS- and non-NS APIs.
private func performFifthExample() {
    // Note: this can be a `let` while `PersonNameComponents` must be a `var` for this.
    let ada = NSPersonNameComponents()
    ada.givenName = "Augusta"
    ada.middleName = "Ada"
    ada.familyName = "Byron King"
    ada.nameSuffix = "Countess of Lovelace"
    ada.nickname = "Ada"

    logNSIsDifferent(ada)
}

// MARK: - Helper Methods

private func log(_ components: PersonNameComponents) {
    // Note: notice the space at the end of the components' string description
    print("❇️\tComponents =\t'\(components)':")
    print("\tDefault =\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .default, options: []))'")
    print("\tLong =\t\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .long, options: []))'")
    print("\tMedium =\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .medium, options: []))'")
    print("\tShort =\t\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .short, options: []))'")
    print("\tAbbreviated =\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .abbreviated, options: []))'")
    if let phoneticRep = components.phoneticRepresentation {
        print("\tPhonetic representation = '\(phoneticRep)'")
    }
}

private func logPhonetics(_ components: PersonNameComponents) {
    let nameFormatter = PersonNameComponentsFormatter()
    print("Before: formatter is set to be phonetic? \(nameFormatter.isPhonetic)")
    print("Before = '\(nameFormatter.string(from: components))'")
    nameFormatter.isPhonetic = true
    print("After: formatter is set to be phonetic? \(nameFormatter.isPhonetic)")
    print("After = '\(nameFormatter.string(from: components))'")
}

// Note:
//   - The conversion *always* succeeds.
//   - The conversion _cannot_ be implicit.
//   - The ObjC type is a class, while the Swift type is a struct.
//   - The ObjC type also prints output for null components. 
private func logNSIsDifferent(_ components: NSPersonNameComponents) {
    print("❇️\tComponents =\t'\(components)':")
    let comps = components as PersonNameComponents
    print("\tDefault =\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .default, options: []))'")
    print("\tLong =\t\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .long, options: []))'")
    print("\tMedium =\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .medium, options: []))'")
    print("\tShort =\t\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .short, options: []))'")
    print("\tAbbreviated =\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .abbreviated, options: []))'")
    if let phoneticRep = components.phoneticRepresentation {
        print("\tPhonetic representation = '\(phoneticRep)'")
    }
}

// MARK: - Demo

performFirstExample()
performSecondExample()
performThirdExample()
performFourthExample()
performFifthExample()

// TODO: MUNC: try Codeye for images?
// TODO: MUNC: MUST look at docs and scripts and clauses and limitations and caveats and SYNONYMS... !
// TODO: MUNC: equality checks...??
