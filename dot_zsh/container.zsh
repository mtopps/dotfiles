# Container system management
# Auto-start container system if not already running

if command -v container &>/dev/null; then
    if ! container system status &>/dev/null || container system status | grep -q "not running"; then
        container system start &>/dev/null
    fi
fi