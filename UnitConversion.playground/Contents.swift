import Foundation

let inFeet = Measurement(value: 600, unit: UnitLength.feet)
//let inFeet = Measurement<UnitLength>(value: 600, unit: .feet)

let inMiles = inFeet.converted(to: UnitLength.miles)
let inMeters = inFeet.converted(to: UnitLength.meters)

let inParsecs = inFeet.converted(to: UnitLength.parsecs)
let inInches = inFeet.converted(to: UnitLength.inches)
let inAstro = inFeet.converted(to: UnitLength.astronomicalUnits)
let inNanoMeters = inFeet.converted(to: UnitLength.nanometers)

let speed = Measurement<UnitSpeed>(value: 80.0,
                                   unit: .kilometersPerHour)
let formatter = MeasurementFormatter()
formatter.string(from: speed)

formatter.numberFormatter.usesSignificantDigits = true
formatter.numberFormatter.maximumSignificantDigits = 3
formatter.string(from: speed)

formatter.unitOptions = [.providedUnit]
formatter.string(from: speed)
formatter.string(from: speed.converted(to: .knots))

formatter.unitOptions = [.providedUnit]
formatter.string(from: inFeet.converted(to: .miles))
formatter.unitOptions = [.naturalScale]
formatter.string(from: inFeet.converted(to: .miles))
// .temperatureWithoutUnit

formatter.unitStyle = .long
formatter.string(from: speed)
formatter.unitStyle = .medium
formatter.string(from: speed)
formatter.unitStyle = .short
formatter.string(from: speed)

formatter.unitStyle = .long
formatter.string(from: inFeet)
formatter.unitStyle = .medium
formatter.string(from: inFeet)
formatter.unitStyle = .short
formatter.string(from: inFeet)

