$file_path = ""

def read_file
	
	map = {}
	
	require 'tk'
	$file_path = Tk::getOpenFile('filetypes'=>[['Currently', '*.csv']])
	
	require 'csv'
	CSV.foreach("#{$file_path}", headers:true) do |row|
	
	acct = row["acct"]
	branch = row["branch"]
	
	if map.has_key?(acct)
     map[acct] += [branch]
    else
     map[acct] = [branch]
    end
	
	#map[acct] = branch
	end
	
	puts map

end
 
puts read_file


