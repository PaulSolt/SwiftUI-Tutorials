# Localizations for iOS and iOS Widgets - SwiftUI

[![SwiftUI Localization](http://img.youtube.com/vi/1piGNwdx9mA/0.jpg)](http://www.youtube.com/watch?v=1piGNwdx9mA "SwiftUI Localization")

This demo project shows how to adapt a project for localizations.

You will learn how to use `String(localized:)` and the new String Catalog that updates on Build.

* Download RocketSim: https://www.rocketsim.app/

## Create a String Catalog

1. Add New File From Template > String Catalog
2. Add a new language: Spanish (US)
3. Go to "Spanish (United States)" and set "Hello, world!" to "¡Hola, mundo!"

English: "Hello, world!"
Spanish: "¡Hola, mundo!"

## Test translations quickly with RocketSim

We can quickly see the result of the language by using [RocketSim](https://www.rocketsim.app/). This feature works great for your iPhone app, but it doesn't work for iOS Widgets. This is because the iOS Widget is going to use the Simulator's language.

1. In RocketSim, Select the Command tab
2. Choose the Lightning Bolt icon
3. Tap on RELAUNCH WITH > Locale > Spanish the Language of the Simulator

## Change the Language of the Scheme

1. Edit Scheme (`Command + Shift + ,`)
2. Run > Options
3. Set "App Language" to a different language (Spanish)

## Change the Language of the Simulator

1. General > Settings > Language & Region > Spanish
2. Reorder languages to set the default (Top)

## Localize the Widget

We need ot use the `String(localized:)` methods to work with the String Catalog.

```swift
init(hours: Double) {
    let sleepDuration = Measurement(value: hours, unit: UnitDuration.hours)
        .formatted(.measurement(width: .narrow))
    let sleep = String(localized: "sleep.highlight", defaultValue: "sleep")
    let rest = String(localized: "rest.highlight", defaultValue: "rest")

    // Less than 6 hours
    let message = String(localized: "Less than \(sleepDuration) of \(sleep) today.")
    let motivation = String(localized: "Get some \(rest)!")
```

## Add the Localizations with Placeholders

When you have data calculations, the translations are more complex.

	English: Less than %@ of %@ today.
	Comment: Less than 4h of sleep today. Keep it short. The hours duration is localized programmatically as %1$@ and the word sleep is translated separately with %2$@. We highlight both placeholders.
	Spanish: Hoy %2$@ menos de %1$@ de sueño.
	
	English: Get some %@!
	Spanish: ¡Descansa, que necesitas %@!
	Comment: Get some sleep! - keep it short and motivational. We highlight the placeholder.
	
	English: rest.highlight
	Spanish: sueño
	Comment: A highlighted word (rest) from: "Get some rest!"
	
	English: sleep.highlight
	Spanish: dormiste A highlighted word (sleep) from: "Less than 4h of sleep today."
	Comment: A highlighted word (sleep) from: "Less than 4h of sleep today."

## Unique Strings

Sometimes you need unique strings. We did this at GoPro for all strings. Using periods can help you organize them. Comments are super helpful for translators.

Because we might not have a literal translation, it is a good idea to use a unique string to identify the string that needs to be localized.

    let sleep = String(localized: "sleep.highlight", defaultValue: "sleep")
    let rest = String(localized: "rest.highlight", defaultValue: "rest")

The defaultValue will be the default language that is set in your Project settings.

## How to Preview SwiftUI Widget Localizations

To quickly Preview two different languages, I use the following Preview macros. This does have a side effect of altering your preview language for other previews, so use this for testing and be aware it has side effects.

```swift
// Force Preview to use English
#Preview("English", as: .systemSmall) {
    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
    return SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}

// Force Preview to use Spanish
#Preview("Spanish", as: .systemSmall) {
    UserDefaults.standard.set(["es"], forKey: "AppleLanguages")
    return SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
```

At least you now have a way to quickly test a localization to see if the text can fit.

## Remove iOS Simulator Language Side Effects

To remove the language override on an iOS Simulator, you can set the "AppleLanguages" key to `nil`:

    UserDefaults.standard.set(nil, forKey: "AppleLanguages")
