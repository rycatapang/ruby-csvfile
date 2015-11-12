x = true #Verify valid input of menu choices

begin

puts "\nChoose an option:\n1. Input the full path file.\n2. Browse for a CSV file.\n3. Exit application." 
puts "\nSelection: "
option = gets.chomp

haveFile = false
cancelSelect = false

def get_header(path = "")

    require 'csv'
	getHeader = CSV.read(path)[0,1] #Reads first row only
	fHeader = getHeader[0,1].join(",").upcase!.split(/\s*,\s*/) #to string upcase > to store in array
	
	puts "\nTable column/s found:"	
	p fHeader
	confirmSelect = "N"

	begin
	
	confirmHeader = false
	puts "\nWould you like to select all columns [Y/N]? "
	selectAll_ans = gets.chomp
	selectAll_ans.downcase!
	
	if selectAll_ans == "n"

		begin 
			
			begin
			puts "\nWhat column/s would you like to be selected (seperate each values by a comma)? (x = cancel)"
			temp_header = gets.chomp
			temp_header.upcase! #input to upcase (so input is not case sensitive)
			
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
			
			compareArray = fHeader & conArray #Comparing (intersection)
			proceedColumn = "N"
				
				if compareArray.any? == true
				
					puts "\n>>> Column/s found: #{fHeader}" 
					puts ">>> You have selected: #{compareArray}\n>>> *Missing value/s means they are not found. Please confirm selected values. Proceed [Y/N]?"
					proceedColumn = gets.chomp
					proceedColumn.upcase!
						
						if proceedColumn == "Y" #Confirmation: proceed to next?
							confirmHeader = true
							break
						elsif proceedColumn == "N"
							confirmHeader = false
						else
							puts ">>> Invalid Input!"
							confirmHeader = false
						end
						
				else
					
					puts "\n>>> Column/s found: #{fHeader}" 
					puts ">>> You have selected: #{compareArray} >>> Nothing. Please input again."
					confirmHeader = false
					
				end

			end until (confirmHeader == true && temp_header != "X")
			break
			
		end while (proceedColumn != "Y" || proceedColumn != "N")
		break
		
	elsif selectAll_ans == "y"
		break
		
	else
		puts "Invalid Input!"
		
	end
	
	confirmSelect = false
	
	end while (confirmSelect != "Y" || confirmSelect != "N"  || cancelSelect == true)
	
end

	if option == "1" # 1st >> Selecting the .CSV file; >> From file path.
		x = false
		pathInvalid = true
		
		begin # From file path.
			puts "\nInput a valid full path file: [x = cancel]"
			file_path = gets.chomp
			file_validate = FileTest.exist?(file_path)
			
			if file_validate == true
								
				isCSV = File.extname(file_path)
				if isCSV == ".csv"
					pathInvalid = false
					haveFile = true
				else
					pathInvalid = true
					puts ">>> File should be in .csv extension."
				end
			
			elsif file_path == "x"
				break
			
			else
				puts ">>> File does not exist!"
				pathInvalid = true
			end
			
		end while (pathInvalid == true)
					
	elsif option == "2" # >> From open file dialog.
		x = false
		
		require 'tk'
		file_path = Tk::getOpenFile('filetypes'=>[['Currently', '*.csv']])
		
		if file_path == ""
			puts ">>> You have not selected anything!"
		else
			puts ">>> You have selected the file located in: #{file_path}."
			haveFile = true
		end
		
	elsif option == "3" # >> Exit to main menu.
		abort "\n>>> Shutting down application. . ."
		
	else
		puts ">>> Invalid input!"
		x = true
	end
	
	if haveFile == true # 2nd >> Read the values in the first row.
		get_header file_path
	end
	
	puts "wew"
	wew = gets
	
	puts wew
end while (x == true || file_path == "x" || file_path == "")
