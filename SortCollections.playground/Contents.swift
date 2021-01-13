import Foundation

/// Demo code for a lightning talk.
/// For deeper topics: https://swiftrocks.com/introsort-timsort-swifts-sorting-algorithm.html

// MARK: - Simple Mutating Sort

var otherStringedInstruments = ["Lanikai", "Kentucky", "Deering", "Woodrow"]
otherStringedInstruments.sort()

otherStringedInstruments.sort { (a, b) -> Bool in
    a < b
}

otherStringedInstruments.sort {
    $0 < $1
}

// MARK: - Different Ordering

var guitars = ["Charvel", "Ovation", "Peavey", "Gibson", "Jackson", "Reverend", "Fender", "D'Angelico", "Schecter", "Ernie Ball"]
guitars.sort()
guitars.reverse()
guitars.sort(by: >)

// MARK: - Mixed Case

var mixedCaseInstruments = ["Lanikai", "lanikai", "Kentucky", "kentucky", "Deering", "deering", "Woodrow", "woodrow"]
mixedCaseInstruments.sort()

// MARK: - What about nils and escape codes?

//var otherOtherStringed = ["Lanikai", "Kentucky", "Deering", "Woodrow", nil]
//otherOtherStringed.sort()
// nil ==> "Referencing instance method 'sort()' on 'MutableCollection' requires that 'String?' conform to 'Comparable'"
var otherOtherStringed = ["Lanikai", "Kentucky", "Deering", "Woodrow", "", "   ", "\t\n\t\n", "🥸"]
otherOtherStringed.sort()

// MARK: Unicode?

var beyondLatinIso = ["👀", "™", "℃", "¶", "฿", "æ", "Ӝ"]
beyondLatinIso.sort()

// MARK: - SortED and More

let otherInstruments = ["keyboard", "theremin", "cajon", "bongo", "flute", "recorder", "harmonica", "iPad"]
// Nope! mutating vs `let`: otherInstruments.sort()
_ = otherInstruments.sorted()
_ = otherInstruments.sorted {
    $0.count < $1.count
}
_ = otherInstruments.reversed()

// MARK: - Review of the Simple Stuff

var justNumbers = [9, 5, 8, 2, 1, 3, 42, 0, -4, 99, 22]
justNumbers.sort()
justNumbers.sort { (a, b) -> Bool in
    a < b
}
justNumbers.sort {
    $0 < $1
}
justNumbers.sort(by: <)

justNumbers.reverse()
justNumbers.sort(by: >)

_ = justNumbers.sorted()
_ = justNumbers.reversed()

// MARK: - Structured Sorting

struct StringedInstrument {
    let name: String
    let stringCount: Int
}

let musicMan = StringedInstrument(name: "Baritone", stringCount: 6)
let soloist = StringedInstrument(name: "Jackson", stringCount: 7)
let t120 = StringedInstrument(name: "Bass", stringCount: 4)
let artist = StringedInstrument(name: "Dulcimer", stringCount: 4)
let goodtime = StringedInstrument(name: "Banjo", stringCount: 5)
let stringers = [musicMan, soloist, t120, artist, goodtime]

let instrumentsSorted = stringers.sorted {
    $0.stringCount < $1.stringCount
}
for stringer in instrumentsSorted {
    print("\(stringer.name): \(stringer.stringCount)");
}

struct DatedPercussion {
    let when: Date
}
extension DatedPercussion: CustomStringConvertible {
    var description: String {
        return "\(when)"
    }
}
let earlier = DatedPercussion(when: Date().addingTimeInterval(-3600))
let now = DatedPercussion(when: Date())
let later = DatedPercussion(when: Date().addingTimeInterval(3600))
let chronoBeats = [now, later, earlier]
chronoBeats.sorted {
    $0.when < $1.when
}

// MARK: - Multi-member Sort

struct ArbitraryExample {
    let ordinal: Int
    let when: Date
    let name: String
}
extension ArbitraryExample: CustomStringConvertible {
    var description: String {
        return "\(name) \(ordinal) \(when)"
    }
    
}
let dateA = Date()
let dateB = Date().advanced(by: 3600)
let first = ArbitraryExample(ordinal: 79, when: dateA, name: "First")
let second = ArbitraryExample(ordinal: 137, when: dateB, name: "Second")
let third = ArbitraryExample(ordinal: 44, when: dateA, name: "Third")
let fourth = ArbitraryExample(ordinal: 55, when: dateA, name: "Fourth")
let fifth = ArbitraryExample(ordinal: 137, when: dateB, name: "Fifth")
let sixth = ArbitraryExample(ordinal: 137, when: dateB, name: "AAA Sixth")
let arbiters = [first, second, third, fourth, fifth,sixth]

_ = arbiters.sorted { (a, b) -> Bool in
    // Primary sort by Date
    return a.when < b.when
}

_ = arbiters.sorted { (a, b) -> Bool in
    // Primary sort by Date
    guard a.when == b.when else {
        return a.when < b.when
    }
    // Secondary sort by Int
    return a.ordinal < b.ordinal
}

_ = arbiters.sorted { (a, b) -> Bool in
    // Primary sort by Date
    guard a.when == b.when else {
        return a.when < b.when
    }
    // Secondary sort by Int
    guard a.ordinal == b.ordinal else {
        return a.ordinal < b.ordinal
    }
    // Tertiary sort by String
    return a.name < b.name
}

// MARK: - Conforming to Comparable

// See: https://reverb.com/news/10-types-of-synthesis

class Synth {
    let type: String
    let other: String
    required init(type: String, other: String = "") {
        self.type = type
        self.other = other
    }
}
extension Synth: Comparable {
    // Needed for Comparable
    static func < (lhs: Synth, rhs: Synth) -> Bool {
        lhs.type < rhs.type
    }
    // Comparable extends Equatable, which needs this.
    // Xcode complains without this for classes but not structs.
    static func == (lhs: Synth, rhs: Synth) -> Bool {
        return lhs.type == rhs.type && lhs.other == rhs.other
    }
}
extension Synth: CustomStringConvertible {
    var description: String {
        return "\(type)"
    }
}
let subtractive = Synth(type: "Subtractive")
let additive = Synth(type: "Additive")
let fm = Synth(type: "Frequency Modulation")
let duplicateFM = Synth(type: "Frequency Modulation")
let granular = Synth(type: "Granular")
let sampled = Synth(type: "Sample-based")
let wavetable = Synth(type: "Wavetable")
let vector = Synth(type: "Vector")
let spectral = Synth(type: "Spectral")
let physical = Synth(type: "Physical Modeling")
let westCoast = Synth(type: "West Coast")
let synthesizers = [subtractive, additive, fm, duplicateFM, granular, sampled, wavetable, vector, spectral, physical, westCoast]
let sortedSynths = synthesizers.sorted()
sortedSynths.contains(fm)
sortedSynths.contains(Synth(type: "Frequency Modulation", other: ""))
sortedSynths.contains(Synth(type: "Frequency Modulation", other: "different"))
sortedSynths.min()?.type
sortedSynths.max()?.type
