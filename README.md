# Food Tracker :hamburger:

Tracks food.

## Running the Server

It is designed to be run with `Shotgun`, to enable code reloading
without having to restart the server.

```
bundle exec shotgun
```

You can also run it via basic Ruby.

```
bundle exec ruby food_tracker.rb
```

## Data Files

Each data file should use square brackets to denote expiration date,
and parentheses to denote location (if not in the default location, defined in the `meta_data.json` file).

## Updating the Meta Data

When new files or types are desired, you'll need to edit `meta_data_generator.rb` directly,
and then run `./meta_data_generator.rb` from the root directory.

Make sure to commit and push the changes.
