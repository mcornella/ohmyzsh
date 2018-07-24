if [[ $ENABLE_PROFILING != true ]]; then
    function start_profiling stop_profiling print_profiling { }
    return
fi

zmodload zsh/datetime

# Store the measurements indexed by the key (name)
typeset -A _time_by_keys
# Store the order the measurements were taken
_ordered_keys=()

# Return a timestamp in milliseconds
function _time_in_ms() {
    printf %.0f $(( EPOCHREALTIME * 1e3 ))
}

# Start recording the elapsed time
# @param key the name that defines the measurement (must be unique)
function start_profiling() {
    local key="$1"
    local time_ms=$(_time_in_ms)
    _time_by_keys[$key]=$time_ms
    _ordered_keys+=($key)
}

# Stop recording the elapsed time
# @param key the name that defines the measurement (must be the same than the one used with 'start_profiling')
function stop_profiling() {
    local key="$1"
    local time_ms=$(_time_in_ms)

    if [[ $_time_by_keys[$key] ]]; then
        _time_by_keys[$key]=$(($time_ms - $_time_by_keys[$key]))
    else
        echo "WARNING: you must start the profiling with 'start_profiling \"$key\"')"
    fi
}

# Print all the measurements
function print_profiling() {
    local dots1='..................................................'
    local dots2='......'

    echo
    for key in $_ordered_keys; do
        local value=$_time_by_keys[$key]
        local percent=$(($_time_by_keys[$key] * 100 / $_time_by_keys[TOTAL]))

        local length1=$(( ${#key} + ${#value} ))
        printf "%s %s %s ms " $key "${dots1:$length1}" $value

        local length2=$(( ${#percent} ))
        printf "%s %s%%\n" "${dots2:$length2}" $percent
    done
    echo
}
