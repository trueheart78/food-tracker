# Food Tracker :hamburger:

Tracks food.

## Features

Each item supports multiple:

* Brands
* Expiration dates
* "Best by" dates
* Custom Locations

Items also support a single "out of stock" flag.

## Endpoints

* Index: `/`
  * Just a landing page, so as to not give site traversal to those that are unaware.
* Kitchen: `/in-the-kitchen`
  * Displays items in stock.
* Expiring: `/expiring`
  * Displays items expiring soon, already expired, and where the "best buy" date has passed.
* Out of stock: `/out-of-stock`
  * Displays items that are out of stock.
* Environment: `/env`, `/environment`
  * Displays all environment variables available.
  * **Note:** Only available in the `development` environment.

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

#### Notations

Each data file supports the use of the following notations (even multiple times per entry):

* Square brackets to denote expiration dates: `[4/30/29]`.
* Bars to denote "best by" dates: `|4/30/29|`.
* Curly braces to denote brands: `{Reeses's}`.
* Parentheses to denote custom location: `(freezer)`.

**Note:** For each entry, spacing between the notations does not matter, neither does the order.

##### Out of Stock

The only limited notation is for the "out of stock" marker, which is denoted by `^oos^`. These are items that are generally available, so a re-order is required. These items will not show up on any page except the Out of Stock endpoint.

### Locations

Default locations are defined YAML files in the `data/` directory.

## Default Environment File (.env)

Create a copy of the `.env` file, and then make sure to update it with relevant details:

```sh
cp .env .env.local
vim .env.local
```

Load order for `.env` files are as follows:

1. `.env.RACK_ENV`, where `RACK_ENV` is `test` or `development`
2. `.env.local`
3. `.env`

You can setup a `.env.local` for data that is general, and put specifics in the
`RACK_ENV` versions.
