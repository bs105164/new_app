require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end 
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end 
  describe "when password is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end 
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foor.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be invalid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not  == user_for_invalid_password  }
      specify { user_for_invalid_password.should be_false }
    end
    describe "with too short password" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  end
end
  
 
describe "Static Pages" do
  subject { page }
  

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) } 
  end

  describe "Home page" do
      before { visit root_path }
      let (:heading) {'Example App'}
      let (:page_title) {''}
      it_should_behave_like "all static pages"
      it { page.should_not have_selector('title',  :text => "| Home")}
  end
  describe "Help page" do
    before { visit help_path }
    let (:heading) { 'Help' }
    let(:page_title) { "Help" }
    it_should_behave_like "all static pages"
  end
  describe "About page" do
    before { visit about_path }
    let (:heading) { 'About' }
    let (:page_title) { "About" }
    it_should_behave_like "all static pages"
  end
  describe "Contact page" do
    before { visit contact_path }
    let (:heading) { 'Contact' }
    let (:page_title) { "Contact" }
    it_should_behave_like "all static pages"
  end
end
