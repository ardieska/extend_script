require 'thor'
require 'fileutils'
module ExtendScript
  class Client < Thor
    default_command nil

    map "-v" => :version
    
    desc "version", "Show ExtendScript version"
    def version
      puts "ExtenedScript Util. #{ExtendScript::VERSION}"
    end

    
    desc "merge", "Merge extendscript.jsx files"
    method_option "input", aliases: "i", required: true
    method_option "output", aliases: "o", required: false
    method_option "embed-version", aliases: "e", required: false
    method_option "detach-target", aliases: "d", defalut: true, type: :boolean
    method_option "attach-target", aliases: "a", type: :string
    def merge
      infile        = options['input']
      outfile       = options['output']
      embed_ver     = options['embed-version']
      detach_target = options['detach-target']
      attach_target = options['attach-target']
      
      opts = {
        embed_ver: embed_ver,
        detach_target: detach_target,
        attach_target: attach_target
      }
      export(infile, outfile, opts)
    end
    
    private
    def export(infile, outfile, opts={})
      ret = merge_recursive(infile)

      embed_ver     = opts[:embed_ver]
      detach_target = opts[:detach_target]
      attach_target = opts[:attach_target]

      if embed_ver
        ret << "\n"
        ret << "//## VERSION #{embed_ver}"
      end

      if detach_target
        ret = remove_target(ret)
      end
      
      if attach_target
        ret = [attach_target, "\n"] + ret
      end

      if outfile
        out_path = File.expand_path(outfile)
        FileUtils.mkdir_p(File.dirname out_path) unless File.exist?(File.dirname out_path)
        File.open(out_path, "wb") do |file|
          file << ret.join
        end
      else
        puts ret.join
      end
    end
    
    def remove_target(lines)
      reg = /(^#|^\/\/@)target\s+[\'\"](.+)[\'\"]/
      lines.reject { |line| line =~ reg }
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

