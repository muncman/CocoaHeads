import Foundation

// MARK: - Examples

/// First example built from components.
private func performFirstExample() {
    var grace = PersonNameComponents()
    grace.namePrefix = "Mrs."
    grace.givenName = "Grace"
    grace.middleName = "Murray"
    grace.familyName = "Hopper"
    // Note: no nickname nor suffix here

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
    // Note: parenthetical values are excluded
    // Note compare the omission of emoji here vs in the non-ASCII scriprt example below
    let nameFormatter = PersonNameComponentsFormatter()
    let william = "Mr. William James (Frickin) 🍸 Murray-Jones de la Rocha Jr. 🕶"
    if let nameComps  = nameFormatter.personNameComponents(from: william) {
        // Note: no automatic "Bill" for short/nickname
        log(nameComps)
    }
    let willy = "Mr. William James \"Frickin\" Murray-Jones de la Rocha MD. III"
    if let nameComps  = nameFormatter.personNameComponents(from: willy) {
        // Note: the shifting relative to the above example! (Bug?)
        log(nameComps)
    }
    let will = "Murray, Bill"
    if let nameComps  = nameFormatter.personNameComponents(from: will) {
        // Note that the 'last, first' format is handled properly.
        log(nameComps)
    }
}

/// An example with a really short name.
private func performThirdExample() {
    let stingString = "Sting"
    var sting = PersonNameComponents()
    sting.givenName = stingString

    log(sting)

    if let nameComps  = PersonNameComponentsFormatter().personNameComponents(from: stingString) {
        log(nameComps)
    }
}

/// An example showing other formatting methods.
private func performFourthExample() {
    var dave = PersonNameComponents()
    dave.givenName = "Dave"
    dave.familyName = "Grohl"

    let nameFormatter = PersonNameComponentsFormatter()
    print("❇️\tPlain & unlocalized = '\(nameFormatter.string(from: dave))'")

    // Note: the keys here are NS-prefixed.
    print("❇️\tAttributed & annotated = \n\(nameFormatter.annotatedString(from: dave))")
}

/// An example built from components using CJK script / logographic characters.
private func performFifthExample() {
    var chiangKaiShek = PersonNameComponents()
    chiangKaiShek.familyName = "蔣"
    chiangKaiShek.givenName = "介石"
    var chiangPhonetic = PersonNameComponents()
    chiangPhonetic.familyName = "Chiang"
    chiangPhonetic.givenName = "Kai-shek"
    chiangKaiShek.phoneticRepresentation = chiangPhonetic

    // Note: the use of phonetics
    // Note: no spaces between name components in the output, as is appropriate for this name
    // Note: instead of a single space at the end of the second (only) component description, there are two
    log(chiangKaiShek)
    print("❇️\tFormatting components with phonetics:")
    logPhonetics(chiangKaiShek)
    print("❇️\tFormatting the phonetic component version directly:")
    logPhonetics(chiangPhonetic)
    print("❇️\tFormatting the phonetic component version after making the relationship bidirectional:")
    chiangPhonetic.phoneticRepresentation = chiangKaiShek
    logPhonetics(chiangPhonetic)

    var chiangKaiShek😎 = PersonNameComponents()
    chiangKaiShek😎.familyName = "蔣"
    chiangKaiShek😎.givenName = "介(你好)石😅"
    chiangKaiShek.phoneticRepresentation = chiangPhonetic
    // Note: that emoji and parenthesis are both kept here， as opposed to above
    // Note: sometimes, the formatted spacing is different when the emoji is in the middle of the name
    log(chiangKaiShek😎)
}

/// An example to highlight some differences between the NS- and non-NS APIs.
private func performSixthExample() {
    // Note: this can be a `let` while `PersonNameComponents` must be a `var`.
    let ada = NSPersonNameComponents()
    ada.givenName = "Augusta"
    ada.middleName = "Ada"
    ada.familyName = "Byron King"
    ada.nameSuffix = "Countess of Lovelace"
    ada.nickname = "Ada"

    logNSIsDifferent(ada)
}

/// An example of equality checking.
private func performSeventhExample() {
    var nirvanaDave = PersonNameComponents()
    nirvanaDave.givenName = "Dave"
    nirvanaDave.familyName = "Grohl"

    var fooDave = PersonNameComponents()
    fooDave.givenName = "Dave"
    fooDave.familyName = "Grohl"

    print("❇️\tAre the Daves equal? \(nirvanaDave == fooDave)")

    var probotDave = PersonNameComponents()
    probotDave.givenName = "Dave"
    probotDave.middleName = "Eric" // <-- different!
    probotDave.familyName = "Grohl"

    print("❇️\tAre these Daves equal? \(nirvanaDave == probotDave)")
}

// MARK: - Helper Methods

// Note:
//   - notice the space at the end of the components' string description
//   - `phonetic` is the only key available for `options`.
private func log(_ components: PersonNameComponents) {
    print("❇️\tComponents =\t'\(components)':")
    print("\tDefault =\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .default, options: []))'")
    print("\tLong =\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .long, options: []))'")
    print("\tMedium =\t\t'\(PersonNameComponentsFormatter.localizedString(from: components, style: .medium, options: []))'")
    print("\tShort =\t\t '\(PersonNameComponentsFormatter.localizedString(from: components, style: .short, options: []))'")
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
    print("\tLong =\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .long, options: []))'")
    print("\tMedium =\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .medium, options: []))'")
    print("\tShort =\t\t'\(PersonNameComponentsFormatter.localizedString(from: comps, style: .short, options: []))'")
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
performSixthExample()
performSeventhExample()
