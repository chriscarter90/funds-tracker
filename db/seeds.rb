Dir[File.join(File.dirname(__FILE__),'seeds','*.rb')].sort.each do |seed_file|
  puts "Seeding from #{File.basename seed_file}..."
  load seed_file
  puts "Done."
end
