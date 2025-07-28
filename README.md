# Domain Scout 

A Ruby CLI tool that generates brandable domain names and checks their availability in real-time. Uses OpenAI GPT for creative generation with intelligent keyword-based fallback.

## Features 

- **Smart Domain Generation**: Uses OpenAI GPT-3.5 for creative, brandable domain names
- **Real-time Availability Checking**: Uses `whois` to check actual domain availability
- **Intelligent Fallback**: Keyword-based generation when API is unavailable
- **Multiple Categories**: Sports, AI/automation, fintech, SaaS, and more
- **CSV Export**: Complete logging with timestamps and metadata
- **Retry Logic**: Automatically tries different prompts if no domains are available
- **Rate Limit Handling**: Graceful handling of API limits

## Quick Start 

```bash
# Clone the repository
git clone https://github.com/rsedighi/domain-scout.git
cd domain-scout

# Install dependencies
bundle install

# Set up your OpenAI API key (optional)
echo "OPENAI_API_KEY=your_openai_api_key_here" > .env

# Generate 5 sports-related domains
ruby run.rb sports 5

# Generate 10 AI automation domains
ruby run.rb ai_automation 10
```

## Installation 

### Prerequisites
- Ruby 3.0+ 
- `whois` command-line tool (usually pre-installed on macOS/Linux)
- OpenAI API key (optional - tool works without it)

### Setup
```bash
# Clone the repository
git clone https://github.com/rsedighi/domain-scout.git
cd domain-scout

# Install Ruby dependencies
bundle install

# Create your environment file
cp .env.example .env

# Edit .env and add your OpenAI API key
# OPENAI_API_KEY=your_key_here
```

## Usage 

### Basic Usage
```bash
# Generate domains for a category
ruby run.rb [category] [number_of_domains]

# Examples
ruby run.rb sports 5                # 5 sports domains
ruby run.rb ai_automation 10        # 10 AI domains  
ruby run.rb finance_fintech 8       # 8 fintech domains
```

### Available Categories
- `sports` - Sports news, streaming, fan communities
- `ai_automation` - AI tools, automation platforms
- `finance_fintech` - Crypto, payments, budgeting apps
- `saas_niches` - SaaS tools, productivity apps
- `sports_fitness_training` - Fitness apps, training platforms
- `sports_psychology` - Sports performance, mindset coaching
- `sports_tech` - Sports analytics, technology

### Output Example
```
 Domain Scout starting...
   Category: sports
   Target: 5 domains
   Max retries: 3

 Attempt 1/3
📝 Using prompt: "Fantasy sports app domain names"
🤖 Generating domains with GPT...
   ✅ GPT generated 5 domains

🔍 Checking domain availability...
sportspulse.com: taken
fantasyhub24.com: AVAILABLE
gametrackpro.com: AVAILABLE
sportsvibe.com: taken
fantasycore2024.com: AVAILABLE

✅ Wrote 5 domains to results.csv
   └─ 3 available, 2 taken

🎉 Success! Found 3 available domains

💎 Available domains:
   1. fantasyhub24.com
   2. gametrackpro.com  
   3. fantasycore2024.com
```

## Configuration 

### Environment Variables
Create a `.env` file in the project root:

```bash
# OpenAI API Key (optional - tool works without it)
OPENAI_API_KEY=your_openai_api_key_here
```

### Custom Prompts
Add your own domain generation prompts in `prompts.yml`:

```yaml
my_category:
  - "Custom prompt for domain generation"
  - "Another creative prompt"
```

## How It Works 

1. **Prompt Selection**: Randomly selects a prompt from the specified category
2. **Domain Generation**: 
   - First tries OpenAI GPT-3.5 for creative, contextual domains
   - Falls back to intelligent keyword-based generation if API unavailable
3. **Availability Checking**: Uses `whois` command to check real domain availability
4. **Results Export**: Saves all results to `results.csv` with metadata
5. **Retry Logic**: If no available domains found, tries different prompts (up to 3 attempts)

## API Usage & Costs 

- Uses OpenAI GPT-3.5-turbo (very cost-effective)
- Typical cost: ~$0.001-0.002 per domain generation batch
- **Works without API key** - uses keyword-based generation as fallback
- Includes rate limiting and quota handling

## Output Files 

### results.csv
Complete log of all domain checks:
```csv
domain,status,prompt_category,prompt_text,checked_at
sportspulse.com,taken,sports,Fantasy sports app domain names,2024-01-15 10:30:25
fantasyhub24.com,AVAILABLE,sports,Fantasy sports app domain names,2024-01-15 10:30:26
```

## Development 

### Project Structure
```
domain-scout/
├── run.rb                 # Main CLI entry point
├── lib/
│   ├── domain_agent.rb    # Main orchestrator
│   ├── gpt_client.rb      # OpenAI integration
│   ├── domain_checker.rb  # Whois domain checking
│   └── csv_writer.rb      # Results export
├── config/                # Configuration files
├── data/                  # Data storage
├── prompts.yml           # Domain generation prompts
└── results.csv           # Output file
```

### Running Tests
```bash
# Test individual components
ruby test_components.rb

# Test with debug logging
ruby run.rb sports 3
```

