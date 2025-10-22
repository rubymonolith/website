class GemsController < ApplicationController
  before_action do
    @gem = JSON.parse HTTP.get("https://rubygems.org/api/v1/gems/#{params[:id]}.json")
  end

  def homepage      = redirect_to_gem "homepage_uri"
  def documentation = redirect_to_gem "documentation_uri"
  def changes       = redirect_to_gem "changelog_uri"
  def versions      = redirect_to_gem "version_downloads_uri"
  def source_code   = redirect_to_gem "source_code_uri"
  def bug_tracker   = redirect_to_gem "bug_tracker_uri"
  def mailing_list  = redirect_to_gem "mailing_list_uri"
  def wiki          = redirect_to_gem "wiki_uri"
  def funding       = redirect_to_gem "funding_uri"
  def project       = redirect_to_gem "project_uri"
  def gem           = redirect_to_gem "gem_uri"

  alias :show :homepage

  protected

  def redirect_to_gem *keys
    redirect_to @gem.dig(*keys), allow_other_host: true
  end
end
