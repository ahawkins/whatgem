class RubyGem < ActiveRecord::Base
  has_and_belongs_to_many :related_gems, :class_name => 'RubyGem',
    :foreign_key => :parent_id, :association_foreign_key => :child_id,
    :join_table => :related_gems, :uniq => true,
    :finder_sql => 'SELECT * FROM ruby_gems INNER JOIN related_gems ON 
      (ruby_gems.id = related_gems.parent_id AND related_gems.child_id = #{id}) OR
      (ruby_gems.id = related_gems.child_id AND related_gems.parent_id = #{id})',
    :delete_sql => 'DELETE * FROM related_gems WHERE 
      parent_id = #{id} OR child_id = #{id}'

  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  belongs_to :user

  validates :name, :description, :github_url, :presence => true

  validates :name, :github_url, :uniqueness => true

  before_save :calculate_rating

  acts_as_taggable_on :tags

  default_scope order('rating desc')

  def self.per_page
    35
  end

  def self.named(name)
    where('LOWER(name) = ?', name.downcase).first
  end

  def self.from_repo(repo)
    new.from_repo(repo)
  end

  def self.create_from_gemcutter!(gemcutter)
    new.from_gemcutter(gemcutter).save!
  end

  def to_s
    name
  end

  def closed_issue_percentage
    self.number_of_closed_issues = 0 if number_of_closed_issues.blank?
    self.number_of_open_issues = 0 if number_of_open_issues.blank?

    if number_of_closed_issues + number_of_open_issues == 0
      1.0
    else
      (number_of_closed_issues.to_f / (number_of_closed_issues + number_of_open_issues).to_f)
    end
  end

  def merged_pull_request_percentage
    self.number_of_closed_pull_requests = 0 if number_of_closed_pull_requests.blank?
    self.number_of_open_pull_requests = 0 if number_of_open_pull_requests.blank?

    if number_of_closed_pull_requests + number_of_open_pull_requests == 0
      1.0
    else
      (number_of_closed_pull_requests.to_f / (number_of_closed_pull_requests + number_of_open_pull_requests).to_f)
    end
  end

  def has_documentation?
    documentation_url.present?
  end

  def from_repo(repo)
    self.github_url = repo.url
    self.user = User.find_or_create_by_name(repo.owner)

    self.number_of_closed_issues = repo.number_of_closed_issues
    self.number_of_open_issues = repo.number_of_open_issues

    self.number_of_open_pull_requests = repo.number_of_open_pull_requests
    self.number_of_closed_pull_requests = repo.number_of_closed_pull_requests

    self.has_readme = repo.has_readme?
    self.has_license = repo.has_license?
    self.has_tests = repo.has_tests?
    self.has_examples = repo.has_examples?
    self.has_features = repo.has_features?
    self
  end

  def from_gemcutter(gemcutter)
    self.from_repo(gemcutter.github_repo)
    self.documentation_url = gemcutter.documentation_url
    self.name = gemcutter.name
    self.description = gemcutter.info
    self
  end

  def up_vote_percentage
    if votes.count == 0
      1.0
    else
      (votes.up.count.to_f / votes.count.to_f)
    end
  end

  def rescore!
    save!
  end

  def calculate_rating
    base = 0

    base += 0.3 if has_tests?
    base += 0.2 if has_documentation?
    base += 0.1 if has_readme?
    base += 0.1 if has_features?
    base += 0.05 if has_examples?
    base += 0.05 if has_license?

    # 80% at this point
    # 5% for issues close rate
    # 5% for pull request rate
    # 10 remaning precent for votes

    base += (0.05 * closed_issue_percentage)
    base += (0.05 * merged_pull_request_percentage)

    # Assume the votes are at 75% approval for now
    base += (0.1 * up_vote_percentage)

    # Extreas
    base += (0.005 * comments.count)

    # Ensure gems with a boat load of extra
    # content don't overflow the rankings
    base = 1 if base > 1

    self.rating = base

    true
  end

  def to_param
    name
  end
end
