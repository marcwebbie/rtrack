require 'test/unit'
require 'tempfile'
require 'json'

require 'rtrack'

class Transcoder_Tests < Test::Unit::TestCase
  def test_transcoder_raises_standard_error_when_missing_time_from_transcoder_output
    assert_raises(StandardError) do
      RTrack::Transcoder.parse_duration 'bad output'
    end
  end

  def test_trascoder_check_if_mp3_is_valid_media
    assert_equal true, RTrack::Transcoder.is_media?('test/data/test2.mp3')
    assert_equal false, RTrack::Transcoder.is_media?('test/data/bad.mp3')
  end

  def test_transcoder_parse_duration_returns_expected_milliseconds
    mock_output = 'time=00:00:10.04'
    expected_milliseconds = 10040
    assert_equal expected_milliseconds, RTrack::Transcoder.parse_duration(mock_output)
  end

  def test_transcoder_info_returns_expected_hash_with_info_about_media
    assert_respond_to RTrack::Transcoder, 'info'
    info = RTrack::Transcoder.info 'test/data/test3.mp3'
    assert_equal true, info.keys.include?('streams'), 'info doesn\'t contain streams'
    assert_equal true, info.keys.include?('format'), 'info doens\'t contain formats'
  end
end
