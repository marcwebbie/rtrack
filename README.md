# Rtrack [![Build Status](https://travis-ci.org/marcwebbie/rtrack.svg?branch=master)](https://travis-ci.org/marcwebbie/rtrack)

RTrack is an object-oriented wrapper around ffmpeg to manipulate audiofiles easily from ruby code.

## Installation

Add this line to your application's Gemfile:

    gem 'rtrack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rtrack

## Usage

Open a wave file

```ruby
require 'rtrack'

song = AudioTrack.from_file "never_gonna_give_you_up.wav"
```

...or a mp3 file


```ruby
require 'rtrack'

song = AudioTrack.from_file "never_gonna_give_you_up.mp3"
```

... or an ogg, or flv, or [anything else ffmpeg supports](http://www.ffmpeg.org/general.html#File-Formats)

```ruby
ogg_version = AudioTrack.from_file "never_gonna_give_you_up.ogg"
flv_version = AudioTrack.from_file "never_gonna_give_you_up.flv"
mp4_version = AudioTrack.from_file "never_gonna_give_you_up.mp4"
wma_version = AudioTrack.from_file "never_gonna_give_you_up.wma"
aac_version = AudioTrack.from_file "never_gonna_give_you_up.aiff"
```

You can concatenate multiple AudioTracks together

```ruby
song_one = AudioTrack.from_file "one_love.mp3"
song_two = AudioTrack.from_file "jamming.ogg"

song_three = song_one + song_two

song_four = song_one + song_two + song_three + AudioTrack.from_file "buffallo_soldiers.mp3"
```

Get a slice of a track, first 10 seconds

```ruby
song = AudioTrack.from_file "mozart.mp3"
slice = song[10000] # rtrack works on milliseconds
```

Wonder how long is that song?

```
song = AudioTrack.from_file "jamming.mp3"
puts song.seconds
```

Repeat track 4 times

```ruby
beat = AudioTrack.from_file "beat.wav"
remix = beat * 4
```

Save the result to disk

```ruby
remix.export "remix.mp3", "mp3"
# or
remix.save "remix.mp3", "mp3"
```

Save the results with bitrate

```ruby
remix.export "remix.mp3", "mp3", "192k"
```

## Examples

Let's suppose you have plenty of `mp4` videos that you'd like to convert to
`mp3` so you can listen on your mp3 player on the road.

```ruby
require "rtrack"

Dir[Dir.home + "/Videos/*.mp4"].each do |video_path|
  video_name = File.basename(video_path, File.extname(video_path))
  puts "converting #{video_name}"
  song = AudioTrack.from_file video_path
  song.export "#{video_name}.mp3"
end
```

## Dependencies

Requires ffmpeg or avconv for encoding and decoding.

 - ffmpeg (http://www.ffmpeg.org/)

 -OR-

 - avconv (http://libav.org/)
 
## Trivia

+ RTrack is inspired by [pydub](http://www.github.com/jiaaro/pydub) and [jquery](http://www.jquery.com)
+ As in pydub all AudioTrack objects are [immutable](http://rubylearning.com/satishtalim/mutable_and_immutable_objects.html)
+ As in jquery you can chain operations using AudioTrack objects


## Contributing

1. Fork it ( http://github.com/marcwebbie/rtrack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
