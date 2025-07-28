require_relative 'gpt_client'
require_relative 'domain_checker'
require_relative 'csv_writer'

class DomainAgent
  def initialize
    @gpt_client = GptClient.new
    @domain_checker = DomainChecker.new
    @csv_writer = CsvWriter.new
    @max_retries = 3
  end

  # Main method to generate and check domains
  def find_domains(category, target_count = 10)
    puts "🚀 Domain Scout starting..."
    puts "   Category: #{category}"
    puts "   Target: #{target_count} domains"
    puts "   Max retries: #{@max_retries}"
    
    prompts = GptClient.load_prompts(category)
    if prompts.empty?
      puts "❌ No prompts found for category: #{category}"
      return false
    end
    
    attempt = 0
    total_available = 0
    
    while attempt < @max_retries && total_available == 0
      attempt += 1
      puts "\n🔄 Attempt #{attempt}/#{@max_retries}"
      
      # Get a random prompt
      prompt = prompts.sample
      puts "📝 Using prompt: \"#{prompt[0..80]}#{'...' if prompt.length > 80}\""
      
      # Generate domains from GPT
      puts "🤖 Generating domains with GPT..."
      domains = @gpt_client.generate_domains(prompt)
      
      if domains.empty?
        puts "❌ GPT returned no domains, retrying..."
        next
      end
      
      # Take the requested number of domains
      domains = domains.first(target_count)
      puts "🎯 Generated #{domains.size} domain ideas"
      
      # Check availability
      puts "\n🔍 Checking domain availability..."
      results = @domain_checker.check_availability(domains)
      
      # Write to CSV
      available_count = @csv_writer.write_results(results, category, prompt)
      total_available += available_count
      
      if available_count > 0
        puts "\n🎉 Success! Found #{available_count} available domains"
        show_available_domains(results)
        return true
      else
        puts "\n😞 No available domains in this batch"
        if attempt < @max_retries
          puts "   Retrying with a different prompt..."
        end
      end
    end
    
    if total_available == 0
      puts "\n❌ Failed to find any available domains after #{@max_retries} attempts"
      puts "   All generated domains were already taken"
      return false
    end
    
    true
  end

  private

  def show_available_domains(results)
    available = results.select { |domain, available| available }
    if available.any?
      puts "\n💎 Available domains:"
      available.each_with_index do |(domain, _), index|
        puts "   #{index + 1}. #{domain}"
      end
    end
  end
end
