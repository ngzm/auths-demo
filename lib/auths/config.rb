module Auths
  # Laod auth config
  module Config
    def gconf
      @@gconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_google.yml')
        File.join(Rails.root, 'config/rp_config_google_test.yml')
      )
    end

    def fconf
      @@fconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_facebook.yml')
        File.join(Rails.root, 'config/rp_config_facebook_test.yml')
      )
    end

    def tconf
      @@tconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_twitter.yml')
        File.join(Rails.root, 'config/rp_config_twitter_test.yml')
      )
    end
  end
end
