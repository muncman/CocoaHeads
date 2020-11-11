theme: Titillium, 1

# What's in a Name?
#
# _NSPeople_

---

## `PersonNameComponents`
# &
## `PersonNameComponentsFormatter`

^
^ Since iOS 9.

---

# Components of a Name

```swift
var grace = PersonNameComponents()
grace.namePrefix = "Mrs."
grace.givenName = "Grace"
grace.middleName = "Murray"
grace.familyName = "Hopper"
```

---

# Styles: `abbreviated` to `long`

```swift
private func log(_ components: PersonNameComponents) {
    print("Components = '\(components)'")
    let defaultName = PersonNameComponentsFormatter.localizedString(from: components,
                                                                    style: .default,
                                                                    options: [])
    print("Default = '\(defaultName)'")
    let longName = PersonNameComponentsFormatter.localizedString(from: components,
                                                                 style: .long,
                                                                 options: [])
    print("Long = '\(longName)'")
    let mediumName = PersonNameComponentsFormatter.localizedString(from: components,
                                                                   style: .medium,
                                                                   options: [])
    print("Medium = '\(mediumName)'")
    let shortName = PersonNameComponentsFormatter.localizedString(from: components,
                                                                  style: .short,
                                                                  options: [])
    print("Short = '\(shortName)'")
    let abbrevName = PersonNameComponentsFormatter.localizedString(from: components,
                                                                   style: .abbreviated,
                                                                   options: [])
    print("Abbreviated = '\(abbrevName)'")
}
```

^
^ Notice that these are class-level methods (instance later).
^ Note that I will not usually show the calls to log in the slides.
^ Note that `phonetic` is the only valid key for `options` (mention later).

---

# Output

```bash
Components =
    'namePrefix: Mrs.
    givenName: Grace
    middleName: Murray
    familyName: Hopper '
Default =	'Grace Hopper'
Long =		'Mrs. Grace Murray Hopper'
Medium =	'Grace Hopper'
Short =		'Grace'
Abbreviated =	'GH'
```

^
^ Notice the space at the end of the components' string description
^ Notice that the short name here is just the first name.

---

# Another Example

```swift
var bill = PersonNameComponents()
bill.namePrefix = "Mr."
bill.givenName = "William"
bill.middleName = "James \"Frickin\""
bill.familyName = "Murray"
bill.nameSuffix = "Esq."
bill.nickname = "Bill"
```

^
^ Notice that we have a name suffix and nickname here.

---

# Another Example

```swift
var bill = PersonNameComponents()
bill.namePrefix = "Mr."
bill.givenName = "William"
bill.middleName = "James \"Frickin\""
bill.familyName = "Murray"
bill.nameSuffix = "Esq."
bill.nickname = "Bill"
```

```bash
Components =	'namePrefix: Mr. givenName: William
    middleName: James "Frickin"
    familyName: Murray nameSuffix: Esq. nickname: Bill '
Default =	'William Murray'
Long =		'Mr. William James "Frickin" Murray Esq.'
Medium =	'William Murray'
Short =		'Bill'
Abbreviated =	'WM'
```

^
^ Notice that the short name here is now the nickname, since that component was present.

---

# But what if I have a single, full-name String?

---

# More Murray: String-to-Component

```swift
let nameFormatter = PersonNameComponentsFormatter()
let william = "Mr. William James (Frickin) 🍸 Murray-Jones de la Rocha Jr. 🕶"
if let nameComps  = nameFormatter.personNameComponents(from: william) {
    log(nameComps)
}
```

^
^ Notice that now we are using a formatter instance.

---

# More Murray: String-to-Component

```swift
let nameFormatter = PersonNameComponentsFormatter()
let william = "Mr. William James (Frickin) 🍸 Murray-Jones de la Rocha Jr. 🕶"
if let nameComps  = nameFormatter.personNameComponents(from: william) {
    log(nameComps)
}
```

```bash
Components =	'namePrefix: Mr. givenName: William James
    middleName: Murray-Jones familyName: de la Rocha nameSuffix: Jr. '
Default =	'William James "Frickin" de la Rocha'
Long =		'Mr. William James "Frickin" Murray-Jones de la Rocha Jr.'
Medium =	'William James "Frickin" de la Rocha'
Short =		'William James "Frickin"'
Abbreviated =	'WD'
```

^
^ Notice that the emojis and parenthetical are ignored (as opposed to a later example).
^ Notice the multiple values within single components.
^ Notice there's no automtic "Bill" from "William", nor the quoted "Frickin" into a nickname.

---

# Another Murray: String-to-Component

```swift
let will = "Murray, Bill"
if let nameComps  = nameFormatter.personNameComponents(from: will) {
    log(nameComps)
}
```

^
^ Notice that now we are using a formatter instance.

---

# Another Murray: String-to-Component

