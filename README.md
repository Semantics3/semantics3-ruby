# semantics3-ruby

semantics3-ruby is a Ruby client for accessing the Semantics3 Products API, which provides structured information, including pricing histories, for a large number of products.
See https://www.semantics3.com for more information.

API documentation can be found at https://www.semantics3.com/docs/

## Installation

semantics3-ruby can be installed through the RubyGem system:
```
 gem install semantics3
```
To build and install from the latest source:
```
 git clone git@github.com:Semantics3/semantics3-ruby.git
 cd semantics3-ruby
 gem build semantics3.gemspec
 gem install semantics3-<VERSION>.gem
```

## Requirements

* json
* oauth

## Getting Started

In order to use the client, you must have both an API key and an API secret. To obtain your key and secret, you need to first create an account at
https://www.semantics3.com/
You can access your API access credentials from the user dashboard at https://www.semantics3.com/dashboard/applications

### Setup Work

Let's lay the groundwork.

```ruby
require 'semantics3'

# Your Semantics3 API Credentials
API_KEY = 'SEM3xxxxxxxxxxxxxxxxxxxxxx'
API_SECRET = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# Set up a client to talk to the Semantics3 API
sem3 = Semantics3::Products.new(API_KEY,API_SECRET)
```

### First Request aka 'Hello World':

Let's run our first request! We are going to run a simple search fo the word "iPhone" as follows:

```ruby
# Build the request
sem3.products_field( "search", "iphone" )

# Run the request
productsHash = sem3.get_products()

# View the results of the request
puts productsHash.to_json
```

## Sample Requests

The following requests show you how to interface with some of the core functionality of the Semantics3 Products API:

### Pagination

The example in our "Hello World" script returns the first 10 results. In this example, we'll scroll to subsequent pages, beyond our initial request:

```ruby
# Build the request
sem3.products_field( "search", "iphone" )

# Run the request
productsHash = sem3.get_products()

# View the results of the request
puts productsHash.to_json

# Goto the next 'page'
page = 0 
while (productsHash = sem3.iterate_products) do
    page = page + 1 
    puts "We are at page = #{page}"
    puts "The results for this page are:\n"
    puts productsHash.to_json
end
```

### UPC Query

Running a UPC/EAN/GTIN query is as simple as running a search query:

```ruby
# Build the request
sem3.products_field( "upc", "883974958450" )
sem3.products_field( "field", ["name","gtins"] )

# Run the request
productsHash = sem3.get_products()

# View the results of the request
puts productsHash.to_json
```

### URL Query

Get the picture? You can run URL queries as follows:

```ruby
sem3.products_field( "url", "http://www.walmart.com/ip/15833173" )
productsHash = sem3.get_products()
puts productsHash.to_json
```

### Price Filter

Filter by price using the "lt" (less than) tag:

```ruby
sem3.products_field( "search", "iphone" )
sem3.products_field( "price", "lt", 300 )
productsHash = sem3.get_products()
puts productsHash.to_json
```

### Category ID Query

To lookup details about a cat_id, run your request against the categories resource:

```ruby
# Build the request
sem3.products_field( "cat_id", 4992 )

# Run the request
productsHash = sem3.get_products()

# View the results of the request
puts productsHash.to_json
```

## Contributing

Use GitHub's standard fork/commit/pull-request cycle.  If you have any questions, email <support@semantics3.com>.

## Author

* Sivamani VARUN <varun@semantics3.com>

## Copyright

Copyright (c) 2015 Semantics3 Inc.

## License

    The "MIT" License
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.