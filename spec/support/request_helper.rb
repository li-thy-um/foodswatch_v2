module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def post_json(url, params)
      post url, params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    end

    def expect_fail
      expect(response).to be_success
      expect(json['success']).to be_false
    end

    def expect_success
      expect(response).to be_success
      expect(json['success']).to be_true
    end

    def expect_same(hash, record)
      hash.each_pair { |k, v| expect(v).to eq(record[k]) }
    end
  end
end
