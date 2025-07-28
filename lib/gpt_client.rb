require 'openai'
require 'yaml'
require 'dotenv/load'

class GptClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])  # Updated for newer gem
  end

  # Generate domains with GPT
  def generate_domains(prompt)
    # Add small delay to prevent rapid API calls
    sleep(0.5)
    
    begin
      puts "   🔌 Making GPT API call..."
      
      response = @client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "You are a creative branding assistant. Generate exactly 10 short, brandable domain names without extensions. Each name should be on a new line, numbered 1-10." },
            { role: "user", content: "#{prompt}. Generate 10 short, brandable domain names (without extensions):" }
          ],
          max_tokens: 150,
          temperature: 0.8
        }
      )
      
      text = response.dig("choices", 0, "message", "content")
      
      if text && !text.strip.empty?
        domains = text.split("\n").map { |l| l.gsub(/^\d+\.\s*/, '').strip }.reject(&:empty?)
        
        # Clean up domains
        cleaned_domains = domains.map do |domain|
          domain.gsub(/\.(com|net|org|io)$/i, '')  # Remove extensions
                .gsub(/[^a-zA-Z0-9\-]/, '')         # Remove special chars except hyphens
                .downcase
        end.reject(&:empty?).uniq.first(10)
        
        puts "   ✅ GPT generated #{cleaned_domains.size} domains: #{cleaned_domains.first(3).join(', ')}..."
        return cleaned_domains if cleaned_domains.any?
      end
      
    rescue Faraday::TooManyRequestsError => e
      puts "   ❌ Rate Limited (429): #{e.message}"
      puts "   📊 Response body: #{e.response_body}"
      puts "   🕒 Retry-After header: #{e.response_headers['retry-after']}"
    rescue Faraday::UnauthorizedError => e
      puts "   ❌ Unauthorized (401): #{e.message}"
      puts "   📊 Response body: #{e.response_body}"
      puts "   � Check API key validity"
    rescue Faraday::BadRequestError => e
      puts "   ❌ Bad Request (400): #{e.message}"
      puts "   📊 Response body: #{e.response_body}"
    rescue => e
      puts "   ❌ Unexpected Error: #{e.class} - #{e.message}"
      puts "   📊 Backtrace: #{e.backtrace.first(3).join(' | ')}"
    end
    
    # Fallback explanation
    puts "   💡 Falling back to keyword-based generation"
    puts "   🧠 This extracts keywords from prompts and combines them creatively"
    generate_from_prompt_keywords(prompt)
  end

  def self.load_prompts(category = 'sports', path = File.expand_path('../../prompts.yml', __FILE__))
    yaml = YAML.load_file(path)
    yaml[category] || []
  end

  private

  def generate_from_prompt_keywords(prompt)
    # Extract keywords from prompt and generate domains
    keywords = prompt.downcase.scan(/\b[a-z]{3,}\b/).reject { |w| %w[the and for app domain names].include?(w) }
    
    # Generate unique suffixes without using current date
    unique_suffixes = %w[pro max hub lab io tech x24 2024 plus core]
    
    # Different word sets for different types of prompts
    if prompt.downcase.include?('sport')
      base_words = %w[vibe flux beam dash peak surge core nexus edge flow]
      tech_words = %w[hub io lab tech cast track stream zone]
    elsif prompt.downcase.include?('ai')
      base_words = %w[neural quantum cipher neural flux mind brain wave]
      tech_words = %w[ai bot engine core sys lab neural]
    else
      base_words = %w[flux beam nexus surge peak vibe edge flow core dash]
      tech_words = %w[io lab hub tech cast stream zone app]
    end
    
    domains = []
    
    # Generate more unique combinations
    keywords.first(2).each do |keyword|
      # Add unique suffixes and numbers
      base_words.sample(3).each do |base|
        domains << "#{keyword}#{base}#{unique_suffixes.sample}"
        domains << "#{base}#{keyword}x"
        domains << "#{keyword}#{base}24"
      end
      
      # Add tech variations with unique elements
      tech_words.sample(2).each do |tech|
        domains << "#{keyword}#{tech}pro"
        domains << "my#{keyword}#{tech}"
        domains << "#{keyword}#{tech}hub"
      end
    end
    
    # Create compound words with numbers/years for uniqueness
    if keywords.size >= 2
      keywords.combination(2).first(3).each do |k1, k2|
        domains << "#{k1}#{k2}2024"
        domains << "#{k2}#{k1}pro"
        domains << "get#{k1}#{k2}"
      end
    end
    
    # Add very unique variations
    keywords.first(2).each do |keyword|
      domains << "#{keyword}verse"
      domains << "#{keyword}fy2024"
      domains << "smart#{keyword}"
      domains << "#{keyword}genie"
      domains << "#{keyword}wizard"
    end
    
    # Clean and return unique domains
    domains.map(&:downcase)
           .reject { |d| d.length < 6 || d.length > 18 }  # Avoid very short generic names
           .uniq
           .shuffle
           .first(10)
  end
end
