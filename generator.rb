require "bibtex"

dir_name = ARGV[0] # YYYY_MM
match = /(....)_(..)/.match(dir_name)
year = match[1] if match
month = match[2] if match
bib_file_name = "#{dir_name}/books.bib"
md_file_name = "#{dir_name}/books.md"

def md_entry_str(info, need_date)
  body = "\n\n"
  body += "# #{info[:title]}\n"
  body += "* 著者: #{info[:author].to_s}\n"
  if need_date
    body += "* 出版年月: #{info[:year].to_s}年#{info[:month_numeric].to_s}月\n"
  end
  body += "* 出版社: #{info[:publisher].to_s}\n"
  url = info[:url].to_s
  body += "* 書籍ページ: [#{url}](#{url})\n"
end

bib = BibTeX.open(bib_file_name)

File.open(md_file_name, "w") {|file|
  date = year and month
  if date
    file.puts("#{year}年の#{month}月に出る本のページ\n")
  end
  bib.each_entry {|info|
    s = md_entry_str(info, !date)
    file.puts(s)
  }
}
