function genkey
    if test (count $argv) -lt 1
        echo "Usage: genkey <key_name>"
        return 1
    end

    set keyname $argv[1]
    set keypath ~/.ssh/$keyname

    if test -f $keypath
        echo "❌ Key already exists: $keypath"
        return 1
    end

    echo "🔑 Generating new SSH key: $keyname"
    ssh-keygen -t ed25519 -f $keypath -C (whoami)"@"(hostname)
    ssh-add --apple-use-keychain $keypath
    cat $keypath.pub | pbcopy

    echo "✅ Key created, added to keychain, and public key copied to clipboard!"
end