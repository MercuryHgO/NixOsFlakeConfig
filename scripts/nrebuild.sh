# Check for flags
while getopts ":sg" opt; do
    case $opt in
        g)
            sudo rm -vrf "$HOME"/.config/gtk-4.0/ "$HOME"/.config/gtk-3.0/;;
        s)
            command="sudo nixos-rebuild switch --flake $HOME/nix";;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# If no flags are provided, use the default command
if [ -z "$command" ]; then
    command="sudo nixos-rebuild test --flake $HOME/nix"
fi

echo "Executing command: $command"
$command
