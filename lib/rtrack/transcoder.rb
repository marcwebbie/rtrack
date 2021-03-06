require 'tempfile'

module RTrack
  class Transcoder
    BIN = "ffmpeg"
    PROBER = "ffprobe"

    def self._clean_output output
      output.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end

    def self.bin
      @@bin
    end

    def self.to_milliseconds(hours, mins, secs, msecs=0)
      (hours * 3600000) + (mins * 60000) + (secs * 1000) + msecs
    end

    def self.parse_duration(output)
      begin
        output = self._clean_output output
        time_string = output.scan(/time\=(\d+:\d+:\d+\.\d+)/).last.last
      rescue NoMethodError
        raise StandardError, "Couldn't parse duration from transcoder output"
      end

      mobj = time_string.match(/(?<hours>\d+):(?<mins>\d+):(?<secs>\d+)\.(?<msecs>\d+)/)
      hours = mobj["hours"].to_i
      mins = mobj["mins"].to_i
      secs = mobj["secs"].to_i
      msecs = mobj["msecs"].ljust(3, "0").to_i

      to_milliseconds hours, mins, secs, msecs
    end

    def self.to_wave(infile_path)
      wavefile = Tempfile.new ['','.wav']
      `#{self::BIN} -y -i #{infile_path} -ar 44100 -ac 2 -f wav  #{wavefile.path} 2>&1`
      wavefile
    end

    def self.to_slice(infile_path, start, to)
      wavefile = Tempfile.new ['','.wav']
      `#{self::BIN} -y -i #{infile_path} -ss #{start} -to #{to} -f wav #{wavefile} 2>&1`
      wavefile
    end

    def self.concat(track_one, track_two)
      new_wavefile = Tempfile.new ['','.wav']
      sample_size = 4096
      tracks = [track_one, track_two]

      WaveFile::Writer.new(new_wavefile.path, WaveFile::Format.new(:stereo, :pcm_16, 44100)) do |writer|
        tracks.each do |track|
          track.wavefile.each_buffer(sample_size) do |buffer|
            writer.write(buffer)
          end
        end
      end
      new_wavefile.path
    end

    def self.is_media?(filepath)
      cmd = "#{self::PROBER} #{filepath} >/dev/null 2>&1"
      `#{cmd}`
      $?.success?
    end

    def self.export(inpath, outpath, format, bitrate)
      cmd = "#{self::BIN} -y -i #{inpath} -f #{format} -b:a #{bitrate} #{outpath} 2>&1"
      `#{cmd}`
      $?.success?
    end

    def self.info mediapath
      cmd = "#{self::PROBER} -v quiet -print_format json -show_format -show_streams #{mediapath}"
      output = `#{cmd}`
      JSON::parse output
    end
  end
end
