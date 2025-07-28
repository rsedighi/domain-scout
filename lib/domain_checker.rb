require 'open3'

class DomainChecker
  def initialize
    @delay_between_checks = 1 # seconds to avoid rate limiting
  end

  # Check availability of multiple domains
  # Returns hash: { "domain.com" => true/false } where true = available
  def check_availability(domains)
    results = {}
    
    domains.each do |domain|
      # Clean domain name - remove any protocol, www, trailing slash
      clean_domain = clean_domain_name(domain)
      next if clean_domain.nil? || clean_domain.empty?
      
      begin
        available = check_single_domain(clean_domain)
        results[clean_domain] = available
        puts "#{clean_domain}: #{available ? 'AVAILABLE' : 'taken'}"
        
        # Rate limiting - small delay between checks
        sleep(@delay_between_checks) if domains.size > 1
      rescue => e
        puts "Error checking #{clean_domain}: #{e.message}"
        results[clean_domain] = false # Assume taken on error
      end
    end
    
    results
  end

  private

  def clean_domain_name(domain)
    # Remove protocol, www, paths, and clean up
    domain = domain.to_s.strip
    domain = domain.gsub(/^https?:\/\//, '')
    domain = domain.gsub(/^www\./, '')
    domain = domain.split('/').first
    domain = domain.downcase
    
    # Add .com if no extension
    domain += '.com' unless domain.include?('.')
    
    # Basic validation
    return nil unless domain.match?(/^[a-z0-9\-]+\.[a-z]+$/)
    
    domain
  end

  def check_single_domain(domain)
    # Use whois command to check domain availability
    stdout, stderr, status = Open3.capture3("whois #{domain}")
    
    # Different registrars have different "not found" messages
    not_found_indicators = [
      'no match',
      'not found',
      'no data found',
      'domain not found',
      'no matching record',
      'not registered',
      'available for registration'
    ]
    
    output = (stdout + stderr).downcase
    
    # If whois fails completely, assume domain is taken
    return false if output.strip.empty?
    
    # Check if any "not found" indicator is present
    not_found_indicators.any? { |indicator| output.include?(indicator) }
  end
end
