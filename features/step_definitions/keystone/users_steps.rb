Given(/^I have a tenant named 'openstack'$/) do
  @tenant = config["tenant_name"]
  @tenants = control_node.get_result_column "keystone tenant-list", "name"
  @role_id = control_node.get_result_item "keystone role-list", "id", "name=Member"
  expect(@tenants).to include @tenant
end

Given(/^I can delete a user named 'test_user'$/) do
  @user_name = config["user_name"]
  @user_id = control_node.get_result_item "keystone user-list", "id", "name=#{@user_name}"
  if @user_id
    control_node.exec!("keystone user-delete #{@user_name}")
  end
  @users = control_node.get_result_column "keystone user-list", "name"
  expect(@users).not_to include @user_name
end

Then(/^I can create a new user named 'test_user'$/) do
  @user_name = config["user_name"]
  @user_id = control_node.get_result_item "keystone user-list", "id", "name=#{@user_name}"
  if not @user_id
    @tenant_id = control_node.get_result_item "keystone tenant-list", "id", "name=openstack"
    control_node.exec!("keystone user-create --tenant-id #{@tenant_id} --name #{@user_name} --pass $OS_PASSWORD --email tux@suse.de --enabled true")
    @user_id = control_node.get_result_item "keystone user-list", "id", "name=#{@user_name}"
    control_node.exec!("keystone user-role-add --user-id #{@user_id} --role-id #{@role_id} --tenant-id #{@tenant_id}")
  end
  @users = control_node.get_result_column "keystone user-list", "name"
  expect(@users).to include @user_name
end


Given(/^I have a test_user$/) do
  step "I can create a new user named 'test_user'"
end

Then(/^I can ask Nova for information about the test_user$/) do
  @user_name = config["user_name"]
  control_node.exec!("nova --os_username #{@user_name} list")
  step "I can delete a user named 'test_user'"
end
