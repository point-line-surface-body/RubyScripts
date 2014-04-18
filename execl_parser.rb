#encoding:gbk
require 'win32ole'
WIN32OLE.codepage = WIN32OLE::CP_UTF8 # to handle chinese in excel
system("copy \\\\s3gweb\\NRNC\\Teams\\SWT\\Support\\PaveHawk_Local_Support_Database.xls PaveHawk_Local_Support_Database.xls \/y \/d")
#C:\\Users\\senya\\Desktop\\AutoSupport\\PaveHawk_Local_Support_Database.xls
#puts Time.now
#SupportList = '\\s3gweb\NRNC\Teams\SWT\Support\PaveHawk_Local_Support_Database.xls'
#/net/s3gweb/vol/s3gweb/
#SupportList = "C:\\Users\\senya\\Desktop\\PaveHawk_Local_Support_Database.xls"
#if !File.exist?(SupportList) then       puts "Error!" end
 
#http://developer.51cto.com/art/200912/170743.htm
excel	= WIN32OLE::new('Excel.Application')
#excel.visible=true
#PaveHawk_Local_Support_Database
xls		= excel.Workbooks.Open('C:\Users\senya\Desktop\AutoSupport\PaveHawk_Local_Support_Database.xls') #xls = excel.Workbooks.Open('C:\Users\senya\Desktop\test.xls')
sheet	= xls.Worksheets(1)
sheet.Select
 
# Read data
Rows 	= sheet.UsedRange.rows.Count  
Columns = sheet.UsedRange.columns.Count  
#puts "Row=#{Rows},Column=#{Columns}"


puts "="*150
i = 1	# skip the top row
Num_of_Inprogress = 0
while i <= Rows
	i += 1
	line_num = 'A' + i.to_s + ':' + 'O'+ i.to_s
	#line = sheet.Range(line_num)
	next if (/Closed/i =~ sheet.Cells(i,"F").value)
	break if(/\w+/i !~ sheet.Cells(i,"B").value)
	print "i=#{i}\t"
	
	#sheet.Range(line_num).each{ |cell| print cell.value.to_s,"\t"}
	
	# B
	selectOriginator = 'B' + i.to_s
	originator = sheet.Range(selectOriginator).value.strip
	print originator,"\t"
	
	# C
	selectAssignee = 'C' + i.to_s
	assignee = sheet.Range(selectAssignee).value.strip
	print assignee,"\n"
	#print "\n"
	
end

puts "="*150

#A	SN
#B	Originator
#C	Assignee
#D	Description
#E	RootCause/Solution
#F	State
#G	Report Time
#H	Category
#I	Support Interface
#J	Assigned Time
#K	Progress Update
#L	Fixed Time
#M	Originator Feedback
#N	Fixer Feedback
#O	Comments

test = 'D'
num = 7
id = test + num.to_s
#puts "ID=#{id}"
string = sheet.Range(id).value
puts string
#sheet.Range('10:10').each{ |cell| puts cell.value}
 
#data = sheet.Range('a1:c12')['Value']


xls.Close(1)
excel.Quit()
