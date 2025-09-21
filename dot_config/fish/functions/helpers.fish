function print_status --description "Print a status message" --private
    set_color blue
    echo "🔄 $argv"
    set_color normal
end

function print_success --description "Print a success message" --private
    set_color green
    echo "✅ $argv"
    set_color normal
end

function print_warning --description "Print a warning message" --private
    set_color yellow
    echo "⚠️  $argv"
    set_color normal
end

function print_error --description "Print an error message" --private
    set_color red
    echo "❌ $argv"
    set_color normal
end

# Check if a variable is set and non-empty
function require_env --description "Check if an environment variable is set" --private
    set -l var_name $argv[1]
    set -l value (eval echo \$$var_name)

    if test -z "$value"
        print_error "Environment variable $var_name is required but not set."
        echo "👉 Set it with: set -x $var_name your_value"
        return 1
    end
end
