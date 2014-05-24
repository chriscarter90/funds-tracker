module TagsHelper

  def tag_with_link(tag, link_target)
    link_to link_target, class: 'tag' do
      content_tag :span, tag.name, class: 'label label-info'
    end
  end

  def tag_without_link(tag)
    content_tag :span, tag.name, class: 'label label-info'
  end

end
