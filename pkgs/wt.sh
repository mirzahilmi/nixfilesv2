usage() {
    echo "Usage: wt [-p|--prefix <prefix>] <name>"
    echo
    echo "Creates worktrees/<name> on a new branch <prefix>/<name>."
    echo
    echo "Options:"
    echo "  -p, --prefix <prefix>  Branch prefix (default: feat)"
    echo "  -h, --help             Show this help"
}

prefix="feat"
name=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    -p | --prefix)
        if [[ -z "${2:-}" ]]; then
            echo "Missing value for $1" >&2
            exit 1
        fi
        prefix="$2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    *)
        if [[ -n "$name" ]]; then
            echo "Unexpected argument: $1" >&2
            usage >&2
            exit 1
        fi
        name="$1"
        shift
        ;;
    esac
done

if [[ -z "$name" ]]; then
    usage >&2
    exit 1
fi

git worktree add "worktrees/$name" -b "$prefix/$name"
