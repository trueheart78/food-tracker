Use `.scan().flatten`. An empty array means no matches.

- Expiration dates: `%r{(\[\d+\/\d+\/\d+\])}`
- Best Buy Dates: `%r{(\|\d+\/\d+\/\d+\|)}`
- Locations: `%r{(\(fridge\)|\(freezer\)|\(cupboard\)|\(counter\)|\(pantry\)|\(candy dish\))}`
- Brands: `/(?<=\{)[^}]+(?=\})/` does something....
- Sample string: `{butts} English Muffins [3/10/21] |3/23/21| {Thomas’} (fridge)  |3/10/21| (cupboard) (candy dish) {Eatons Wantons}`

See:

- https://www.google.com/search?q=regex+match+EVERYTHING+between+braces
- https://superuser.com/questions/629817/what-is-the-shortcut-to-select-everything-between-curly-braces-in-notepad

