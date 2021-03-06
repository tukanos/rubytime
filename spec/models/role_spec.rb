require 'spec_helper'

describe Role do

  describe "can_manage_financial_data attribute" do
    it "should have default value false" do
      Role.new.can_manage_financial_data.should be_false
    end
  end

  describe ":name attribute writer" do
    context "for new records" do
      before { @role = Role.generate(:name => 'Original Name') }

      it "should normally assign values" do
        @role.name.should == 'Original Name'
      end
    end

    context "for existing records" do
      before { @role = Role.generate(:name => 'Original Name') }

      it "should raise Exception" do
        block_should(raise_error(Exception)) { @role.name = 'New Name' }
      end

      context "when assigning unchanged value" do
        it "should not raise any Exception" do
          block_should_not(raise_error(Exception)) { @role.name = 'Original Name' }
        end
      end
    end
  end

end
