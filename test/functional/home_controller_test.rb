require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HomeControllerTest < ActionController::TestCase
  context "HomeController index page with some shows" do
    setup do
      @family_guy = Factory(:show, :name => "Family Guy")
      @the_simpsons = Factory(:show, :name => "Simpsons")
      @west_wing = Factory(:show, :name => "West Wing")

      Factory(:episode, :created_at => 1.year.ago)
      Factory(:episode, :show => @the_simpsons, :created_at => 1.hour.ago)
      Factory(:episode, :show => @family_guy, :created_at => 1.day.ago)
      Factory(:episode, :show => @west_wing, :created_at => 8.days.ago)
      Factory(:episode, :created_at => 1.year.ago)
    end

    static_context "and nothing else" do
      static_setup do
        get :index
      end

      should_respond_with :success

      should "list The Simpsons as the most recently updated show" do
        assert_equal @the_simpsons, assigns(:fresh_episodes).first
      end

      should "list Family Guy as the second most recently updated show" do
        assert_equal @family_guy, assigns(:fresh_episodes).second
      end

      should "not show West Wing in the list of fresh episodes" do
        assert !assigns(:fresh_episodes).include?(@west_wing)
      end

      should_render_with_layout "master"
    end

    static_context "and we have seen all the simpsons episodes" do
      static_setup do
        @the_simpsons.episodes.each(&:seen!)
        get :index
      end

      should_respond_with :success

      should "not list The Simpsons in the most recently updated shows" do
        assert !assigns(:fresh_episodes).include?(@the_simpsons)
      end
    end

    static_context "and a new episode of the west wing has been found" do
      static_setup do
        Factory(:episode, :show => @west_wing)
        get :index
      end

      should_respond_with :success

      should "list The West Wing as the most recently updated show" do
        assert_equal @west_wing, assigns(:fresh_episodes).first
      end

      should "have relegated The Simpsons to number 2 spot" do
        assert_equal @the_simpsons, assigns(:fresh_episodes).second
      end
    end
  end
end
