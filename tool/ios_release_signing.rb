# Signs the Runner app's Release build manually for App Store distribution
# (Release workflow, docs/STORE.md). Only the Runner target: the pods keep
# their own settings.
#
#   gem install xcodeproj
#   ruby tool/ios_release_signing.rb TEAM_ID "Profile name"
require 'xcodeproj'

team, profile = ARGV
abort 'usage: ios_release_signing.rb TEAM_ID PROFILE_NAME' unless team && profile

project = Xcodeproj::Project.open('ios/Runner.xcodeproj')
runner = project.targets.find { |target| target.name == 'Runner' }
release = runner.build_configurations.find { |config| config.name == 'Release' }
release.build_settings.merge!(
  'CODE_SIGN_STYLE' => 'Manual',
  'DEVELOPMENT_TEAM' => team,
  'CODE_SIGN_IDENTITY' => 'Apple Distribution',
  'PROVISIONING_PROFILE_SPECIFIER' => profile
)
project.save
