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
$haveInputRow = false
$haveAll = false
cancelSelect = false
$iRow = 0 #How many rows needed
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

def get_inputs

	iRowConfirm = true
	
	while iRowConfirm == true
	
	puts "\nInput how many rows to be output in each file."
	$iRow = gets.chomp
	
		begin 
			$iRow = Integer($iRow)
			puts ">>> You have entered #{$iRow}. Proceed further. . ."
			iRowConfirm = false
			$haveInputRow = true
		rescue ArgumentError, TypeError
			puts "\n>>> #{$iRow} is not a valid input."
			iRowConfirm = true
			$haveInputRow = false
		end
		
	end
	
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
	
		begin
		arr = CSV.read("#{$file_directory}/New#{$new_filename}.csv", {:encoding => "CP1251:UTF-8", :col_sep => ",", :row_sep => :auto, :headers => :none})
		
		begin
			arr.each do |row|
			
				begin #creating file
					
					CSV.open("#{$file_directory}/#{$new_filename}#{$fileNum}.csv", "a") do |csv|
						if $temp == 1
							csv << $compareArray
						end
						
						csv << row
						puts "Creating and writing data. . . #{$temp}/#{$iRow} (#{$fileNum} file/s created.)"
					if $temp % $iRow == 0
						$fileNum += 1
						$temp = 1
					else
						$temp += 1
						
					end			
					
					end
				end 
			
			end
		end
	
	end
	
	puts "\n>>> Compeleted."
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
			get_inputs
		end
		
		if ($haveInputRow == true)
			get_saveFileName
		end
		
		if ($haveAll == true)
			process_file		
		end
	end
	
end while (x == true || $file_path == "x" || $file_path == "")