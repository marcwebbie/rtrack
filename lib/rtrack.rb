require "tempfile"
require "wavefile"

require "rtrack/version"
require "rtrack/transcoder"

class AudioTrack
  attr_reader :wavefile

  def initialize (wavefile_path)
    @wavefile = WaveFile::Reader.new wavefile_path
  end

  def self.from_file(infile)
    if not (File.exists? infile)
      fail StandardError, "Couldn't find file from path: #{infile}"
    end
    wavefile_path = RTrack::Transcoder.to_wave infile
    AudioTrack.new wavefile_path
  end

  def duration
    hours = @wavefile.total_duration.hours
    mins = @wavefile.total_duration.minutes
    secs = @wavefile.total_duration.seconds
    msecs = @wavefile.total_duration.milliseconds

    (hours * 3600000) + (mins * 60000) + (secs * 1000) + msecs
  end

  def seconds
    duration / 1000
  end

  def path
    @wavefile.path
  end

  def [](slice_range)
    if not slice_range.class == Range
      fail StandardError, "Invalid slice was given: #{slice_range}"
    end

    slice_start, slice_end = slice_range.min, slice_range.max
    new_wavefile = RTrack::Transcoder.to_slice(@wavefile.path,
      new_wavefile.path,
      slice_start,
      slice_end)

    AudioTrack.new new_wavefile.path
  end

  def +(other)
    AudioTrack.new RTrack::Transcoder.concat self, other
  end

  def export(outpath, format="mp3", bitrate="128k")
    return_code = RTrack::Transcoder.export(@wavefile.path, outpath, format, bitrate)
    return_code
  end

  alias_method :save, :export
end
