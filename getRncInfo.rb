#!/usr/bin/ruby
# encoding:utf-8
#
# Query RNC Device Version Information
#


require 'pty'
require 'expect'

STDOUT.sync = true
STDERR.sync = true

class RncExpect
	Login_Pattern = %r/^\s*Enter login:\s*/io
	Password_Pattern = %r/^\s*Enter password:\s*/io
	Prompt_Pattern = %r/^\s*\d>\s*/io

	def initialize()
		@rncInfo = Hash.new
	end

	def init_rncInfo(rncIp)
		@rncInfo[:base] = ""
		@rncInfo[:iRNC] = ""
		@rncInfo[:ss7] = ""
		@rncInfo[:apcBase] = ""
		@rncInfo[:baseExt] = ""
		@rncInfo[:iRncApc] = ""
		@rncInfo[:cRNCApc] = ""
		@rncInfo[:cnp] = ""
		@rncInfo[:rncIpAddresses] = rncIp
		@rncInfo[:oamOmcIpAddresses] = ""
		@rncInfo[:oamPrimaryOmuIpAddress] = ""
	end
	
	def resultVal
		@rncInfo
	end

  def connectRnc(rncIpAddress,user,passwd)
	expect_verbose = true
	PTY.spawn("telnet #{rncIpAddress}") do |reader, writer, pid|
	writer.sync = true
	reader.expect(Login_Pattern)    { writer.puts user }
	reader.expect(Password_Pattern) { writer.puts passwd }
	reader.expect(Prompt_Pattern)   { writer.puts "d sw avl"}
	reader.expect(Prompt_Pattern) do |output|
		getVersion(output.to_s)
	end
      
	sleep 2
	@rncInfo[:oamOmcIpAddresses] = getIpAddress(reader,writer,"d -p rncin oamOmcIpAddresses")
	sleep 1
	@rncInfo[:oamPrimaryOmuIpAddress] = getIpAddress(reader,writer,"d -p rncin oamPrimaryOmuIpAddress")
	writer.puts "\r"
	writer.print("exit") 
	end
	end

	def getVersion(ver_string)
		ver_string.split(/,/).each{ |e|
		case e
		when /base_(RI\w+)/
			@rncInfo[:base] = $1
		when /iRNC_(RI\w+)/
			@rncInfo[:iRNC] = $1
		when /ss7_(RI\w+)/
			@rncInfo[:ss7] = $1
		when /apcBase_(RI\w+)/
			@rncInfo[:apcBase] = $1
		when /baseExt_(RI\w+)/
			@rncInfo[:baseExt] = $1
		when /iRNCApc_(RI\w+)/
			@rncInfo[:iRncApc] = $1
		when /cRNCApc_(RI\w+)/
			@rncInfo[:cRNCApc] = $1
		when /cnp_(RI\w+)/
			@rncInfo[:cnp] = $1
		end		
		}
	end


	def getIpAddress(r,w,command)
		ip = ""
		w.puts "\r"
		r.expect(Prompt_Pattern){
			while(ip == "")
				w.puts command
				r.expect(Prompt_Pattern) do |output|
					output.to_s.split(/=/).each{ |e|
						case e
							when /(\d+\.\d+\.\d+\.\d+)/i
								ip = $1
						end
					}
				end
			end
		}		
		ip
	end


	def run(ip,usr,passwd)
		init_rncInfo(ip)
		connectRnc(ip,usr,passwd)
		@rncInfo.each{|key,value|
			printf("%-24s= %s\n",key,value);
		}
		resultVal
	end
end


#rnc = RncExpect.new("10.9.5.46","debug","debug")
rnc = RncExpect.new()
rnc.run(ARGV[0],"debug","debug")
