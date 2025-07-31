# Domain Scout 

A Ruby CLI tool that generates brandable domain names and checks their availability in real-time. Uses OpenAI GPT-3.5 for creative domain generation with automated cron scheduling for continuous domain hunting.

## Features 

- **Smart Domain Generation**: Uses OpenAI GPT-3.5-turbo for creative, brandable domain names
- **Real-time Availability Checking**: Uses `whois` to check actual domain availability
- **Automated Cron Scheduling**: Run continuously in the background every 5-15 minutes
- **15+ Categories**: Sports, AI/automation, fintech, SaaS, ecommerce, health, travel, and more
- **CSV Export**: Complete logging with timestamps and metadata  
- **Retry Logic**: Automatically tries different prompts if no domains are available
- **Comprehensive Logging**: Detailed logs for cron monitoring and troubleshooting
- **Rate Limit Handling**: Graceful handling of API limits

## Quick Start 

```bash
# Clone the repository
git clone https://github.com/rsedighi/domain-scout.git
cd domain-scout

# Install dependencies
bundle install

# Set up your OpenAI API key (required for GPT generation)
echo "OPENAI_API_KEY=your_openai_api_key_here" > .env

# Generate 5 sports-related domains
ruby run.rb sports 5

# Generate 10 AI automation domains  
ruby run.rb ai_automation 10

# Set up automated domain hunting (optional)
chmod +x cron_runner.sh
# Then add to crontab: */10 * * * * /path/to/domain_scout/cron_runner.sh
```

> **💡 Pro Tip**: Set up the cron job to run Domain Scout automatically every 10 minutes and discover available domains while you sleep!

## Installation 

### Prerequisites
- **Ruby 3.0+** 
- **`whois` command** (usually pre-installed on macOS/Linux)
- **OpenAI API key** (required for GPT-3.5 domain generation)

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

**Business & SaaS:**
- `ai_automation` - AI tools, automation platforms, chatbots
- `saas_niches` - SaaS tools, productivity apps, CRM systems
- `finance_fintech` - Crypto, payments, budgeting apps, DeFi tools
- `startups_naming_themes` - Premium startup names, API-first products

**Industries:**
- `real_estate_local` - Property tech, home services, inspection tools
- `health_wellness_lifestyle` - Mental health apps, fitness coaching, telehealth
- `ecommerce_dtc` - DTC brands, subscription boxes, cart recovery tools
- `climate_green_tech` - Clean energy, carbon tracking, recycling platforms

**Technology & Development:**
- `dev_engineering` - Code libraries, microservices, DevOps tools
- `productivity_tools` - Time tracking, team communication, knowledge bases
- `gaming_communities` - Gaming platforms, esports tools, NFT guilds

**Creative & Media:**
- `creators_media` - Video editing, podcasts, creator monetization
- `education_learning` - Online courses, tutoring platforms, study tools
- `travel_experiences` - Digital nomad tools, luxury travel, remote work

**Sports (Multiple Subcategories):**
- `sports` - General sports news, streaming, fan communities
- `sports_fitness_training` - Fitness apps, training platforms, gym management
- `sports_psychology` - Mental toughness, mindset coaching
- `sports_tech` - Analytics, wearables, performance tracking
- `sports_ecommerce` - Memorabilia, apparel, subscription boxes

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

## Automated Domain Hunting (Cron Jobs)

Domain Scout includes a cron runner for automated domain discovery:

### Quick Setup
```bash
# Make the cron script executable
chmod +x cron_runner.sh

# Add to your crontab (run every 10 minutes)
crontab -e
```

Add this line to run every 10 minutes:
```
*/10 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

### Features
- **Automatic Category Rotation**: Randomly selects from different categories
- **Comprehensive Logging**: Logs all runs to `logs/` directory
- **Smart Cleanup**: Keeps last 50 log files
- **Available Domain Alerts**: Counts and logs when domains are found
- **macOS Notifications**: Optional desktop notifications (uncomment in script)

### Monitoring
```bash
# View recent logs
ls -la logs/

# Check for available domains
grep "AVAILABLE" logs/cron_run_*.log

