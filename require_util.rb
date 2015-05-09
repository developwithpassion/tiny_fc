module Require
  ROOT_DIR = File.expand_path(File.dirname(__FILE__))

  def self.all_files
    @all_files ||= RequireUtil.new(ROOT_DIR, [/.*/])    
  end

  def self.non_spec_files
    @non_spec_files ||= RequireUtil.new(ROOT_DIR, [ ->(file) {
      /spec.rb/ !~ file
    }])    
  end

  def self.only_specs
    @only_specs ||= RequireUtil.new(ROOT_DIR, [/spec.rb/])    
  end

  class RequireUtil
    include Initializer

    initializer :root_folder,
      :inclusion_patterns_or_blocks

    def inclusions
      @inclusions ||= inclusion_patterns_or_blocks.map do |pattern_or_block|
        pattern_or_block.is_a?(Regexp) ? -> (element) { pattern_or_block =~ element } : pattern_or_block
      end
    end

    def in(folder, pattern="**/*.rb")
      pattern = File.join(root_folder, folder, pattern)

      Dir.glob(pattern).each do |file|
        should_require = inclusions.any? do |inclusion|
          inclusion.call(file)
        end
        require file if should_require
      end
    end
  end
end
