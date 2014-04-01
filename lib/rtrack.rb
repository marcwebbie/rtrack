require "tempfile"

require "rtrack/version"
require "rtrack/transcoder"

class AudioTrack
  attr_reader :wavefile, :duration
  
  def initialize (wavefile, duration)
    @wavefile = wavefile
    @duration = duration
  end

  def self.from_file(infile)
    if not (File.exists? infile)
      fail StandardError, "Couldn't find file from path: #{infile}"
    end
    infile = File.open(infile)
    wavefile = Tempfile.new ['','.wav']
    duration = RTrack::Transcoder.to_wave(infile.path, wavefile.path)
    AudioTrack.new wavefile, duration
  end

  def seconds
    @duration / 1000
  end
  
  def path
    @wavefile.path
  end
  
  def [](slice_range)
    if not slice_range.class == Range
      fail StandardError, "Invalid slice was given: #{slice_range}"
    end
    
    slice_start, slice_end = slice_range.min, slice_range.max
    new_wavefile = Tempfile.new ['','.wav']
    duration = RTrack::Transcoder.to_slice(@wavefile.path,
      new_wavefile.path,
      slice_start,
      slice_end)
    
    AudioTrack.new new_wavefile, duration
  end

  def +(other)
    info = RTrack::Transcoder.concat @wavefile.path, other.wavefile.path
    AudioTrack.new info["wavefile"], info["duration"]
  end

  def export(outpath, format="mp3", bitrate="128k")
    return_code = RTrack::Transcoder.export(@wavefile.path, outpath, format, bitrate)
    return_code
  end

  alias_method :save, :export
end
