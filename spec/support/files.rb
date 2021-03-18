# frozen_string_literal: true

module Support
  module Files
    def fixture_dir
      File.join Dir.getwd, 'spec', 'fixtures'
    end

    def fixture_path(file)
      File.join fixture_dir, file
    end
  end
end
