module Miron
  class Utils
    # Returns the path of the Mironfile in the given dir, if any exists.
    #
    # @param  [Pathname] dir
    #         The directory where to look for the Mironfile.
    #
    # @return [Pathname] The path of the Mironfile.
    # @return [Nil] If no Mironfile was found in the given dir
    #
    def self.mironfile_in_dir(dir)
      mironfile = dir + 'Mironfile'
      if mironfile.exist?
        true
      else
        false
      end
    end

    # Returns the contents of the Mironfile in the given dir, if any exists.
    #
    # @param  [Pathname] dir
    #         The directory where to look for the Mironfile.
    #
    # @return [String] The contents of the Mironfile.
    # @return [Nil] If no Mironfile was found in the given dir
    #
    def self.mironfile(dir)
      mironfile = dir + 'Mironfile'
      return File.read(mironfile) if mironfile.exist?
    end
  end
end
