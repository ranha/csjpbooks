require "bibtex"
require "erb"

this_year = {}
timeless = []

def yymm(info)
  [info[:year], info[:month_numeric]]
end

def md_entry_str(info, timeless)
  body = "\n\n"
  body += "# #{info[:title]}\n"
  body += "* 著者: #{info[:author].to_s}\n"
  if timeless
    body += "* 出版年月: #{info[:year].to_s}年#{info[:month_numeric].to_s}月\n"
  end
  body += "* 出版社: #{info[:publisher].to_s}\n"
  url = info[:url].to_s
  body += "* 書籍ページ: [#{url}](#{url})\n"
  if info[:note]
    body += "* 注記: #{info[:note].to_s}\n"
  end
  return body
end

bib = BibTeX.open("all_books.bib")

bib.each_entry {|info|
  year = info[:year].to_i
  month = info[:month_numeric].to_i
  key = [year, month]
  # page_name = "#{year}_#{month}.md"
  
  if year < 2021
    timeless << md_entry_str(info, true)
  else
    if this_year[key].nil?
      this_year[key] = []
    end
    this_year[key] << md_entry_str(info, false)
  end
}

this_year_links = "# 2021\n"

this_year.each {|key, strs|
  year = key[0]
  month = key[1]
  
  page = "#{year}_#{month}"

  this_year_links << "* [#{year}/#{month} (#{strs.size}冊)](#{page}.html)\n"
  
  File.open("#{page}.md", "w") {|file|
    file.puts("#{year}年の#{month}月に出る本のページ\n")
    file.puts(strs)
  }
}

File.open("timeless.md", "w") {|file|
  file.puts("過去に出た本で気になっているもののページ\n")
  file.puts(timeless)
}

erb = ERB.new(File.read("README.md.src"))


File.open("README.md", "w") {|file|
  file.puts( erb.result(binding))
}

