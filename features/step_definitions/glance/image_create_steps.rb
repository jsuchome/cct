Given(/^Glance is prepared for testing and testing image exists$/) do

  # set the glance_flags, check for jeoes image
  # FIXME test multiple hv types
  @flags        = ""
  @image_name   = "jeos1"

end

When(/^I create new glance image based on jeos1$/) do
  # if image already exists, skip creating
  @images = control_node.get_result_column "glance #{@flags} image-list 2>/dev/null", "Name"
  if @images.include? @image_name
    pending
  end
#  control_node.exec!("glance image create ...")
end

Then(/^the image is listed as active$/) do
  pending
end

Then(/^this image can be shown by its ID$/) do
  pending
end