```swift
let will = "Murray, Bill"
if let nameComps  = nameFormatter.personNameComponents(from: will) {
    log(nameComps)
}
```

```bash
Components =	'givenName: Bill familyName: Murray '
Default =		'Bill Murray'
Long =			'Bill Murray'
Medium =		'Bill Murray'
Short =			'Bill'
Abbreviated =	'BM'
```

^
^ Notice that the 'last, first' format is handled properly.

---

# Junior is now a Doc and more Junior

```swift
let willy = "Mr. William James \"Frickin\" Murray-Jones de la Rocha MD. III"
if let nameComps  = nameFormatter.personNameComponents(from: willy) {
    log(nameComps)
}
```

---

# 🦟🕷🐛🐜🐞...? 👀 😱

```swift
let willy = "Mr. William James \"Frickin\" Murray-Jones de la Rocha MD. III"
if let nameComps  = nameFormatter.personNameComponents(from: willy) {
    log(nameComps)
}
```

```bash
Components =	'namePrefix: Mr. givenName: MD.
    familyName: William James "Frickin" Murray-Jones de la Rocha nameSuffix: III '
Default =	'MD. William James "Frickin" Murray-Jones de la Rocha'
Long =		'Mr. MD. William James "Frickin" Murray-Jones de la Rocha III'
Medium =	'MD. William James "Frickin" Murray-Jones de la Rocha'
Short =		'MD.'
Abbreviated =	'MW'
```

^
^ Notice the shifted parsing relative to the prior example. MD as givenName?! The output here is not consistent (buggy).

---

# Mononyms?

```swift
let stingString = "Sting"
var sting = PersonNameComponents()
sting.givenName = stingString

let formatter = PersonNameComponentsFormatter()
if let nameComps  = formatter.personNameComponents(from: stingString) {
    log(nameComps)
}
```

^
^ Notice that it is suprisingly hard to type "Sting" instead of "String"! 😅

---

# Mononyms!

```swift
let stingString = "Sting"
var sting = PersonNameComponents()
sting.givenName = stingString

let formatter = PersonNameComponentsFormatter()
if let nameComps  = formatter.personNameComponents(from: stingString) {
    log(nameComps)
}
```

```bash
Components =	'givenName: Sting '
Default =		'Sting'
Long =			'Sting'
Medium =		'Sting'
Short =			'Sting'
Abbreviated =	'S'
Components =	'givenName: Sting ':
Default =		'Sting'
Long =			'Sting'
Medium =		'Sting'
Short =			'Sting'
Abbreviated =	'S'
```

---

# Other Formats

---

# Plain & Fancy

```swift
var dave = PersonNameComponents()
dave.givenName = "Dave"
dave.familyName = "Grohl"

let nameFormatter = PersonNameComponentsFormatter()
print("Plain & unlocalized = '\(nameFormatter.string(from: dave))'")

let attributed = nameFormatter.annotatedString(from: dave)
print("Attributed & annotated = \(attributed)")
```

---

# Fancy & Plain

```swift
var dave = PersonNameComponents()
dave.givenName = "Dave"
dave.familyName = "Grohl"

let nameFormatter = PersonNameComponentsFormatter()
print("Plain & unlocalized = '\(nameFormatter.string(from: dave))'")

let attributed = nameFormatter.annotatedString(from: dave)
print("Attributed & annotated = \(attributed)")
```

```bash
Plain & unlocalized = 'Dave Grohl'
Attributed & annotated =
Dave{
    NSPersonNameComponentKey = givenName;
} {
    NSPersonNameComponentKey = delimiter;
}Grohl{
    NSPersonNameComponentKey = familyName;
}
```

^
^ Notice that the keys here are NS-prefixed.

---

# What about Non-ASCII names?

---

# CJK Script, Logographic Characters, Phonetics

```swift
var chiangKaiShek = PersonNameComponents()
chiangKaiShek.familyName = "蔣"
chiangKaiShek.givenName = "介石"
var chiangPhonetic = PersonNameComponents()
chiangPhonetic.familyName = "Chiang"
chiangPhonetic.givenName = "Kai-shek"
chiangKaiShek.phoneticRepresentation = chiangPhonetic
```

---

# Added to `log`

```swift
if let phoneticRep = components.phoneticRepresentation {
    print("Phonetic representation = '\(phoneticRep)'")
}
```

---

# Phonetics Mo'netics

```swift
var chiangKaiShek = PersonNameComponents()
chiangKaiShek.familyName = "蔣"
chiangKaiShek.givenName = "介石"
var chiangPhonetic = PersonNameComponents()
chiangPhonetic.familyName = "Chiang"
chiangPhonetic.givenName = "Kai-shek"
chiangKaiShek.phoneticRepresentation = chiangPhonetic
```

