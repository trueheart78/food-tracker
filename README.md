# Food Tracker :hamburger:

Tracks food.

## Features

Each item supports multiple:

* Brands
* Expiration dates
* "Best by" dates
* Custom Locations

## Development

### Running the Server Locally

It is designed to be run with `Shotgun`, to enable code reloading
without having to restart the server.

```
bundle exec shotgun
```

You can also run it via basic Ruby.

```
bundle exec ruby food_tracker.rb
```

### Data Files

Each data file supports the use of the following notations (even multiple times per entry):

* Square brackets to denote expiration dates: `[4/30//9]`.
* Bars to denote "best by" dates: `|4/30/29|`.
* Curly braces to denote brands: `{Reeses's}`.
* Parentheses to denote custom location: `(freezer)`.

**Note:** For each entry, spacing between the notations does not matter, neither does the order.

### Locations

Default locations are defined in the `meta_data.json` file.

### Updating the Meta Data

When new files or types are desired, you'll need to edit `meta_data_generator.rb` directly,
and then run `./meta_data_generator.rb` from the root directory.

Make sure to commit and push the changes.

## Roadmap

1. ~~Data entry.~~
1. Create a file auditor to verify entries are valid, especially with the denomiators.
   * Will require tests.
1. Create an endpoint that displays the data plainly.
   * Consider caching via Redis, based on performance.
   * If caching, create a custom endpoint that is called when no cache is found. It can redirect to the root endpoint when complete.
1. Finish the `meta_data_generator.rb`
