$x = true #Verify valid input of menu choices

begin

puts "\nChoose an option:\n1. Input the full path file.\n2. Browse for a CSV file.\n3. Exit application." 
puts "\nSelection: "
option = gets.chomp

$file_path = "" #csv file location
$file_directory = "" #csv save file
$totalRowfound = 0 #How many rows in file
haveFile = false
$haveColumnSelected = false
$haveAll = false
cancelSelect = false
# $compareArray - Columns selected
$new_filename = ""
$fHeader = []

def get_header(path = "")

    require 'csv'
	getHeader = CSV.read(path)[0,1] #Reads first row only
	#$fHeader = getHeader[0,1].join(",").upcase!.split(/\s*,\s*/) #to string upcase > to store in array
	$fHeader = getHeader[0,1].join(",").split(/\s*,\s*/) #to string upcase > to store in array
	
	puts "\nTable column/s found:"	
	p $fHeader
	confirmSelect = "N"

	begin
	
	confirmHeader = false
	puts "\nWould you like to select all columns [Y/N]? "
	selectAll_ans = gets.chomp
	selectAll_ans.downcase!
	
	if selectAll_ans == "n"

		begin 
			
			begin
			puts "\nWhat column/s would you like to be selected (seperate each values by a comma)? (Columns are case-sensitive)"
			temp_header = gets.chomp
			#temp_header.upcase! #input to upcase (so input is not case sensitive)
			
			#if temp_header == "x"
			#	cancelSelect = true
			#	break
			#end
			
			if temp_header == "X"
			cancelSelect = false
			break
			end
				
			conArray = []
			conArray = temp_header.split(/\s*,\s*/)
			
			$compareArray = $fHeader & conArray #Comparing (intersection)
			proceedColumn = "N"
				
				if $compareArray.any? == true
				
					puts "\n>>> Column/s found: #{$fHeader}" 
					puts ">>> You have selected: #{$compareArray}\n>>> *Missing value/s means they are not found. Please confirm selected values. Proceed [Y/N]?"
					proceedColumn = gets.chomp
					proceedColumn.upcase!
						
						if proceedColumn == "Y" #Confirmation: proceed to next?
							confirmHeader = true
							$haveColumnSelected = true
						elsif proceedColumn == "N"
							confirmHeader = false
						else
							puts ">>> Invalid Input!"
							confirmHeader = false
						end
						
				else
					
					puts "\n>>> Column/s found: #{$fHeader}" 
					puts ">>> You have selected: #{$compareArray} >>> Nothing. Please input again."
					confirmHeader = false
					
				end

			end until (confirmHeader == true && temp_header != "X")
			break
			
		end while (proceedColumn != "Y" || proceedColumn != "N")
		break
		
	elsif selectAll_ans == "y"
		$haveColumnSelected = true
		
		require 'csv'
		getHeader = CSV.read(path)[0,1] #Reads first row only
		$fHeader = getHeader[0,1].join(",").split(/\s*,\s*/) #to string upcase > to store in array
		#$fHeader = getHeader[0,1].join(",").upcase!.split(/\s*,\s*/) #to string upcase > to store in array
		
		$compareArray = $fHeader
		break
		
	else
		puts "Invalid Input!"
		
	end
	
	confirmSelect = false
	
	end while (confirmSelect != "Y" || confirmSelect != "N"  || cancelSelect == true)
	
end

def get_saveFileName

	confirmAnsw = false
	confirmPath = false
	
	begin
	
	puts "\nInput your desired filename."
	$new_filename = gets.chomp.gsub(/[^\w\.]/, '_')
	
	puts ">>> You have entered #{$new_filename}. Proceed? [Y/N]"
	confirmAns = gets.chomp
	confirmAns.upcase!
	
	if confirmAns == "Y"
		confirmAnsw = true
	elsif confirmAns == "N"
		confirmAnsw = false
	end

	end until confirmAnsw == true
	
	if confirmAnsw == true
	
	begin	
	
		puts "\nSet the file location."
		
		require 'tk'
		$file_directory = Tk::chooseDirectory()
		
		if $file_directory == ""
			puts ">>> You have not selected anything!"
		else
			puts ">>> You have selected this file path: #{$file_directory}."
			confirmPath = true
			$haveAll = true
		end
	
	end until confirmPath == true
	end
