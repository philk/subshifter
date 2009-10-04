Subtitle Shifter
================

This is just a simple project for the RubyLearning challenge.  The task is to allow a commandline script to shift the timecodes in an SRT file by an arbitrary number of seconds and milliseconds.

I went a little crazy with it and created a specific Timecode class for all the operations on the timecodes and a Subshifter class to deal with the file operations.

Go into the example folder and run main.rb like this:

`ruby main.rb -o add -t "10,150" "../samples/SurfsUp.srt" "../samples/SurfsUp-shifted.srt"`
