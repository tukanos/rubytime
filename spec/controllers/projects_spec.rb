require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Projects do
  before(:each) { prepare_users; Project.all.destroy! }
  
  # all actions
  
  it "shouldn't show any action for guest, employee and client's user" do
    [:index, :new, :create, :edit, :update, :destroy].each do |action|
      dispatch_to_as_guest(Projects, action).should redirect_to(url(:login))
      lambda { dispatch_to_as_employee(Projects, action)}.should raise_forbidden
      lambda { dispatch_to_as_client(Projects, action)}.should raise_forbidden
    end
  end

  # index

  it "should show index for admin" do
    controller = dispatch_to_as_admin(Projects, :index)
    controller.should be_successful
  end

  # new
  
  it "should show new project form" do
    dispatch_to_as_admin(Projects, :new).should be_successful
  end

  # create
  
  it "should create new record successfully and redirect to index" do
    proc do
      controller = dispatch_to_as_admin(Projects, :create, { 
        :project => { 
          :name => "Jola", 
          :description => "Jolanta", 
          :client_id => @client.id 
        }
      })
      controller.should redirect_to(url(:projects))
    end.should change(Project, :count)
  end

  it "should should not create record and show errors when invalid data" do
    controller = dispatch_to_as_admin(Projects, :create, { :project => { :name => "Jola" } })
    controller.should be_successful
    controller.should_not redirect_to(url(:projects))
  end
 
  # edit
  
  it "should show edit project form" do
    project = Project.gen
    Project.should_receive(:get).with(project.id.to_s).and_return(project)
    dispatch_to_as_admin(Projects, :edit, :id => project.id).should be_successful
  end

  it "shouldn't show edit project form nonexistent project" do
    lambda { dispatch_to_as_admin(Projects, :edit, :id => 12345678)}.should raise_not_found
  end
  
  # update

  it "should update record successfully and redirect to index" do
    project = Project.gen
    controller = dispatch_to_as_admin(Projects, :update, { 
      :id => project.id , 
      :project => { 
        :name => "Misio", 
        :description => "Misiaczek", 
        :client_id => @client.id 
      }
    })
    controller.should redirect_to(url(:projects))
    project.reload
    project.name.should == "Misio"
    project.description.should == "Misiaczek"
    project.client.should == @client
  end

  it "should not update record and show errors" do
    project = Project.gen
    controller = dispatch_to_as_admin(Projects, :update, { :id => project.id , :project => { :name => "" } })
    controller.should be_successful
    controller.should_not redirect_to(url(:projects))
  end
  
  it "shouldn't update nonexistent project" do
    lambda { dispatch_to_as_admin(Projects, :update, :id => 12345678, :project => {})}.should raise_not_found
  end
  
  # destroy
  
  it "shouldn't delete nonexistent project" do
    lambda { dispatch_to_as_admin(Projects, :destroy, :id => 12345678)}.should raise_not_found
  end

  # TODO
end