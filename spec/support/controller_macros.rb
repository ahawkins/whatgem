module ControllerMacros
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def it_should_require_a_user_for(actions) 
      fixtures :users

      actions.each_pair do |verb, action|
        it "should process #{verb.upcase} #{action} if the user is signed in" do
          sign_in users(:Adman65)
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
