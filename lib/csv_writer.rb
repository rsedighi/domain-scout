require 'csv'

class CsvWriter
  def initialize(filename = 'results.csv')
    @filename = filename
    @headers = ['domain', 'status', 'prompt_category', 'prompt_text', 'checked_at']
    
    # Create CSV with headers if it doesn't exist
    unless File.exist?(@filename)
      CSV.open(@filename, 'w') do |csv|
        csv << @headers
      end
    end
  end

  # Write domain results to CSV
  # domain_results: hash of { "domain.com" => true/false }
  # prompt_category: string like "sports"
  # prompt_text: the actual prompt used
  def write_results(domain_results, prompt_category, prompt_text)
    timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    
    CSV.open(@filename, 'a') do |csv|
      domain_results.each do |domain, available|
        status = available ? 'AVAILABLE' : 'taken'
        csv << [domain, status, prompt_category, prompt_text, timestamp]
      end
    end
    
    available_count = domain_results.values.count(true)
    total_count = domain_results.size
    
    puts "\n✅ Wrote #{total_count} domains to #{@filename}"
    puts "   └─ #{available_count} available, #{total_count - available_count} taken"
    
    available_count
  end

  # Get summary of results from CSV
  def summary
    return "No results file found" unless File.exist?(@filename)
    
    total = 0
    available = 0
    
    CSV.foreach(@filename, headers: true) do |row|
      total += 1
      available += 1 if row['status'] == 'AVAILABLE'
    end
    
    "Total domains checked: #{total}, Available: #{available}"
  end
end
