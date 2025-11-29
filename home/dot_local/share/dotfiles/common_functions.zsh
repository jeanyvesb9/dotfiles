# Copyright (C) 2025 Jean Yves Beaucamp
# Helper functions. These cannot be defined in scripts, as they may need to modify the active shell (e.g. in up)

#=============================================================================
# up
#=============================================================================
up () {
    local level=1
    local level_set=false

    # Parse cmd line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                echo "Usage: up level"
                echo
                echo "Upfolder navigation tool."
                echo
                echo "Options:"
                echo "  level                   Number of levels to go up."
                echo "  -h, --help              Show this help message and exit."
                return 0
                ;;
            --) # stop parsing
                shift
                break
                ;;
            -*)
                echo "up: unknown option: $1" >&2
                return 1
                ;;
            *)
                if [[ "$level_set" = true ]]; then
                    echo "up: unknown option: $1" >&2
                    return 1
                fi
                level="$1"
                level_set=true
                shift
                ;;
        esac
    done


    if [[ "$level" -le 0 ]]; then
        echo "A positive level is needed"
        return 1
    fi

    local d=""
    for ((i=1;i<=level;i++)); do
        d="../$d"
    done
    
    if ! cd "$d"; then
        echo "Couldn't go up $level levels"
        exit 1
    fi
}



#=============================================================================
# array_contains
#=============================================================================
## array_contains <array> <elem> : checks if the array contains an element
array_contains () {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${(@element)array}"; do
    if [[ $element == "$seeking" ]]; then
      in=0
      break
    fi
  done
  return $in
}
