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
          # model: "gpt-3.5-turbo",
          model: "gpt-4.1-nano",
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
      puts "   ❌ Rate Limited (429) - please wait and try again"
    rescue Faraday::UnauthorizedError => e
      puts "   ❌ Unauthorized (401) - check API key validity"
    rescue Faraday::BadRequestError => e
      puts "   ❌ Bad Request (400) - invalid request format"
    rescue => e
      puts "   ❌ Unexpected Error: #{e.class} - #{e.message}"
    end
    
    # Return empty array if GPT fails
    puts "   ❌ GPT generation failed"
    []
  end

  def self.load_prompts(category = 'sports', path = File.expand_path('../../prompts.yml', __FILE__))
    yaml = YAML.load_file(path)
    yaml[category] || []
  end
end
