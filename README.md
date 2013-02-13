# semantics3-ruby

semantics3-ruby is a Ruby client for accessing the Semantics3 Products API, which provides structured information, including pricing histories, for a large number of products.
See https://www.semantics3.com for more information.

Quickstart guide: https://www.semantics3.com/quickstart
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

### First Query aka 'Hello World':

Let's make our first query! For this query, we are going to search for all Toshiba products that fall under the category of "Computers and Accessories", whose cat_id is 4992. 

```ruby
# Build the query
sem3.products_field( "cat_id", 4992 )
sem3.products_field( "brand", "Toshiba" )

# Make the query
productsHash = sem3.get_products()

# View the results of the query
puts productsHash.to_json
```

## Examples

The following examples show you how to interface with some of the core functionality of the Semantics3 Products API. For more detailed examples check out the Quickstart guide: https://www.semantics3.com/quickstart

### Explore the Category Tree

In this example we are going to be accessing the categories endpoint. We are going to be specifically exploring the "Computers and Accessories" category, which has a cat_id of 4992. For more details regarding our category tree and associated cat_ids check out our API docs at https://www.semantics3.com/docs

```ruby
# Build the query
sem3.categories_field( "cat_id", 4992 )

# Make the query
categoriesHash = sem3.get_categories()

# View the results of the query
puts categoriesHash.to_json
```

### Nested Search Query

You can construct complex queries by just repeatedly calling the products_field() or add() methods. Here is how we translate the following JSON query - '{"cat_id":4992,"brand":"Toshiba","weight":{"gte":1000000,"lt":1500000},"sitedetails":{"name":"newegg.com","latestoffers":{"currency":"USD","price":{"gte":100}}}}'.

This query returns all Toshiba products within a certain weight range narrowed down to just those that retailed recently on newegg.com for >= USD 100.

```ruby
# Build the query
sem3.products_field( "cat_id", 4992 )
sem3.products_field( "brand", "Toshiba" )
sem3.products_field( "weight", "gte", 1000000 )
sem3.products_field( "weight", "lt", 1500000 )
sem3.products_field( "sitedetails", "name", "newegg.com" )
sem3.products_field( "sitedetails", "latestoffers", "currency", "USD" )
sem3.products_field( "sitedetails", "latestoffers", "price", "gte", 100 )

# Let's make a modification - say we no longer want the weight attribute
sem3.remove( "products", "brand", "weight" )

# Let's view the JSON query we just constructed. This is a good starting point to debug, if you are getting incorrect 
# results for your query
constructedJson = sem3.get_query_json( "products" )
puts constructedJson

# Make the query
productsHash = sem3.get_products

# View the results of the query
puts productsHash.to_json
```

### Pagination

Let's now look at doing pagination, continuing from where we stopped previously.

```ruby
# Goto the next 'page'
page = 0 
while (productsHash = sem3.iterate_products) do
    page = page + 1 
    puts "Iterating through page: #{page}"
end
```

### Explore Price Histories

We shall use the add() method, which allows you to access any of the supported endpoints by just specifiying the name of the endpoint. add( "products", param1, param2, ...) is the equivalent of products_field( param1, param2, ... ), add( "offers", param1, param2, ... ) is the equivalent of offers_field( param1, param2, ...)

For this example, we are going to look at a particular product that is sold by select mercgants and whose price is >= USD 30 and seen after a specific date (specified as a UNIX timestamp).

```ruby
# Build the query
sem3.add( "offers", "sem3_id", "4znupRCkN6w2Q4Ke4s6sUC")
sem3.add( "offers", "seller", ["ATRQ56T3H9TM5","LFleurs","Frys","Walmart"] )
sem3.add( "offers", "currency", "USD")
sem3.add( "offers", "price", "gte", 30)
sem3.add( "offers", "lastrecorded_at", "gte", 1348654600)

# Make the query
offersHash = sem3.get_offers
#Alternatively we could also do
offersHash = sem3.run_query( "offers" )

# View the results of the query
puts offersHash.to_json
```

## Contributing

Use GitHub's standard fork/commit/pull-request cycle.  If you have any questions, email <support@semantics3.com>.

## Author

* Sivamani VARUN <varun@semantics3.com>

## Copyright

Copyright (c) 2013 Semantics3 Inc.

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


