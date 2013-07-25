if RUBY_PLATFORM =~ /linux/
	wkhtmltopdf_executable = "wkhtmltopdf-amd64"
elsif RUBY_PLATFORM =~ /darwin/
	wkhtmltopdf_executable = "wkhtmltopdf-darwin"
else
	raise "Unsupported. Must be running linux or intel-based Mac OS."
end

WickedPdf.config = {
  :exe_path => Rails.root.join('vendor', 'bin', wkhtmltopdf_executable).to_s
}