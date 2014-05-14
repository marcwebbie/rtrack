require 'test/unit'
require 'tempfile'

require 'rtrack'
require 'rtrack/transcoder'

class Audiorack_Tests < Test::Unit::TestCase
  def setup
    @track = AudioTrack.from_file 'test/data/test.mp3'
  end

  def test_instantiate_audio_track_from_file
    test_track = AudioTrack.from_file 'test/data/test.mp3'
    assert_not_nil test_track
    assert_equal test_track.class, AudioTrack
  end

  def test_from_file_throw_exception_when_wrong_infile_path_is_given
    assert_raises(StandardError) do
      test_track = AudioTrack.from_file 'test/data/wrong_path.mp3'
      assert_not_nil test_track
    end
  end

  def test_audio_track_has_a_not_nil_wavefile_from_given_infile
    test_track = AudioTrack.from_file 'test/data/test.mp3'
    assert_not_nil test_track.wavefile
  end

  def test_from_file_returns_audio_track_with_expected_duration
    test_track = AudioTrack.from_file 'test/data/test.mp3'
    expected_duration = 10009
    assert_respond_to test_track, "duration"
    assert_equal expected_duration, test_track.duration

    test_track = AudioTrack.from_file 'test/data/test2.mp3'
    expected_duration = 5016
    assert_respond_to test_track, "duration"
    assert_equal expected_duration, test_track.duration
  end

  def test_duration_seconds_match_duration
    assert_respond_to @track, "seconds"
    expected_seconds = @track.duration/1000
    assert_equal expected_seconds, @track.seconds
  end

  def test_slice_from_song_has_expected_duration
    assert_respond_to @track, "[]"
    expected_seconds = Random.rand(1..10)

    slice = AudioTrack.from_file('test/data/test.mp3')[0..expected_seconds]
    assert_equal slice.seconds, expected_seconds
    slice = AudioTrack.from_file('test/data/test.mp3')[0...expected_seconds]
    assert_equal slice.seconds, expected_seconds-1
  end

  def test_slice_operation_throws_exception_when_invalid_slice_range_is_given
    assert_raises(StandardError) do
      @track[nil]
    end

    assert_raises(StandardError) do
      @track[50]
    end
  end

  def test_concatenate_two_audio_tracks_has_duration_equal_to_sum_of_durations
    track_one = AudioTrack.from_file('test/data/test.mp3')
    track_two = AudioTrack.from_file('test/data/test2.mp3')

    assert_respond_to track_one, "+"
    track_three = track_one + track_two
    expected_duration = 15026
    assert_equal expected_duration, track_three.duration
  end

  def test_export_track
    remix = @track + @track
    destination_file = Tempfile.new ["",".mp3"]

    assert_respond_to remix, "export"
    assert_equal false, RTrack::Transcoder.is_media?(destination_file.path)
    remix.export destination_file.path
    assert_equal true, RTrack::Transcoder.is_media?(destination_file.path)
  end

  def test_save_is_same_as_export
    assert_respond_to @track, "save"
    assert_equal @track.method(:save), @track.method(:export)
  end
end
