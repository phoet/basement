module WorkHelper
  def commits(repo_name)
    c = Helper::commits repo_name
    c.nil? ? [] : c.commits
  end
end
