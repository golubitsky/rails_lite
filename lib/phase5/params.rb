require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
        @req = req
        @params = route_params
        p @params
        parse_www_encoded_form(@req.query_string) unless @req.query_string.nil?
        parse_www_encoded_form(@req.body) unless @req.body.nil?
    end

    def [](key)
        @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
        parsed_url = URI.decode_www_form(www_encoded_form)
        parsed_url.each do |(key, value)|
            key_array = parse_key(key)
            parametarize(key_array, value)
        end
    end

    def parametarize(key_array, value)
        current_node = @params
        key_array.each_with_index do |key, idx|
            if idx == key_array.length - 1
                current_node[key] = value
            else
                current_node[key] ||= {}
                current_node = current_node[key]
            end
        end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
        key.split(/\]\[|\[|\]/).flatten
    end

    #previous attempt at solution

    # def generate_nested_hash(nested_keys)
    #     inner_hash = { nested_keys[-2] => nested_keys[-1] }
    #     return inner_hash if nested_keys.size == 2
    #     i = nested_keys.length - 3
    #     result = {}
    #     while i >= 0
    #         result = { nested_keys[i] => inner_hash }
    #         inner_hash = result
    #         i -= 1
    #     end
    #     p result
    #     result
    # end

    # def read_query_string
    #   regex = /[\?&](([\w]+)=([\w]+))*/
    #   regex_results = @req.query_string.scan(regex)
    #   # p regex_results
    #   regex_results.each do |match, key, value|
    #     @params[key] = value
    #   end
    # end
  end
end
