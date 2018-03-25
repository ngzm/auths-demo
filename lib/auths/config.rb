module Auths
  # Laod auth config
  module Config
    def gconf
      @@gconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_google.yml')
        File.join(Rails.root, 'config/rp_config_google_demo.yml')
      )
    end

    def fconf
      @@fconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_facebook.yml')
        File.join(Rails.root, 'config/rp_config_facebook_demo.yml')
      )
    end

    def tconf
      @@tconf ||= YAML.load_file(
        # File.join(Rails.root, 'config/rp_config_twitter.yml')
        File.join(Rails.root, 'config/rp_config_twitter_demo.yml')
      )
    end
  end
end
