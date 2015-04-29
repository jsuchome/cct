Given(/^Glance is prepared for testing and KVM source image exists$/) do

  # set the glance_flags (TODO move to background?)
  @flags        = "" # TODO set --insecure if needed (current tests ignore it)
  @image_name   = "jeos1"
  @properties   = "--property hypervisor_type=kvm"

  @image_source = "--copy-from http://clouddata.cloud.suse.de/images/jeos-64.qcow2"
  @image_source = "--file /root/jeos-64.qcow2" # FIXME for local testing only...

  # TODO check if jeos image is available

  control_node.exec!("curl --output /dev/null --silent --head --fail http://clouddata.cloud.suse.de/images/jeos-64.qcow2")

  # FIXME it must be reachable from controller
  # url_status    = Faraday.head("http://clouddata.cloud.suse.de/images/jeos-64.qcow2").status
  # expect(url_status).to match(200)

end

Given(/^Glance is prepared for testing and XEN HVM source image exists$/) do

  @flags        = ""
  @image_name   = "jeos2"
  @properties   = "--property hypervisor_type=xen --property vm_mode=hvm"
  @image_source = "--copy-from http://clouddata.cloud.suse.de/images/jeos-64-hvm.qcow2"
  @image_source = "--file /root/jeos-64-hvm.qcow2"

  # TODO check if jeos image is available

end

Given(/^Glance is prepared for testing and XEN PV source image exists$/) do

  @flags        = ""
  @image_name   = "jeos2"
  @properties   = "--property hypervisor_type=xen --property vm_mode=xen"
  @image_source = "--copy-from http://clouddata.cloud.suse.de/images/jeos-64-pv.qcow2"
  @image_source = "--file /root/jeos-64-pv.qcow2"

  # TODO check if jeos image is available

end

Given(/^glance image does not exist$/) do
  images = control_node.get_result_column "glance #{@flags} image-list 2>/dev/null", "Name"
  expect(images).not_to include @image_name
end

When(/^I create new glance image based on jeos1$/) do
  control_node.exec!("glance #{@flags} image-create #{@properties} --name=#{@image_name} --is-public=True --container-format=bare --disk-format=qcow2 #{@image_source}")
end

Then(/^the image is listed as active$/) do
  # in original tests we were waiting for some time before the image turned active...
  statuses = control_node.get_result_column "glance #{@flags} image-list --name #{@image_name} 2>/dev/null", "Status"
  expect(statuses).to include "active"
end

Then(/^this image has non-empty ID$/) do
  @image_id = control_node.get_result_item "glance #{@flags} image-list 2>/dev/null", "ID", "Name=#{@image_name}"
  expect(@image_id).not_to be_empty
end

Then(/^its ID can be used to show the image info$/) do
  control_node.exec!("glance #{@flags} image-show #{@image_id}")
end

When(/^I delete the image$/) do
  control_node.exec!("glance #{@flags} image-delete #{@image_id}")
end

Then(/^it is no longer listed$/) do
  images = control_node.get_result_column "glance #{@flags} image-list 2>/dev/null", "Name"
  expect(images).not_to include @image_name
end
