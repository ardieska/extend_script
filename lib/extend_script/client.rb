require 'thor'
require 'fileutils'
module ExtendScript
  class Client < Thor
    
    default_command nil
    
    desc "merge usage", "$ merge -i infile [-o outfile]"
    method_option "input", aliases: "i", require: true
    method_option "output", aliases: "o", require: false
    def merge
      # puts "#{infile} -> #{outfile || 'nil'}"
      infile = options['input']
      outfile = options['output']
      export(infile, outfile)
    end
    
    private
    def export(infile, outfile)
      ret = merge_recursive(infile)
      if outfile.nil?
        puts ret.join
      else
        out_path = File.expand_path(outfile)
        FileUtils.mkdir_p(File.dirname out_path) unless File.exist?(File.dirname out_path)
        File.open(out_path, "wb") do |file|
          file << ret.join
          # puts "--> #{file.path}"
        end
      end
    end
    
    def merge_recursive(infile, results=[], dup={})
      File.open(infile, "r") do |file|
        file.readlines.each do |line|
          # search  #include or //@include
          reg = /(^#|^\/\/@)include\s+[\'\"](.+)[\'\"]/
          if line =~ reg
            m2 = line.match(reg)[2]
            child_path = File.expand_path(m2, File.dirname(infile))
            if dup[child_path].nil?
              dup[child_path] = true
              # source comment
              # results << "//-->source: #{child_path}\n"
              merge_recursive(child_path, results, dup)
            end
          else
            results << line
          end
        end
      end
      results
    end
    
  end
  
end

