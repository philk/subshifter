Subtitle Shifter
================

This is just a simple project for the RubyLearning challenge.  The task is to allow a commandline script to shift the timecodes in an SRT file by an arbitrary number of seconds and milliseconds.

I went a little crazy with it and created a specific Timecode class for all the operations on the timecodes and a Subshifter class to deal with the file operations.

`subshifter -o add -t "10,105" --input-file FILENAME --output-file FILENAME`

There's a sample srt file in the samples directory.
