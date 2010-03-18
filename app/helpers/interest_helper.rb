module InterestHelper
  def file_size file_name
    File.size(file_name) / 1000
  end
end
