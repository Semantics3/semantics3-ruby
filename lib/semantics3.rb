# Ruby bindings for the Semantics3 APIs
# Quickstart: https://semantics3.com/quickstart
# Docs: https://semantics3.com/docs
#
# Author: Sivamani Varun (varun@semantics3.com)
# Copyright 2013 Semantics3 Inc., see LICENSE

require 'rubygems'
require 'oauth'
require 'uri'
require 'json'

module Semantics3
    @auth={}

    class Base
        def initialize(api_key,api_secret)
            @api_key = api_key
            @api_secret = api_secret

            raise Error.new('API Credentials Missing','You did not supply an api_key. Please sign up at https://semantics3.com/ to obtain your api_key.','api_key') if api_key == ''
            raise Error.new('API Credentials Missing','You did not supply an api_secret. Please sign up at https://semantics3.com/ to obtain your api_secret.','api_secret') if api_secret == ''

            consumer = OAuth::Consumer.new(@api_key, @api_secret)
            @auth = OAuth::AccessToken.new(consumer)
        end

        private

        #returns a value
        def _make_request(endpoint, params)
            url = 'https://api.semantics3.com/v1/' + endpoint + '?q=' + URI.escape(params)

            #puts "url = #{url}"
            response = @auth.get(url)

            #-- Response.code - TBD
            JSON.parse response.body
        end

    end

    class Products < Base

        def initialize api_key, api_secret
            super
            clear() 
        end

        MAX_LIMIT = 10

        #Offers

        def offers_field(*fields)
            add("offers",*fields)
        end

        def get_offers 
            run_query("offers")
        end

        #Categories
            
        def categories_field(*fields)
            add("categories",*fields)
        end
        
        def get_categories
            run_query("categories")
        end
        
        #Products
        
        def products_field(*fields)
            add("products",*fields)
        end
        
        def get_products
            run_query("products")
        end
        
        def all_products
            if not @query_result.has_key?(results)
                raise Error.new('Undefined Query','Query result is undefined. You need to run a query first.')
            end
            @query_result['results']  
        end

        def iterate_products
            limit = MAX_LIMIT
            prodRef = @data_query['products']

            if (not ( @query_result.has_key?('total_results_count') ) ) or ( @query_result['offset'] >= @query_result['total_results_count'] )
                return
            end 

            if prodRef.has_key?('limit')
                limit = prodRef['limit']
            end

            if not prodRef.has_key?('offset')
                prodRef['offset'] = limit
            else
                prodRef['offset'] = prodRef['offset'] + limit
            end

            get_products()
        end

        #General

        def add(endpoint,*fields)

            #-- If not defined endpoint, throw error
            if not ( endpoint.kind_of? String and endpoint != '')
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products','endpoint')
            end

            if not @data_query.has_key?(endpoint)
                @data_query[endpoint] = {}
            end

            prodRef = @data_query[endpoint]

            for i in 1..(fields.length - 1)
                if not prodRef.has_key?(fields[i-1])
                    prodRef[fields[i-1]] = {}
                end
                if i != (fields.length - 1)
                    prodRef = prodRef[fields[i-1]] 
                else
                    prodRef[ fields[i-1] ] = fields[i]
                end
            end

            #-- To be removed
            #puts @data_query.inspect

        end

        def remove(endpoint,*fields)

            #-- If not defined endpoint, throw error
            if not ( endpoint.kind_of? String and endpoint != '')
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products','endpoint')
            end

            valid = 0
            prodRef = {}
            arrayCt = 0

            if @data_query.has_key?(endpoint)
                prodRef = data_query[endpoint]
                arrayCt = fields.length-1
                valid = 1

                for i in 0..(arrayCt-1)
                    if prodRef.has_key?(fields[i])
                        prodRef = prodRef[ fields[i] ]
                        prodRef[ fields[i-1] ] = {}
                    else
                        valid = 0
                    end
                end
            end

            if valid == 1
                prodRef.delete(fields[arrayCt])
            else
                #-- Throw error
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products', 'endpoint')
            end
                
            #-- To be removed
            #puts @data_query.inspect

        end

        def get_query(endpoint)
            if not @data_query.has_key?(endpoint)
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products', 'endpoint')
            end
            @data_query[endpoint]
        end

        def get_query_json(endpoint)
            if not @data_query.has_key?(endpoint)
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products', 'endpoint')
            end
            @data_query[endpoint].to_json
        end

        def get_results
            @query_result
        end
        
        def get_results_json
            @query_result.to_json
        end

        def clear
            @data_query={}
            @query_result={}
        end

        def run_query(endpoint,*params)

            #-- If not defined endpoint, throw error
            if not ( endpoint.kind_of? String and endpoint != '')
                raise Error.new('Undefined Endpoint','Query Endpoint was not defined. You need to provide one. Eg: products','endpoint')
            end

            data = params[0]

            if data == nil
                @query_result = _make_request(endpoint,@data_query[endpoint].to_json)
            else
                if not data.is_a?(Hash) and not data.is_a?(String)
                    #-- Throw error - neither string nor hash
                    raise Error.new('Invalid Input','You submitted an invalid input. Input has to be either JSON string or hash')
                else
                    #-- Data is Hash ref. Great just send it.
                    if data.is_a?(Hash)
                        @query_result = _make_request(endpoint,data.to_json)
                    #-- Data is string
                    elsif data.is_a?(String)
                        #-- Check if it's valid JSON
                        if JSON.is_json?(data)
                            @query_result = _make_request(endpoint,data)
                        else
                            raise Error.new('Invalid Input','You submitted an invalid JSON query string')
                        end
                    end
                end
            end
            @query_result
        end

    end

    class Error < StandardError
        attr_reader :type
        attr_reader :message
        attr_reader :param

        def initialize(type=nil, message=nil, param=nil)
            @message = 'Error: ' + type + ' Message: ' + message
            @message += ' Failed at parameter: ' + param if not param.nil?
        end
    end

end

module JSON
    def self.is_json?(foo)
        begin
            return false unless foo.is_a?(String)
            JSON.parse(foo).all?
        rescue JSON::ParserError
            false
        end 
    end
end


