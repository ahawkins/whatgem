module ControllerMacros
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def it_should_require_a_user_for(actions) 
      fixtures(:users)

      actions.each_pair do |verb, action|
        it "should process #{verb.upcase} #{action} if the user is signed in" do
          user = users(:Adman65)

          # stub methods that create costly http requests
          user.stub!(:build_gems_from_github_and_rubygems => [])

          sign_in user
          send(verb, action)
          response.should be_success
        end

        it "should not process #{verb.upcase} #{action} if the user is not signed in" do
          send(verb, action)
          response.should_not be_success
        end
      end
    end
  end
end
