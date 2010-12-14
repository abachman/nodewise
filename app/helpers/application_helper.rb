module ApplicationHelper
  def set_title title
    content_for :title do 
      title
    end
  end
end