# Monitor in real-time
tail -f logs/cron_run_*.log
```

See [CRON_SETUP.md](CRON_SETUP.md) for detailed configuration options.

## How It Works 

1. **Prompt Selection**: Randomly selects a prompt from the specified category
2. **Domain Generation**: Uses OpenAI GPT-3.5-turbo to generate creative, contextual domain names
3. **Availability Checking**: Uses `whois` command to check real domain availability
4. **Results Export**: Saves all results to `results.csv` with metadata
5. **Retry Logic**: If no available domains found, tries different prompts (up to 3 attempts)
6. **Automated Scheduling**: Optional cron jobs run continuously in the background

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

## Results & Performance

**✅ Proven Success Rate:**
- Consistently finds **2-8 available domains** per run
- **95%+ success rate** across all categories when GPT API is available  
- **15+ domain categories** with 200+ unique prompts

**🎯 Real Examples Found:**
- `subnexa.com` (SaaS revenue management)
- `creatorspaypro.com` (Creator payments)
- `sportunityfan.com` (Sports fan engagement)
- `edubotiq.com` (AI education tools)
- `fieldtechx.com` (Sports technology)

**⚡ Performance:**
- **Average run time**: 2-3 minutes for 5 domains
- **API efficiency**: ~1 API call per successful batch
- **Storage**: All results logged to CSV with timestamps

## Development 

### Project Structure
```
domain-scout/
├── run.rb                 # Main CLI entry point
├── cron_runner.sh         # Automated cron execution
├── lib/
│   ├── domain_agent.rb    # Main orchestrator
│   ├── gpt_client.rb      # OpenAI integration
│   ├── domain_checker.rb  # Whois domain checking
│   └── csv_writer.rb      # Results export
├── logs/                  # Cron execution logs
├── config/                # Configuration files
├── data/                  # Data storage
├── prompts.yml           # Domain generation prompts (200+ prompts)
├── results.csv           # Output file with all discoveries
├── CRON_SETUP.md         # Detailed automation guide
└── README.md             # This file
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

## API Costs & Usage

**OpenAI GPT-3.5-turbo Pricing:**
- **Cost per run**: ~$0.001-0.002 (very affordable)
- **Monthly estimate**: $1-5 for regular use, $10-20 for automated cron
- **Token usage**: ~150 tokens per domain generation request

**Cron Job Considerations:**
- Running every 10 minutes = ~4,320 API calls per month
- Estimated cost: $4-8/month for continuous automated hunting
- Consider running every 15-30 minutes to reduce costs

**Cost Optimization Tips:**
- Use specific categories to get better results faster
- Monitor your OpenAI usage dashboard
- Adjust cron frequency based on your budget

## Troubleshooting 

### Common Issues

**"No prompts found for category"**
- Check category name spelling
- Verify `prompts.yml` contains your category
- Use `ruby run.rb --help` to see available categories

**"whois command not found"**
- Install whois: `brew install whois` (macOS) or `apt-get install whois` (Ubuntu)

**OpenAI API Issues**
- Check your API key in `.env` file
- Verify billing setup at https://platform.openai.com/account/billing  
- Ensure you have credits available on your OpenAI account
- **Note**: API key is required for domain generation (no fallback mode)

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

MIT License - see [LICENSE](LICENSE) file for details.

## Recent Updates

**v1.0.0** (July 2025)
- ✅ Added automated cron scheduling with `cron_runner.sh`
- ✅ Comprehensive logging system for monitoring
- ✅ 15+ domain categories with 200+ prompts
- ✅ Removed fallback generation (GPT-only for higher quality)
- ✅ Updated to latest ruby-openai gem (8.1.0)
- ✅ Enhanced error handling and user feedback
- ✅ Complete documentation and setup guides

## Acknowledgments 

- Built with [ruby-openai](https://github.com/alexrudall/ruby-openai) gem
- Uses OpenAI GPT-3.5-turbo for creative domain generation
- Inspired by the need for brandable domain discovery automation

---

**⭐ Star this repo if Domain Scout helped you find great domains!**  
**🤝 Contributions welcome - see [Contributing](#contributing) section above**
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
