module Auths
  # Laod auth config
  module Config
    def gconf
      @@gconf ||= YAML.safe_load(
        ERB.new(
          File.read(
            File.join(Rails.root, 'config/rp_config_google.yml')
          )
        ).result
      )
    end

    def fconf
      @@fconf ||= YAML.safe_load(
        ERB.new(
          File.read(
            File.join(Rails.root, 'config/rp_config_facebook.yml')
          )
        ).result
      )
    end

    def tconf
      @@tconf ||= YAML.safe_load(
        ERB.new(
          File.read(
            File.join(Rails.root, 'config/rp_config_twitter.yml')
          )
        ).result
      )
    end
  end
end
