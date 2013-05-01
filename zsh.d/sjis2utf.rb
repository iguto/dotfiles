#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'pathname'
require 'optparse'
require 'fileutils'
require 'nkf'

#=====================================================================
# 文字コード変換を行うスクリプト
#   機能強化ver
#=====================================================================

#---------------------------------------------------------------------
# やりたいこと
# - 再起的な変換
#   - 再起オプション
#   - オプション解析
# - UTF-8,ASCIIエンコードのファイルは変換しない
# - TEXTでないファイルも変換しない
# - 変換しないファイルしかない場合は、.sjisディレクトリを作成しない
#   - もしくは、作成しても消しておく
#---------------------------------------------------------------------

############
# setting  #
############
BACKUP_DIR = ".sjis-dir"
BACKUP_SUFFIX =".sjis"

CODES = {
  NKF::JIS     => "JIS",
  NKF::EUC     => "EUC",
  NKF::SJIS    => "SJIS",
  NKF::UTF8    => "UTF8",
  NKF::BINARY  => "BINARY",
  NKF::ASCII   => "ASCII",
  NKF::UNKNOWN => "UNKNOWN"
}

##################
# オプション解析 #
##################

options = { :r => nil }

OptionParser.new do |opt|

  Version = "0.0.1"

  opt.on('-r') do |v|
    options[:r] = true
  end

  begin 
    opt.parse!
  rescue
    STDOUT.puts "Invalied option"
    exit 1
  end
end

######################
# 個別のファイル処理 #
######################

def convert_file(file)
  encode = NKF.guess(File.read(file))
  if encode == NKF::SJIS
    puts "c\t#{file}"
    $converted_flg = true
    renamed_file = file + BACKUP_SUFFIX
    FileUtils.mv file, renamed_file
    File.open file, 'w' do |f|
      f.print NKF.nkf '-w' , File.read(renamed_file)
    end
    FileUtils.mv renamed_file, BACKUP_DIR
  else
    puts "n\t#{file}"
  end
end

##########################
# 対象ディレクトリへ移動 #
##########################
target = ARGV.shift
cwd = Pathname.pwd + target
cwd = File.dirname(cwd)  unless File.directory? cwd
Dir.chdir cwd
puts "--> cwd = #{Dir.pwd}"
puts 

####################################
# バックアップ用ディレクトリの作成 #
####################################
$mkdir_flg = nil
$converted_flg = nil

unless File.exist? BACKUP_DIR
  Dir.mkdir BACKUP_DIR
  $mkdir_flg = true
  puts "BACKUP_DIR is created as '#{BACKUP_DIR}'"
  puts 
end

############
# 処理分岐 #
############
if options[:r]
  Dir.glob('**/*').each do |file|
    next  if file.include?(BACKUP_DIR)
    convert_file(file)
  end
else
  file = target
  convert_file(file)
end

##############################################################
# 変換するものがなかった場合、バックアップディレクトリを削除 #
##############################################################

if $converted_flg
  puts 
  puts "Completed convert. The original files are in .sjis-dir/"
else
  Dir.rmdir BACKUP_DIR  if $mkdir_flg
end


