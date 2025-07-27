#!/bin/bash

echo "HomeFleet Migration Verification"
echo "================================"
echo ""

# Check if we're in the HomeFleet directory
if [[ ! -f "Makefile" ]] || [[ ! -f ".env.example" ]]; then
    echo "❌ Error: This script must be run from the HomeFleet directory"
    exit 1
fi

echo "✅ HomeFleet directory structure verified"
echo ""

# Count services
CORE_COUNT=$(find services/core -name "compose.yaml" | wc -l)
MEDIA_COUNT=$(find services/media -name "compose.yaml" | wc -l)
UTILITIES_COUNT=$(find services/utilities -name "compose.yaml" | wc -l)
MONITORING_COUNT=$(find services/monitoring -name "compose.yaml" | wc -l)
TOTAL_COUNT=$((CORE_COUNT + MEDIA_COUNT + UTILITIES_COUNT + MONITORING_COUNT))

echo "Service Count Summary:"
echo "  Core Services: $CORE_COUNT"
echo "  Media Services: $MEDIA_COUNT"
echo "  Utilities: $UTILITIES_COUNT"
echo "  Monitoring: $MONITORING_COUNT"
echo "  Total Services: $TOTAL_COUNT"
echo ""

# Check for required files
echo "Required Files Check:"
[[ -f "Makefile" ]] && echo "✅ Makefile" || echo "❌ Makefile missing"
[[ -f ".env.example" ]] && echo "✅ .env.example" || echo "❌ .env.example missing"
[[ -f "README.md" ]] && echo "✅ README.md" || echo "❌ README.md missing"
[[ -f "LICENSE" ]] && echo "✅ LICENSE" || echo "❌ LICENSE missing"
[[ -f ".gitignore" ]] && echo "✅ .gitignore" || echo "❌ .gitignore missing"
echo ""

# Check documentation
echo "Documentation Check:"
DOC_COUNT=$(find setup_docs -name "*.md" | wc -l)
echo "  Setup Documentation: $DOC_COUNT files"
[[ -f "troubleshooting.md" ]] && echo "✅ Troubleshooting guide" || echo "❌ Troubleshooting guide missing"
[[ -f "blog_post.md" ]] && echo "✅ Blog post" || echo "❌ Blog post missing"
[[ -f "MIGRATION_SUMMARY.md" ]] && echo "✅ Migration summary" || echo "❌ Migration summary missing"
echo ""

# Check for hardcoded secrets
echo "Security Check:"
HARDCODED_PASSWORDS=$(grep -r "password\|secret\|key" services/ --include="*.yaml" | grep -v "PASSWORD\|SECRET\|KEY" | wc -l)
if [[ $HARDCODED_PASSWORDS -eq 0 ]]; then
    echo "✅ No hardcoded secrets found"
else
    echo "⚠️  Found $HARDCODED_PASSWORDS potential hardcoded secrets"
fi

HARDCODED_PATHS=$(grep -r "/media/\|/home/\|/etc/" services/ --include="*.yaml" | wc -l)
if [[ $HARDCODED_PATHS -eq 0 ]]; then
    echo "✅ No hardcoded paths found"
else
    echo "⚠️  Found $HARDCODED_PATHS potential hardcoded paths"
fi
echo ""

echo "Migration Verification Complete!"
echo ""
echo "Next Steps:"
echo "1. Copy .env.example to .env and configure your environment"
echo "2. Test service startup: make up core"
echo "3. Initialize Git repository and push to GitHub"
echo "4. Update Heimdall with new service URLs"
echo ""
