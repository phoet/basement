module WorkHelper
  def commits(repo_name)
    c = Helper::commits repo_name
    c.nil? ? [] : c.commits
  end
  
  def file_extension(file)
    extension = :"#{file[file.rindex('.') + 1, file.length]}"
    {
      :rb => :ruby,
      :txt => :ruby,
      :sh => :ruby,
    }[extension] || extension
  rescue
    :ruby
  end
end
