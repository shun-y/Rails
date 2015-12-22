require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
        @other_user = users(:archer)
        Rails.application.routes.default_url_options[:host]= 'localhost:3000'
    end

    test "unsuccessful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        assert_template 'users/edit'
        patch user_path(@user), user: { name:  "",
                                        email: "foo@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" }
        assert_template 'users/edit'
    end

    test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        name  = "Foo Bar"
        email = "foo@bar.com"
        patch user_path(@user), user: { name:  name,
                                        email: email,
                                        password:              "",
                                        password_confirmation: "" }
        assert_not flash.empty?
        assert_redirected_to @user
        @user.reload
        assert_equal name,  @user.name
        assert_equal email, @user.email
        log_in_as(@user)
    end

    test "should get new" do
        get new_user_path
        assert_response :success
    end

    test "should redirect edit when not logged in" do
        get edit_user_path(@user) 
        assert_not flash.empty?
        assert_redirected_to login_url
    end

    test "should redirect update when not logged in" do
        patch user_path(@user), user: { name: @user.name, email: @user.email }
        assert_not flash.empty?
        assert_redirected_to login_url
    end

    test "should redirect edit when logged in as wrong user" do
        log_in_as(@other_user)
        get edit_user_path(@user)
        assert flash.empty?
        assert_redirected_to root_url
    end

    test "should redirect update when logged in as wrong user" do
        log_in_as(@other_user)
        patch user_path(@user), user: { name: @user.name, email: @user.email }
        assert flash.empty?
        assert_redirected_to root_url
    end
end