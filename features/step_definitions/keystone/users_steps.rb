Given(/^I have a tenant named 'openstack'$/) do
  @tenant = "openstack"  # in some kind of config
  @user = "test_user"    # this needs to be stored ...
  @tenants = control_node.get_result_column "keystone tenant-list", "name"
  @tenant_ids = control_node.get_result_column "keystone tenant-list", "id"
  @tenant_id = control_node.get_result_item "keystone tenant-list", "id", "name=openstack"
  @tenants.include? @tenant
end

Given(/^there is no user named 'test_user'$/) do
  @users = control_node.get_result_column "keystone user-list", "name"
  expect(@users).not_to include @user
end

When(/^I add a new user named 'test_user' to the tenant$/) do
  control_node.exec!("keystone user-create --tenant-id #{@tenant_id} --name #{@user} --pass XXXXXX --email tux@suse.de --enabled true")
end

Then(/^this new user is known by Keystone$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^this new user is member of that tenant$/) do
  pending # Write code here that turns the phrase above into concrete actions
end


Given(/^I have a keystone userid$/) do
  pending # Write code here that turns the phrase above into concrete actions
  control_node.exec!("")
end

When(/^I list all users known to Nova$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^my username is part of that list$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
