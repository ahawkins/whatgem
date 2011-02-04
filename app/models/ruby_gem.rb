class RubyGem < ActiveRecord::Base
  belongs_to :user

  validates :name, :description, :github_url, :presence => true

  validates :name, :github_url, :uniqueness => true

  before_save :calculate_rating

  acts_as_taggable_on :tags

  default_scope order('rating desc')

  def self.from_repo(repo)
    new.from_repo(repo)
  end

  def to_s
    name
  end

  def closed_issue_percentage
    self.number_of_closed_issues ||= 0
    self.number_of_open_issues ||= 0

    if number_of_closed_issues + number_of_open_issues == 0
      100
    else
      (number_of_closed_issues.to_f / (number_of_closed_issues + number_of_open_issues).to_f) * 100
    end
  end

  def merged_pull_request_percentage
    self.number_of_closed_pull_requests ||= 0
    self.number_of_open_pull_requests ||= 0

    if number_of_closed_pull_requests + number_of_open_pull_requests == 0
      100
    else
      (number_of_closed_pull_requests.to_f / (number_of_closed_pull_requests + number_of_open_pull_requests).to_f) * 100
    end
  end

  def has_documentation?
    documentation_url.present?
  end

  def related_gems
    RubyGem.where('name LIKE ? AND id != ?', "%#{name}%", id)
  end

  def from_repo(repo)
    self.name = repo.name
    self.description = repo.description
    self.github_url = repo.url

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

  private
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

    base += (0.05 * (closed_issue_percentage / 100))
    base += (0.05 * (merged_pull_request_percentage / 100))

    # Assume the votes are at 75% approval for now
    base += (0.1 * 0.75)

    self.rating = base * 100
  end
end
