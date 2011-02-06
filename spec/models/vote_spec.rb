require 'spec_helper'

describe Vote do
  it { should belong_to(:user) }
  it { should belong_to(:ruby_gem, :touch => true) }

  # FIXME: Problem with remakable_activerecord ?
  # it { should have_scope(:up).where(:up => true) }
  # it { should have_scope(:down).where(:up => false) }
end
