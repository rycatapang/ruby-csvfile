x = true #Verify valid input of menu choices

begin

puts "\nChoose an option:" 
puts "1. Input the full path file."
puts "2. Browse for a CSV file."
puts "3. Exit application."
puts "\nSelection: "
option = gets.chomp

haveFile = false

def get_header(path = "")
    require 'csv'
	getHeader = CSV.read(path, {:encoding => "CP1251:UTF-8", :col_sep => ";", :row_sep => :auto, :headers => false, :converters => :numeric})[0,1]
	#array = getcsv[0,1]
	puts "\nTable columns:"
	p getHeader
	#p getcsv.to_a
	#CSV.foreach(path) do |row|
	#puts row.inspect
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
		puts "\nWhat columns would you like to be selected (seperate each column by comma)? [* = select all]"
		temp_header = gets.chomp
		p temp_header
		temp_header.split('"",""')
		p temp_header
	end
	
end while (x == true || file_path == "x" || file_path == "")