```bash
Components =	'givenName: 介石 familyName: 蔣
    phoneticRepresentation: givenName: Kai-shek familyName: Chiang  '
Default =	'蔣介石'
Long =		'蔣介石'
Medium =	'蔣介石'
Short =		'蔣介石'
Abbreviated =	'蔣'
Phonetic representation = 'givenName: Kai-shek familyName: Chiang '
```

^
^ Notice there are no spaces between name components in the output, as is appropriate for this name.
^ Notice that instead of a single space at the end of the second component description, there are two (unicode).
^ Interesting that unicode glyphs are handled, but emoji are ignored.

---

# Another Log Method

```swift
private func logPhonetics(_ components: PersonNameComponents) {
    let nameFormatter = PersonNameComponentsFormatter()
    print("Before: formatter is set to be phonetic? \(nameFormatter.isPhonetic)")
    print("Before = '\(nameFormatter.string(from: components))'")
    nameFormatter.isPhonetic = true
    print("After: formatter is set to be phonetic? \(nameFormatter.isPhonetic)")
    print("After = '\(nameFormatter.string(from: components))'")
}
```

---

# Pho-netics Fo-real

```swift
logPhonetics(chiangKaiShek)
logPhonetics(chiangPhonetic)
chiangPhonetic.phoneticRepresentation = chiangKaiShek
logPhonetics(chiangPhonetic)
```

```bash
Formatting components with phonetics:
Before: formatter is set to be phonetic? false
Before = '蔣介石'
After: formatter is set to be phonetic? true
After = 'Chiang Kai-shek'
Formatting the phonetic component version directly:
Before: formatter is set to be phonetic? false
Before = 'Kai-shek Chiang'
After: formatter is set to be phonetic? true
After = ''
Formatting the phonetic component version after making the relationship bidirectional:
Before: formatter is set to be phonetic? false
Before = 'Kai-shek Chiang'
After: formatter is set to be phonetic? true
After = '介石 蔣'
```

---

# UTF FTW

```swift
var chiangKaiShek😎 = PersonNameComponents()
chiangKaiShek😎.familyName = "蔣"
chiangKaiShek😎.givenName = "介(你好)石😅"
chiangKaiShek.phoneticRepresentation = chiangPhonetic
```

---

# You Tee Eph

```swift
var chiangKaiShek😎 = PersonNameComponents()
chiangKaiShek😎.familyName = "蔣"
chiangKaiShek😎.givenName = "介(你好)石😅"
chiangKaiShek.phoneticRepresentation = chiangPhonetic
```

```bash
Components =	'givenName: 介(你好)石😅 familyName: 蔣 '
Default =		'蔣介(你好)石😅'
Long =			'蔣介(你好)石😅'
Medium =		'蔣介(你好)石😅'
Short =			'蔣介(你好)石😅'
Abbreviated =	'蔣'
```

^
^ Notice that both the parenthetical and emoji are not omitted here (as opposed to the above).

---

# Some Things to Take NSNote Of

---

# `PersonNameComponents` vs `NSPersonNameComponents`

```swift
let ada = NSPersonNameComponents()
ada.givenName = "Augusta"
ada.middleName = "Ada"
ada.familyName = "Byron King"
ada.nameSuffix = "Countess of Lovelace"
ada.nickname = "Ada"
```

^
^ Notice that this can be a `let` while `PersonNameComponents` must be a `var`.

---

# `let comps = nsComponents as PersonNameComponents`

```bash
Components =	'<NSPersonNameComponents: 0x6000008f8100> {
    givenName = Augusta, familyName = Byron King, middleName = Ada, namePrefix = (null),
    nameSuffix = Countess of Lovelace, nickname = Ada
    phoneticRepresentation = (null) }'
Default =	'Augusta Byron King'
Long =		'Augusta Ada Byron King Countess of Lovelace'
Medium =	'Augusta Byron King'
Short =		'Ada'
Abbreviated =	'AB'
```

^
^ Notice that the conversion *always* succeeds.
^ Notice that the conversion _cannot_ be implicit.
^ Notice that the ObjC type is a class, while the Swift type is a struct.
^ Notice that the ObjC type also prints output for null components.

---

# From the Docs
## Clauses, Limitations, Caveats, Cautions, and Provisos

---

# From the Docs

> A name that contains more than one script (for example, given name: “John”, family name: “王”) is detected to have “Unknown” script, which has its own set of behaviors and characteristics.

---

# From the Docs

> `NSPersonNameComponentsFormatter` does not currently account for prepositional particles. Representations using the Short style that specify a family name initial naively use the first letter unit of the particle as the initial.

---

# From the Docs

> `NSPersonNameComponentsFormatter` doesn’t currently account for prepositional particles or compound names. Representations using the Abbreviated style uses the first letter unit of each name component, regardless.

^
^ Note, too, that some of the behavior can, I think, be controlled by user settings.

---

# Questions? Answers?

## Kevin Munc
## @muncman
