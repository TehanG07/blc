#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "██████╗ ██████╗  ██████╗ ██╗  ██╗███████╗███╗   ██╗     ██╗     ██╗███╗   ██╗██╗  ██╗"
echo "██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║     ██║     ██║████╗  ██║██║ ██╔╝"
echo "██████╔╝██████╔╝██║   ██║█████╔╝ █████╗  ██╔██╗ ██║     ██║     ██║██╔██╗ ██║█████╔╝ "
echo "██╔═══╝ ██╔══██╗██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║     ██║     ██║██║╚██╗██║██╔═██╗ "
echo "██║     ██║  ██║╚██████╔╝██║  ██╗███████╗██║ ╚████║     ███████╗██║██║ ╚████║██║  ██╗"
echo "╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝     ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${YELLOW}💥 Broken Link Grasper Started...${NC}"
echo ""

# Prompt for URL
read -p "🔗 Enter the target URL: " target_url

# Validate input
if [[ -z "$target_url" ]]; then
  echo -e "${RED}❌ URL cannot be empty. Exiting.${NC}"
  exit 1
fi

# Clear previous output
> broken_links.txt
> social_links.txt

# Social media pattern
social_regex='https?://(www\.)?(facebook|twitter|instagram|linkedin|youtube|tiktok|pinterest|threads|medium|reddit|snapchat|tumblr|quora|discord|telegram|t\.me|vimeo|flickr)\.[^ ]+'

# Start BLC scan
echo -e "${GREEN}🔍 Scanning started for: $target_url${NC}"
echo ""

# Run BLC and process each line
blc "$target_url" -ro --filter-level 3 | while IFS= read -r line; do
  echo -e "${BLUE}[LOG]${NC} $line"

  # If broken link found
  if [[ "$line" == *"BROKEN"* ]]; then
    broken_link=$(echo "$line" | grep -Eo 'https?://[^ ]+')
    if [[ -n "$broken_link" ]]; then
      echo -e "${RED}[BROKEN]${NC} $broken_link"
      echo "$broken_link" >> broken_links.txt

      # If broken link is social media
      if echo "$broken_link" | grep -Eq "$social_regex"; then
        echo -e "${YELLOW}[SOCIAL LINK FOUND IN BROKEN]${NC} $broken_link"
        echo "$broken_link" >> social_links.txt
      fi
    fi
  fi
done

# Deduplicate both files
sort -u broken_links.txt -o broken_links.txt
sort -u social_links.txt -o social_links.txt

# Final Summary
echo -e "\n${YELLOW}📦 Output Summary:${NC}"
echo -e "${GREEN}✔ Broken links saved in:${NC} broken_links.txt"
echo -e "${GREEN}✔ Social media links (broken only, duplicates removed) saved in:${NC} social_links.txt"
echo -e "${BLUE}🎯 Scanning Completed!${NC}"




