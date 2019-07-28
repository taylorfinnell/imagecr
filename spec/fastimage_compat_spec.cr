require "./spec_helper"
require "spec-kemal"
require "./helper/server"

FIXTURE_PATH = File.join(File.expand_path("./spec"), "data")

GOOD_FIXTURES = {
  "test.bmp"                  => [:bmp, [40, 27]],
  "test2.bmp"                 => [:bmp, [1920, 1080]],
  "test.gif"                  => [:gif, [17, 32]],
  "test.jpg"                  => [:jpeg, [882, 470]],
  "test.png"                  => [:png, [30, 20]],
  "test2.jpg"                 => [:jpeg, [250, 188]],
  "test3.jpg"                 => [:jpeg, [630, 367]],
  "test4.jpg"                 => [:jpeg, [1485, 1299]],
  "test.tiff"                 => [:tiff, [85, 67]],
  "test2.tiff"                => [:tiff, [333, 225]],
  "test.psd"                  => [:psd, [17, 32]],
  "exif_orientation.jpg"      => [:jpeg, [600, 450]],
  "infinite.jpg"              => [:jpeg, [160, 240]],
  "orient_2.jpg"              => [:jpeg, [230, 408]],
  "favicon.ico"               => [:ico, [16, 16]],
  "favicon2.ico"              => [:ico, [32, 32]],
  "man.ico"                   => [:ico, [256, 256]],
  "test.cur"                  => [:cur, [32, 32]],
  "webp_vp8x.webp"            => [:webp, [386, 395]],
  "webp_vp8l.webp"            => [:webp, [386, 395]],
  "webp_vp8.webp"             => [:webp, [550, 368]],
  "test.svg"                  => [:svg, [200, 300]],
  "test_partial_viewport.svg" => [:svg, [860, 400]],
  "test2.svg"                 => [:svg, [366, 271]],
  "test3.svg"                 => [:svg, [255, 48]],
  "test4.svg"                 => [:svg, [271, 271]],
  "orient_6.jpg"              => [:jpeg, [1250, 2500]],
}