### Adding New Categories
1. Edit `prompts.yml`
2. Add your category and prompts:
```yaml
your_category:
  - "Prompt for domain generation in your niche"
  - "Another creative prompt for your category"
```

## Troubleshooting 

### Common Issues

**"No prompts found for category"**
- Check category name spelling
- Verify `prompts.yml` contains your category
- Use `ruby run.rb --help` to see available categories

**"whois command not found"**
- Install whois: `brew install whois` (macOS) or `apt-get install whois` (Ubuntu)

**OpenAI API Issues**
- Check your API key in `.env`
- Verify billing setup at https://platform.openai.com/account/billing
- Tool works without API key using keyword generation

**All domains showing as taken**
- Try different categories for more unique domains
- The tool generates brandable names, some popular ones may be taken
- Increase domain count to get more options

## Contributing 

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Add tests if applicable
5. Commit: `git commit -am 'Add your feature'`
6. Push: `git push origin feature/your-feature`
7. Create a Pull Request

## License 

MIT License - see LICENSE file for details.

## Acknowledgments 

- Built with [ruby-openai](https://github.com/alexrudall/ruby-openai) gem
- Uses OpenAI GPT-3.5 for creative domain generation
- Domain checking via standard `whois` command

---

**Happy domain hunting!** 

If you find this tool useful, please give it a ⭐ on GitHub!

-  **GPT-Powered Generation**: Uses OpenAI's GPT to generate creative domain names
-  **Real Domain Checking**: Uses `whois` command to check actual domain availability  
-  **Smart Retry Logic**: Automatically retries with different prompts if no domains are available
-  **CSV Export**: Saves all results with timestamps for easy review
-  **Fast & Simple**: Command-line interface for quick domain research

## Quick Start

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Set up your OpenAI API key:**
   ```bash
   # Create .env file (already included)
   echo "OPENAI_API_KEY=your_api_key_here" > .env
   ```

3. **Run the tool:**
   ```bash
   # Generate 5 sports-related domains
   ruby run.rb sports 5
   
   # Generate 10 AI automation domains  
   ruby run.rb ai_automation 10
   
   # Use default settings (sports, 10 domains)
   ruby run.rb
   ```

## Usage

```bash
ruby run.rb [category] [number_of_domains]
```

### Available Categories
- `sports` - Sports and athletics domains
- `ai_automation` - AI and automation tools
- `saas_niches` - SaaS product ideas
- `finance_fintech` - Finance and fintech domains
- `sports_fitness_training` - Fitness and training
- `sports_psychology` - Sports psychology and mindset
- `sports_tech` - Sports technology
- And more... (see `prompts.yml`)

### Examples

```bash
# Find 5 sports domains
ruby run.rb sports 5

# Find 15 fintech domains  
ruby run.rb finance_fintech 15

# Get help
ruby run.rb --help
```

## Output

The tool outputs results in two ways:

1. **Console**: Real-time progress and available domains
2. **CSV File**: `results.csv` with all checked domains and metadata

### Sample Console Output
```
🚀 Domain Scout starting...
   Category: sports
   Target: 5 domains
   Max retries: 3

🔄 Attempt 1/3
📝 Using prompt: "Fantasy sports app domain names"
🤖 Generating domains with GPT...
🎯 Generated 5 domain ideas

🔍 Checking domain availability...
fieldtechx.com: AVAILABLE
sportbeam.com: taken
sportvibeio.com: AVAILABLE

🎉 Success! Found 2 available domains

💎 Available domains:
   1. fieldtechx.com
   2. sportvibeio.com
```

### CSV Output
```csv
domain,status,prompt_category,prompt_text,checked_at
fieldtechx.com,AVAILABLE,sports,Fantasy sports app domain names,2025-07-27 20:00:03
sportbeam.com,taken,sports,Fantasy sports app domain names,2025-07-27 20:00:04
```

## How It Works

1. **Load Prompts**: Reads creative prompts from `prompts.yml` for the specified category
2. **Generate Domains**: Uses GPT (with fallback) to generate brandable domain names
3. **Check Availability**: Uses local `whois` command to check if domains are available
4. **Retry Logic**: If no domains are available, tries again with a different prompt (max 3 attempts)
5. **Export Results**: Saves all results to CSV for later review

## Requirements

- Ruby 3.0+
- `whois` command (usually pre-installed on macOS/Linux)
- OpenAI API key (optional - has fallback domains)
- Internet connection for domain checking

## Project Structure

```
domain_scout/
├── run.rb              # Main CLI script
├── lib/
│   ├── gpt_client.rb      # GPT integration
│   ├── domain_checker.rb  # Domain availability checking
│   ├── csv_writer.rb      # CSV export
│   └── domain_agent.rb    # Main orchestrator
├── prompts.yml         # Domain generation prompts
├── results.csv         # Output file
└── .env               # API keys
```

## Troubleshooting

**"No available domains found"**: Try a different category or increase the number of domains to check.

**GPT API errors**: The tool has fallback domains and will continue working even without GPT.

**"whois command not found"**: Install whois (`brew install whois` on macOS).

---

Built for quick domain research and brainstorming! 
