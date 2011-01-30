Given /^I login as "([^"]*)"$/ do |name|
  visit '/'

  data = {
      'user' => {
        :login => name
      }
    }

  Devise::OmniAuth.short_circuit_authorizers!
  Devise::OmniAuth.stub!(:github) do |b|
    b.post('/login/oauth/access_token') { [200, {}, ACCESS_TOKEN.to_json] }
    b.get('/api/v2/json/user/show?access_token=whatgem') { [200, {}, data.to_json] }
  end

  visit '/users/auth/github/callback'
end