end

def process_file
	
	begin
	puts "\nPlease input the name of the column for branches(Case sensitive)."
	$getName = gets.chomp
	
	if $compareArray.include?("#{$getName}") == false
		puts ">>> Column not found."
	end
	
	end until $compareArray.include?("#{$getName}") == true
	
	$getIndex = $compareArray.index("#{$getName}")
	
	#Create new csv file w desired column
	require 'csv'
	original = CSV.read("#{$file_path}", { headers: true, return_headers: true })
	$array = $fHeader - $compareArray
	
	if $array != []
		$array.each do |val| 
		original.delete(val)
		end
	end
	
	CSV.open("#{$file_directory}/New#{$new_filename}.csv", "w") do |csv|
	original.each do |row|
	csv << row
	puts "Collecting and processing data. . ."
		end
	end
	
	puts "\n>>> New source file created."
	
	$temp = 1
	$fileNum = 1	
	
	require "benchmark"
	
	time = Benchmark.realtime do
	(1..10000).each { |i| i }
	
	begin

	require 'csv'
	csv = CSV.read("#{$file_path}", :headers=>true)
	uniqColValues = []
	uniqColValues = csv["#{$getName}"] 

	uniqColValues = uniqColValues.uniq
	
	#Create each file and place header
	uniqColValues.each do |val|
		CSV.open("#{$file_directory}/#{$new_filename}#{val}.csv", "w") do |csv|
		csv << $compareArray
		end
	end

	
	uniqColValues.each do |val|
		begin
			CSV.foreach("#{$file_directory}/New#{$new_filename}.csv", headers:true) do |guest|
			CSV.open("#{$file_directory}/#{$new_filename}#{val}.csv", "a") do |csv|
			csv << guest if guest["#{$getName}"] == val
				end
			end
			puts "#{$temp} file completed."
			$temp +=1
			branches_needed = []	
		end
	end
	end
	
	end
	puts "\n>>> All processes are completed."
	puts "\n>>> Time elapsed #{time} seconds"
	#
end

	if option == "1" # 1st >> Selecting the .CSV file; >> From file path.
		x = false
		pathInvalid = true
		
		begin # From file path.
			puts "\nInput a valid full path file: [x = cancel]"
			$file_path = gets.chomp
			file_validate = FileTest.exist?($file_path)
			
			if file_validate == true
								
				isCSV = File.extname($file_path)
				if isCSV == ".csv"
					pathInvalid = false
					haveFile = true
				else
					pathInvalid = true
					puts ">>> File should be in .csv extension."
				end
			
			elsif $file_path == "x"
				break
			
			else
				puts ">>> File does not exist!"
				pathInvalid = true
			end
			
		end while (pathInvalid == true)
					
	elsif option == "2" # >> From open file dialog.
		x = false
		
		require 'tk'
		$file_path = Tk::getOpenFile('filetypes'=>[['Currently', '*.csv']])
		
		if $file_path == ""
			puts ">>> You have not selected anything!"
		else
			puts ">>> You have selected the file located in: #{$file_path}."
			haveFile = true
		end
		
	elsif option == "3" # >> Exit to main menu.
		abort "\n>>> Shutting down application. . ."
		
	else
		puts ">>> Invalid input!"
		x = true
	end
	
	if haveFile == true # 2nd >> Read the values in the first row.
		get_header $file_path
		
		if ($haveColumnSelected == true)
			get_saveFileName
		end
		
		if ($haveAll == true)
			process_file		
		end
	end
	
end while (x == true || $file_path == "x" || $file_path == "")