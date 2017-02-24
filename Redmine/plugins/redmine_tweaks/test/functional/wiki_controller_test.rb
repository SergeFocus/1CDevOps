# Redmine Tweaks plugin for Redmine
# Copyright (C) 2013-2016 AlphaNodes GmbH

require File.expand_path('../../test_helper', __FILE__)

# Redmine Tweaks functional tests
class WikiControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :issue_statuses,
           :issues,
           :enumerations,
           :custom_fields,
           :custom_values,
           :custom_fields_trackers,
           :wikis

  def setup
    RedmineTweaks::TestCase.prepare
    EnabledModule.create(project_id: 1, name: 'wiki')
    @project = Project.find(1)
    @wiki = @project.wiki
    @page_name = 'tweaks_macro_test'
    @page = @wiki.find_or_new_page(@page_name)
    @page.content = WikiContent.new
    @page.content.text = 'test'
    @page.save!
  end

  def test_show_with_youtube_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{youtube(KMU0tzLwhbE)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'iframe[src=?]', '//www.youtube-nocookie.com/embed/KMU0tzLwhbE'
  end

  def test_show_with_vimeo_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{vimeo(142849533)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'iframe[src=?]', '//player.vimeo.com/video/142849533'
  end

  def test_show_with_slideshare_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{slideshare(57941706)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'iframe[src=?]', '//www.slideshare.net/slideshow/embed_code/57941706'
  end

  def test_show_with_twitter_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{twitter(alphanodes)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a.twitter'
    assert_select 'a[href=?]', 'https://twitter.com/alphanodes',
                  text: '@alphanodes'
  end

  def test_show_last_updated_by_marco
    @request.session[:user_id] = 1
    @page.content.text = '{{last_updated_by}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'span.last-updated-by'
    assert_select 'a[href=?]', '/users/1',
                  text: 'admin'
  end

  def test_show_last_updated_at_marco
    @request.session[:user_id] = 1
    @page.content.text = '{{last_updated_at}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'span.last-updated-at'
    assert_select 'a[href=?]', '/projects/ecookbook/activity'
  end

  def test_show_recently_updated_marco
    @request.session[:user_id] = 1
    @page.content.text = '{{recently_updated}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.recently-updated'
  end

  def test_show_calendar_marco
    @request.session[:user_id] = 1
    @page.content.text = '{{calendar(year=1970, month=7)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.month-calendar'
  end

  def test_show_with_members_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{members}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki div.user'
  end

  def test_show_with_projects_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{projects}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki div.projects li.project'
  end

  def test_show_with_gist_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{gist(plentz/6737338)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'script[src=?]', 'https://gist.github.com/plentz/6737338.js'
  end

  def test_show_with_weeknumber_macro
    @request.session[:user_id] = 1
    @page.content.text = '{{current_weeknumber}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki span.current-date', Time.zone.today.cweek.to_s
  end

  def test_show_issue
    @request.session[:user_id] = 1
    @page.content.text = '{{issue(2, format=short)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a[href=?]', '/issues/2',
                  text: 'Add ingredients categories'
  end

  def test_show_issue_with_id
    @request.session[:user_id] = 1
    @page.content.text = '{{issue(2, format=link)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a[href=?]', '/issues/2',
                  text: 'Add ingredients categories #2'
  end

  def test_show_issue_with_id_default
    @request.session[:user_id] = 1
    @page.content.text = '{{issue(2)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a[href=?]', '/issues/2',
                  text: 'Add ingredients categories #2'
  end

  def test_show_user_with_id
    @request.session[:user_id] = 1
    @page.content.text = '{{user(1)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a[href=?]', '/users/1',
                  text: 'admin'
  end

  def test_show_user_with_id_fullname
    @request.session[:user_id] = 1
    @page.content.text = '{{user(1, format=firstname_lastname)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a.user', text: 'Redmine Admin'
    assert_select 'a[href=?]', '/users/1',
                  text: 'Redmine Admin'
  end

  def test_show_user_with_name
    @request.session[:user_id] = 2
    @page.content.text = '{{user(jsmith)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a[href=?]', '/users/2',
                  text: 'jsmith'
  end

  def test_show_user_with_name_fullname
    @request.session[:user_id] = 2
    @page.content.text = '{{user(jsmith, format=firstname_lastname, avatar=true)}}'
    @page.content.save!
    get :show, project_id: 1, id: @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'a.user', text: 'John Smith'
    assert_select 'a[href=?]', '/users/2',
                  text: 'John Smith'
  end
end
