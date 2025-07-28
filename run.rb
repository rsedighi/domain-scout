#!/usr/bin/env ruby
require_relative './lib/domain_agent'
require 'optparse'

# CLI usage: ruby run.rb [category] [number_of_domains]
def show_usage
  puts <<~USAGE
    Domain Scout - Generate and check domain availability
    
    Usage: ruby run.rb [category] [number_of_domains]
    
    Examples:
      ruby run.rb sports 5
      ruby run.rb ai_automation 10
      ruby run.rb finance_fintech 15
    
    Available categories:
      - sports, ai_automation, saas_niches, finance_fintech
      - sports_fitness_training, sports_psychology, sports_tech
      - And more (see prompts.yml)
    
    Default: sports category, 10 domains
  USAGE
end

# Parse command line arguments
if ARGV.include?('--help') || ARGV.include?('-h')
  show_usage
  exit 0
end

category = ARGV[0] || 'sports'
num_domains = (ARGV[1] || 10).to_i

# Validate inputs
if num_domains < 1 || num_domains > 50
  puts "❌ Number of domains must be between 1 and 50"
  exit 1
end

# Check if .env file exists
unless File.exist?('.env')
  puts "❌ Missing .env file. Please create one with:"
  puts "   OPENAI_API_KEY=your_openai_api_key_here"
  exit 1
end

# Run the domain scout
begin
  agent = DomainAgent.new
  success = agent.find_domains(category, num_domains)
  
  exit success ? 0 : 1
  
rescue => e
  puts "\n❌ Error: #{e.message}"
  puts "   Please check your .env file and internet connection"
  exit 1
end
