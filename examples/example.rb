#!/usr/bin/env ruby

require 'semantics3'
#
################################################################################
# Simple test script to showcase use of the semantics3 Ruby gem to interface
# with the Semantics3 Products API.
# 
# Quickstart guide: https://semantics3.com/quickstart
# API Documentation: https://semantics3.com/docs
#
# Author: Sivamani VARUN <varun@semantics3.com>
# Copyright (c) 2013 Semantics3 Inc.
#
# The MIT License from http://www.opensource.org/licenses/mit-license.php
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#################################################################################

API_KEY = 'YOUR_SEM3_API_KEY'
API_SECRET = 'YOU_SEM3_API_SECRET'
sem3 = Semantics3::Products.new(API_KEY,API_SECRET)

sem3.products_field( "cat_id", 4992 )
sem3.products_field( "brand", "Toshiba" )
sem3.products_field( "weight", "gte", 1000000 )
sem3.products_field( "weight", "lt", 1500000 )
sem3.products_field( "sitedetails", "name", "newegg.com" )
sem3.products_field( "sitedetails", "latestoffers", "currency", "USD" )
sem3.products_field( "sitedetails", "latestoffers", "price", "gte", 100 )

# Let's view the JSON query we just constructed. This is a good starting point to debug, if you are getting incorrect 
# results for your query
constructedJson = sem3.get_query_json( "products" )
puts constructedJson

# Make the query
productsHash = sem3.get_products

# Iterate throught the result of the pages
page = 0
while (productsHash = sem3.iterate_products) do
    page = page + 1
    puts "Iterating through page: #{page}"
end
