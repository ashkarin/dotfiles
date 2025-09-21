function podman-login-gitlab
    print_status "Logging into GitLab registry with Podman..."
    require_env GITLAB_REGISTRY_TOKEN; or return 1
    require_env GITLAB_USER; or return 1

    if echo $GITLAB_REGISTRY_TOKEN | podman login https://registry.gitlab.com/ -u $GITLAB_USER --password-stdin
        print_success "Successfully logged into GitLab registry"
    else
        print_error "Failed to login to GitLab registry"
        return 1
    end
end

function podman-login-aws
    print_status "Logging into AWS ECR with Podman..."

    if not type -q aws
        print_warning "AWS CLI not found. Please install it first."
        return 1
    end

    require_env AWS_REGION; or return 1
    require_env AWS_PROFILE; or return 1
    require_env AWS_ACCOUNT_ID; or return 1

    if aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE \
        | podman login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        print_success "Successfully logged into AWS ECR"
    else
        print_error "Failed to login to AWS ECR"
        return 1
    end
end

function setup-podman
    echo "🐳 Podman Registry Login Setup"
    echo ""

    # Ensure Podman exists
    if not type -q podman
        print_error "Podman is not installed. Please install it first."
        return 1
    end

    # Ensure Podman machine is running
    if not podman info ^/dev/null
        print_warning "Podman machine not running. Starting podman machine..."
        if podman machine start
            print_success "Podman machine started"
        else
            print_error "Failed to start Podman machine"
            return 1
        end
    end

    # Run both logins
    set -l errors 0
    podman-login-gitlab; or set errors (math $errors + 1)
    podman-login-aws; or set errors (math $errors + 1)

    echo ""
    if test $errors -eq 0
        print_success "Podman registry setup completed!"
    else
        print_warning "Podman setup finished with $errors error(s)."
    end
end
