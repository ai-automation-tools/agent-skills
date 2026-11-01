---
name: religious-calendars
description: Use when converting dates between religious calendars and the Gregorian calendar, or when giving the date of a religious holiday, such as Easter (Western and Orthodox), Passover, Rosh Hashanah, Ramadan, Eid, Diwali, Vesak, Lunar New Year, Naw-Rúz or a saint's day. Explains how each calendar works (lunar, lunisolar, solar), why dates differ by community and country, era systems (AM, AH, BE, Vikram Samvat, Shaka), and which dates can't be computed ahead of time, so dates are given with their convention rather than one confident wrong day. Triggered by "when is", "what date", "convert to Hijri/Hebrew", "this year's Ramadan", "Orthodox Easter", "what year is it in the … calendar".
---

# Religious calendars

A religious date has three parts that often go unstated: **the calendar**, **the
convention** (whose computation or observation), and **the place** (days begin at sunset
in some calendars; sightings depend on location). State all three, or the date can be off
by a day, a month, or a year.

## The main systems

| Calendar | Type | Key facts |
|:---|:---|:---|
| **Gregorian / Julian** | Solar | The Julian calendar runs 13 days behind the Gregorian from 1900 to 2099. Many Orthodox churches keep the Julian calendar for fixed feasts (Christmas on 25 December Julian = 7 January Gregorian) |
| **Easter** | Computed (computus) | Western churches use the Gregorian computus; most Orthodox churches the Julian. The two Easters coincide in some years and otherwise differ by one or more weeks. Python's `dateutil.easter` implements both methods |
| **Hebrew** | Lunisolar | 19-year cycle with 7 leap years, each adding a month (Adar I). Days run sunset to sunset, so holidays begin the evening before the Gregorian date usually listed. Years counted *anno mundi* (AM). Fully computed, so it can be converted exactly |
| **Islamic (Hijri)** | Lunar | 12 lunar months, about 354 days, so it moves about 11 days earlier each Gregorian year. Era AH from 622 CE. Many communities start months by moon sighting, so Ramadan and Eid can differ by a day or two between countries; Saudi Arabia's Umm al-Qura calendar is computed. A conversion gives the expected date, not the observed one |
| **Hindu** | Lunisolar, regional | Lunar months with an intercalary month (*adhika māsa*); months reckoned from new moon (*amānta*, mostly south and west) or full moon (*pūrṇimānta*, mostly north). Festivals fall on a *tithi* (lunar day), which can make the same festival a day apart by region. Eras: Vikram Samvat (about 57 BCE), Shaka (78 CE; India's national calendar) |
| **Buddhist** | Lunisolar, regional | Vesak dates differ between Theravada countries and East Asian traditions. Thailand counts the Buddhist Era as CE + 543 |
| **Chinese** | Lunisolar | Lunar New Year falls between 21 January and 20 February |
| **Baháʼí (Badíʻ)** | Solar | 19 months of 19 days plus intercalary days; Naw-Rúz at the vernal equinox |
| **Zoroastrian** | Solar, several | Shahenshahi, Kadmi and Fasli calendars differ, so Parsi and Iranian communities can celebrate the same feast on different days |
| **Sikh** | Mixed, contested | The Nanakshahi calendar and its revisions are disputed between bodies; some gurpurabs follow the lunar calendar. Say which convention you use |

## How to answer a date question

1. **Identify the calendar and convention.** "Orthodox Easter" in which church; "Eid" in
   which country; "Diwali" by which regional calendar.
2. **Compute what can be computed** with a maintained library or the algorithm, and say
   so. For dates that depend on observation, give the expected date and say observation may
   move it.
3. **Prefer the community's own published calendar** for the current year (a national
   moon-sighting body, a church's calendar, a temple's panchang) and cite it with the date
   you checked.
4. **Mark sunset starts**: "begins at sundown on …".
5. **Convert years carefully**: there is no year 0 between 1 BCE and 1 CE; Hijri years
   are shorter, so AH and CE years don't map one to one.

## Pitfalls

- Copying a holiday date from one year into another for a lunar or lunisolar calendar.
- Giving one date for a festival observed on different days by different communities.
- Treating a computed Islamic date as certain.
- Mixing Julian and Gregorian dates for events before a country's switch (Britain 1752,
  Russia 1918, Greece 1923).