describe Imagecr do
  GOOD_FIXTURES.each do |file, attrs|
    type = File.extname(file)

    describe "local files" do
      if [".bmp", ".gif", ".png", ".psd", ".tiff"].includes?(type)
        it "get correct type (#{type})" do
          Imagecr.type("#{FIXTURE_PATH}/#{file}").should eq(attrs[0].to_s)
        end

        it "get correct size (#{type})" do
          Imagecr.size("#{FIXTURE_PATH}/#{file}").should eq(attrs[1])
        end
      else
        pending "#{File.extname(file)} is not supported" do
        end
      end
    end

    describe "http files" do
      if [".bmp", ".gif", ".png", ".psd", ".tiff"].includes?(type)
        it "get correct type (#{type})" do
          Imagecr.type("http://localhost:3000/#{file}").should eq(attrs[0].to_s)
        end

        it "get correct size (#{type})" do
          Imagecr.size("http://localhost:3000/#{file}").should eq(attrs[1])
        end
      else
        pending "#{File.extname(file)} is not supported"
      end
    end

    describe "for io" do
      if [".bmp", ".gif", ".png", ".psd", ".tiff"].includes?(type)
        it "get correct type (#{type})" do
          File.open("#{FIXTURE_PATH}/#{file}") do |f|
            Imagecr.type(f).should eq(attrs[0].to_s)
          end
        end

        it "get correct size (#{type})" do
          File.open("#{FIXTURE_PATH}/#{file}") do |f|
            Imagecr.size(f).should eq(attrs[1])
          end
        end
      else
        pending "#{File.extname(file)} is not supported" do
        end
      end
    end

    describe "for io that has been read" do
      if [".bmp", ".gif", ".png", ".psd", ".tiff"].includes?(type)
        pending "get correct type (#{type})" do
        end

        pending "get correct size (#{type})" do
        end
      else
        pending "#{File.extname(file)} is not supported" do
        end
      end
    end

    describe "for io that has been read twice" do
      if [".bmp", ".gif", ".png", ".psd", ".tiff"].includes?(type)
        pending "get correct type (#{type})" do
        end

        pending "get correct size (#{type})" do
        end
      else
        pending "#{File.extname(file)} is not supported" do
        end
      end
    end
  end

  it "test_should_return_nil_on_fetch_failure" do
    Imagecr.size("http://localhost:3000/does_not_exist").should eq(nil)
  end

  it "test_should_return_nil_for_faulty_jpeg_where_size_cannot_be_found" do
    Imagecr.size("http://localhost:3000/faulty.jpg").should eq(nil)
  end

  it "test_should_return_nil_when_image_type_not_known" do
    Imagecr.size("http://localhost:3000/test_rgb.ct").should eq(nil)
  end

  pending "test_should_return_nil_if_timeout_occurs"

  pending "test_should_raise_when_asked_to_when_size_cannot_be_found" do
    expect_raises Imagecr::SizeNotFound do
      Imagecr.size("http://localhost:3000/doesnotexist", Imagecr::Options.new(raise_on_exception: true)).should eq(nil)
    end
  end

  pending "test_should_raise_when_asked_to_when_timeout_occurs"
  pending "test_should_raise_when_asked_to_when_file_does_not_exist"
  pending "test_should_raise_when_asked_when_image_type_not_known"
  pending "test_should_raise_image_fetch_failure_error_if_net_unreach_exception_happens"
  pending "test_should_raise_unknown_image_typ_when_file_is_non_svg_xml"
  pending "test_should_report_content_length_correctly_for_local_files"

  it "test_should_report_size_correctly_for_local_files_with_path_that_has_spaces" do
  end

  it "test_should_return_nil_on_fetch_failure_for_local_path" do
    Imagecr.size("#{FIXTURE_PATH}/does_not_exist").should eq(nil)
  end

  it "test_should_return_nil_for_faulty_jpeg_where_size_cannot_be_found_for_local_file" do
    Imagecr.size("#{FIXTURE_PATH}/faulty.jpg").should eq(nil)
  end

  it "test_should_return_nil_when_image_type_not_known_for_local_file" do
    Imagecr.size("#{FIXTURE_PATH}/test_rgb.ct").should eq(nil)
  end

  pending "test_should_raise_when_asked_to_when_size_cannot_be_found_for_local_file"
  pending "test_should_handle_permanent_redirect"
  pending "test_should_handle_permanent_redirect_4_times"
  pending "test_should_raise_on_permanent_redirect_5_times"

  pending "test_should_handle_permanent_redirect_with_relative_url"
  pending "test_should_handle_permanent_redirect_with_protocol_relative_url"
  pending "test_should_handle_permanent_redirect_with_complex_relative_url"
  pending "test_should_handle_permanent_redirect_with_encoded_url"
  pending "register_redirect(from, to)"
  pending "test_should_fetch_info_of_large_image_faster_than_downloading_the_whole_thing"

  # This test doesn't actually test the proxy function, but at least
  # it excercises the code. You could put anything in the http_proxy and it would still pass.
  # Any ideas on how to actually test this?
  pending "test_should_fetch_via_proxy"
  pending "test_should_fetch_via_proxy_option"
  pending "test_should_handle_https_image"
  pending "test_should_handle_pathname"
  pending "test_should_report_type_and_size_correctly_for_stringios"
  pending "test_should_rewind_ios"
  pending "test_gzipped_file"
  pending "test_truncated_gzipped_file"
  pending "test_cant_access_shell"
  pending "test_content_length"
  pending "test_content_length_not_provided"
  pending "test_should_return_correct_exif_orientation"
  pending "test_should_return_orientation_1_when_exif_not_present"
  pending "test_should_raise_when_handling_invalid_ico_files"
  pending "test_should_support_data_uri_scheme_images"
  pending "test_should_work_with_domains_with_underscores"
  pending "test_should_return_content_length_for_data_uri_images"
  pending "test_canon_raw_formats_are_not_recognised_as_tiff"
end
