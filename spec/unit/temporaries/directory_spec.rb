require 'spec/spec_helper'

describe Temporaries::Directory do
  before do
    @context = Object.new
    @context.extend Temporaries::Directory
    FileUtils.rm_rf TMP
    FileUtils.mkdir_p TMP
  end

  before do
    FileUtils.rm_rf TMP
  end

  describe "#push_temporary_directory and #pop_temporary_directory" do
    it "should create the given directory and make it the #tmp until it is popped" do
      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")

      @context.push_temporary_directory "#{TMP}/dir1"

      @context.tmp.should == "#{TMP}/dir1"
      File.should be_directory("#{TMP}/dir1")

      @context.pop_temporary_directory

      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")
    end

    it "should be nestable" do
      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")

      @context.push_temporary_directory "#{TMP}/dir1"

      @context.tmp.should == "#{TMP}/dir1"
      File.should be_directory("#{TMP}/dir1")
      File.should_not be_directory("#{TMP}/dir2")

      @context.push_temporary_directory "#{TMP}/dir2"

      @context.tmp.should == "#{TMP}/dir2"
      File.should be_directory("#{TMP}/dir2")

      @context.pop_temporary_directory

      @context.tmp.should == "#{TMP}/dir1"
      File.should_not exist("#{TMP}/dir2")
      File.should be_directory("#{TMP}/dir1")

      @context.pop_temporary_directory

      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")
    end

    it "should not destroy the directory on pop if the directory already existed on push" do
      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir")

      @context.push_temporary_directory "#{TMP}/dir"

      @context.tmp.should == "#{TMP}/dir"
      File.should be_directory("#{TMP}/dir")

      @context.push_temporary_directory "#{TMP}/dir"

      @context.tmp.should == "#{TMP}/dir"
      File.should be_directory("#{TMP}/dir")

      @context.pop_temporary_directory

      @context.tmp.should == "#{TMP}/dir"
      File.should be_directory("#{TMP}/dir")

      @context.pop_temporary_directory

      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir")
    end
  end

  describe "#with_temporary_directory" do
    it "should make the given directory and make it the #tmp only during the given block" do
      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")

      block_run = false
      @context.with_temporary_directory "#{TMP}/dir1" do
        block_run = true
        @context.tmp.should == "#{TMP}/dir1"
        File.should be_directory("#{TMP}/dir1")
      end
      block_run.should be_true

      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")
    end

    it "should be nestable" do
      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")

      blocks_run = []
      @context.with_temporary_directory "#{TMP}/dir1" do
        blocks_run << 1
        @context.tmp.should == "#{TMP}/dir1"
        File.should be_directory("#{TMP}/dir1")
        File.should_not be_directory("#{TMP}/dir2")

        @context.with_temporary_directory "#{TMP}/dir2" do
          blocks_run << 2
          @context.tmp.should == "#{TMP}/dir2"
          File.should be_directory("#{TMP}/dir2")
        end

        @context.tmp.should == "#{TMP}/dir1"
        File.should_not exist("#{TMP}/dir2")
        File.should be_directory("#{TMP}/dir1")
      end

      blocks_run.should == [1, 2]

      @context.tmp.should be_nil
      File.should_not exist("#{TMP}/dir1")
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @context.tmp.should be_nil
      begin
        @context.with_temporary_directory "#{TMP}/dir" do
          @context.tmp.should == "#{TMP}/dir"
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @context.tmp.should be_nil
    end
  end
end
