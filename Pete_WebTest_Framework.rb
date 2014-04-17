#!/usr/bin/ruby
# encoding:utf-8
#
# Web Automation Testing Using Ruby Watir 
# http://watir.com/
# http://blog.chinaunix.net/uid-20255298-id-170598.html
#

require 'rubygems'
require 'watir' 


puts Watir::IE::VERSION
#puts Time.now.strftime("%s")
StartTime = Time.now
_start_sec = StartTime.to_i


rand(2) == 1 ? viewKeyWord = "BL_RNC_RI mchen002 c normal" : viewKeyWord = "senya BL_RNC_RI PeteBulkTest"

# ASB PETE Web Url
webUrl = "http://172.24.12.129/rdr/projects/rnc/own/Tools/petesuper/login.php"

# Start an IE
ie = Watir::IE.new
#ie.logger.level = Logger::ERROR
#ie.set_slow_speed()
#ie.maximize()
#ie.bring_to_front()

puts Watir::IE::Process.process_id_from_hwnd(ie.hwnd)
# Browser the #{webUrl}
ie.goto(webUrl)
ie.wait()

_login_sec = Time.now.to_i
time_openloginphp = _login_sec - _start_sec
puts "Login login.php Used:#{_login_sec - _start_sec}s"

# Set the KeyWord and Click lookup View
#puts ie.title()
ie.text_field(:name, "handle").set(viewKeyWord)
#ie.text_field(:name, "handle").value = viewKeyWord
ie.button(:value, "Look Up View").click 
ie.wait()

# Set the KeyWord and Click lookup View
contents = ie.select_list(:id, "view").getAllContents.to_a

# delete the first element "choose a view"
contents.delete_at(0)

# Just Feature List
if contents.size < 2
	puts "Error: Get ViewList Failed"
	ie.close
	exit
end

_grepview_sec = Time.now.to_i
time_lookupview = _grepview_sec - _login_sec
puts "Lookup key View Used:#{_grepview_sec - _login_sec}s"


#puts contents[0]
#viewselected = contents.last # default
#viewselectedid = rand(contents.size)
#viewselectedid == 0 ? viewselected = contents.last : viewselected = contents[viewselectedid]

# Select one View random
viewselected = contents[rand(contents.size)]
ie.select_list(:id, "view").select(viewselected)
ie.wait()

_login_pete_with_view_sec = Time.now.to_i
time_loginpetephp = _login_pete_with_view_sec - _grepview_sec
puts "Login pete.php  Used:#{_login_pete_with_view_sec - _grepview_sec}s"


rand(2) == 1 ? transportMedia = "ATM" : transportMedia = "IP_IUB"
ie.radio(:value,transportMedia).set   #ie.radio(:value,"ATM").set
#ie.radio(:name,"transportMedia").set

#ie.select_list(:id,"selectDomain").select("ALL DOMAIN")

# Select one Feature random, 70% selected "ALL"
featureList = ie.select_list(:id, "selectFeature").getAllContents.to_a

# 70% selected "ALL"
#rand(10) > 8 ? featureSelected = featureList.first : featureSelected = featureList[rand(featureList.size)]
rand(99999).to_f/10000 > 5.5 ? featureSelected = featureList.first : featureSelected = featureList[rand(featureList.size)]
ie.select_list(:id,"selectFeature").select(featureSelected)  ##ie.select_list(:id,"selectFeature").select(features[0])

# Start a New Job
ie.button(:value, "Start New Job").click
ie.wait()
_start_a_new_job_sec = Time.now.to_i
time_startanewjob = _start_a_new_job_sec - _login_pete_with_view_sec
puts "Start a new Job Used:#{_start_a_new_job_sec - _login_pete_with_view_sec}s"

# Test Click Cluster Status
ie.button(:value, "Cluster Status").click
ie.wait()
_See_Cluster_Status_sec = Time.now.to_i
time_clusterstatus = _See_Cluster_Status_sec - _start_a_new_job_sec
puts "Cluster Status  Used:#{_See_Cluster_Status_sec - _start_a_new_job_sec}s"


#ie.radio(:name,"transportMedia").set
#ie.checkbox(:id,"retryFailures").set
#ie.button(:value, "Job Status").click
#list = ie.select_list(:name,'').getAllContents.to_a
#re = ie.radio(:name,"box1").attribute_value("CHECKED")  

# Get the JobId Started 
jobList = Array.new
ie.radios.each {|d| jobList << d if d.name =='job'}
jobStarted = jobList.first.value

# 
#jobStarted = "None"
now = Time.now.to_i

# Modify pete.php, line 220, add id="joblist"
ie.div(:id, "joblist").radio(:name=>'job', :index => 1).set
ie.checkbox(:name,"platform").set
ie.button(:value, "Job Status").click
ie.wait()
_See_Job_Status_sec_1 = Time.now.to_i
time_seejobstatus1 = _See_Job_Status_sec_1 - now
puts "See Job1 Status Used:#{_See_Job_Status_sec_1 - now}s"

#p ie.div(:id, "joblist").radio(:name=>'job')
#ie.div(:id, "joblist").radio(:name => 'job').each {|r| radios << r}
#puts ie.div(:id, "joblist").radio(:value, /job_*/)
#puts ie.div(:id, "joblist").radio(:xpath, "//input")
#puts ie.radio(:xpath, "//input[contains(@value,'job_*')]")
#puts ie.div(:id, "joblist").getAllContents.to_a
#puts ie.radio(:xpath, '//input[contains(@value,"job_*")]')

#puts jobList[rand(4)].value

ie.div(:id, "joblist").radio(:name=>'job', :value => jobList[rand(jobList.size-2)+1].value).set
ie.checkbox(:name,"platform").set
ie.button(:value, "Job Status").click
ie.wait()
_See_Job_Status_sec_2 = Time.now.to_i
time_seejobstatus2 = _See_Job_Status_sec_2 - _See_Job_Status_sec_1
puts "See Job2 Status Used:#{_See_Job_Status_sec_2 - _See_Job_Status_sec_1}s"

#if ie.radio(:name=>'radio', :index => 2).exists? 
#	puts "HELLO"
#else
#	puts "World"
#end
#sleep 3
#ie.button(:name, "btnG").click # "btnG" is the name of the Search button
ie.close




End__Time = Time.now
_end_sec = End__Time.to_i
_used_sec = _end_sec - _start_sec
puts "Select View         :#{viewselected}"
puts "Job Created         :#{jobStarted}"
puts "Start Time          :#{StartTime.strftime("%Y-%m-%d %H:%M:%S")}"
puts "End   Time          :#{End__Time.strftime("%Y-%m-%d %H:%M:%S")}"
puts "Used  Time          :#{_used_sec}s"

SummaryReport = "PeteWeb_WatirAutomationTestingLog.csv"
reportFile = File.new(SummaryReport,"a")
reportFile.printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",viewselected,jobStarted,transportMedia,featureSelected,StartTime.strftime("%Y-%m-%d_%H:%M:%S"),End__Time.strftime("%Y-%m-%d_%H:%M:%S"),_used_sec,time_openloginphp,time_lookupview,time_loginpetephp,time_startanewjob,time_clusterstatus,time_seejobstatus1,time_seejobstatus2)
reportFile.close


#usethe while loop for repeated testing
=begin
while (1)
	system("ruby Pete_WebTest_Framework.rb")
	sleep 300 + rand(300)
	puts "---------------------------------------------------------"
end
=end