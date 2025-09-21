# Function to create a new project with mise
function new-project
    set project_name $argv[1]
    if test -z "$project_name"
        echo "Usage: new-project <project-name>"
        return 1
    end
    
    mkdir $project_name
    cd $project_name
    mise init
    echo "Created new project: $project_name"
    echo "Run 'mise install' to install dependencies"
end